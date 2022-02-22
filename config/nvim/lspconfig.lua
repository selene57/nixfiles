--setup buffer specific functionality
local on_attach = function()
	--setup keybindings and completion (things that are buffer specific)
        vim.cmd[[
                augroup lsp_buf_format
                au! BufWritePre <buffer>
                autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
                augroup END
        ]]
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
        vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, {buffer=0})
        vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, {buffer=0})
        vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer=0})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer=0})
end

--setup all language servers in the list of servers below
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = {
	'pyright'
}
for _, lsp in pairs(servers) do
	require('lspconfig')[lsp].setup {
		capabilities = capabilities,
		on_attach = on_attach,
		flags = {
			-- This will be the default in neovim 0.7+
			debounce_text_changes = 150
		}
	}
end
