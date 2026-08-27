return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		{
			"nvim-mini/mini.icons",
			version = false,
			config = function()
				require("mini.icons").setup({
					style = "glyph",
				})
				require("mini.icons").mock_nvim_web_devicons()
			end,
		},
	},
	opts = {
		sync_root_with_cwd = true, -- Sync the tree's root with the working directory
		update_focused_file = { -- Highlight and center the current file in the tree
			enable = true,
			update_cwd = true,
		},
	},
	config = function(_, opts)
		-- Set up keymap to toggle nvim-tree
		vim.keymap.set("n", "<Leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

		require("nvim-tree").setup(vim.tbl_deep_extend("force", {
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
			},
			renderer = {
				group_empty = false,
			},
			filters = {
				dotfiles = false,
				git_ignored = false,
			},
		}, opts))
	end,
}
