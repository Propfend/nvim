nvim-config
===========

Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim).

<img width="1281" height="705" alt="image" src="https://github.com/user-attachments/assets/fdf5934c-27a5-4e82-8434-a4b81cfff160" />

Requirements
------------

### Core

| Tool | Why |
|------|-----|
| [neovim](https://github.com/neovim/neovim) >= 0.11 | `vim.lsp.config` / `vim.lsp.enable` are used throughout |
| [git](https://git-scm.com/) | lazy.nvim clones plugins |
| [gcc](https://gcc.gnu.org/) | compiles treesitter parsers and native plugin builds |
| [make](https://www.gnu.org/software/make/) | builds [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) and [CopilotChat](https://github.com/CopilotC-Nvim/CopilotChat.nvim) tiktoken |
| [curl](https://curl.se/) | [plenary.curl](https://github.com/nvim-lua/plenary.nvim) posts to the inference server |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | [telescope](https://github.com/nvim-telescope/telescope.nvim) live grep |
| [fd](https://github.com/sharkdp/fd) | telescope file finding |
| [node](https://nodejs.org/) + [npm](https://www.npmjs.com/) | [copilot.vim](https://github.com/github/copilot.vim), [markdown-preview](https://github.com/iamcco/markdown-preview.nvim), [typescript-tools](https://github.com/pmizio/typescript-tools.nvim) |
| [wl-clipboard](https://github.com/bugaevc/wl-clipboard) | `vim.g.clipboard` is pinned to `wl-copy` / `wl-paste` |

### Language servers

| Server | Binary | Filetypes |
|--------|--------|-----------|
| [lua-language-server](https://github.com/LuaLS/lua-language-server) | `lua-language-server` | lua |
| [pyright](https://github.com/microsoft/pyright) | `pyright-langserver` | python |
| [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) | `gopls` | go, gomod, gowork, gotmpl |
| [rust-analyzer](https://rust-analyzer.github.io/) | `rust-analyzer` | rust |
| [terraform-ls](https://github.com/hashicorp/terraform-ls) | `terraform-ls` | terraform, terraform-vars, tf |
| [ast-grep](https://ast-grep.github.io/) | `ast-grep` | structural search, multi-language |
| [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) | `vscode-css-language-server`, `vscode-html-language-server`, `vscode-json-language-server` | css, html, json |
| [nixd](https://github.com/nix-community/nixd) | `nixd` | nix |
| [arduino-language-server](https://github.com/arduino/arduino-language-server) | `arduino-language-server` | arduino |
| [typescript](https://www.typescriptlang.org/) 5.x | `tsserver` | ts, tsx, js, jsx |

### Formatters

Wired through [conform.nvim](https://github.com/stevearc/conform.nvim).

| Filetype | Formatter |
|----------|-----------|
| lua | [stylua](https://github.com/JohnnyMorganz/StyLua) |
| rust | [rustfmt](https://github.com/rust-lang/rustfmt) |
| go | [gofmt](https://pkg.go.dev/cmd/gofmt) |
| python | [isort](https://pycqa.github.io/isort/), [black](https://github.com/psf/black) |
| javascript, typescript | [prettierd](https://github.com/fsouza/prettierd) |
| nix | [alejandra](https://github.com/kamadorueda/alejandra) |
| terraform | [terraform](https://developer.hashicorp.com/terraform) fmt |

### Treesitter parsers

Installed on demand by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter);
each one is compiled, so a C compiler is required.

`bash`, `c`, `css`, `diff`, `go`, `html`, `javascript`, `lua`, `luadoc`,
`markdown`, `python`, `query`, `rust`, `terraform`, `vim`, `vimdoc`.

### Optional, host-specific

| Tool | Why |
|------|-----|
| [kitty](https://sw.kovidgoyal.net/kitty/) | [kitty-scrollback.nvim](https://github.com/mikesmithgh/kitty-scrollback.nvim) |
| [imagemagick](https://imagemagick.org/) | [image.nvim](https://github.com/3rd/image.nvim), plus the [magick](https://luarocks.org/modules/leafo/magick) luarock |
| [Firefox](https://www.mozilla.org/firefox/) or [Chromium](https://www.chromium.org/) | [firenvim](https://github.com/glacambre/firenvim) |

### Development of this repository

| Tool | Why |
|------|-----|
| [luajit](https://luajit.org/) | 5.1-compatible interpreter matching Neovim's embedded Lua |
| [luarocks](https://luarocks.org/) | installs test dependencies from `nvim-config.rockspec` |
| [busted](https://lunarmodules.github.io/busted/) | test runner |
| [nlua](https://github.com/mfussenegger/nlua) | runs busted inside Neovim so the `vim` global exists |
| [luacheck](https://github.com/lunarmodules/luacheck) | static analysis |
| [stylua](https://github.com/JohnnyMorganz/StyLua) | formatting |

Make targets
------------

Project linting. This is the default target:

```
make lint
```

Formats project code:

```
make fmt
```

Runs configuration unit tests:

```
make test
```

Deletes both `node_modules` and `.luarocks` from the repository root:

```
make clean
```

Tests live inside the files they cover, guarded by `if describe then` so they
only run under busted. 

Conversational diagnostics
--------------------------

Example:

```
:PromptLSP flag every occurrence of the word I with warning severity
```

This commands sends the buffer contents to `http://127.0.0.1:8080` by default (you can change that through `vim.g.none_ls_inference_server_address` var, in `lua/conversational-diagnostics-builder/request_diagnostics_from_inference_server.lua`) as an OpenAI-compatible `/v1/chat/completions` request, with the diagnostics JSON schema in
`response_format`.

Manual installation
-------------------

Install the tools listed above with your own package manager first. Neovim must
be 0.11 or newer; nothing else is needed to get started, since the language
servers and formatters are only consulted for the filetypes you open.

Clone the repository straight into the Neovim configuration directory. If you
already have one, move it aside rather than merging.

```
git clone https://github.com/Propfend/nvim-config ~/.config/nvim
```

Start Neovim. [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself:

```
nvim
```

Docker
------

Builds an [Ubuntu](https://ubuntu.com/) 24.04 image with every tool above
preinstalled and this configuration at `/root/.config/nvim`. The resulting
image is 4.32 GB:

```
docker build -t nvim-config .
```

Starts a login shell in the image.

```
docker run --rm -it nvim-config
```

The shell is [zsh](https://www.zsh.org/) by default. Override it with
`NVIM_DOCKERFILE_SHELL`.

```
docker run --rm -it -e NVIM_DOCKERFILE_SHELL=bash nvim-config
```

Arguments are forwarded to the shell, so the test suite can be run directly.

```
docker run --rm -t nvim-config -lc 'make test'
```

`nixd` has no prebuilt release binary, so the image installs
[Nix](https://nixos.org/) itself in single-user mode and pulls `nixd` from
nixpkgs.
