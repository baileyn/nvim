local wk = require("which-key")

wk.setup {
    ['<esc>'] = 'ESC',
}

wk.register({
	t = {
		name = 'Telescope',
        b = { '<cmd>Telescope buffers<CR>', 'Buffers' },
        f = { '<cmd>Telescope find_files<CR>', 'Files' },
        l = { '<cmd>Telescope live_grep<CR>', 'Lines' },
        g = {
            name = 'git',
            b = { '<cmd>Telescope git_branches<CR>', "Branches" },
            c = { '<cmd>Telescope git_commits<CR>', "Commits" },
            s = { '<cmd>Telescope git_status<CR>', "Status" },
        },
	},

    g = {
        name = 'Git',
        p = { ':G push<CR>', 'Push' },
        s = { ':G<CR>', 'Status' },
        d = { ':diffget //2<CR>', 'Accept Left (Conflict)' },
        h = { ':diffget //3<CR>', 'Accept Right (Conflict)' },
    },

    p = {
        name = 'Project',
        v = { ':E<CR>', 'View' },
    }
}, { prefix = '<leader>' })

wk.register({
    name = 'Buffer',
    ['='] = { ':Format<CR>', 'Format' },
}, { prefix = '<leader>b' })

wk.register({
    ['<esc>'] = { '<C-\\><C-n>' },
}, { mode = 't' })
