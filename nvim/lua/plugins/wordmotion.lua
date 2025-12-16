return {
	"chaoren/vim-wordmotion",
    event = "VeryLazy",
    init = function()
        vim.keymap.set({'o', 'x'}, 'is', 'iw', { noremap = true, desc = 'inner word (original vim)' })
        vim.keymap.set({'o', 'x'}, 'as', 'aw', { noremap = true, desc = 'a word (original vim)' })
    end,
}
