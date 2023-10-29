# lualine-copilot

A lualine component to show github copilot status,
you can toggle the enabled state by clicking

# Screenshots

Copilot enabled
![image](https://user-images.githubusercontent.com/61115159/155043869-2d6f836d-1fee-4635-9910-65b9bd81fddd.png)

Copilot disabled
![image](https://user-images.githubusercontent.com/61115159/155043897-9d9976ee-d763-46ac-87eb-37a2461672c6.png)

# Installation

## lazy.nvim

```lua
-- lua
{ "ofseed/lualine-copilot" }
```

## [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
-- lua
use { "ofseed/lualine-copilot" }
```

## [vim-plug](https://github.com/junegunn/vim-plug)
```vim
" vimscript
Plug 'ofseed/lualine-copilot'
```

# Usage
Default values for lualine configuration is
```lua
lualine_x = {
  'encoding',
  'fileformat',
  'filetype'
}
```
So I recommend that you can add it to this table and arrange them in a reasonable order.
My configuration is
```lua
lualine_x = {
  "copilot",
  "filetype",
  "fileformat",
  "encoding",
},
```

Or you can custom icons.

```lua
-- lua
require("lualine").setup {
  sections = {
    lualine_x = {
      -- Options with default values
      {
        "copilot",
        show_running = true,
        symbols = {
          status = {
            enabled = " ",
            disabled = " ",
          },
          spinners = require("copilot-status.spinners").dots,
        },
      },
    }
  }
}
```
# TODO
- [ ] Add different highlights
- [ ] Show offline status
