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

```
call dein#add('neovim/nvim-lspconfig')
call dein#add('octarect/nvim-lspservers')
```

### Usage

```
local servers = require'lspservers'.get_installed_servers()
for _, server in pairs(servers) do
  server:setup({ on_attach = on_attach })
end
```

## Configuration

### Change the installation path of language servers

By default, language servers is placed on `$HOME/.local/share/nvim/lspservers`.

You can specify another directory as their installation path.

```
let g:lspservers_installation_path = '/other/installation/path'
```

## Development

### Additional dependencies

You need to install [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for automated testing.

See https://github.com/nvim-lua/plenary.nvim#installation

### Test

```
make test
```

