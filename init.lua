local options = {
    expandtab = true,
    formatoptions = table.concat({
        "j",
        "n",
        "c",
        "r",
        "o",
        "q",
        "l",
    }, ""),
    lazyredraw = true,
    shiftwidth = 4,
    softtabstop = 4,
    splitbelow = false,
    splitright = true,
    swapfile = false,
    tabstop = 4,
    termguicolors = true,
    textwidth = 80,
    updatetime = 100,
    wrap = false,
}

local globals = {
    mapleader = " ",
    maplocalleader = " ",
}

for k, v in pairs(options) do
    vim.o[k] = v
end

for k, v in pairs(globals) do
    vim.g[k] = v
end

-- Remove windows line endings (^M)
vim.cmd([[
    command! RemoveWindowsLineEndings :%s/\r//g
]])

-- ignore mouse completely (so that wezterm can correctly open hyperlinks)
vim.cmd([[
  set mouse=
]])

-- Toggle between relative and number
local numbertoggle_group = vim.api.nvim_create_augroup("numbertoggle", {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    group = numbertoggle_group,
    pattern = "*",
    callback = function()
        vim.o.relativenumber = true
        vim.o.number = true
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    group = numbertoggle_group,
    pattern = "*",
    callback = function()
        vim.o.relativenumber = false
        vim.o.number = true
    end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("bootstrapping lazy.nvim")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
	{
		import = "plugins",
		defaults = { lazy = true },
	}
}
