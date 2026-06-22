# Notes for agents working in this Neovim config

## Plugin management (vim.pack)

Plugins are managed by Neovim's native `vim.pack` (Neovim 0.12+), configured in
`lua/plugins.lua`. Pinned revisions are recorded in `nvim-pack-lock.json`, which
**is a real `vim.pack` lockfile** — keep it under version control.

Key behavior to know:

- **Adding** a plugin: add an entry to `vim.pack.add({ ... })` in
  `lua/plugins.lua` (with a `version`). It's cloned and the lockfile updated on
  next launch.
- **Removing** a plugin: deleting its line from `vim.pack.add()` does **not**
  uninstall it or update the lockfile. You must explicitly run
  `:lua vim.pack.del({ 'plugin-name' })`, which removes it from disk *and*
  updates `nvim-pack-lock.json` in one step. (Don't hand-edit the lockfile to
  remove a plugin.)
- Plugins live on disk under
  `~/.local/share/nvim/site/pack/core/opt/<plugin-name>/`.
