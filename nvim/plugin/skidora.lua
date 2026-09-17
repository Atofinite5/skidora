if vim.g.loaded_skidora then
  return
end
vim.g.loaded_skidora = true
require("skidora").setup()
