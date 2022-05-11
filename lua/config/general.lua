vim.opt.termguicolors = true
vim.opt.termguicolors = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.updatetime = 300
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
vim.g.mapleader = " "
vim.g.netrw_altfile = 1

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 2

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
vim.lsp.buf.formatting()
end,
})
