return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 18,
			direction = "float",
			float_opts = {
				border = "rounded",
			},
		})

		local Terminal = require("toggleterm.terminal").Terminal

		local tmux = Terminal:new({
			cmd = "tmux",
			hidden = true,
			direction = "float",
		})

		local function toggle_tmux()
			tmux:toggle()
		end

		local codex = Terminal:new({
			cmd = "codex",
			hidden = true,
			direction = "vertical",
		})

		local function toggle_codex()
			local width = vim.o.columns * 0.4

			codex:toggle(width, "vertical")
		end

		vim.keymap.set("n", "<leader>T", toggle_tmux, { desc = "Toggle Terminal (Tmux)" })
		vim.keymap.set("n", "<leader>tc", toggle_codex, { desc = "Toggle Codex (Side)" })
	end,
}
