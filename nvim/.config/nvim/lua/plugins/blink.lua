return {
  "saghen/blink.cmp",
  opts = {
    -- no completion popup while writing prose
    enabled = function()
      return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
    end,
  },
}
