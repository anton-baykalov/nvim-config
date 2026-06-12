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
})
