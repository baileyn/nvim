local wk = require("which-key")

wk.setup({
	["<esc>"] = "ESC",
})

wk.register({
	t = {
		name = "Telescope",
		b = { "<cmd>Telescope buffers<CR>", "Buffers" },
		f = { "<cmd>Telescope find_files<CR>", "Files" },
		l = { "<cmd>Telescope live_grep<CR>", "Lines" },
		g = {
			name = "git",
			b = { "<cmd>Telescope git_branches<CR>", "Branches" },
			c = { "<cmd>Telescope git_commits<CR>", "Commits" },
			s = { "<cmd>Telescope git_status<CR>", "Status" },
		},
	},

	g = {
		name = "Git",
		p = { ":G push<CR>", "Push" },
		s = { ":G<CR>", "Status" },
		d = { ":diffget //2<CR>", "Accept Left (Conflict)" },
		h = { ":diffget //3<CR>", "Accept Right (Conflict)" },
	},

	p = {
		name = "Project",
		v = { ":E<CR>", "View" },
		f = { ":Telescope file_browser<CR><ESC>", "File Browser" },
	},

	h = {
		name = "Harpoon",
		h = { ":lua require('harpoon.mark').add_file()<CR>", "Harpoon File" },
		m = { ":lua require('harpoon.ui').toggle_quick_menu()<CR>", "Toggle Quick Menu" },
		a = { ":lua require('harpoon.ui').nav_file(1)<CR>", "Go to File 1" },
		r = { ":lua require('harpoon.ui').nav_file(2)<CR>", "Go to File 2" },
		s = { ":lua require('harpoon.ui').nav_file(3)<CR>", "Go to File 3" },
		t = { ":lua require('harpoon.ui').nav_file(4)<CR>", "Go to File 4" },

		n = { ":lua require('harpoon.term').gotoTerminal(1)<CR>", "Go to Terminal 1" },
		e = { ":lua require('harpoon.term').gotoTerminal(2)<CR>", "Go to Terminal 2" },
		i = { ":lua require('harpoon.term').gotoTerminal(3)<CR>", "Go to Terminal 3" },
		o = { ":lua require('harpoon.term').gotoTerminal(4)<CR>", "Go to Terminal 4" },
	},
}, { prefix = "<leader>" })

wk.register({
	name = "Buffer",
	["f"] = { ":Format<CR>", "Format" },
}, { prefix = "<leader>b" })

wk.register({
	["<esc>"] = { "<C-\\><C-n>" },
}, { mode = "t" })
