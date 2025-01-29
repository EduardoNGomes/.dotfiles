return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"go",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "ruby", "go" },
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)

		-- Custom syntax highlighting for Go
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				local custom_colors = {
					function_name = "#13FBA7",
					keyword = "#F65454",
					string = "#FFEB81",
					constant = "#C678DD",
					type = "#73F9F1",
					operator = "#ABB2BF",
					error = "#F65454",
					warning = "#E5C07B",
					variable = "#FFFFFF",
					escape = "#CE80D9",
				}

				vim.api.nvim_set_hl(0, "@function.go", { fg = custom_colors.function_name })
				vim.api.nvim_set_hl(0, "@function.call.go", { fg = custom_colors.function_name })
				vim.api.nvim_set_hl(0, "@keyword.go", { fg = custom_colors.keyword })
				vim.api.nvim_set_hl(0, "@string.go", { fg = custom_colors.string })
				vim.api.nvim_set_hl(0, "@constant.go", { fg = custom_colors.constant })
				vim.api.nvim_set_hl(0, "@type.go", { fg = custom_colors.type })
				vim.api.nvim_set_hl(0, "@operator.go", { fg = custom_colors.operator })
				vim.api.nvim_set_hl(0, "@variable.go", { fg = custom_colors.variable })
				vim.api.nvim_set_hl(0, "@error.go", { fg = custom_colors.error })
				vim.api.nvim_set_hl(0, "@warning.go", { fg = custom_colors.warning })
				vim.api.nvim_set_hl(0, "@string.escape", { fg = custom_colors.escape })
				vim.api.nvim_set_hl(0, "@string.escape.go", { fg = custom_colors.escape })
			end,
		})

		-- Enable folding
		vim.o.foldmethod = "expr"
		vim.o.foldexpr = "nvim_treesitter#foldexpr()"
		vim.o.foldenable = true
		vim.o.foldlevel = 99

		vim.opt.foldtext = [[v:lua.CustomFoldText()]]

		function CustomFoldText()
			local line = vim.fn.getline(vim.v.foldstart) -- Get the start of the fold
			return line .. " ... (" .. (vim.v.foldend - vim.v.foldstart) .. " lines)"
		end
	end,
}
