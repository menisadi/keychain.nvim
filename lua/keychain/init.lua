local M = {}
local keymap_counts = {}
local save_file = vim.fn.stdpath("data") .. "/keymap_counts.json"

-- Load keymap counts from file
local function load_counts()
	local f = io.open(save_file, "r")
	if f then
		local content = f:read("*a")
		f:close()
		keymap_counts = vim.json.decode(content) or {}
	end
end

-- Save keymap counts to file
local function save_counts()
	local f = io.open(save_file, "w")
	if f then
		f:write(vim.json.encode(keymap_counts))
		f:close()
	end
end

-- Increment usage count for a key
local function increment_key(key)
	if keymap_counts[key] == nil then
		keymap_counts[key] = 0
	end
	keymap_counts[key] = keymap_counts[key] + 1
end

-- Track key usage
local function setup_autocmds()
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*",
		callback = function()
			save_counts()
		end,
	})

	-- Example: Tracking Normal mode key presses (simplified)
	vim.on_key(function(key)
		local maps = vim.api.nvim_get_keymap("n")
		for _, map in ipairs(maps) do
			if map.lhs == key then
				increment_key(key)
			end
		end
	end, vim.api.nvim_create_namespace("keymap_tracker"))
end

-- Display keymap counts
function M.show_counts()
	print(vim.inspect(keymap_counts))
end

-- Plugin setup
function M.setup()
	vim.notify("Starting keychain")
	load_counts()
	vim.notify("setting up keychain")
	setup_autocmds()
		vim.notify("Creating commands")
	vim.api.nvim_create_user_command("ShowKeyCounts", M.show_counts, {})
	vim.keymap.set("n", "<Leader>ks", "<cmd>ShowKeyCounts<cr>", { noremap = true, silent = true })
end

return M
