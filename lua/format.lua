-- Formatting via conform.nvim. Prettier is the formatter for web filetypes; it
-- auto-resolves the project-local node_modules/.bin/prettier, so it only runs on
-- projects that actually have prettier installed (otherwise conform skips it).
--
-- NOTE: oxfmt is also enabled as an LSP formatter (see lsp.lua), and eslint runs
-- codeActionOnSave on save. `lsp_format = 'never'` keeps conform from invoking
-- the LSP formatter, so prettier and oxfmt don't both rewrite a buffer on save.
-- If you'd rather oxfmt own JS/TS formatting, drop those entries here (or remove
-- prettier entirely) instead of running both.
require('conform').setup({
  formatters_by_ft = {
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    css = { 'prettier' },
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
