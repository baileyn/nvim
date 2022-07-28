vim.opt.termguicolors = true
vim.opt.termguicolors = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.updatetime = 300
vim.opt.wrap = false
vim.g.mapleader = " "
vim.g.netrw_altfile = 1

-- Folding
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldlevel = 2

vim.o.tabstop = 4
vim.o.shiftwidth = 0

vim.wo.number = true
vim.wo.relativenumber = true

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
		vim.lsp.buf.formatting_seq_sync()
	end,
})

function OrgImports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = "formatting",
	pattern = "*.go",
	callback = function()
		OrgImports(1000)
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = "line_numbers",
	command = ":set relativenumber",
})

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
