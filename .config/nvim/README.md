# 📁 Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point (clean & minimal)
├── init.lua.backup            # Your original config (backed up)
└── lua/config/
    ├── options.lua            
    ├── keybinds.lua           
    ├── plugins.lua            
    ├── lsp.lua                
    ├── helpers.lua            
    └── autocommands.lua       
```


### Dashboard
<!-- add photo from screenshot  -->
![Dashboard](/images/dashboard.png)
## Theme Manager
<!-- Screenshot placeholder -->

## Sticky Notes
<!-- Screenshot placeholder -->

## Plugins List
<!-- Screenshot placeholder -->

### Keymap
Here is a comprehensive table of all keybinds from your Neovim configuration, including those defined for plugins:

### General Keybinds

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `Ctrl + o`       | Save                                     |
| `x (after o)`    | Save & Exit                              |
| `Ctrl + q`       | Quit                                     |
| `Ctrl + c`       | Force Quit (no save)                    |
| `Ctrl + x`       | Cut Line (to clipboard)                  |
| `Ctrl + k`       | Close side Pane                          |
| `Ctrl + y`       | Redo                                     |
| `Ctrl + z/_`     | Undo                                     |
| `Ctrl + a`       | Select All                               |
| `Ctrl + c (V)`   | Copy to Clipboard (visual)               |
| `Ctrl + v`       | Paste from Clipboard                     |
| `<C-n>`          | Toggle Nvim Tree                         |
| `<Tab>`          | Cycle to Next Buffer                     |
| `<S-Tab>`        | Cycle to Previous Buffer                 |
| `<C-p>`          | Open Telescope Find Files                |
| `<C-l>`          | Vertical Split                           |
| `<C-h>`          | Horizontal Split                         |
| `<C-k>`          | Close Current Split Pane                 |
| `<C-Left>`       | Move to Previous Pane                    |
| `<C-r>`          | Open Recent Files (Telescope)            |

### Window Management Keybinds

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<C-l>`          | Vertical split and resize                |
| `<C-h>`          | Horizontal split and resize              |
| `<C-k>`          | Close current split pane                 |

### Editing Keymaps

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<C-x>`          | Cut line                                 |
| `<C-c>`          | Copy line                                |
| `<C-v>`          | Paste                                    |
| `<C-z>`          | Undo                                     |
| `<C-y>`          | Redo                                     |
| `<C-o>`          | Save                                     |
| `x`              | Save & Exit                              |
| `<C-q>`          | Quit                                     |
| `<C-c>`          | Force Quit                               |
| `<C-w>`          | Close buffer                             |
| `<C-a>`          | Select all                               |

### Miscellaneous Keybinds

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<C-d>`          | Open dashboard                           |
| `<C-Left>`       | Move to previous pane                    |
| `<C-r>`          | Open recent project                      |
| `<C-R>`          | Recent files                             |
| `<C-t>`          | New file                                 |
| `<leader><CR>`   | Insert new line below                    |
| `<C-j>`          | Find word in current directory           |
| `*`              | Load last session                        |

### Plugin-Specific Keybinds

#### Nvim Tree

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<C-n>`          | Toggle Nvim Tree                         |

#### Bufferline

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<Tab>`          | Cycle to Next Buffer                     |
| `<S-Tab>`        | Cycle to Previous Buffer                 |

#### Telescope

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<C-p>`          | Open Telescope Find Files                |
| `<C-r>`          | Open Recent Files (Telescope)            |
| `<C-j>`          | Find word in current directory           |

#### Dashboard

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<C-d>`          | Open dashboard                           |
| `<leader>h`      | Show keybind cheatsheet                  |

#### Gitsigns

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `]g`             | Next Git hunk                            |
| `[g`             | Prev Git hunk                            |
| `<leader>gp`     | Preview hunk                             |
| `<leader>gr`     | Reset hunk                               |
| `<leader>gb`     | Blame line                               |
| `<leader>gs`     | Stage hunk                               |
| `<leader>gu`     | Undo stage hunk                          |

#### Trouble

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<leader>xx`     | Toggle Trouble                           |
| `<leader>xd`     | Document Diagnostics                      |
| `<leader>xw`     | Workspace Diagnostics                     |
| `<leader>xl`     | Location List                            |
| `<leader>xq`     | Quickfix List                           |
| `gR`             | LSP References                           |

#### Sticky Notes

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<leader>mn`     | Open sticky note                         |
| `<leader>ms`     | Toggle Sticky Notes Picker               |
| `<leader>w`      | Save sticky note                         |
| `<Esc>`          | Close without saving                     |
| `<leader>tsk`    | Add new task to sticky note              |
| `<leader>n`      | Jump to typing section                   |
| `<leader>d`      | Toggle task done/undone                  |

#### LSP Keybinds

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `gd`             | Go to definition                         |
| `gD`             | Go to declaration                        |
| `gi`             | Go to implementation                     |
| `gr`             | Go to references                         |
| `K`              | Hover documentation                      |
| `<leader>rn`     | Rename symbol                            |
| `<leader>ca`     | Code action                              |
| `<leader>f`      | Format buffer                            |
| `[d`             | Previous diagnostic                      |
| `]d`             | Next diagnostic                          |

#### Multi-Cursor Keybinds

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<C-S-Down>`     | Start/extend block selection down       |
| `<C-S-Up>`       | Start/extend block selection up         |
| `<leader><Space>`| Insert space at start of block selection |
| `<leader><Tab>`   | Insert tab at start of block selection  |
| `<leader>s`      | Append space at end of block selection   |
| `<leader>t`      | Append tab at end of block selection     |

### Floating Terminal

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<leader>t`      | Open Floating Terminal                   |

### Additional Keybinds

| Keybind          | Action                                   |
|------------------|------------------------------------------|
| `<leader>lh`     | Show LSP keybinds                       |
| `<leader>ih`     | Toggle Inlay Hints                      |
| `<leader>mp`     | Toggle Markdown Preview                  |
| `<leader>s`      | Open Plugin Store                        |




