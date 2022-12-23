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

vim.cmd([[colorscheme habamax]])

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
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use("nvim-lua/plenary.nvim")

	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	})

	use({
		"williamboman/mason-lspconfig.nvim",
		after = "mason.nvim",
	})

	use({
		"neovim/nvim-lspconfig",
		after = { "nvim-cmp", "mason-lspconfig.nvim", "mason.nvim" },
		config = function()
			-- Setup keymaps
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, bufopts)
			end

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			require("mason-lspconfig").setup({})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
			})
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "vim" },
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
				},
			})
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = "plenary.nvim",
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>tf", builtin.find_files, {})
			vim.keymap.set("n", "<leader>tl", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>tb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>th", builtin.help_tags, {})
		end,
	})
	use({ "L3MON4D3/LuaSnip" })
	use({ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" })

	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-cmdline" })
	use({
		"hrsh7th/nvim-cmp",
		after = { "cmp-nvim-lsp", "cmp-buffer", "cmp-path", "cmp-cmdline", "cmp_luasnip" },
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					-- { name = 'vsnip' }, -- For vsnip users.
					{ name = "luasnip" }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
				}, {
					{ name = "buffer" },
				}),
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	})

	use({
		"nvim-neorg/neorg",
		requires = "nvim-lua/plenary.nvim",
		run = ":Neorg sync-parsers",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.norg.dirman"] = {
						config = {
							workspaces = {
								work = "~/notes/work",
								home = "~/notes/home",
							},
						},
					},
				},
			})
		end,
	})

	use({ "tpope/vim-vinegar" })

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})

	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	use("nvim-tree/nvim-web-devicons")
	use({
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup()
		end,
	})

	use({
		"folke/which-key.nvim",
		config = function()
			local wk = require("which-key")
			wk.setup()

			wk.register({
				t = {
					c = { "<CMD>tabclose<CR>", "Close Tab" },
				},
			}, { prefix = "<leader>" })
		end,
	})

	use({
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("nvim-treesitter.configs").setup({
				context_commentstring = {
					enable = true,
				},
			})
		end,
	})

	use({ "tpope/vim-fugitive" })

	use({
		"jose-elias-alvarez/null-ls.nvim",
	})

	use({
		"jayp0521/mason-null-ls.nvim",
		after = { "mason.nvim" },
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = { "stylua", "jq" },
				automatic_setup = true,
			})
			require("mason-null-ls").setup_handlers()
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
