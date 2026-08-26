local parsers = {
	"bash",
	"c",
	"comment",
	"diff",
	"go",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"printf",
	"query",
	"regex",
	"vim",
	"vimdoc",
}

local highlighted_filetypes = {
	"bash",
	"c",
	"diff",
	"go",
	"help",
	"html",
	"lua",
	"markdown",
	"query",
	"sh",
	"vim",
}

local function start_highlighter(bufnr)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return false
	end

	return pcall(vim.treesitter.start, bufnr)
end

local function load_parsers(parser_names)
	for _, parser in ipairs(parser_names) do
		pcall(vim.treesitter.language.add, parser)
	end
end

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function(plugin)
		vim.opt.runtimepath:prepend(plugin.dir .. "/runtime")

		local treesitter = require("nvim-treesitter")
		treesitter.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		local installed = treesitter.get_installed("parsers")
		load_parsers(installed)

		local missing = vim.tbl_filter(function(parser)
			return not vim.list_contains(installed, parser)
		end, parsers)

		if #missing > 0 and vim.fn.executable("tree-sitter") == 1 then
			treesitter.install(missing):await(function(error)
				vim.schedule(function()
					if error then
						vim.notify("Treesitter parser installation failed: " .. tostring(error), vim.log.levels.ERROR)
						return
					end

					load_parsers(missing)
					for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
						vim.treesitter.stop(bufnr)
						start_highlighter(bufnr)
					end
				end)
			end)
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("edu-gomes-treesitter", { clear = true }),
			pattern = highlighted_filetypes,
			callback = function(event)
				if not start_highlighter(event.buf) then
					return
				end

				vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.opt_local.foldenable = true
				vim.opt_local.foldlevel = 99
			end,
		})

		vim.opt.foldtext = [[v:lua.CustomFoldText()]]

		function _G.CustomFoldText()
			local line = vim.fn.getline(vim.v.foldstart)
			return line .. " ... (" .. (vim.v.foldend - vim.v.foldstart) .. " lines)"
		end
	end,
}
