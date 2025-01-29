local function set_transparent_bg()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ChangeTheme(theme)
	theme = theme or "catppuccin"

	if theme == "davinci" then
		require("edu-gomes.themes.davinci").setup()
	else
		vim.cmd.colorscheme(theme)
	end

	set_transparent_bg()
end

vim.keymap.set("n", "<Leader>t1", function()
	ChangeTheme("aura-dark")
end, { desc = "Switch to aura-dark" })

vim.keymap.set("n", "<Leader>t2", function()
	ChangeTheme("catppuccin")
end, { desc = "Switch to Catppuccin" })

vim.keymap.set("n", "<Leader>t3", function()
	ChangeTheme("onedark")
end, { desc = "Switch to Onedark" })

vim.keymap.set("n", "<Leader>t4", function()
	ChangeTheme("davinci")
end, { desc = "Switch to Davinci" })

vim.keymap.set("n", "<Leader>t5", function()
	ChangeTheme("tokyonight-night")
end, { desc = "Switch to Tokyo Night" })

return {
	{
		"baliestri/aura-theme",
		priority = 50,
		lazy = false,
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
			vim.cmd([[colorscheme aura-dark]])
			set_transparent_bg()
		end,
	},
	-- TokyoNight theme setup
	{
		"folke/tokyonight.nvim",
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
			vim.g.tokyonight_transparent = true
			vim.cmd.colorscheme("tokyonight-night")
			vim.cmd.hi("Comment gui=none")
		end,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
		end,
	},
	-- Onedarkpro theme
	{
		"olimorris/onedarkpro.nvim",
		name = "onedarkpro",
		priority = 50,
		config = function()
			require("onedarkpro").setup({
				options = {
					transparency = true, -- Enable transparent background
				},
			})
			ChangeTheme("onedark")
			set_transparent_bg()
		end,
	},

	-- Catppuccin theme setup
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})
			ChangeTheme("catppuccin")
		end,
	},
}
