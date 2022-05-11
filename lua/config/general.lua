vim.opt.termguicolors = true
vim.opt.termguicolors = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.g.mapleader = ' '

-- Folding
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldlevel = 2

vim.o.tabstop = 4
vim.o.shiftwidth = 0

vim.wo.number = true
vim.wo.relativenumber = true

vim.api.nvim_exec([[
filetype plugin indent on
augroup custom_commands
    autocmd!
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
augroup end
]], true)
