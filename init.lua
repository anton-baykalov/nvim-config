vim.opt.number = true
vim.opt.relativenumber = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<C-Left>",  "<C-w><")
vim.keymap.set("n", "<C-Right>", "<C-w>>")
vim.keymap.set("n", "<C-Up>",    "<C-w>+")
vim.keymap.set("n", "<C-Down>",  "<C-w>-")

require("lazy").setup({
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme("tokyonight") end,
  },

  -- File tree (no icons)
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        renderer = {
          icons = {
            show = { file = false, folder = false, folder_arrow = false, git = false },
          },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      ensure_installed = { "markdown", "markdown_inline", "latex" },
    },
  },

  -- Status line (no icons)
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          section_separators = "",
          component_separators = "|",
        },
      })
    end,
  },

  -- LaTeX
  {
    "lervag/vimtex",
    lazy = false, -- vimtex needs to load early to detect .tex files correctly
    init = function()
      -- Set these BEFORE the plugin loads (init, not config)
      vim.g.vimtex_view_method = "zathura" -- swap for "skim" (macOS) or "sioyek" if you use those instead
      vim.g.vimtex_quickfix_mode = 0       -- don't auto-open quickfix on warnings
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.tex_flavor = "latex"           -- helps filetype detection default to tex not plaintex
    end,
  },

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { latex = { enabled = true } },
  },

  -- REPL + cell execution via vim-slime
  {
    "jpalardy/vim-slime",
    config = function()
      -- Start in neovim mode (internal pane, no tmux needed)
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_cell_delimiter = "# %%"
      vim.g.slime_python_ipython = 1

      -- Cell, line, selection
      vim.keymap.set("n", "<leader>se", "<Plug>SlimeSendCell",   { desc = "Send cell" })
      vim.keymap.set("n", "<leader>sl", "<Plug>SlimeLineSend",   { desc = "Send line" })
      vim.keymap.set("v", "<leader>sv", "<Plug>SlimeRegionSend", { desc = "Send selection" })

      -- Jump between cells
      vim.keymap.set("n", "]c", function() vim.fn.search("^# %%", "W")  end, { desc = "Next cell" })
      vim.keymap.set("n", "[c", function() vim.fn.search("^# %%", "bW") end, { desc = "Prev cell" })

      -- Toggle between internal pane and external tmux pane
      vim.keymap.set("n", "<leader>st", function()
        if vim.g.slime_target == "neovim" then
          vim.g.slime_target = "tmux"
          vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
          print("slime → tmux (external)")
        else
          vim.g.slime_target = "neovim"
          print("slime → neovim (internal)")
        end
      end, { desc = "Toggle slime target" })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*", -- follow latest release
    build = "make install_jsregexp", -- optional, needed for some snippet features
    dependencies = {
      "rafamadriz/friendly-snippets", -- community snippet collection
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load() -- load friendly-snippets
      require("luasnip.loaders.from_lua").lazy_load()    -- your own luasnippets/*.lua
      local ls = require("luasnip")

      -- Expand or jump forward
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      -- Jump backward
      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      -- Cycle choice nodes
      vim.keymap.set("i", "<C-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end,
  },

-- Completion engine
  {
    "saghen/blink.cmp",
    dependencies = { "L3MON4D3/LuaSnip" },
    version = "*", -- use the latest release (prebuilt binary, no Rust toolchain needed)
    opts = {
      keymap = { preset = "super-tab" }, -- Tab/Enter accept, Ctrl-n/Ctrl-p navigate, etc.

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono", -- irrelevant since you're not using icons, but required field
      },

      snippets = { preset = "luasnip" }, -- tells blink to expand/jump via LuaSnip

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      completion = {
        documentation = { auto_show = true },
      },
    },
    opts_extend = { "sources.default" },
  },
})
