function _G.NvimTreeOSOpen()
  local lib = require "nvim-tree.lib"
  local node = lib.get_node_at_cursor()
  if node then
    vim.fn.jobstart("open -R '" .. node.absolute_path .. "' &", {detach = true})
  end
end

local function on_attach(bufnr)
  local api = require "nvim-tree.api"
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "<C-o>", _G.NvimTreeOSOpen)
  vim.keymap.set("n", "v", "vsplit")
  vim.keymap.set("n", "s", "split")
  vim.keymap.set("n", "<C-r>", "refresh")
end

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  hijack_directories   = {
    enable = true,
    auto_open = true,
  },
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics     = {
    enable = false,
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  actions = {
    open_file = {
      resize_window = true
    }
  },
  on_attach = on_attach,
  view = {
    width = 28,
    side = 'left',
  },
  git = {
    ignore = false
  },
}

local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

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
