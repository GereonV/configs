-- vim: foldmethod=marker
-- vim options {{{
vim.opt.lazyredraw = true
-- visual {{{
vim.cmd.colorscheme("evening")
vim.cmd.highlight("link EndOfBuffer Pmenu")
-- vim.cmd.highlight("Folded ctermbg=248")
vim.opt.list = true
vim.opt.listchars = {
  tab = "▶-",
  eol = "↲",
  nbsp = "␣",
  lead = "•",
  trail = "•",
  extends = "󰶻",
  precedes = "󰶺",
}
vim.opt.showbreak = "↪ "
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:2"
-- }}}
-- copy & paste operators {{{
-- undefines {{{
vim.keymap.set("", "<Space>", "") --  just use l!?
vim.keymap.set("", "+", "")       -- used for searching
vim.keymap.set("", "-", "")       -- used as clipboard-prefix
vim.keymap.set("v", "x", "")      -- just use d!?
vim.keymap.set("v", "X", "")      -- just use d!?
vim.keymap.set("v", "D", "")      -- just use d!?
vim.keymap.set("v", "C", "")      -- just use c!?
vim.keymap.set("n", "S", "")      -- just use cc!?
vim.keymap.set("v", "s", "")      -- just use c!?
vim.keymap.set("v", "Y", "")      -- just use y!?
vim.keymap.set("v", "P", "")      -- just use y!?
-- }}}
-- own mappings {{{
vim.keymap.set({ "n", "v" }, "<Space>d", '"+d')
vim.keymap.set({ "n", "v" }, "<Space>c", '"+c')
vim.keymap.set({ "n", "v" }, "<Space>y", '"+y')
vim.keymap.set({ "n", "v" }, "<Space>p", '"+p')
vim.keymap.set({ "n", "v" }, "-d", '"_d')
vim.keymap.set({ "n", "v" }, "-c", '"_c')
vim.keymap.set("n", "<Space>D", '"+D')
vim.keymap.set("n", "<Space>C", '"+C')
vim.keymap.set("n", "<Space>Y", '"+y$')
vim.keymap.set("n", "<Space>P", '"+P')
vim.keymap.set("v", "-<Space>P", '"_d"+P')
vim.keymap.set("v", "<Space>-P", '"_d"+P')
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "X", '"_X')
vim.keymap.set("n", "-D", '"_D')
vim.keymap.set("n", "-C", '"_C')
vim.keymap.set("v", "-p", '"_dP')
-- }}}
-- }}}
-- scrolling {{{
vim.opt.scrolloff = 10
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
-- }}}
-- joining {{{
vim.keymap.set("n", "J", "@='mzJ`z'<CR>")
vim.keymap.set("n", "gJ", "@='mzgJ`z'<CR>")
vim.keymap.set("n", "<Space>J", "J")
vim.keymap.set("n", "<Space>gJ", "gJ")
vim.keymap.set("n", "g<Space>J", "gJ")
-- }}}
-- searching {{{
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true  -- override ignorecase if pattern includes uppercase
vim.keymap.set("n", "Q", vim.cmd.nohlsearch)
vim.keymap.set("n", "+", '/\\C<C-r><C-w><CR>')
vim.keymap.set("v", "+", '"zy/\\C<C-r>z<CR>')
-- vim.keymap.set("n", "-", '?\\C<C-r><C-w><CR>')
-- vim.keymap.set("v", "-", '"zy?\\C<C-r>z<CR>')
-- }}}
-- indenting {{{
-- +----------+---------------+--------+---------+----------------------------------------------------------+
-- | priority | variable/mode | type   | default | description                                              |
-- +==========+===============+========+=========+==========================================================+
-- | 1        | autoindent    | bool   | on      | copy indentation of previous line to new line            |
-- | 1        | smartindent   | bool   | off     | "smartly" adds extra indentation to new line             |
-- | 2        | cindent       | bool   | off     | configurable version of smartindent for C-style programs |
-- | 3        | indentexpr    | string | ""      | expression that evaluates to indent of line              |
-- +----------+---------------+--------+---------+----------------------------------------------------------+
--
-- +----------------+------+---------+-----------------------------------------------------------------------+
-- | variable       | type | default | meaning                                                               |
-- +================+======+=========+=======================================================================+
-- | tabstop        | int  | 8       | how many spaces make up a <TAB> character                             |
-- +----------------+------+---------+-----------------------------------------------------------------------+
-- | softtabstop    | int  | 0       | if != 0, how many visual spaces a <TAB>/<BS> press accounts for       |
-- +----------------+------+---------+-----------------------------------------------------------------------+
-- | smarttab       | bool | on      | shift start of line using shiftwidth (ie. not tabstop or softtabstop) |
-- | shiftwidth     | int  | 8       | number of spaces to indent each step with                             |
-- |                |      |         | if == 0, uses tabstop                                                 |
-- | shiftround     | bool | off     | round indent to multiples of shiftwidth (for > & <)                   |
-- +----------------+------+---------+-----------------------------------------------------------------------+
-- | expandtab      | bool | off     | always use spaces instead of eagerly collapsing to tab characters     |
-- +----------------+------+---------+-----------------------------------------------------------------------+
-- | copyindent     | bool | off     | use indenting characters from previous line for same indentation      |
-- |                |      |         | ie. prevent reconstructing indentation with usual rules               |
-- |                |      |         | greater indentation is accomplished by adding usual characters        |
-- +----------------+------+---------+-----------------------------------------------------------------------+
-- | preserveindent | bool | off     | preserve indenting structure and characters when changing indentation |
-- +----------------+------+---------+-----------------------------------------------------------------------+
--
-- cindent {{{
-- +---------------+--------+------------------------------------------------------+
-- | variable      | type   | meaning                                              |
-- +===============+========+======================================================+
-- | cinkeys       | string | insert mode reindenting triggers (:h cinkeys-format) |
-- +---------------+--------+------------------------------------------------------+
-- | cinoptions    | string | specifies preferred style (:h cinoptions-values)     |
-- +---------------+--------+------------------------------------------------------+
-- | cinwords      | string | words that start extra indentation on the next line  |
-- |               |        | case-sensitive                                       |
-- |               |        | only done at "appropiate places" (eg. inside `{}`)   |
-- +---------------+--------+------------------------------------------------------+
-- | cinscopedecls | string | "public,protected,private"                           |
-- +---------------+--------+------------------------------------------------------+
-- }}}
-- smartindent {{{
-- +----------+--------+-----------------------------------------------------+
-- | variable | type   | meaning                                             |
-- +==========+========+=====================================================+
-- | cinwords | string | words that start extra indentation on the next line |
-- |          |        | case-sensitive                                      |
-- +----------+--------+-----------------------------------------------------+
-- }}}
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.copyindent = false
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
  "t9md/vim-quickhl",           -- highlights wie textmarker
  "airblade/vim-rooter",        -- change cwd automatically
  "numToStr/FTerm.nvim",        -- floating terminal
  "airblade/vim-gitgutter",     -- show diff markers
  "dhruvasagar/vim-table-mode", -- auto-adjust tables
  {
    "folke/flash.nvim",         -- situational version of vim motions
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  "folke/neodev.nvim",                               -- LSP setup for nvim config
  "neovim/nvim-lspconfig",                           -- LSP defaults
  {
    "nvim-lualine/lualine.nvim",                     -- statusline
    dependencies = { "nvim-tree/nvim-web-devicons" } -- file icons
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- optional for floating window border decoration
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",            -- fuzzy finder for basically anything
        dependencies = { "nvim-lua/plenary.nvim" }, -- floating window
      },
      "nvim-tree/nvim-web-devicons",                -- file icons
    },
  },
  {
    "terrortylor/nvim-comment", -- comment using `gc{motion}` and `gcc`
    config = function()
      require("nvim_comment").setup {}
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",                        -- tree like netrw
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- file icons
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
        dependencies = { "hrsh7th/vim-vsnip" }, -- VSCode snippet feature
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
  extensions = {
    file_browser = {
      prompt_path = true,
      hidden = true,
      no_ignore = true,
    },
  },
}
local telescope = require("telescope")
local builtin = require("telescope.builtin")
local file_browser = telescope.load_extension("file_browser")
local function browse_home()
  file_browser.file_browser {
    path = "~",
  }
end
vim.keymap.set("n", "<Leader>ff", builtin.find_files)
vim.keymap.set("n", "<Leader>fo", builtin.oldfiles)
vim.keymap.set("n", "<Leader>fd", file_browser.file_browser)
vim.keymap.set("n", "<Leader>fa", browse_home)
vim.keymap.set("n", "<Leader>fg", builtin.live_grep)
vim.keymap.set("n", "<Leader>fs", builtin.grep_string)
vim.keymap.set("n", "<Leader>fb", builtin.buffers)
vim.keymap.set("n", "<Leader>fh", builtin.help_tags)
vim.keymap.set("n", "<Leader>fm", builtin.man_pages)
vim.keymap.set("n", "<Leader>ft", builtin.builtin)
-- }}}
-- LSP {{{
local lspconfig = require("lspconfig")
local lsp_opts = { capabilities = require("cmp_nvim_lsp").default_capabilities() }
local pylsp_opts = { capabilities = lsp_opts.capabilities, settings = { pylsp = {
  confiurationSources = {"flake8"},
  plugins = {
    rope_autoimport = { enabled = true },
    pycodestyle = { enabled = false },
    pyflakes = { enabled = false },
    mccabe = { enabled = false },
    flake8 = { enabled = true },
  }
} } }
-- diagnostics displaying {{{
vim.diagnostic.config({
  underline = { severity = { min = "WARN" } },
  virtual_text = {
    source = "if_many",
    prefix = "●",
  },
  float = {
    severity_sort = true,
    source = true,
  },
  severity_sort = true,
})
-- }}}
-- register servers {{{
require("neodev").setup {} -- ABOVE! lspconfig
lspconfig.clangd.setup(lsp_opts)
lspconfig.rust_analyzer.setup(lsp_opts)
lspconfig.lua_ls.setup(lsp_opts)
lspconfig.texlab.setup(lsp_opts)
lspconfig.hls.setup(lsp_opts)
lspconfig.zls.setup(lsp_opts)
lspconfig.bashls.setup(lsp_opts)
lspconfig.jdtls.setup(lsp_opts)
lspconfig.pylsp.setup(pylsp_opts)
lspconfig.dockerls.setup(lsp_opts)
lspconfig.ts_ls.setup(lsp_opts)
lspconfig.gopls.setup(lsp_opts)
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
    vim.keymap.set("n", "L", vim.diagnostic.open_float, opts)
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
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),        -- stop completion
    ["<C-Space>"] = cmp.mapping.complete(), -- restart completion
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
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
vim.keymap.set("n", "<Leader>lg", open_lg)
-- }}}
-- lualine {{{
local lualine = require("lualine")
local lualine_config = lualine.get_config()
lualine_config.options.theme = "dracula"
lualine_config.sections.lualine_c = { { "filename", path = 1 } }
lualine.setup(lualine_config)
-- }}}
-- vim-rooter {{{
vim.g.rooter_buftypes = { "" }
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
vim.keymap.set({ "n", "v" }, "<Space>m", "<Plug>(quickhl-manual-this)")
vim.keymap.set({ "n", "v" }, "<Space>w", "<Plug>(quickhl-manual-this-whole-word)")
vim.keymap.set({ "n", "v" }, "<Space>c", "<Plug>(quickhl-manual-clear)")
vim.keymap.set({ "n", "v" }, "<Space>M", "<Plug>(quickhl-manual-reset)")
vim.keymap.set("n", "<Space>j", "<Plug>(quickhl-tag-toggle)")
-- }}}
-- gitgutter {{{
-- +------------+-----------------------------------------+
-- | mapping    | action                                  |
-- +============+=========================================+
-- | <Leader>hp | preview hunk                            |
-- | <Leader>hs | stage hunk                              |
-- | <Leader>hu | undo hunk                               |
-- | ]c         | next hunk                               |
-- | [c         | prev hunk                               |
-- | ic         | "in hunk"                               |
-- | ac         | "all hunk" (includes trailing newlines) |
-- +------------+-----------------------------------------+
vim.opt.updatetime = 100
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
vim.keymap.set("", "<Leader>tc", ":Tableize/;") -- all modes
vim.cmd.TableModeEnable { mods = { silent = true } }
-- }}}
-- FTerm {{{
local fterm = require("FTerm")
fterm.setup {
  border = "none",
}
vim.keymap.set({ "n", "t" }, "<Leader>i", fterm.toggle)
-- }}}
