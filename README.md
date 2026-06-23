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
- **eslint** — JS/TS linting, served by `vscode-eslint-language-server` from
  [`vscode-langservers-extracted`](https://formulae.brew.sh/formula/vscode-langservers-extracted).
  Install with `brew install vscode-langservers-extracted`. Fix-on-save is enabled
  via the server's `codeActionOnSave` setting (see `lua/lsp.lua`).
- **biome** — JS/TS linting & formatting, served by the `biome` CLI. Install
  globally with `npm i -g @biomejs/biome`, or add it as a project devDependency.
- **tailwindcss** — Tailwind CSS class completion & linting, served by
  `tailwindcss-language-server`. Install with
  `brew install tailwindcss-language-server`. Only attaches in projects with a
  Tailwind config (see `lua/lsp.lua`).
- **oxlint**, **oxfmt** — JS/TS linting & formatting.

### Installation
Clone this into `.config/nvim`. Plugins install automatically on first launch,
pinned to the revisions in `nvim-pack-lock.json` (the `vim.pack` lockfile — keep
it under version control so installs are reproducible).

### Keybindings
Leader is `\` (the default). Custom maps defined in this config:

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<C-l>` | n | Toggle line numbers | `lua/general.lua` |
| `\q` | n | Close current buffer, keep window/Neovim open | `lua/general.lua` |
| `\e` | n | Show full diagnostic for the current line in a float | `lua/lsp.lua` |
| `<C-Space>` | i | Manually trigger LSP completion | `lua/lsp.lua` |
| `<C-t>` | n | Open the nvzone context menu | `lua/menu_setup.lua` |
| `<RightMouse>` | n, v | Open the context menu at the click (tree-aware) | `lua/menu_setup.lua` |
| `<C-n>` | n | Toggle the nvim-tree pane | `lua/nvim_tree.lua` |
| `<C-e>` | n | Bring the tree back into a split if hidden | `lua/nvim_tree.lua` |

Inside the **nvim-tree pane** (on top of nvim-tree's own defaults):

| Key | Action | Source |
| --- | --- | --- |
| `<C-o>` | Reveal the node in macOS Finder (`open -R`) | `lua/nvim_tree.lua` |
| `v` | Open the file in a vertical split | `lua/nvim_tree.lua` |
| `s` | Open the file in a horizontal split | `lua/nvim_tree.lua` |
| `<C-r>` | Reload / refresh the tree | `lua/nvim_tree.lua` |

> LSP navigation (`grn` rename, `gra` code action, `grr` references, `gri`
> implementation, `K` hover, etc.) uses Neovim's built-in defaults — they aren't
> redefined here.

### Closing files vs. quitting
The tabline lists open **buffers**, but there's usually only a single editor
window (plus the nvim-tree pane on the left). Because of that:
- `:q` closes the editor window, leaving only the tree — and the auto-close
  autocmd in `lua/nvim_tree.lua` then quits Neovim. So `:q` effectively quits.
- `:bd` also closes the editor window instead of switching to your other buffer
  while the tree is open, with the same result.

To close the current file but keep the window (and Neovim) open, use **`<leader>q`**
(leader is `\`, so `\q`). It switches the window to another listed buffer first,
then deletes the old one (see `close_buffer` in `lua/general.lua`). Reserve `:q`
for actually quitting, and use `:close` / `<C-w>c` to close splits.
