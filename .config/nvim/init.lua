-- vim: foldmethod=marker
-- vim options {{{
vim.opt.lazyredraw = true
-- visual {{{
vim.cmd.colorscheme("evening")
vim.cmd.highlight("link EndOfBuffer Pmenu")
-- vim.cmd.highlight("Folded ctermbg=248")
vim.opt.list = true
vim.opt.listchars = "tab:▶-,eol:↲,nbsp:␣,lead:•,trail:•,extends:󰶻,precedes:󰶺"
vim.opt.showbreak = "↪ "
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
-- }}}
-- copy & paste operators {{{
-- undefines {{{
vim.keymap.set("", "<Space>", "", {}) --  just use l!?
vim.keymap.set("", "+", "", {})       -- used for searching
vim.keymap.set("", "-", "", {})       -- used as clipboard-prefix
vim.keymap.set("v", "x", "", {})      -- just use d!?
vim.keymap.set("v", "X", "", {})      -- just use d!?
vim.keymap.set("v", "D", "", {})      -- just use d!?
vim.keymap.set("v", "C", "", {})      -- just use c!?
vim.keymap.set("n", "S", "", {})      -- just use cc!?
vim.keymap.set("v", "s", "", {})      -- just use c!?
vim.keymap.set("v", "Y", "", {})      -- just use y!?
vim.keymap.set("v", "P", "", {})      -- just use y!?
-- }}}
-- own mappings {{{
vim.keymap.set({ "n", "v" }, "<Space>d", '"+d', {})
vim.keymap.set({ "n", "v" }, "<Space>c", '"+c', {})
vim.keymap.set({ "n", "v" }, "<Space>y", '"+y', {})
vim.keymap.set({ "n", "v" }, "<Space>p", '"+p', {})
vim.keymap.set({ "n", "v" }, "-d", '"_d', {})
vim.keymap.set({ "n", "v" }, "-c", '"_c', {})
vim.keymap.set("n", "<Space>D", '"+D', {})
vim.keymap.set("n", "<Space>C", '"+C', {})
vim.keymap.set("n", "<Space>Y", '"+y$', {})
vim.keymap.set("n", "<Space>P", '"+P', {})
vim.keymap.set("v", "-<Space>P", '"_d"+P', {})
vim.keymap.set("v", "<Space>-P", '"_d"+P', {})
vim.keymap.set("n", "x", '"_x', {})
vim.keymap.set("n", "X", '"_X', {})
vim.keymap.set("n", "-D", '"_D', {})
vim.keymap.set("n", "-C", '"_C', {})
vim.keymap.set("v", "-p", '"_dP', {})
-- }}}
-- }}}
-- scrolling {{{
vim.opt.scrolloff = 10
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", {})
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", {})
-- }}}
-- joining {{{
vim.keymap.set("n", "J", "@='mzJ`z'<CR>", {})
vim.keymap.set("n", "gJ", "@='mzgJ`z'<CR>", {})
vim.keymap.set("n", "<Space>J", "J", {})
vim.keymap.set("n", "<Space>gJ", "gJ", {})
vim.keymap.set("n", "g<Space>J", "gJ", {})
-- }}}
-- searching {{{
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true  -- override ignorecase if pattern includes uppercase
vim.keymap.set("n", "Q", vim.cmd.nohlsearch, {})
vim.keymap.set("n", "+", '/<\\CC-r><C-w><CR>', {})
vim.keymap.set("v", "+", '"zy/\\C<C-r>z<CR>', {})
-- vim.keymap.set("n", "-", '?\\C<C-r><C-w><CR>', {})
-- vim.keymap.set("v", "-", '"zy?\\C<C-r>z<CR>', {})
-- }}}
-- indenting {{{
-- +-------------+------+---------+
-- | variable    | type | meaning |
-- +=============+======+=========+
-- | autoindent  | bool |         |
-- | copyindent  | bool |         |
-- | smartindent | bool |         |
-- | expandtab   | bool |         |
-- | smarttab    | bool |         |
-- | tabstop     | int  |         |
-- | shiftwidth  | int  |         |
-- | softtabstop | int  |         |
-- +-------------+------+---------+
-- }}}
-- }}}
-- lazy.nvim {{{
-- lazypath {{{
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
-- }}}
-- setup {{{
require("lazy").setup {
  "t9md/vim-quickhl",            -- highlights wie textmarker
  "airblade/vim-rooter",         -- change cwd automatically
  "airblade/vim-gitgutter",      -- show diff markers
  "dhruvasagar/vim-table-mode",  -- auto-adjust tables
  "easymotion/vim-easymotion",   -- situational version of vim motions
  "folke/neodev.nvim",           -- LSP setup for nvim config
  "neovim/nvim-lspconfig",       -- LSP defaults
  {
    'nvim-lualine/lualine.nvim', -- statusline
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    "nvim-telescope/telescope.nvim", -- fuzzy finder for basically anything
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- optional for floating window border decoration
  },
  {
    "terrortylor/nvim-comment",    -- comment using `gc{motion}` and `gcc`
    config = function()
      require("nvim_comment").setup {}
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup {}
    end,
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
-- }}}
-- }}}
-- telescope {{{
require("telescope").setup {
  defaults = {
    prompt_prefix = "🔍  ",
  },
}
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<Leader>fo", builtin.oldfiles, {})
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<Leader>fs", builtin.grep_string, {})
vim.keymap.set("n", "<Leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<Leader>fm", builtin.man_pages, {})
vim.keymap.set("n", "<Leader>ft", builtin.builtin, {})
-- }}}
-- LSP {{{
local lspconfig = require("lspconfig")
local lsp_opts = { capabilities = require("cmp_nvim_lsp").default_capabilities() }
-- register servers {{{
require("neodev").setup {} -- ABOVE! lspconfig
lspconfig.clangd.setup(lsp_opts)
lspconfig.rust_analyzer.setup(lsp_opts)
lspconfig.lua_ls.setup(lsp_opts)
-- }}}
-- mappings {{{
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
    vim.keymap.set("n", "<Space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<Space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<Space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<Space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<Space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<Space>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
-- }}}
-- }}}
-- cmp (autocompletion) {{{
local cmp = require("cmp")
local cmp_buffer = require("cmp_buffer")
-- setup (sources & mappings) {{{
local function cmp_next()
  if not cmp.visible() then cmp.complete() end
  cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
end
local function cmp_prev()
  if not cmp.visible() then cmp.complete() end
  cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
end
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = cmp_next,
    ["<C-p>"] = cmp_prev,
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
-- }}}
-- setup cmdline {{{
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "path" },
    { name = "cmdline" },
  },
})
-- }}}
-- setup cmdline search {{{
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
  sorting = {
    priority_weight = 2, -- arbitrary value  from defaults
    comparators = {
      function(...) cmp_buffer:compare_locality(...) end,
    }
  },
})
-- }}}
-- }}}
-- lazygit {{{
local lazygit = require("lazygit")
local function open_lg()
  vim.cmd.nohlsearch()
  lazygit.lazygit()
end
vim.keymap.set("n", "<Leader>lg", open_lg, {})
-- }}}
-- lualine {{{
require("lualine").setup {
  options = { theme = "dracula" },
}
-- }}}
-- vim-rooter {{{
vim.g.rooter_buftypes = { '' }
vim.g.rooter_patterns = {
  "!.git/worktrees",
  ".git",
  "_darcs",
  ".gh",
  ".bzr",
  ".svn,",
  "package.json",
  "cargo.toml",
  ">.config",
}
-- }}}
-- quickhl {{{
vim.keymap.set({ "n", "v" }, "<Space>m", "<Plug>(quickhl-manual-this)", {})
vim.keymap.set({ "n", "v" }, "<Space>w", "<Plug>(quickhl-manual-this-whole-word)", {})
vim.keymap.set({ "n", "v" }, "<Space>c", "<Plug>(quickhl-manual-clear)", {})
vim.keymap.set({ "n", "v" }, "<Space>M", "<Plug>(quickhl-manual-reset)", {})
vim.keymap.set("n", "<Space>j", "<Plug>(quickhl-tag-toggle)", {})
-- }}}
-- gitgutter {{{
-- }}}
-- vim-table-mode {{{
-- +-------------+----------------------------------------+
-- | mapping     | action                                 |
-- +=============+========================================+
-- | <Leader>tm  | :TableModeToggle                       |
-- | <Leader>tr  | :TableModeRealign                      |
-- | <Leader>tt  | :Tableize            (CSV -> table)    |
-- | <Leader>tc  | :Tableize/;          (CSV -> table)    |
-- | <Leader>T   | :Tableize{pattern}   (CSV -> table)    |
-- | <Leader>tdd | delete table row                       |
-- | <Leader>tdc | delete table column                    |
-- | <Leader>tic | insert table column after cursor       |
-- | <Leader>tiC | insert table column before cursor      |
-- | <Leader>ts  | :TableSort                             |
-- | <Leader>tfa | :TableAddFormula                       |
-- +-------------+----------------------------------------+
-- | ]\|         | next cell motion                       |
-- | [\|         | prev cell motion                       |
-- | i\|         | "in  table cell" when operator pending |
-- | a\|         | "all table cell" when operator pending |
-- +-------------+----------------------------------------+
vim.g.table_mode_corner_corner = "+"
vim.g.table_mode_header_fillchar = "="
vim.keymap.set("", "<Leader>tc", ":Tableize/;", {}) -- all modes
vim.cmd.TableModeEnable { mods = { silent = true } }
-- }}}
