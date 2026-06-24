-- Native plugin management via vim.pack (requires Neovim 0.12+).
-- Plugins are cloned into ~/.local/share/nvim/site/pack/core/opt and loaded
-- immediately, in the order listed below (devicons before its consumers).
local vim = vim

vim.pack.add({
  { src = 'https://github.com/junegunn/fzf',                    version = '3c9965a61a842ef54e976c7195b985ee43a3e776' },
  { src = 'https://github.com/junegunn/fzf.vim',                version = 'd2a59a992a2455f609c0fde2ebd84427ea8f919a' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons',     version = 'dfbfaa967a6f7ec50789bead7ef87e336c1fa63c' }, -- file icons
  { src = 'https://github.com/nvim-tree/nvim-tree.lua',         version = 'v1.17.0' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim',       version = '221ce6b2d999187044529f49da6554a92f740a96' },
  { src = 'https://github.com/neovim/nvim-lspconfig',           version = 'v2.10.0' },
  { src = 'https://github.com/f-person/git-blame.nvim',         version = '5c536e2d4134d064aa3f41575280bc8a2a0e03d7' },
  { src = 'https://github.com/nvzone/volt',                     version = '620de1321f275ec9d80028c68d1b88b409c0c8b1' },
  { src = 'https://github.com/nvzone/menu',                     version = '7a0a4a2896b715c066cfbe320bdc048091874cc6' },
  { src = 'https://github.com/stevearc/conform.nvim',           version = 'v9.1.0' },
  { src = 'https://github.com/OXY2DEV/markview.nvim',           version = 'v28.3.0' },
  { src = 'https://github.com/mrjones2014/codesettings.nvim',   version = 'v1.6.7' },
})

-- Build hook for fzf, replacing the old vim-plug `do` that ran fzf#install().
-- vim.pack has no per-plugin build field, so run it on install/update instead.
-- vim.pack.add() sources plugins synchronously, so by the time this scheduled
-- callback runs fzf#install() is defined (and it handles Windows vs Unix).
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local data = ev.data
    if data.spec.name == 'fzf' and (data.kind == 'install' or data.kind == 'update') then
      vim.schedule(function() vim.fn['fzf#install']() end)
    end
  end,
})
