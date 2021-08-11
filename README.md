# nvim-lspservers

Easy to install a language server for [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

**nvim-lspservers is in early stage and a breaking change may happen suddenly. Stay tuned 😎**

## Features

- 🏭 Automate installation and setup of language servers
- 🚀 Just call `require'lspservers'.setup()` to configure
- ⚙️ Easy to customize language server

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

> See also [Available Language Servers](#available-language-servers) for examples of `:LspServersInstall`.

The following code will install and setup language servers.

```lua
require'lspservers'.setup{
  -- List servers you want to use. Each value of RHS should be `true` or dictionary.
  servers = {
    gopls = true,

    -- You can write server-specific configuration as follows;
    -- vimls = {
    --   filetypes = { "vim", ... },
    --   init_options = {
    --     ...
    --   },
    -- },
  },

  -- `global` configuration will be applied to all language servers.
  global = {
    on_attach = on_attach,
  },
}
```

### Available options

You can configure the plugin by passing options to `setup()` function as dictionary.
The following options are available.

#### Top level

| Option              | Description                                                            | Type       | Default                              |
|:--------------------|:-----------------------------------------------------------------------|:-----------|:------------------------------------:|
| `installation_path` | Where to install servers.                                              | String     | `$HOME/.local/share/nvim/lspservers` |
| `global`            | Configuration for all servers.                                         | Dictionary | `{}`                                 |
| `servers`           | Configuration for each server. See also [Server level](#server-level). | Dictionary | `{}`                                 |

#### Server level

You can use same server name as nvim-lspconfig. See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md

Some special fields is defined for nvim-lspservers and they will be ignored as server configuration.

| Option        | Description                                            | Type    | Default |
|:--------------|:-------------------------------------------------------|:--------|:-------:|
| `auto_config` | Determine whether to apply recommended config or not. | Boolean | `true`  |

## Available language servers

**TODO**: I am planning to expand our supported servers in series. For the time being, we will focus to add same servers as [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md).

| Language   | Language Server | Auto config |
|:-----------|:----------------|:-----------:|
| Dockerfile | dockerls        |             |
| Go         | gopls           |             |
| HTML       | html            | Yes         |
| Lua        | sumneko_lua     | Yes         |
| TypeScript | tsserver        |             |
| Vim        | vimls           |             |
| YAML       | yamlls          |             |

## Development

### Additional dependencies

You need to install [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for automated testing.

See https://github.com/nvim-lua/plenary.nvim#installation

### Adding new server

1. Create new lua file in `./lua/lspservers/servers/`. (e.g. `vimls.lua`)

2. Edit `vimls.lua`

`installer` and `cmd` will be executed in server's installation path.
In this example, working directry is `<installation_path>/vimls/`.

```lua
local server = require'lspservers/server'

return server.new({
  name = 'vimls',
  cmd = { './node_modules/.bin/vim-language-server', '--stdio' },
  installer = [[
    set -e
    npm install vim-language-server@latest
  ]]
})
```

3. Commit your changes and submit pull request.
