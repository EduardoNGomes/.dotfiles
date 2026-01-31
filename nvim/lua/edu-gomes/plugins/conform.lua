return { -- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({
					async = true,
					lsp_format = "fallback",
				})
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},

	opts = function()
		local function has_biome(bufnr)
			return vim.fs.root(bufnr, { "biome.json", "biome.jsonc" }) ~= nil
		end

		return {
			notify_on_error = false,

			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }

				local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"

				return {
					timeout_ms = 2500,
					lsp_fallback = true,
					lsp_format = lsp_format_opt,
				}
			end,

			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports" },
				yaml = { "yamlfmt" },
				yml = { "yamlfmt" },

				javascript = function(bufnr)
					if has_biome(bufnr) then
						return { "biome" }
					end
					return { "prettierd", "prettier", stop_after_first = true }
				end,

				javascriptreact = function(bufnr)
					if has_biome(bufnr) then
						return { "biome" }
					end
					return { "prettierd", "prettier", stop_after_first = true }
				end,

				typescript = function(bufnr)
					if has_biome(bufnr) then
						return { "biome" }
					end
					return { "prettierd", "prettier", stop_after_first = true }
				end,

				typescriptreact = function(bufnr)
					if has_biome(bufnr) then
						return { "biome" }
					end
					return { "prettierd", "prettier", stop_after_first = true }
				end,
			},

			formatters = {
				biome = {
					command = "biome",
					args = { "format", "--stdin-file-path", "$FILENAME" },
					stdin = true,
				},
			},
		}
	end,
}
