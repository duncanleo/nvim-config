function _G.NvimTreeOSOpen()
  local lib = require "nvim-tree.lib"
  local node = lib.get_node_at_cursor()
  if node then
    vim.fn.jobstart("open -R '" .. node.absolute_path .. "' &", {detach = true})
  end
end

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = true,
  ignore_ft_on_setup  = {},
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics     = {
    enable = false,
  },
  highlight_focused_file = true,
  update_focused_file = {
    enable      = true,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  view = {
    width = 28,
    height = 30,
    side = 'left',
    auto_resize = true,
    mappings = {
      custom_only = false,
      list = {
        { key ="<C-o>", cb = ":lua NvimTreeOSOpen()<cr>" },
        { key ="v", action = "vsplit" },
        { key ="s", action = "split" },
        { key = "<C-r>", action = "refresh" }
      }
    }
  },
  git = {
    ignore = false
  },
}

vim.api.nvim_set_keymap(
  'n',
  '<C-n>',
  ':NvimTreeToggle<CR>',
  { noremap = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<C-e>',
  ':sb NvimTree<CR>',
  { noremap = true }
)

vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd "quit"
    end
  end
})
