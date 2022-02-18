--setup global lspconfig keybindings or other settings

--setup buffer specific functionality
local on_attach = function()
	--setup keybindings and completion (things that are buffer specific)
end

--setup all language servers in the list of servers below
local servers = {
	'pyright'
}
for _, lsp in pairs(servers) do
	require('lspconfig')[lsp].setup {
		on_attach = on_attach,
		flags = {
			-- This will be the default in neovim 0.7+
			debounce_text_changes = 150
		}
	}
end
