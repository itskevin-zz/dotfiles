-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.colorcolumn = "80"

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2d2d2d" })
  end,
})

vim.opt.wrap = true
vim.opt.linebreak = true -- wraps at word boundaries, not mid-word
