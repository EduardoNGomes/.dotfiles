local function set_transparent_bg()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ChangeTheme(theme)
	theme = theme or "tokyonight-night"

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

vim.keymap.set("n", "<Leader>t6", function()
	ChangeTheme("leaf")
end, { desc = "Switch to Leaf" })

return {
	-- TokyoNight theme setup
	{
		"folke/tokyonight.nvim",
		priority = 1000,
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
				on_colors = function() end, -- Empty function
				on_highlights = function() end, -- Empty function
				style = "night", -- Default style
				light_style = "day", -- Default light style
				terminal_colors = true, -- Default value
				day_brightness = 0.3, -- Default value
				dim_inactive = false, -- Default value
				lualine_bold = false, -- Default value
				cache = true, -- Default value
				plugins = {
					-- Add empty plugin configurations
					cmp = true,
					gitsigns = true,
					indent_blankline = true,
					nvim_tree = true,
					telescope = true,
					treesitter = true,
					which_key = true,
				},
			})
		end,
	},

	-- Aura theme setup
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
		priority = 10,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})
			ChangeTheme("catppuccin")
		end,
	},

	{
		"daschw/leaf.nvim",
		priority = 100,
		config = function()
			require("leaf").setup({
				underlineStyle = "underline",
				commentStyle = "italic",
				functionStyle = "NONE",
				keywordStyle = "italic",
				statementStyle = "bold",
				typeStyle = "NONE",
				variablebuiltinStyle = "italic",
				transparent = true,
				colors = {},
				overrides = {},
				theme = "auto", -- default, based on vim.o.background, alternatives: "light", "dark"
				contrast = "high", -- default, alternatives: "medium", "high"
			})
			ChangeTheme("leaf")
		end,
	},
}
