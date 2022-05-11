local lsp_installer = require("nvim-lsp-installer")

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

lsp_installer.on_server_ready(function(server)
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

	local opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	if server.name == "rust_analyzer" then
		require("rust-tools").setup({
			server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
		})
		server:attach_buffers()
		return
	elseif server.name == "yamlls" then
		opts.settings = {
			yaml = {
				format = {
					enable = true,
				},
				hover = true,
				completion = true,

				customTags = {
					"!fn",
					"!And",
					"!If",
					"!Not",
					"!Equals",
					"!Or",
					"!FindInMap sequence",
					"!Base64",
					"!Cidr",
					"!Ref",
					"!Ref Scalar",
					"!Sub",
					"!GetAtt",
					"!GetAZs",
					"!ImportValue",
					"!Select",
					"!Split",
					"!Join sequence",
				},
			},
		}
	end

	-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
	server:setup(opts)
	vim.cmd([[ do User LspAttachBuffers ]])
end)
