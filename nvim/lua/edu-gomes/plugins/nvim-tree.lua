return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
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

		-- Make the nvim-tree background transparent
		vim.cmd("hi NvimTreeNormal guibg=NONE ctermbg=NONE") -- Transparent background for the file tree
		vim.cmd("hi NvimTreeVertSplit guibg=NONE ctermbg=NONE") -- Transparent vertical split in file tree

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
