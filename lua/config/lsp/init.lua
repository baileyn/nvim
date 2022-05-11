local lsp_installer = require("nvim-lsp-installer")
local lsp_status = require('lsp-status')

local on_attach = function(client, bufnr)
    require'nest'.applyKeymaps {
        { mode = 'n', {
                { 'gr', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>' },
                { 'gD', '<cmd>lua require"lspsaga.provider".preview_definition()<CR>' },
                { 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
                { 'ca', '<cmd>lua require"lspsaga.codeaction".code_action()<CR>' },
                { 'K', '<cmd>lua require"lspsaga.hover".render_hover_doc()<CR>' },
                { '<C-k>', '<cmd>lua require"lspsaga.signaturehelp".signature_help()<CR>' },
                { 'rn', '<cmd>lua require"lspsaga.rename".rename()<CR>' },
                { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
                { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
            },
        },
        { mode = 'v', {
                { 'ca', ':<C-U>lua require"lspsaga.codeaction".range_code_action()<CR>' },
            },
        }
    }

    lsp_status.on_attach(client, bufnr)
end

lsp_installer.on_server_ready(function(server)
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

