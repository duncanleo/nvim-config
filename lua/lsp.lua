vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }

-- LSP servers, each mapped to the binary it spawns (`bin`) and any Neovim-side
-- `settings` to merge on top of nvim-lspconfig's defaults. nvim-lspconfig
-- resolves the binary per-project (preferring node_modules/.bin, then $PATH),
-- so a server whose binary isn't installed would fail with an ENOENT spawn
-- error when a matching file opens. Enable each only when its binary is
-- resolvable. (Checked once at startup against the cwd, so launch Neovim from
-- the project root — which is also where nvim-tree roots itself.)
--
-- Project-local .vscode/settings.json is layered on top of these `settings` via
-- codesettings in the loop below; doing it per-server there (rather than a
-- global `before_init` hook) keeps nvim-lspconfig's own `before_init` intact for
-- servers like eslint/tailwindcss/oxlint that define one.
local servers = {
  biome = { bin = 'biome' },
  -- Fix-on-save with ESLint, driven by the server itself: `codeActionOnSave`
  -- applies all auto-fixes (via workspace/applyEdit) on save, and `run = 'onSave'`
  -- re-lints then.
  eslint = {
    bin = 'vscode-eslint-language-server',
    settings = {
      format = true,
      run = 'onSave',
      codeActionOnSave = { enable = true, mode = 'all' },
    },
  },
  jsonls = { bin = 'vscode-json-language-server' },
  oxfmt = { bin = 'oxfmt' },
  oxlint = { bin = 'oxlint' },
  tailwindcss = { bin = 'tailwindcss-language-server' }, -- brew install tailwindcss-language-server
  tsgo = { bin = 'tsgo' }, -- @typescript/native-preview, still a preview release
  yamlls = { bin = 'yaml-language-server' },
}

local function available(bin)
  if vim.fn.executable(bin) == 1 then
    return true
  end
  local root = vim.fs.root(vim.fn.getcwd(), 'node_modules')
  return root ~= nil and vim.fn.executable(root .. '/node_modules/.bin/' .. bin) == 1
end

local codesettings = require('codesettings')
for server, spec in pairs(servers) do
  if available(spec.bin) then
    vim.lsp.config(server, codesettings.with_local_settings(server, { settings = spec.settings }))
    vim.lsp.enable(server)
  end
end
vim.lsp.codelens.enable(true)

vim.diagnostic.config({
  virtual_text = false, -- no inline message; use the cursor float instead
  underline = true, -- squiggle under the offending text
  signs = { -- gutter icons per severity
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  severity_sort = true, -- show most severe sign when several overlap
  update_in_insert = false, -- don't re-render while typing
  float = { border = 'rounded', source = true },
})

-- Show the full diagnostic for the current line in a float
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'line diagnostics' })

-- Auto-show the diagnostic under the cursor after it rests briefly
vim.opt.updatetime = 300 -- ms of idle before CursorHold fires (default 4000)
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, {
      scope = 'cursor', -- only the diagnostic right under the cursor
      focus = false, -- don't jump into the float
      close_events = { 'CursorMoved', 'InsertEnter', 'BufLeave' },
    })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- Manual trigger fallback for when you want completion without a trigger char
vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { desc = 'trigger LSP completion' })

-- Auto-trigger completion while typing identifier characters (e.g. field names
-- inside `{}`), not just on server trigger chars like `.`. Native completion
-- doesn't do this on its own.
vim.api.nvim_create_autocmd('TextChangedI', {
  callback = function()
    if vim.fn.pumvisible() == 1 then
      return
    end
    local col = vim.fn.col('.') - 1
    if col == 0 then
      return
    end
    local char = vim.api.nvim_get_current_line():sub(col, col)
    if char:match('[%w_]') then
      vim.lsp.completion.get()
    end
  end,
})
