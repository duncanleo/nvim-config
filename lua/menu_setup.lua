-- volt (the renderer behind `menu`) redefines its Ex* highlight groups every time
-- a menu opens, using GUI hex colours only. Our `ansi` colourscheme runs with
-- termguicolors off, so those guibg values are ignored and the hover highlight
-- (ExBlack3Bg) ends up with no background. Re-set the groups with cterm colours
-- here — the FileType event fires after volt has drawn, so these win.
local function style_menu_hl()
  local hl = vim.api.nvim_set_hl
  hl(0, 'ExBlack2Bg', { ctermfg = 15, ctermbg = 0 }) -- menu background
  hl(0, 'ExBlack2Border', { ctermfg = 8, ctermbg = 0 }) -- menu border
  hl(0, 'ExLightGrey', { ctermfg = 7 }) -- item text
  hl(0, 'ExBlack3Bg', { ctermfg = 15, ctermbg = 8, cterm = { bold = true } }) -- hovered/selected item
  hl(0, 'ExBlack3Border', { ctermfg = 8, ctermbg = 8 })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvMenu',
  callback = function(args)
    style_menu_hl()

    -- minimal-style windows force cursorline off. Mouse mode shows selection via
    -- hover (ExBlack3Bg); keyboard mode (<C-t>) moves the cursor instead, so turn
    -- cursorline back on — but only on the focused menu window, else mouse menus
    -- would paint row 1 permanently. Remap CursorLine to the selected-item colour.
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_buf(win) == args.buf then
      vim.wo[win].cursorline = true
      vim.wo[win].winhl = vim.wo[win].winhl .. ',CursorLine:ExBlack3Bg'
    end
  end,
})

-- Git blame actions for the current line, backed by git-blame.nvim commands.
local git_blame_items = {
  { name = 'Open Commit in Browser', cmd = 'GitBlameOpenCommitURL' },
  { name = 'Open File in Browser', cmd = 'GitBlameOpenFileURL' },
  { name = 'separator' },
  { name = 'Copy Commit SHA', cmd = 'GitBlameCopySHA' },
  { name = 'Copy Commit URL', cmd = 'GitBlameCopyCommitURL' },
  { name = 'Copy PR URL', cmd = 'GitBlameCopyPRURL' },
  { name = 'separator' },
  { name = 'Toggle Inline Blame', cmd = 'GitBlameToggle' },
}

local function toggle_line_comment()
  vim.api.nvim_feedkeys(vim.keycode('gcc'), 'mx', false)
end

local function toggle_selection_comment()
  vim.api.nvim_feedkeys(vim.keycode('gvgc'), 'mx', false)
end

local lsp_context_items = {
  { name = 'Go to Definition', cmd = vim.lsp.buf.definition, rtxt = 'grd' },
  { name = 'Go to Declaration', cmd = vim.lsp.buf.declaration, rtxt = 'gD' },
  { name = 'Find All References', cmd = vim.lsp.buf.references, rtxt = 'grr' },
  { name = 'separator' },
  { name = 'Rename Symbol', cmd = vim.lsp.buf.rename, rtxt = 'grn' },
  { name = 'Code Actions', cmd = vim.lsp.buf.code_action, rtxt = 'gra' },
  { name = 'separator' },
  { name = 'Toggle Selection Comment', cmd = toggle_selection_comment, rtxt = 'gc' },
  { name = 'Toggle Line Comment', cmd = toggle_line_comment, rtxt = 'gcc' },
}

local replaced_default_items = {
  ['Format Buffer'] = true,
  ['Code Actions'] = true,
  ['  Lsp Actions'] = true,
}

-- The plugin's bundled "default" menu, plus our Git Blame submenu. Deepcopy so
-- repeated opens don't accumulate appended entries on the shared module table.
local function default_menu()
  local items = vim.deepcopy(lsp_context_items)

  for _, item in ipairs(require('menus.default')) do
    if not replaced_default_items[item.name] then
      if item.name ~= 'separator' or items[#items].name ~= 'separator' then
        table.insert(items, vim.deepcopy(item))
      end
    end
  end

  vim.list_extend(items, {
    { name = 'separator' },
    { name = '󰊢 Git Blame', hl = 'Exblue', items = git_blame_items },
  })
  return items
end

-- Keyboard users
vim.keymap.set('n', '<C-t>', function()
  require('menu').open(default_menu())
end, {})

-- mouse users + nvimtree users!
vim.keymap.set({ 'n', 'v' }, '<RightMouse>', function()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec('"normal! \\<RightMouse>"')

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == 'NvimTree' and 'nvimtree' or default_menu()

  require('menu').open(options, { mouse = true })
end, {})
