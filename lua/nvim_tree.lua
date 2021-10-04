function _G.NvimTreeOSOpen()
  local lib = require "nvim-tree.lib"
  local node = lib.get_node_at_cursor()
  if node then
    vim.fn.jobstart("open -R '" .. node.absolute_path .. "' &", {detach = true})
  end
end

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = true,
  ignore_ft_on_setup  = {},
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  auto_close          = true,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  lsp_diagnostics     = true,
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
        { key ="v", cb = tree_cb("vsplit") },
        { key ="s", cb = tree_cb("split") }
      }
    }
  }
}



