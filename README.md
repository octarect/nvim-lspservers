# nvim-lspservers

Easy to install a language server for [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

## Features

- Install/Uninstall language servers
- Automatic installation

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

### Examples

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

You can configure nvim-lspservers by setup() method. Default settings is as below.

NOTE: setup() must be called before installing or setting up servers.

```lua
require'lspservers'.setup{
  installation_path = '$HOME/.local/share/nvim/lspservers',
  default_servers = {},
}
```

### Auto install

You can install your favorite servers when they aren't installed.

```lua
require'lspservers'.setup{
  default_servers = { 'gopls', 'vimls' },
}
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

