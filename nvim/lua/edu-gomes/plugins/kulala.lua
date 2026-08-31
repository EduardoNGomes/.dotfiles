return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	opts = {
		vscode_rest_client_environmentvars = true,
	},
	keys = {
		{
			"<leader>Rs",
			function()
				require("kulala").run()
			end,
			desc = "[R]equest [S]end",
		},
		{
			"<leader>Ra",
			function()
				require("kulala").run_all()
			end,
			desc = "[R]equest send [A]ll",
		},
		{
			"<leader>Rr",
			function()
				require("kulala").replay()
			end,
			desc = "[R]equest [R]eplay",
		},
	},
}
