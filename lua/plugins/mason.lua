return {
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-tool-installer').setup {
                ensure_installed = {
                },
            }
        end,
    },
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },
    {
        'williamboman/mason.nvim',
        dependencies = { 'williamboman/mason-lspconfig.nvim', 'j-hui/fidget.nvim', 'hrsh7th/cmp-nvim-lsp', 'neovim/nvim-lspconfig' },
        config = function()
            require('fidget').setup {
                text = {
                    spinner = 'moon',
                },
                align = {
                    bottom = true,
                },
                window = {
                    relative = 'editor',
                },
            }

            require('mason').setup {}
            require('mason-lspconfig').setup {
                ensure_installed = {
                    'bashls',
                    'dockerls',
                    'gopls',
                    'html',
                    'jsonls',
                    'lua_ls',
                    'pyright',
                    'rust_analyzer',
                    'sqlls',
                    'terraformls',
                    'tflint',
                    'tsserver',
                    'vimls',
                    'yamlls',
                },
            }

            local installed_servers = require('mason-lspconfig').get_installed_servers()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local default_opts = {
                capabilities = capabilities,
            }

            for _, server in pairs(installed_servers) do
                if server.name == 'rust_analyzer' then
                    default_opts.tools = {
                        inlay_hints = {
                            -- prefix for parameter hints
                            -- default: "<-"
                            parameter_hints_prefix = '« ',
                            -- prefix for all the other hints (type, chaining)
                            -- default: "=>"
                            other_hints_prefix = '» ',
                        },
                    }
                elseif server.name == "tsserver" then
                    local function organize_imports()
                        local params = {
                            command = "_typescript.organizeImports",
                            arguments = { vim.api.nvim_buf_get_name(0) },
                            title = ""
                        }
                        vim.lsp.buf.execute_command(params)
                    end
                    default_opts.commands = {
                        organize_imports(),
                        description = "Organize Imports"
                    }
                elseif server.name == 'yamlls' then
                    default_opts.settings = {
                        ['yaml'] = {
                            customTags = {
                                '!And sequence',
                                '!And',
                                '!Base64',
                                '!Cidr',
                                '!Condition',
                                '!Equals sequence',
                                '!Equals',
                                '!FindInMap sequence',
                                '!GetAZs',
                                '!GetAtt',
                                '!If sequence',
                                '!If',
                                '!ImportValue',
                                '!Join sequence',
                                '!Not sequence',
                                '!Not',
                                '!Or sequence',
                                '!Or',
                                '!Ref scalar',
                                '!Ref sequence',
                                '!Ref',
                                '!Select sequence',
                                '!Select',
                                '!Split sequence',
                                '!Split',
                                '!Sub sequence',
                                '!Sub',
                                '!fn',
                            },
                            schemas = {
                                ['https://raw.githubusercontent.com/awslabs/goformation/v4.18.2/schema/cloudformation.schema.json'] =
                                'cloudformation/*.template',
                            },
                            schemaStore = {
                                url = 'https://www.schemastore.org/api/json/catalog.json',
                                enable = true,
                            },
                            schemaDownload = { enable = true },
                            completion = true,
                            validate = true,
                        },
                    }
                end
                -- default setup for all servers
                require('lspconfig')[server].setup(default_opts)
            end

            vim.api.nvim_create_augroup('formatOnSave', {})
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = 'formatOnSave',
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end,
    }
}
