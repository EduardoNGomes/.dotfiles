local M = {}

local colors = {
	background = "#191A20",
	foreground = "#9D9AB1",
	cursor = "#F4AFD2",
	selection = "#2F313C",
	line_highlight = "#2F313C",
	-- Syntax
	comment = "#7E8392",
	keyword = "#F65454",
	function_name = "#13FBA7",
	variable = "#FFFFFF",
	string = "#FFEB81",
	constant = "#C678DD",
	type = "#73F9F1",
	operator = "#ABB2BF",
	error = "#F65454",
	warning = "#E5C07B",

	-- Git
	git_add = "#98C379",
	git_change = "#E5C07B",
	git_delete = "#E06C75",

	-- Custom Colors for Specific Needs
	function_call = "#98C379",
	object_reference = "#C678DD",

	-- New colors for specific needs
	brackets = "#FCC42E",
	arguments = "#F38D3A",
	operator_signals = "#F26B71",
	escapes = "#CE80D9",
}

local function apply_highlights()
	local highlight = vim.api.nvim_set_hl

	highlight(0, "Normal", { bg = "none", fg = colors.foreground })
	highlight(0, "NormalFloat", { bg = "none" })

	highlight(0, "Comment", { fg = colors.comment, italic = true })
	highlight(0, "Keyword", { fg = colors.keyword, italic = true })
	highlight(0, "Function", { fg = colors.function_name, bold = true })
	highlight(0, "Variable", { fg = colors.variable })
	highlight(0, "String", { fg = colors.string })
	highlight(0, "Constant", { fg = colors.constant })
	highlight(0, "Type", { fg = colors.type, bold = true })
	highlight(0, "Operator", { fg = colors.operator })
	highlight(0, "Error", { fg = colors.error, bold = true })
	highlight(0, "Warning", { fg = colors.warning })

	-- Linhas e números
	highlight(0, "CursorLine", { bg = colors.line_highlight })
	highlight(0, "CursorLineNr", { fg = colors.foreground, bold = true })
	highlight(0, "LineNr", { fg = colors.comment })
	highlight(0, "Visual", { bg = colors.selection })
	-- Git
	highlight(0, "GitSignsAdd", { fg = colors.git_add })
	highlight(0, "GitSignsChange", { fg = colors.git_change })
	highlight(0, "GitSignsDelete", { fg = colors.git_delete })

	-- Treesitter highlights for better Go, JavaScript, and TypeScript support
	highlight(0, "@keyword", { fg = colors.keyword })
	highlight(0, "@namespace", { fg = colors.type })
	highlight(0, "@variable", { fg = colors.variable })
	highlight(0, "@function", { fg = colors.function_name, bold = true })
	highlight(0, "@function.builtin", { fg = "#F65454" })
	highlight(0, "@function.call", { fg = colors.function_call })
	highlight(0, "@parameter", { fg = "#FB9D46" })
	highlight(0, "@number", { fg = colors.constant })
	highlight(0, "@type", { fg = colors.type, bold = true })
	highlight(0, "@type.builtin", { fg = "#73F9F1" })
	highlight(0, "@string", { fg = colors.string })
	highlight(0, "@operator", { fg = colors.operator })
	highlight(0, "@comment", { fg = colors.comment, italic = true })
	highlight(0, "@field", { fg = colors.variable })
	highlight(0, "@attribute", { fg = colors.type })
	highlight(0, "@decorator", { fg = colors.function_name, italic = true })
	highlight(0, "@variable.builtin", { fg = colors.object_reference })

	-- Custom syntax highlighting rules
	highlight(0, "@punctuation.brackets", { fg = colors.brackets })
	highlight(0, "@parameter", { fg = colors.arguments })
	highlight(0, "@operator", { fg = colors.operator_signals })
	highlight(0, "@string.escape", { fg = colors.escapes })
	highlight(0, "@string.special", { fg = colors.escapes })
	highlight(0, "@string.special.symbol", { fg = colors.escapes })
end

function M.setup()
	vim.cmd("highlight clear")
	vim.cmd("syntax reset")
	vim.o.background = "dark"
	vim.g.colors_name = "davinci"

	-- Transparência
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = "#9D9AB1" }) -- Transparente com texto claro
	vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", fg = "#7E8392" }) -- Para a status line inativa

	apply_highlights()
end

return M
