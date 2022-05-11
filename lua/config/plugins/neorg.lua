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
				workspace = "home",
			},
		},
        ["core.gtd.ui"] = {},
        ["core.gtd.helpers"] = {},
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
					home = "~/notes/home",
				},
			},
		},
		["core.norg.qol.toc"] = {},
		["core.integrations.telescope"] = {},
	},
})
