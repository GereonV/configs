local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none", -- partial clone; get file contents lazily
    -- never ever add this! "--depth=1",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  }
end
vim.opt.rtp:prepend(lazypath)
vim.cmd.colorscheme("default")
require("lazy").setup {
  "folke/neodev.nvim",               -- LSP setup for nvim config
  "neovim/nvim-lspconfig",           -- LSP defaults
  {
    "nvim-telescope/telescope.nvim", -- fuzzy finder for basically anything
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- optional for floating window border decoration
  },
  {
    "hrsh7th/nvim-cmp",                         -- auto completion
    dependencies = {                            -- cmp "sources"
      "hrsh7th/cmp-nvim-lsp",                   -- lsp
      "hrsh7th/cmp-calc",                       -- math expressions
      "hrsh7th/cmp-buffer",                     -- words in buffer
      "hrsh7th/cmp-path",                       -- pathes and filenames
      "hrsh7th/cmp-cmdline",                    -- pathes and filenames
      {
        "hrsh7th/cmp-vsnip",                    -- vim-vsnip
        dependencies = { "hrsh7th/vim-vsnip" }, -- VSC snippet feature
      },
    },
  },
}

vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>", {})

local cmp = require("cmp")
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = function()
      if not cmp.visible() then cmp.complete() end
      cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    end,
    ["<C-p>"] = function()
      if not cmp.visible() then cmp.complete() end
      cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    end,
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),        -- stop completion
    ["<C-Space>"] = cmp.mapping.complete(), -- restart completion
    ["<CR>"] = cmp.mapping.confirm {
      select = true                         -- `select = false` -> only confirm explicitly selected items.
    },
  },
  sources = {
    { name = "calc" },
    { name = "vsnip" },
    { name = "nvim_lsp" },
    { name = "path" },
  },
}
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "path" },
    { name = "cmdline" },
  },
})
local cmp_buffer = require("cmp_buffer")
cmp.setup.cmdline({ "/", "?" }, {
  sources = { { name = "buffer" } },
  sorting = {
    priority_weight = 2, -- arbitrary value  from defaults
    comparators = {
      function(...) cmp_buffer:compare_locality(...) end,
    }
  },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fs", builtin.grep_string, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fm", builtin.man_pages, {})
vim.keymap.set("n", "<leader>ft", builtin.builtin, {})

require("neodev").setup {} -- ABOVE! lspconfig
local lspconfig = require("lspconfig")
local lsp_opts = { capabilities = require("cmp_nvim_lsp").default_capabilities() }
lspconfig.clangd.setup(lsp_opts)
lspconfig.rust_analyzer.setup(lsp_opts)
lspconfig.lua_ls.setup(lsp_opts)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    local buf_no = event.buf                     -- number of buffer, where event fired
    local buf_opts = vim.bo[buf_no]              -- options of that buffer
    buf_opts.omnifunc = "v:lua.vim.lsp.omnifunc" -- Insert mode omni-completion (<C-x> & <C-o>)
    local opts = { buffer = buf_no }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
