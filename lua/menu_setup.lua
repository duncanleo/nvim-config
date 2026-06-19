-- volt (the renderer behind `menu`) redefines its Ex* highlight groups every time
-- a menu opens, using GUI hex colours only. Our `ansi` colourscheme runs with
-- termguicolors off, so those guibg values are ignored and the hover highlight
-- (ExBlack3Bg) ends up with no background. Re-set the groups with cterm colours
-- here — the FileType event fires after volt has drawn, so these win.
local function style_menu_hl()
  local hl = vim.api.nvim_set_hl
  hl(0, "ExBlack2Bg", { ctermfg = 15, ctermbg = 0 }) -- menu background
  hl(0, "ExBlack2Border", { ctermfg = 8, ctermbg = 0 }) -- menu border
  hl(0, "ExLightGrey", { ctermfg = 7 }) -- item text
  hl(0, "ExBlack3Bg", { ctermfg = 15, ctermbg = 8, cterm = { bold = true } }) -- hovered/selected item
  hl(0, "ExBlack3Border", { ctermfg = 8, ctermbg = 8 })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvMenu",
  callback = function(args)
    style_menu_hl()

    -- minimal-style windows force cursorline off. Mouse mode shows selection via
    -- hover (ExBlack3Bg); keyboard mode (<C-t>) moves the cursor instead, so turn
    -- cursorline back on — but only on the focused menu window, else mouse menus
    -- would paint row 1 permanently. Remap CursorLine to the selected-item colour.
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_buf(win) == args.buf then
      vim.wo[win].cursorline = true
      vim.wo[win].winhl = vim.wo[win].winhl .. ",CursorLine:ExBlack3Bg"
    end
  end,
})

-- Keyboard users
vim.keymap.set("n", "<C-t>", function()
  require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})
