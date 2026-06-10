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

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { latex = { enabled = true } },
  },
  
  -- IPython REPL + cell execution
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { "sage" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
  sage = {                                -- ← add this
    command = { "sage" },
    format = common.bracketed_paste_python,
    block_dividers = { "# %%", "#%%" },
  },
          },
          repl_open_cmd = view.split.vertical.rightbelow("40%"),
        },
        keymaps = {
          send_line     = "<leader>sl",
          send_file     = "<leader>sf",
          visual_send   = "<leader>sv",
          interrupt     = "<leader>si",
          exit          = "<leader>sq",
          clear         = "<leader>sc",
        },
      })

      -- Send current # %% cell
      vim.keymap.set("n", "<leader>se", function()
        iron.send_code_block()
      end, { desc = "Send cell to IPython" })

      -- Jump between cells
      vim.keymap.set("n", "]c", function() vim.fn.search("^# %%", "W")  end, { desc = "Next cell" })
      vim.keymap.set("n", "[c", function() vim.fn.search("^# %%", "bW") end, { desc = "Prev cell" })
    end,
  },
})
