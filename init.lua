vim.o.termguicolors = true
vim.o.termguicolors = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.updatetime = 300
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.g.mapleader = " "
vim.g.netrw_altfile = 1

-- Folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 2

vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd('colorscheme habamax')

-- Augroups
vim.api.nvim_create_augroup("line_numbers", {})
vim.api.nvim_create_autocmd("InsertEnter", {
    group = "line_numbers",
    command = ":set norelativenumber",
})
vim.api.nvim_create_autocmd("InsertLeave", {
    group = "line_numbers",
    command = ":set relativenumber",
})

vim.api.nvim_create_augroup("formatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "formatting",
    callback = function()
        vim.lsp.buf.format()
    end,
})

-- Packer Bootstrap
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use "nvim-lua/plenary.nvim"

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        config = function()
            require('nvim-treesitter.configs').setup {
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },
                indent = {
                    enable = true,
                }
            }
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = 'plenary.nvim',
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>tf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>tl', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>tb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>th', builtin.help_tags, {})
        end
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
