return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            require('telescope').setup {
                pickers = {
                    find_files = { theme = "ivy" },
                    live_grep = { theme = "ivy" },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                    -- Fuzzy matching
                        override_generic_sorter = true, -- Override the generic sorter
                        override_file_sorter = true,    -- Override the file sorter
                        case_mode = "smart_case",       -- Case-insensitive unless uppercase is used
                    },
                },
            }
            require('telescope').load_extension('fzf')
        end,
    },
}
