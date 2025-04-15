-- Nvim-tree config
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- nvim-tree keybindings
vim.keymap.set('n', '<c-i>', ':NvimTreeResize +3<CR>', {})
vim.keymap.set('n', '<c-d>', ':NvimTreeResize -3<CR>', {})
vim.keymap.set('n', '<leader>ft', ':NvimTreeToggle <CR>', {})
