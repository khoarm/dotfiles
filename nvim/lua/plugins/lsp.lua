return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- lspconfig
      local servers = { "clangd", "gopls", "lua_ls", "pyright", "jdtls", "ts_ls" }
      require("mason").setup()
      require("mason-lspconfig").setup({ ensure_installed = servers })
      local lspconfig = require("lspconfig")
      local config = require("lsp").make_cfg()
      config["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
      for _, server in ipairs(servers) do
        if server ~= "jdtls" then
          lspconfig[server].setup(config)
        end -- use nvim-jdtls for java
      end
      -- completion
      local cmp = require("cmp")
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered({ border = "single" }),
          documentation = cmp.config.window.bordered({ border = "single" }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.scroll_docs(-5),
          ["<C-d>"] = cmp.mapping.scroll_docs(5),
          ["<C-space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<cr>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, }, { { name = "buffer" }, })
      })
    end
  },
  { "mfussenegger/nvim-jdtls" },
}
