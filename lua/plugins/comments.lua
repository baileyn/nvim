return {
    {
        'numToStr/Comment.nvim',
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require('Comment').setup {
                ignore = '^$',
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
        end,
    },
    {
        's1n7ax/nvim-comment-frame',
        dependencies = {
            { 'nvim-treesitter' },
        },
        config = function()
            require('nvim-comment-frame').setup()
        end,
        keys = {
            '<leader>cf',
            '<leader>cm',
        },
    },

    {
        'danymat/neogen',
        config = function()
            require('neogen').setup {
                enabled = true,
            }
        end,
        cmd = 'Neogen',
        dependencies = 'nvim-treesitter/nvim-treesitter',
    },
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
