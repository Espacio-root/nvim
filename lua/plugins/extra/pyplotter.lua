return {
  dir = "~/nvim-plugins/PyPlotter",
  requires = {
    "HakonHarnes/img-clip.nvim",
  },
  config = function()
    require("PyPlotter").setup({})
  end
}
