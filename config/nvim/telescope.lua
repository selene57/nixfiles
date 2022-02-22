require('telescope').setup{
        -- config goes here
        extensions = {
                fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case"
                }
        }
}

require('telescope').load_extension('fzf')

vim.keymap.set('n', '<leader>fa', "<cmd>lua require('telescope.builtin').builtin()<cr>")
vim.keymap.set('n', '<leader>ff', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>")
vim.keymap.set('n', '<leader>fq', "<cmd>lua require('telescope.builtin').quickfix()<cr>")
vim.keymap.set('n', '<leader>fd', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
vim.keymap.set('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
