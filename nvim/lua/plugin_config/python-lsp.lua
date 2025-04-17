-- lsp config

local lsp = require("lspconfig")
--local capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp.pylsp.setup{
 settings = {
    pylsp = {
       plugins = {
        -- code formatting
        black = {enabled = true},
        -- code linting
        pylint = { enabled = true, executable = "pylint" },
       }
     }
  },
--  capabilities = capabilities
}

