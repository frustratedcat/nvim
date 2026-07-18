-- =======================================================================================
-- Table of Contents
-- ========================================================================================
-- Options
-- Keymaps
-- ADD PACKAGES
-- COLORS
-- LSP
-- AUTOPAIRS
-- ALPHA
-- AUTOTAG
-- MINI
-- NONECKPAIN
-- RENDER-MARKDOWN

-- ========================================================================================
-- OPTIONS
-- ========================================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.listchars:append({ tab = "  " })
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.winborder = "rounded"
vim.opt.laststatus = 0

-- ========================================================================================
-- API
-- ========================================================================================
-- don't allow pyright to try to format on save as it slows everything down
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		vim.lsp.buf.format({
			bufnr = args.buf,
			async = false,
			timeout_ms = 500,
			filter = function(client)
				return client.name ~= "pyright"
			end,
		})
	end,
})
-- LSP Commands
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)
		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code Actions" })
		)
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Code Rename" }))
		vim.keymap.set(
			"n",
			"<leader>k",
			vim.lsp.buf.hover,
			vim.tbl_extend("force", opts, { desc = "Hover Documentation" })
		)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover (alt)" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
	end,
})

-- ========================================================================================
-- KEYMAPS
-- ========================================================================================
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
-- mini commands
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Fuzzy find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Live grep text" })
vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "Fuzzy find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Search help tags" })
vim.keymap.set("n", "<leader>fr", "<cmd>Pick resume<cr>", { desc = "Resume last search" })
vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle file explorer" })
-- mini.pick Navigation Keybindings (Default Actions)
-- <C-p> or <Up>   - Move Selection Up
-- <C-n> or <Down> - Move Selection Down
-- <CR>            - Select / Open File
-- <Esc> or <C-c>  - Close / Cancel Picker
-- <C-f> / <C-b>   - Scroll Preview Up / Down
-- Toggle NoNeckPain centering layout on/off
vim.keymap.set("n", "<leader>np", "<cmd>NoNeckPain<CR>", { desc = "Toggle NoNeckPain" })
-- Diagnostic navigation
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.jump({ count = -1 })<CR>", { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.jump({ count = 1 })<CR>", { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>le", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show line error details" })

-- ========================================================================================
-- ADD PACKAGES
-- ========================================================================================
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/goolord/alpha-nvim" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/shortcuts/no-neck-pain.nvim" },
	{ src = "https://github.com/nvim-mini/mini.files" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/nyoom-engineering/oxocarbon.nvim" },
})

-- ========================================================================================
-- COLORS
-- ========================================================================================
--vim.cmd("colorscheme catppuccin-macchiato")
vim.cmd("colorscheme oxocarbon")

-- ========================================================================================
-- LSP
-- ========================================================================================
-- MASON
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "pyright", "html", "cssls", "gopls", "ruff", "marksman" },
})
-- lua_ls stuff so I don't get the warnings for "vim" as a global
local lua_cfg = vim.lsp.config.lua_ls
lua_cfg.settings = {
	Lua = {
		diagnostics = {
			globals = { "vim" },
		},
		workspace = {
			library = vim.api.nvim_get_runtime_file("", true),
		},
	},
}
-- Enable all the LSP stuff
vim.lsp.config("lua_ls", lua_cfg)
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("gopls")
vim.lsp.enable("ruff")
vim.lsp.enable("marksman")

-- ========================================================================================
-- AUTOPAIRS
-- ========================================================================================
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "spectre_panel" },
	disable_in_macro = true,
})

-- ========================================================================================
-- ALPHA
-- ========================================================================================
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	[[ ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓       ]],
	[[ ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒       ]],
	[[▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░       ]],
	[[▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██        ]],
	[[▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒       ]],
	[[░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░       ]],
	[[░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░       ]],
	[[   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░          ]],
	[[         ░    ░  ░    ░ ░        ░   ░         ░          ]],
	[[                                ░                         ]],
	[[             \`-._           __                           ]],
	[[              \\  \-..____,.'  `.                         ]],
	[[               :  )       :      :\                       ]],
	[[                ;'        '   ;  | :                      ]],
	[[                )..      .. .:.`.; :                      ]],
	[[               /::...  .:::...   ` ;                      ]],
	[[               `:o>   /\o_>        : `.                   ]],
	[[              `-`.__ ;   __..--- /:.   \                  ]],
	[[              === \_/   ;=====_.':.     ;                 ]],
	[[               ,/'`--'...`--....        ;                 ]],
	[[                    ;                    ;                ]],
	[[                . '                       ;               ]],
	[[              .'     ..     ,      .       ;              ]],
	[[             :       ::..  /      ;::.     |              ]],
	[[            /      `.;::.  |       ;:..    ;              ]],
	[[           :         |:.   :       ;:.    ;               ]],
	[[           :         ::     ;:..   |.    ;                ]],
	[[            :       :;      :::....|     |                ]],
	[[            /\     ,/ \      ;:::::;     ;                ]],
	[[          .:. \:..|    :     ; '.--|     ;                ]],
	[[         ::.  :''  `-.,,;     ;'   ;     ;                ]],
	[[      .-'. _.'\      / `;      \,__:      \               ]],
	[[      `---'    `----'   ;      /    \,.,,,/               ]],
	[[                         `----`                           ]],
}
dashboard.section.buttons.val = {}
local function footer()
	return string.upper("you mess with the paw, you get the claw")
end
dashboard.section.footer.val = footer()
alpha.setup(dashboard.opts)

-- ========================================================================================
-- AUTOTAG
-- ========================================================================================
require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = false,
	},
})

-- ========================================================================================
-- MINI
-- ========================================================================================
require("mini.pick").setup()
require("mini.files").setup()

-- ========================================================================================
-- NONECKPAIN
-- ========================================================================================
require("no-neck-pain").setup({
	width = 100,
	autocmds = {
		enableOnVimEnter = true,
	},
	buffers = {
		right = {
			enabled = true,
		},
		left = {
			enabled = true,
		},
		colors = {
			background = "catppuccin-macchiato",
		},
	},
})

-- ========================================================================================
-- RENDER-MARKDOWN
-- ========================================================================================
require("render-markdown").setup({
	html = { enabled = false },
	latex = { enabled = false },
	yaml = { enabled = false },
})
