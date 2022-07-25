local on_attach = function(client, bufnr)
	require("which-key").register({
		name = "Buffer",
		K = { '<cmd>lua require"lspsaga.hover".render_hover_doc()<CR>', "Hover Docs" },
		g = {
			name = "Goto",
			r = { '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', "References" },
			D = { '<cmd>lua require"lspsaga.provider".preview_definition()<CR>', "Preview Definition" },
			d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
		},
		c = {
			name = "Code",
			a = { '<cmd>lua require"lspsaga.codeaction".code_action()<CR>', "Code Action" },
			h = { '<cmd>lua require"lspsaga.signaturehelp".signature_help()<CR>', "Signature Help" },
			n = { '<cmd>lua require"lspsaga.rename".rename()<CR>', "Rename" },
		},
		["["] = {
			name = "Jump Previous",
			d = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Diagnostic" },
		},
		["]"] = {
			name = "Jump",
			d = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Diagnostic" },
		},
	}, { buffer = bufnr, mode = "n", prefix = "<leader>b" })

	require("which-key").register({
		g = {
			name = "Goto",
			r = { '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', "References" },
			D = { '<cmd>lua require"lspsaga.provider".preview_definition()<CR>', "Preview Definition" },
			d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
		},
		c = {
			name = "Code",
			a = { '<cmd>lua require"lspsaga.codeaction".code_action()<CR>', "Code Action" },
			n = { '<cmd>lua require"lspsaga.rename".rename()<CR>', "Rename" },
		},
		K = {
			'<cmd>lua require"lspsaga.signaturehelp".signature_help()<CR>',
			"Signature Help",
		},
		["["] = {
			name = "Jump Previous",
			d = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Diagnostic" },
		},
		["]"] = {
			name = "Jump",
			d = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Diagnostic" },
		},
	}, { buffer = bufnr, mode = "n" })
	-- { mode = 'v', {
	--         { 'ca', ':<C-U>lua require"lspsaga.codeaction".range_code_action()<CR>' },
	--     },
	-- }
	--
	if client.server_capabilities.document_highlight then
		vim.cmd([[
            augroup lsp_document_highlight
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup end
            ]])
	end
end

require("mason").setup({})
require("mason-lspconfig").setup({})

local installed_servers = require("mason-lspconfig").get_installed_servers()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local default_opts = {
	on_attach = on_attach,
	capabilities = capabilities,
}

for _, server in pairs(installed_servers) do
	if server.name == "rust_analyzer" then
		default_opts.tools = {
			inlay_hints = {
				-- prefix for parameter hints
				-- default: "<-"
				parameter_hints_prefix = "« ",
				-- prefix for all the other hints (type, chaining)
				-- default: "=>"
				other_hints_prefix = "» ",
			},
		}
	elseif server.name == "yamlls" then
		default_opts.settings = {
			["yaml"] = {
				customTags = {
					"!And sequence",
					"!And",
					"!Base64",
					"!Cidr",
					"!Condition",
					"!Equals sequence",
					"!Equals",
					"!FindInMap sequence",
					"!GetAZs",
					"!GetAtt",
					"!If sequence",
					"!If",
					"!ImportValue",
					"!Join sequence",
					"!Not sequence",
					"!Not",
					"!Or sequence",
					"!Or",
					"!Ref scalar",
					"!Ref sequence",
					"!Ref",
					"!Select sequence",
					"!Select",
					"!Split sequence",
					"!Split",
					"!Sub sequence",
					"!Sub",
					"!fn",
				},
				schemas = {
					["https://raw.githubusercontent.com/awslabs/goformation/v4.18.2/schema/cloudformation.schema.json"] = "cloudformation/*.template",
				},
				schemaStore = {
					url = "https://www.schemastore.org/api/json/catalog.json",
					enable = true,
				},
				schemaDownload = { enable = true },
				completion = true,
				validate = true,
			},
		}
	end
	-- default setup for all servers
	require("lspconfig")[server].setup(default_opts)
end

require("rust-tools").setup({ server = default_opts })
