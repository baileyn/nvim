require("neorg").setup({
	load = {
		["core.defaults"] = {},
		["core.keybinds"] = {
			config = {
				neorg_leader = " ",
			},
		},
		["core.gtd.base"] = {
			config = {
				workspace = "gtd",
			},
		},
		["core.presenter"] = {
			config = {
				zen_mode = "zen-mode",
			},
		},
		["core.norg.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
		["core.norg.concealer"] = {},
		["core.norg.dirman"] = {
			config = {
				workspaces = {
					work = "~/notes/default",
				},
                autodetect = false,
			},
		},
		["core.norg.qol.toc"] = {},
		["core.integrations.telescope"] = {},
	},
})
