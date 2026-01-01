return {
  "yuukiflow/Arduino-Nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "arduino",
      callback = function()
        require("Arduino-Nvim")
      end,
    })
  end,
}
