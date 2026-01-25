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

		local gemini = Terminal:new({
			cmd = "ESCDELAY=0 gemini",
			hidden = true,
			direction = "vertical",
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = term.bufnr, nowait = true })
			end,
		})

		local function toggle_gemini()
			local width = vim.o.columns * 0.4

			gemini:toggle(width, "vertical")
		end

		local open_code = Terminal:new({
			cmd = "opencode",
			hidden = true,
			direction = "vertical",
		})

		local function toggle_open_code()
			local width = vim.o.columns * 0.4
			open_code:toggle(width, "vertical")
		end

		vim.keymap.set("n", "<leader>T", toggle_tmux, { desc = "Toggle Terminal (Tmux)" })
		vim.keymap.set("n", "<leader>to", toggle_open_code, { desc = "Toggle OpenCode (Side)" })
		vim.keymap.set("n", "<leader>tc", toggle_codex, { desc = "Toggle Codex (Side)" })
		vim.keymap.set("n", "<leader>tg", toggle_gemini, { desc = "Toggle Gemini (Side)" })
	end,
}
