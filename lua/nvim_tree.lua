-- Reveal the node under the cursor in macOS Finder (`open -R`), detached so it
-- doesn't block Neovim. Global so the keymap below can reference it by name.
function _G.NvimTreeOSOpen()
  local lib = require('nvim-tree.lib')
  local node = lib.get_node_at_cursor()
  if node then
    vim.fn.jobstart("open -R '" .. node.absolute_path .. "' &", { detach = true })
  end
end

-- Buffer-local mappings applied to every tree window. We keep nvim-tree's
-- defaults and add a few on top.
local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<C-o>', _G.NvimTreeOSOpen, { buffer = bufnr }) -- reveal in Finder
  vim.keymap.set('n', 'v', api.node.open.vertical, { buffer = bufnr }) -- open in vsplit
  vim.keymap.set('n', 's', api.node.open.horizontal, { buffer = bufnr }) -- open in split
  vim.keymap.set('n', '<C-r>', api.tree.reload, { buffer = bufnr }) -- refresh tree
end

require('nvim-tree').setup({
  disable_netrw = true, -- nvim-tree replaces netrw entirely
  hijack_netrw = true,
  hijack_directories = {
    enable = true, -- `nvim <dir>` / `:e <dir>` opens the tree
    auto_open = true,
  },
  open_on_tab = false, -- don't mirror the tree into every new tab
  hijack_cursor = false,
  update_cwd = false, -- never change Neovim's cwd from the tree
  diagnostics = {
    enable = false, -- no LSP diagnostic icons in the tree
  },
  update_focused_file = {
    enable = true, -- highlight the current buffer's file in the tree
    update_cwd = false,
    ignore_list = {},
  },
  actions = {
    open_file = {
      resize_window = true, -- grow the editor window when opening a file
    },
  },
  on_attach = on_attach,
  view = {
    width = 28,
    side = 'left',
  },
  git = {
    ignore = false, -- still show .gitignore'd files
  },
})

-- Track whether Neovim was fed data on stdin (e.g. `git diff | nvim -`); in that
-- case we're a pager, not an editor, so don't pop the tree open.
local read_from_stdin = false
vim.api.nvim_create_autocmd('StdinReadPre', {
  callback = function()
    read_from_stdin = true
  end,
})

local function open_nvim_tree(data)
  if read_from_stdin then
    return
  end

  -- Don't hijack git's commit / merge / rebase editor sessions.
  local name = data.file
  if
    vim.bo[data.buf].filetype == 'gitcommit'
    or name:match('COMMIT_EDITMSG$')
    or name:match('MERGE_MSG$')
    or name:match('git%-rebase%-todo$')
  then
    return
  end

  require('nvim-tree.api').tree.open()
end

-- Open the tree automatically on startup.
vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

-- <C-n>: toggle the tree open/closed.
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })

-- <C-e>: bring the tree back into a split if it was closed/hidden.
vim.api.nvim_set_keymap('n', '<C-e>', ':sb NvimTree<CR>', { noremap = true })

-- Quit Neovim if the tree is the only window left (so it never lingers alone
-- after closing the last real buffer).
vim.api.nvim_create_autocmd('BufEnter', {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil then
      vim.cmd('quit')
    end
  end,
})
