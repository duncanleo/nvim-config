# nvim
Neovim configuration.

A native-Lua setup: plugins via the built-in `vim.pack`, native LSP + completion
(no coc.nvim), `lualine`, `nvim-tree`, `nvzone/menu`, and a hand-ported ANSI
colorscheme that inherits your terminal's 16-color palette (`termguicolors` off).

### Requirements

| Requirement | Notes |
| --- | --- |
| Neovim 0.12+ | Plugins are managed by the built-in `vim.pack`. |
| A Nerd Font | Required for `nvim-web-devicons` file icons and diagnostic / statusline glyphs. |
| fzf | The `junegunn/fzf` plugin builds its own binary on install via the `PackChanged` hook in `lua/plugins.lua`. |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Powers `:Rg` and faster `:Files`; included in the [Homebrew](#homebrew-dependencies) block below. |

### Language servers (optional, enabled when present)
LSP servers are external binaries, resolved per-project (preferring
`node_modules/.bin`, then `$PATH`). They're enabled lazily — a missing one is
simply skipped rather than erroring:

| Server | Purpose | Provided by / install source | Notes |
| --- | --- | --- | --- |
| `tsgo` | TypeScript | `@typescript/native-preview` via `npm i -g @typescript/native-preview`, or as a project devDependency | Only enabled when a `tsgo` binary is resolvable from the launch directory; see `lua/lsp.lua`. |
| `vtsls` | TypeScript fallback | Homebrew package `vtsls` | Skipped when `tsgo` is available. |
| `eslint` | JS/TS linting | `vscode-eslint-language-server` from [`vscode-langservers-extracted`](https://formulae.brew.sh/formula/vscode-langservers-extracted) | Fix-on-save is enabled via the server's `codeActionOnSave` setting; see `lua/lsp.lua`. |
| `biome` | JS/TS linting & formatting | `biome` CLI via `npm i -g @biomejs/biome`, or as a project devDependency | Resolved per-project before `$PATH`. |
| `jsonls` | JSON language support | `vscode-json-language-server` from `vscode-langservers-extracted` | Resolved per-project before `$PATH`. |
| `yamlls` | YAML language support | `yaml-language-server` via `npm i -g yaml-language-server`, or as a project devDependency | Resolved per-project before `$PATH`. |
| `tailwindcss` | Tailwind CSS class completion & linting | Homebrew package `tailwindcss-language-server` | Only attaches in projects with a Tailwind config; see `lua/lsp.lua`. |
| `oxlint` / `oxfmt` | JS/TS linting & formatting | External binaries | Enabled when present. |

### Formatting
Formatting runs through `conform.nvim` (format-on-save, or `<leader>f` manually;
see `lua/format.lua`). Like the language servers, formatters are external
binaries — a missing one is skipped rather than erroring.

| Formatter | Filetypes | Provided by / install source | Notes |
| --- | --- | --- | --- |
| `stylua` | Lua | Homebrew package `stylua` | Style is pinned in `stylua.toml` (2-space indent, single quotes, 120 cols). Without the binary, conform silently skips `.lua` files. |
| `prettier` | JS/TS, JSON, CSS, HTML, YAML, Markdown | Project-local `node_modules/.bin` | Only runs where the project has it. |

### Homebrew dependencies
Everything this config installs via Homebrew, in one command:

```sh
brew install neovim ripgrep stylua vscode-langservers-extracted tailwindcss-language-server vtsls
```

| Package | Used for |
| --- | --- |
| `neovim` | Neovim 0.12+ with built-in `vim.pack`. |
| `ripgrep` | `:Rg` and faster `:Files`. |
| `stylua` | Lua formatting; see [Formatting](#formatting). |
| `vscode-langservers-extracted` | `eslint` and `jsonls` language servers. |
| `tailwindcss-language-server` | Tailwind class completion & linting. |
| `vtsls` | TypeScript language server fallback when `tsgo` is unavailable. |

The remaining language servers are installed via npm rather than Homebrew — see
[Language servers](#language-servers-optional-enabled-when-present) for `tsgo`,
`biome`, and `yamlls`. A Nerd Font is also required for icons/glyphs.

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
