return {
    {
		"elihunter173/dirbuf.nvim",
		config = function()
			require("dirbuf").setup({
				sort_order = "directories_first",
			})
			vim.cmd("command E Dirbuf")
		end,
	},
}
