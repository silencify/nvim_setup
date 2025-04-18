local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- file manager
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')

-- harpoon
Plug('nvim-lua/plenary.nvim')
Plug('ThePrimeagen/harpoon', { ['branch'] = 'harpoon2'})

-- telescope
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.6' })

-- nvim lsp
Plug('neovim/nvim-lspconfig')

-- theme
Plug('joshdick/onedark.vim')

-- vim fugutive
Plug("tpope/vim-fugitive")

-- tree sitter
Plug("nvim-treesitter/nvim-treesitter", {["do"] = ":TSUpdate"})

-- nvim cmp
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')

vim.call('plug#end')

require('config.options')
require('config.remap')

require('plugin_config.harpoon')
require('plugin_config.nvim-tree')
require('plugin_config.telescope')
require('plugin_config.theme')
require('plugin_config.tree-sitter')
require('plugin_config.python-lsp')
require('plugin_config.nvim-cmp')
require('plugin_config.typescript-lsp')
