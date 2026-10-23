return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" } },
  opts = {
    window = { width = 90 },
    plugins = {
      -- keep statusline (zen hides it by default)
      options = { enabled = true, ruler = true, showcmd = true, laststatus = 3 },
      twilight = { enabled = false },
    },
  },
}
