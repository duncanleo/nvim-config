# Notes for agents working in this Neovim config

## Commit conventions

When creating commits, use the Conventional Commits format for the subject line,
for example `feat: add picker shortcut` or `fix(format): guard missing stylua`.

Agent-authored commits must also include a `Co-Authored-By` trailer that signs
off with the agent's own identity, not the user's identity, for example:

```text
Co-Authored-By: Agent Name <agent@example.com>
```

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

## Formatting (conform.nvim)

Formatting is run through `conform.nvim`, configured in `lua/format.lua`
(format-on-save + `<leader>f`). Lua is formatted by **StyLua**, web filetypes by
prettier.

- **StyLua requires the `stylua` binary on `PATH`**: `brew install stylua`.
  Without it, conform silently skips Lua files. Style is pinned in `stylua.toml`
  (2-space indent, single quotes, 120 cols) to match the existing config.
- Format the whole config from the shell with `stylua lua/ init.lua colors/`, or
  check without writing via `stylua --check ...`.
- To keep hand-aligned blocks (e.g. the `version =` columns in `lua/plugins.lua`)
  from being collapsed, fence them with `-- stylua: ignore start` /
  `-- stylua: ignore end`. The directive comment must be **exactly** that text —
  any trailing text on the same line makes StyLua silently ignore the directive.
