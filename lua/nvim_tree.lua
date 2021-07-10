function _G.NvimTreeOSOpen()
  local lib = require "nvim-tree.lib"
  local node = lib.get_node_at_cursor()
  if node then
    vim.fn.jobstart("open -R '" .. node.absolute_path .. "' &", {detach = true})
  end
end

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

vim.g.nvim_tree_bindings = {
  { key ="<C-o>", cb = ":lua NvimTreeOSOpen()<cr>" },
  { key ="v", cb = tree_cb("vsplit") },
  { key ="s", cb = tree_cb("split") }
}
