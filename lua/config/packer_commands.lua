vim.cmd [[command! PackerInstall packadd packer.nvim | lua require('config.plugins').install()]]
vim.cmd [[command! PackerUpdate packadd packer.nvim | lua require('config.plugins').update()]]
vim.cmd [[command! PackerSync packadd packer.nvim | lua require('config.plugins').sync()]]
vim.cmd [[command! PackerClean packadd packer.nvim | lua require('config.plugins').clean()]]
vim.cmd [[command! PackerCompile packadd packer.nvim | lua require('config.plugins').compile()]]

