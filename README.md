# nvim
Neovim configuration.

A native-Lua setup: plugins via the built-in `vim.pack`, native LSP + completion
(no coc.nvim), `lualine`, `nvim-tree`, `nvzone/menu`, and a hand-ported ANSI
colorscheme that inherits your terminal's 16-color palette (`termguicolors` off).

### Requirements
- **Neovim 0.12+** — plugins are managed by the built-in `vim.pack`.
- **A Nerd Font** — for `nvim-web-devicons` file icons and the diagnostic /
  statusline glyphs.
- **fzf** — the `junegunn/fzf` plugin builds its own binary on install (handled by
  the `PackChanged` hook in `lua/plugins.lua`); install [ripgrep](https://github.com/BurntSushi/ripgrep)
  too for `:Rg` and faster `:Files`.

### Language servers (optional, enabled when present)
LSP servers are external binaries, resolved per-project (preferring
`node_modules/.bin`, then `$PATH`). They're enabled lazily — a missing one is
simply skipped rather than erroring:
- **tsgo** — `@typescript/native-preview` (TypeScript). Install globally with
  `npm i -g @typescript/native-preview`, or add it as a project devDependency.
  Only enabled when a `tsgo` binary is resolvable from the launch directory
  (see `lua/lsp.lua`).
- **eslint**, **oxlint**, **oxfmt** — JS/TS linting & formatting.

### Installation
Clone this into `.config/nvim`. Plugins install automatically on first launch,
pinned to the revisions in `nvim-pack-lock.json` (the `vim.pack` lockfile — keep
it under version control so installs are reproducible).
