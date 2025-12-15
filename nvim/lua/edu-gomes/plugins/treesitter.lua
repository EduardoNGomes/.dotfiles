return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.config",
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
		require("nvim-treesitter.config").setup(opts)

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
