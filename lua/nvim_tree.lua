function _G.NvimTreeOSOpen()
  local lib = require "nvim-tree.lib"
  local node = lib.get_node_at_cursor()
  if node then
    vim.fn.jobstart("open -R '" .. node.absolute_path .. "' &", {detach = true})
  end
end

vim.g.nvim_tree_bindings = {
  { key ="<C-o>", cb = ":lua NvimTreeOSOpen()<cr>" }
}
