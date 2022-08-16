local execute = vim.api.nvim_command
local packer = nil
-- check if packer is installed (~/.local/share/nvim/site/pack)
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local compile_path = install_path .. "/plugin/packer_compiled.lua"
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0

local function init()
    if not is_installed then
        if vim.fn.input("Install packer.nvim? (y for yes) ") == "y" then
            execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
            execute("packadd packer.nvim")
            print("Installed packer.nvim.")
            is_installed = 1
        end
    end

    if not is_installed then
        return
    end
    if packer == nil then
        packer = require("packer")
        packer.init({
            disable_commands = true,
            compile_path = compile_path,
        })
    end

    local use = packer.use
    packer.reset()

    use("wbthomason/packer.nvim")
    use({ "lewis6991/impatient.nvim" })
    use("neovim/nvim-lspconfig")
    use({
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").load_extension("file_browser")
        end,
    })

    use({
        "cljoly/telescope-repo.nvim",
        requires = { "nvim-telescope/telescope.nvim" },
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            -- local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

            -- -- These two are optional and provide syntax highlighting
            -- -- for Neorg tables and the @document.meta tag
            -- parser_configs.norg_meta = {
            --     install_info = {
            --         url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
            --         files = { "src/parser.c" },
            --         branch = "main",
            --     },
            -- }
            --
            -- parser_configs.norg_table = {
            --     install_info = {
            --         url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
            --         files = { "src/parser.c" },
            --         branch = "main",
            --     },
            -- }

            require("nvim-treesitter.configs").setup({
                -- One of "all", "maintained" (parsers with maintainers), or a list of languages
                ensure_installed = {
                    "rust",
                    "go",
                    "java",
                    "yaml",
                    "json",
                    "hcl",
                    "norg",
                    "toml",
                    "org",
                },

                -- Install languages synchronously (only applied to `ensure_installed`)
                sync_install = false,

                indent = {
                    enabled = true,
                },

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = { "org" },
                },
            })
        end,
    })

    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                },
            })
        end,
    })

    use("elkowar/yuck.vim")

    -- Use the Github Neovim Theme
    use({
        "projekt0n/github-nvim-theme",
        config = function()
            require("github-theme").setup({
                theme_style = "dark",
                function_style = "italic",
                sidebars = { "qf", "vista_kind", "terminal", "packer" },
                colors = {
                    hint = "orange",
                    error = "#FF0000",
                },
                overrides = function(c)
                    return {
                        DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
                    }
                end,
            })
        end,
    })

    use({
        "tami5/lspsaga.nvim",
        config = function()
            require("lspsaga").setup()
        end,
    })

    use({
        "hrsh7th/nvim-cmp",
        config = function()
            require("config.plugins.cmp").setup()
        end,
    })

    use({
        "simrat39/rust-tools.nvim",
        requires = "neovim/nvim-lspconfig",
    })
    use({
        "mfussenegger/nvim-dap",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            local dap = require("dap")
            dap.adapters.cppvsdbg = {
                id = "cppvsdbg",
                type = "executable",
                command = "C:\\debugAdapters\\bin\\OpenDebugAD7.exe",
                options = {
                    detached = false,
                },
            }
        end,
    })

    use({ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" })
    use({ "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-path", after = "cmp-buffer" })
    use({ "hrsh7th/cmp-calc", after = "cmp-path" })

    -- use({ "github/copilot.vim" })
    use({ "onsails/lspkind-nvim" })

    use({ "saadparwaiz1/cmp_luasnip" })
    use({ "L3MON4D3/LuaSnip", requires = { "rafamadriz/friendly-snippets" }, after = "cmp_luasnip" })

    -- Add components to show LSP Status in Status Line
    use({ "jose-elias-alvarez/nvim-lsp-ts-utils", after = { "nvim-treesitter" } })

    -- use({
    -- 	"williamboman/nvim-lsp-installer",
    -- 	event = "BufEnter",
    -- 	after = "cmp-nvim-lsp",
    -- 	config = "require('config.lsp')",
    -- })
    use({
        "williamboman/mason.nvim",
        after = "cmp-nvim-lsp",
        requires = { "williamboman/mason-lspconfig.nvim" },
        config = "require('config.lsp')",
    })

    -- tpope is our savior.
    use({ "tpope/vim-fugitive" })
    use({ "tpope/vim-speeddating" })
    use({ "tpope/vim-vinegar" })
    use({ "tpope/vim-abolish" })

    -- Status Line for Neovim
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("config.plugins.statusline").setup()
        end,
    })

    -- Git signs
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup()
        end,
    })

    use({
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("nvim-treesitter.configs").setup({
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
            })
        end,
    })
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup(
            -- NOTE: The example below is a proper integration and it is RECOMMENDED.
                {
                    ---@param ctx Ctx
                    pre_hook = function(ctx)
                        local U = require("Comment.utils")

                        local location = nil
                        if ctx.ctype == U.ctype.block then
                            location = require("ts_context_commentstring.utils").get_cursor_location()
                        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                            location = require("ts_context_commentstring.utils").get_visual_start_location()
                        end

                        return require("ts_context_commentstring.internal").calculate_commentstring({
                            key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
                            location = location,
                        })
                    end,
                }
            )
        end,
    })

    use({ "rcarriga/nvim-notify" })
    use({ "folke/which-key.nvim", config = "require('config.plugins.whichkey')" })
    use({
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup()
        end,
    })
    use({
        "SmiteshP/nvim-gps",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-gps").setup()
        end,
    })
    use({ "nvim-telescope/telescope-file-browser.nvim", requires = { "nvim-telescope/telescope.nvim" } })
    use({
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-treesitter.configs").setup({
                autotag = {
                    enable = true,
                },
            })
        end,
    })

    use({ "nvim-lua/popup.nvim", requires = { "nvim-lua/plenary.nvim" } })
    -- use({
    --     "nvim-neorg/neorg",
    --     -- tag = "0.0.11",
    --     requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
    --     after = { "nvim-treesitter", "telescope.nvim" },
    --     config = "require('config.plugins.neorg')",
    -- })
    use({
        "nvim-orgmode/orgmode",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("orgmode").setup_ts_grammar()
            require("orgmode").setup({
                org_agenda_files = { "~/notes/**/*" },
                org_default_notes_file = "~/notes/org/refile.org",
            })
        end,
    })

    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({
                text = {
                    spinner = "moon",
                },
                align = { bottom = true },
                window = { relative = "editor" },
            })
        end,
    })
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("null-ls").setup({
                sources = {
                    require("null-ls").builtins.formatting.stylua,
                },
            })
        end,
    })

    use({ "f-person/git-blame.nvim" })
    use({ "ThePrimeagen/harpoon", requires = { "nvim-lua/plenary.nvim" } })
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end,
})

return plugins
