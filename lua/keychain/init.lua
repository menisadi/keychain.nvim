local M = {}
local keymap_counts = {}

function M.init_keymap_counts()
	local maps = vim.api.nvim_get_keymap("n")
	for i, map in ipairs(maps) do
		if i < 3 then
			for k, v in pairs(map) do
				print("----")
				print(k)
				print(v)
			end
		end
	end
end

function M.show_counts()
	vim.notify("Placeholder notification", vim.log.levels.INFO)
end

function M.setup()
	-- load_counts()
	-- setup_autocmds()
	vim.api.nvim_create_user_command("ShowKeyCounts", M.show_counts, {})
	vim.keymap.set("n", "<Leader>ks", "<cmd>ShowKeyCounts<cr>", { noremap = true, silent = true })
end

return M
