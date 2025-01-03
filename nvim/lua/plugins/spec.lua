return {
  {
  "vhyrro/luarocks.nvim",
  priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  config = true,
  },
  { "ellisonleao/gruvbox.nvim", 
    priority = 1000,
    opts = ...,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true
      })
      vim.cmd([[colorscheme gruvbox]])
      vim.o.background = "dark"
    end,
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim'},
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<C-p>', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", 
                               "lua",
                               "vim", 
                               "vimdoc",
                               "query", 
                               "elixir", 
                               "heex", 
                               "javascript", 
                               "html",
                               "python"
                              },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require("neo-tree").setup({
       filesystem = {
         filtered_items = {
           visible = true,
           hide_dotfiles = false,
           hide_gitignored = true
         }
       }
      })
      vim.keymap.set('n','<C-n>', ':Neotre filesystem reveal left<CR>', {})
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependancies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = 'gruvbox'
        }
      })
    end
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependancies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {}
  }
}
