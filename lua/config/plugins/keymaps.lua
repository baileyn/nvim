local nest = require("nest")
local M = {}

function M.setup()
	nest.applyKeymaps({
		-- Let ESC go to insert mode in Terminal
		{ "<Esc>", "<C-\\><C-n>", mode = "t" },
		{ "==", ":Format<CR>" },
		-- Prefix  every nested keymap with <leader>
		{
            "<leader>",
            {
                -- Prefix every nested keymap with f (meaning actually <leader>f here)
                {
                    "f",
                    {
						{ "b", "<cmd>Telescope buffers<CR>" },
						{ "f", "<cmd>Telescope find_files<CR>" },
						-- This will actually map <leader>fl
						{ "l", "<cmd>Telescope live_grep<CR>" },
						-- Prefix every nested keymap with g (meaning actually <leader>fg here)
						{
							"g",
							{
								{ "b", "<cmd>Telescope git_branches<CR>" },
								-- This will actually map <leader>fgc
								{ "c", "<cmd>Telescope git_commits<CR>" },
								{ "s", "<cmd>Telescope git_status<CR>" },
							},
						},
					},
				},

				-- Fugitive mappings
				{
					"g",
					{
						{ "p", ":G push<CR>" },
						{ "g", ":diffget //2<CR>" },
						{ "h", ":diffget //3<CR>" },
					},
				},

				-- Project mappings
				{ "p", {
					{ "v", ":E<CR>" },
				} },
			},
		},

		-- Use insert mode for all nested keymaps

		{
			mode = "i",
			{
				{ "jk", "<Esc>" },

				-- Set <expr> option for all nested keymaps
				-- { options = { expr = true }, {
				--     { '<cr>',       'compe#confirm("<CR>")' },
				--     -- This is equivalent to viml `:inoremap <C-Space> <expr>compe#complete()`
				--     { '<C-Space>',  'compe#complete()' },
				-- }},
			},
		},
	})
end

return M
