# nvim-lspservers

Easy to install a language server for [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

## Getting Started

### Dependencies

`nvim-lspservers` uses the following tools to install language servers;

- go
- npm

Obviously you must have [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

### Installation

Using [dein](https://github.com/Shougo/dein.vim)

```nvim
call dein#add('neovim/nvim-lspconfig')
call dein#add('octarect/nvim-lspservers')
```

## Usage

### Enable language servers

The following lua code setups all servers managed by `nvim-lspservers`.

```lua
local servers = require'lspservers'.get_installed_servers()
for _, server in pairs(servers) do
  server:setup({ on_attach = on_attach })
end
```

### Available commands

> See also [Available Language Servers](#available-language-servers) for examples of `:LspServersInstall`.

| Command                                |                              |
|:---------------------------------------|:-----------------------------|
| :LspServersInstall <language_server>   | Install a language server.   |
| :LspServersUninstall <language_server> | Uninstall a language server. |

## Configuration

### Change the installation path of language servers

By default, language servers is placed on `$HOME/.local/share/nvim/lspservers`.

You can specify another directory as their installation path.

```nvim
let g:lspservers_installation_path = '/other/installation/path'
```

## Available language servers

| Language | Language Server | Command                    |
|:---------|:----------------|:---------------------------|
| Go       | gopls           | `:LspServersInstall gopls` |
| Vim      | vimls           | `:LspServersInstall vimls` |

## Development

### Additional dependencies

You need to install [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for automated testing.

See https://github.com/nvim-lua/plenary.nvim#installation

### Test

```bash
make test
```

