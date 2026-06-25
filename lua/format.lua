-- Formatting via conform.nvim. Biome is preferred for JS/TS/JSON/CSS when a
-- project has biome.json/biome.jsonc; otherwise conform falls back to Prettier.
-- Both formatters auto-resolve project-local node_modules/.bin binaries.
--
-- NOTE: Biome/oxfmt are also enabled as LSP formatters (see lsp.lua), and eslint
-- runs codeActionOnSave on save. `lsp_format = 'never'` keeps conform from
-- invoking LSP formatting, so only the explicit conform formatter rewrites a
-- buffer on save.
local web_formatter = { 'biome', 'prettier', stop_after_first = true }

require('conform').setup({
  formatters = {
    biome = {
      require_cwd = true,
    },
  },
  formatters_by_ft = {
    lua = { 'stylua' }, -- requires the `stylua` binary (brew install stylua)
    javascript = web_formatter,
    javascriptreact = web_formatter,
    typescript = web_formatter,
    typescriptreact = web_formatter,
    json = web_formatter,
    jsonc = web_formatter,
    css = web_formatter,
    html = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = 'never',
  },
})

-- Manual format trigger for the current buffer.
vim.keymap.set('n', '<leader>f', function()
  require('conform').format({ async = true, lsp_format = 'never' })
end, { desc = 'format buffer (conform)' })
