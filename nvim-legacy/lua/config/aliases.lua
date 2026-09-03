-- Close all other buffers except current
vim.api.nvim_create_user_command("Bone", ":%bd|e#", {})
