require("neorg").setup({
	load = {
		["core.defaults"] = {},
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
					work = "~/notes/work",
					home = "~/notes/home",
                    gtd = "~/notes/gtd"
				},
			},
		},
		["core.gtd.base"] = {
			config = {
				workspace = "gtd",
			},
		},
	},
})
