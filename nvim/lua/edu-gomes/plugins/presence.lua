return {
	"andweeb/presence.nvim",
	config = function()
		require("presence").setup({
			auto_update = true,
			main_image = "file",
			enable_line_number = false,
			show_time = true,
			workspace_text = "Working on a project",
			file_explorer_text = "Browsing Filetree",
			editing_text = function(filename)
				local ext = filename:match("^.+(%..+)$") or ""

				return "Writing unbelievable things in " .. ext .. " "

				------------------return "Editing a " .. ext .. " file"
			end,
		})
	end,
}
