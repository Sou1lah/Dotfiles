
# 🧠 Neovim Keybinds Cheatsheet

> Complete reference of all custom and plugin keybindings.

---

## 🔧 General Keybinds

| Keybind        | Action                        |
|----------------|-------------------------------|
| Ctrl + o       | Save                          |
| x (after o)    | Save & Exit                   |
| Ctrl + q       | Quit                          |
| Ctrl + c       | Force Quit (no save)          |
| Ctrl + x       | Cut Line (clipboard)          |
| Ctrl + k       | Close side Pane               |
| Ctrl + y       | Redo                          |
| Ctrl + z / _   | Undo                          |
| Ctrl + a       | Select All                    |
| Ctrl + c (V)   | Copy (visual mode)            |
| Ctrl + v       | Paste                         |
| <C-n>          | Toggle Nvim Tree              |
| <Tab>          | Next Buffer                   |
| <S-Tab>        | Prev Buffer                   |
| <C-p>          | Telescope Find Files          |
| <C-l>          | Vertical Split                |
| <C-h>          | Horizontal Split              |
| <C-k>          | Close Split Pane              |
| <C-Left>       | Previous Pane                 |
| <C-r>          | Telescope Recent Files        |

## 🪟 Window Management

| Keybind | Action                   |
|---------|--------------------------|
| <C-l>   | Vertical split + resize  |
| <C-h>   | Horizontal split + resize|
| <C-k>   | Close split              |

## ✍️ Editing Keymaps

| Keybind | Action           |
|---------|------------------|
| <C-x>   | Cut line         |
| <C-c>   | Copy line        |
| <C-v>   | Paste            |
| <C-z>   | Undo             |
| <C-y>   | Redo             |
| <C-o>   | Save             |
| x       | Save & Exit      |
| <C-q>   | Quit             |
| <C-c>   | Force Quit       |
| <C-w>   | Close buffer     |
| <C-a>   | Select all       |

## 🧩 Plugin Keybinds

<details>
<summary>📁 Nvim Tree</summary>

| Keybind | Action          |
|---------|-----------------|
| <C-n>   | Toggle Tree     |

</details>

<details>
<summary>📑 Bufferline</summary>

| Keybind   | Action             |
|-----------|--------------------|
| <Tab>     | Next Buffer        |
| <S-Tab>   | Prev Buffer        |

</details>

<details>
<summary>🔭 Telescope</summary>

| Keybind | Action                  |
|---------|-------------------------|
| <C-p>   | Find Files              |
| <C-r>   | Recent Files            |
| <C-j>   | Find word in directory  |

</details>

<details>
<summary>📊 Dashboard</summary>

| Keybind     | Action               |
|-------------|----------------------|
| <C-d>       | Open Dashboard       |
| <leader>h   | Keybind Cheatsheet   |

</details>

<details>
<summary>🌱 Gitsigns</summary>

| Keybind     | Action         |
|-------------|----------------|
| ]g          | Next Hunk      |
| [g          | Prev Hunk      |
| <leader>gp  | Preview Hunk   |
| <leader>gr  | Reset Hunk     |
| <leader>gb  | Blame Line     |
| <leader>gs  | Stage Hunk     |
| <leader>gu  | Undo Stage     |

</details>

<details>
<summary>🧨 Trouble</summary>

| Keybind     | Action                 |
|-------------|------------------------|
| <leader>xx  | Toggle Trouble         |
| <leader>xd  | Document Diagnostics   |
| <leader>xw  | Workspace Diagnostics  |
| <leader>xl  | Location List          |
| <leader>xq  | Quickfix List          |
| gR          | LSP References         |

</details>

<details>
<summary>📝 Sticky Notes</summary>

| Keybind      | Action                     |
|--------------|----------------------------|
| <leader>mn   | Open Sticky Note           |
| <leader>ms   | Toggle Sticky Picker       |
| <leader>w    | Save Sticky                |
| <Esc>        | Close (no save)            |
| <leader>tsk  | Add Task to Sticky         |
| <leader>n    | Jump to typing section     |
| <leader>d    | Toggle task done/undone    |

</details>

<details>
<summary>🚀 LSP</summary>

| Keybind      | Action             |
|--------------|--------------------|
| gd           | Go to Definition   |
| gD           | Go to Declaration  |
| gi           | Go to Implementation|
| gr           | Go to References   |
| K            | Hover Docs         |
| <leader>rn   | Rename             |
| <leader>ca   | Code Action        |
| <leader>f    | Format Buffer      |
| [d           | Prev Diagnostic    |
| ]d           | Next Diagnostic    |

</details>

<details>
<summary>🖱️ Multi-Cursor</summary>

| Keybind          | Action                           |
|------------------|----------------------------------|
| <C-S-Up>         | Block Select Up                  |
| <C-S-Down>       | Block Select Down                |
| <leader><Space>  | Insert space at block start      |
| <leader><Tab>    | Insert tab at block start        |
| <leader>s        | Space at block end               |
| <leader>t        | Tab at block end                 |

</details>

<details>
<summary>🧱 Floating Terminal</summary>

| Keybind     | Action                 |
|-------------|------------------------|
| <leader>t   | Open Floating Terminal |

</details>

<details>
<summary>📎 Other</summary>

| Keybind     | Action                    |
|-------------|---------------------------|
| <leader>lh  | Show LSP Keybinds         |
| <leader>ih  | Toggle Inlay Hints        |
| <leader>mp  | Markdown Preview          |
| <leader>s   | Plugin Store              |

</details>

---

**📌 Tip:** Use `<leader>` as your space key unless customized.

---
