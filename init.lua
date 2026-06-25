local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- set leader key
vim.g.mapleader = ','

-- no editor config
vim.g.editorconfig = false

-- Highlighter (default key mappings)
vim.g.HiSet   = '<M-f>'
vim.g.HiErase = '<M-e>'
vim.g.HiClear = '<space>c'
vim.g.HiFind  = '<space>f'
-- vim.g.HiKeywords = '~/.vim/after/vim-highlighter'

-- configs
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.autoread = true
vim.opt.ignorecase = true

-- path configs
path_spliter = '\\'
if not (vim.loop.os_uname().sysname == 'Windows_NT') then
	path_spliter = '/'
end
sessions_path = vim.fn.expand('$HOME') .. path_spliter .. 'vim_sessions'
bookmarks_path = vim.fn.expand('$HOME') .. path_spliter .. 'vim_bookmarks'

-- check bookmark directory
if vim.fn.isdirectory(bookmarks_path) == 0 then
	vim.fn.mkdir(bookmarks_path)
end

-- check session directory
if vim.fn.isdirectory(sessions_path) == 0 then
	vim.fn.mkdir(sessions_path)
end

-- Load customized modularized configurations
require('my_config')
require('my_utils')
require('my_codelink')
require('my_session')
require('my_snippets')
require('my_tag')
require('my_diff')

require('lazy').setup({
	{
		'folke/tokyonight.nvim',
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd.colorscheme('tokyonight')
		end,
	},
	-- For NVim completion
	'neovim/nvim-lspconfig',
	-- blink.cmp
	{
		'saghen/blink.cmp',
		dependencies = {
			'rafamadriz/friendly-snippets',
			{
				'saghen/blink.compat',
				--! @brief Configure blink.compat to mock nvim-cmp.
				opts = {},
				config = function(_, opts)
					require('blink.compat').setup(opts)
					--! @brief Monkeypatch cmp.ConfirmBehavior to prevent errors with Avante
					local ok, cmp = pcall(require, "cmp")
					if ok then
						cmp.ConfirmBehavior = {
							Insert = "insert",
							Replace = "replace",
						}
					end
				end
			},
		},
		version = '*',
		opts = {
			keymap = {
				preset = 'none',
				['<Tab>'] = { 'snippet_forward', 'accept', 'fallback' },
				['<Down>'] = { 'select_next', 'fallback' },
				['<Up>'] = { 'select_prev', 'fallback' },
				['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
				['<M-e>'] = { 'show', 'show_documentation', 'hide_documentation' },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono'
			},
			completion = {
				list = {
					selection = {
						preselect = true,
						auto_insert = false
					}
				}
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer', 'buffer_names', 'avante_commands', 'avante_mentions', 'avante_files' },
				providers = {
					buffer = {
						opts = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						}
					},
					buffer_names = {
						name = 'BufferNames',
						module = 'buffer_names',
						score_offset = 100, -- Give it a boost if needed
					},
					--! @brief Configure Avante commands source provider using blink.compat
					avante_commands = {
						name = 'avante_commands',
						module = 'blink.compat.source',
						score_offset = 90,
						opts = {}
					},
					--! @brief Configure Avante mentions source provider using blink.compat
					avante_mentions = {
						name = 'avante_mentions',
						module = 'blink.compat.source',
						score_offset = 90,
						opts = {}
					},
					--! @brief Configure Avante files source provider using blink.compat
					avante_files = {
						name = 'avante_files',
						module = 'blink.compat.source',
						score_offset = 90,
						opts = {}
					},
				}
			},
		},
		opts_extend = { "sources.default" }
	},
	'tpope/vim-commentary',
	{
		'scrooloose/nerdtree',
		cmd = { 'NERDTree', 'NERDTreeToggle', 'NERDTreeFind', 'NERDTreeClose', 'NERDTreeMirror' },
	},
	'vim-airline/vim-airline',
	'vim-airline/vim-airline-themes',
	-- {
		-- 'phaazon/hop.nvim', -- instead of easymotion, it's faster
		-- config = function()
			--	 require'hop'.setup()
			-- end,
			-- },
			-- 'easymotion/vim-easymotion',
			{
				"folke/flash.nvim",
				event = "VeryLazy",
				---@type Flash.Config
				opts = {},
				-- stylua: ignore
				keys = {
					{ "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump({
						labels = "asdfghjklqwertyuiopzxcvbnm",
						search = { forward = true, wrap = true, multi_window = true, mode="search"},
						label = {uppercase = false, after = false, before = true},
					}) end, desc = "Flash" },
				},
			},
			'rust-lang/rust.vim',
			{
				'junegunn/fzf',
				build = function ()
					vim.cmd(':call fzf#install()')
				end
			},
			'junegunn/fzf.vim',
			{
				"yetone/avante.nvim",
				-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
				-- ⚠️ must add this setting! ! !
				build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
				or "make",
				event = "VeryLazy",
				version = false, -- Never set this value to "*"! Never!
				config = function()
					SetupAvantePlugin()
				end,
				dependencies = {
					"nvim-lua/plenary.nvim",
					"MunifTanjim/nui.nvim",
					--- The below dependencies are optional,
					"nvim-mini/mini.pick", -- for file_selector provider mini.pick
					"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
					"ibhagwan/fzf-lua", -- for file_selector provider fzf
					"stevearc/dressing.nvim", -- for input provider dressing
					"folke/snacks.nvim", -- for input provider snacks
					"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
					"zbirenbaum/copilot.lua", -- for providers='copilot'
					{
						-- support for image pasting
						"HakonHarnes/img-clip.nvim",
						event = "VeryLazy",
						opts = {
							-- recommended settings
							default = {
								embed_image_as_base64 = false,
								prompt_for_file_name = false,
								drag_and_drop = {
									insert_mode = true,
								},
								-- required for Windows users
								use_absolute_path = true,
							},
						},
					},
					{
						-- Make sure to set this up properly if you have lazy=true
						'MeanderingProgrammer/render-markdown.nvim',
						opts = {
							file_types = { "markdown", "Avante" },
						},
						ft = { "markdown", "Avante" },
					},
				},
			},

	'junegunn/vim-easy-align',
	'frazrepo/vim-rainbow',
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
			cmdline = {
				enabled = false, -- disabled to avoid conflict with wilder.nvim
				view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
				opts = {}, -- global options for the cmdline. See section on views
				---@type table<string, CmdlineFormat>
				format = {
					-- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
					-- view: (default is cmdline view)
					-- opts: any options passed to the view
					-- icon_hl_group: optional hl_group for the icon
					-- title: set to anything or empty string to hide
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
					input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
					-- lua = false, -- to disable a format, set to `false`
				},
			},
			lsp = {
				hover = {
					enabled = true,
					silent = false, -- set to true to not show a message if hover is not available
					view = nil, -- when nil, use defaults from documentation
					---@type NoiceViewOptions
					opts = {}, -- merged with defaults from documentation
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
						luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
						throttle = 50, -- Debounce lsp signature help request by 50ms
					},
					view = nil, -- when nil, use defaults from documentation
					---@type NoiceViewOptions
					opts = {}, -- merged with defaults from documentation
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			views = {
				notify = {
					timeout = 1500,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		}
	},
	{
		'gelguy/wilder.nvim',
		config = function()
			-- config goes here
			local wilder = require('wilder')
			wilder.setup({
				modes = { ':', '/', '?', '!' },
			})
			wilder.set_option('renderer', wilder.popupmenu_renderer(
			wilder.popupmenu_palette_theme({
				-- 'single', 'double', 'rounded' or 'solid'
				-- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
				border = 'rounded',
				max_height = '75%',	  -- max height of the palette
				min_height = 0,		  -- set to the same as 'max_height' for a fixed height window
				prompt_position = 'top', -- 'top' or 'bottom' to set the location of the prompt
				reverse = 0,			 -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
			})
			))
		end,
	},
	{
		'akinsho/bufferline.nvim',
		config = function() 
			require('bufferline').setup(
			{
				options = {
					show_buffer_close_icons = false,
					show_close_icon = false,
					show_tab_indicators = true,
					separator_style = 'thin',
					always_show_bufferline = true,
				}
			}
			)
		end,
	},
	{
		'nvimdev/dashboard-nvim',
		event = 'VeryLazy',
		config = function()
			require('dashboard').setup {
				-- config
				theme = 'hyper',
				config = {
					week_header = {
						enable = true,
					},
					packages = { enable = true }, -- show how many plugins neovim loaded
					project = { enable = true, limit = 8, icon = 'your icon', label = ''},
					mru = { limit = 10, icon = 'your icon', label = '', },
					footer = {}, -- footer
					shortcut = {
						{ desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
						{
							icon = ' ',
							icon_hl = '@variable',
							desc = 'Files',
							group = 'Label',
							action = 'FZF',
							key = 'f',
						},
						{
							desc = 'Exit',
							group = 'Label',
							action = 'q',
							key = 'q',
						},
						-- {
						--   desc = ' Apps',
						--   group = 'DiagnosticHint',
						--   action = 'Telescope app',
						--   key = 'a',
						-- },
					},
				},
			}
		end,
		dependencies = { {'nvim-tree/nvim-web-devicons'}}
	},
	{ 'stevearc/dressing.nvim' },
	'azabiong/vim-highlighter',
	'tikhomirov/vim-glsl',
	'beyondmarc/hlsl.vim',
	-- LSP
	'neovim/nvim-lspconfig',
	{
		'williamboman/mason.nvim',
		config = function ()
			require("mason").
			setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "->",
						package_uninstalled = "x"
					}
				}
			})
		end
	},
	'williamboman/mason-lspconfig.nvim',
	'nvim-lua/plenary.nvim',
	{
		'nvim-telescope/telescope.nvim', branch = 'master',
		cmd = { "Telescope" },
		dependencies = { 
			'nvim-lua/plenary.nvim',
			{ 
				"nvim-telescope/telescope-live-grep-args.nvim" ,
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
		},
		config = function()
			SetupTelescopePlugin()
		end
	},
	{
		'kentzhang-geek/zoekt.nvim',
		dependencies = { 
			'nvim-lua/plenary.nvim',
		},
		config = function()
			require('zoektnvim').setup()
		end
	},
	{
		'kentzhang-geek/bookmarks.nvim', -- after = "telescope.nvim",
		event = "VimEnter",
		config = function()
			require('bookmarks').setup{
				save_file = bookmarks_path .. path_spliter .. "default.bookmarks", -- bookmarks save file path
				keywords =  {
					["@t"] = "☑️", -- mark annotation startswith @t ,signs this icon as `Todo`
					["@w"] = "⚠️", -- mark annotation startswith @w ,signs this icon as `Warn`
					["@f"] = "⛏", -- mark annotation startswith @f ,signs this icon as `Fix`
					["@n"] = "⭐", -- mark annotation startswith @n ,signs this icon as `Note`
				},
			}
		end
	},
	{ 'nvim-telescope/telescope-ui-select.nvim', lazy = true },
	{ 'nvim-telescope/telescope-file-browser.nvim', lazy = true },
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest",  -- Installs `mcp-hub` node binary globally
		config = function()
			require("mcphub").setup()
		end
	},
	'petertriho/nvim-scrollbar',
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>cd %:p:h<cr><cmd>LazyGit<cr>", desc = "LazyGit" }
		}
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
	},
	{
		'stevearc/aerial.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- Spec for group labels and key descriptions
			spec = {
				-- Leader key groups
				{ "<leader>b", group = "Bookmarks" },
				{ "<leader>bb", desc = "Toggle bookmark" },
				{ "<leader>ba", desc = "Annotate bookmark" },
				{ "<leader>bs", desc = "Show bookmark list" },
				{ "<leader>n", group = "NERDTree" },
				{ "<leader>nt", desc = "Open NERDTree" },
				{ "<leader>w", desc = "Save file" },
				{ "<leader>q", desc = "Close buffer" },
				{ "<leader>x", desc = "Quit all" },
				{ "<leader>f", desc = "FZF files" },
				{ "<leader>k", desc = "Half page up" },
				{ "<leader>j", desc = "Half page down" },
				{ "<leader>/", desc = "Toggle comment" },
				{ "<leader>s", desc = "Flash jump" },
				{ "<leader>a", desc = "Aerial toggle" },
				{ "<leader>o", group = "Outline" },
				{ "<leader>ol", desc = "Outline (Telescope aerial)" },
				{ "<leader>ea", desc = "EasyAlign paragraph" },
				{ "<leader>ts", desc = "Telescope" },
				{ "<leader>url", desc = "Copy code link" },
				{ "<leader>pt", desc = "Copy absolute path" },
				{ "<leader>mm", desc = "Utility menu" },
				{ "<leader>lg", desc = "LazyGit" },
				{ "<leader>?", desc = "Buffer local keymaps" },

				-- Space key group (vim-highlighter)
				{ "<space>c", desc = "Highlight clear" },
				{ "<space>f", desc = "Highlight find" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	}
})

-- for airline statusline
vim.g.airline_section_c = '%F'
vim.g.airline_exclude_filetypes = { 'Avante', 'AvanteInput', 'AvanteSelectedFiles', 'notify', 'noice', 'NvimTree', 'neo-tree', 'dashboard', 'help', 'qf' }
vim.g.airline_exclude_preview = 1

local function disable_airline_for_special_windows()
	local buftype = vim.bo.buftype
	local filetype = vim.bo.filetype
	if buftype == 'nofile' or buftype == 'prompt' or buftype == 'quickfix' or filetype == 'Avante' or filetype == 'notify' or filetype == 'noice' then
		vim.w.airline_disable_statusline = 1
		vim.wo.statusline = ' '
	else
		vim.w.airline_disable_statusline = nil
		if vim.wo.statusline == ' ' then
			vim.wo.statusline = ''
		end
	end
end

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'FileType' }, {
	group = vim.api.nvim_create_augroup('DisableAirlineSpecialWindows', { clear = true }),
	callback = disable_airline_for_special_windows,
})

vim.opt.encoding    = 'utf-8'
vim.opt.nu          = true
vim.opt.smartindent = true
vim.opt.expandtab   = false   -- use tabs, not spaces
vim.opt.tabstop     = 4		-- tab character is 4 spaces wide
vim.opt.shiftwidth  = 4	 -- indent levels are 4 spaces
vim.opt.softtabstop = 4	-- number of spaces when hitting Tab
vim.opt.cindent     = true
vim.bo.softtabstop  = 4
vim.o.softtabstop   = 4
vim.o.hlsearch      = false
vim.o.cursorline    = true
vim.opt.swapfile    = false
vim.opt.list        = true
vim.opt.listchars   = {
	tab             = '>-',		 -- How a tab will be shown
	trail           = '~',		-- Trailing spaces
	extends         = '>',	  -- When line is too long at end
	precedes        = '<',	 -- When line is too long at beginning
}
vim.opt.listchars:append("space:·") -- Use "·" or another char for spaces
vim.opt.fixendofline = false
vim.opt.fixeol = false

local gui_font_size = 16
local function adjust_font_size(amount)
	gui_font_size = gui_font_size + amount
	vim.o.guifont = 'Consolas:h' .. gui_font_size
end

if vim.g.neovide then
	vim.o.guifont = "JetBrainsMono Nerd Font:h14"
	-- Dynamic font size adjustment via neovide_scale_factor
	vim.g.neovide_scale_factor = 1.0
	vim.keymap.set('n', '<C-ScrollWheelUp>', function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
	end)
	vim.keymap.set('n', '<C-ScrollWheelDown>', function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
	end)
elseif vim.fn.has('gui_running') == 1 then
	vim.o.guifont = 'JetBrainsMono Nerd Font:h14'
	vim.keymap.set('n', '<C-ScrollWheelUp>', function()
		adjust_font_size(2)
	end)
	vim.keymap.set('n', '<C-ScrollWheelDown>', function()
		adjust_font_size(-2)
	end)
end

--! @brief Configures the system clipboard statically to speed up Neovim startup on Windows.
vim.g.clipboard = {
	name = 'win32yank',
	copy = {
		['+'] = 'win32yank.exe -i --crlf',
		['*'] = 'win32yank.exe -i --crlf',
	},
	paste = {
		['+'] = 'win32yank.exe -o --lf',
		['*'] = 'win32yank.exe -o --lf',
	},
	cache_enabled = 0,
}
vim.cmd('set clipboard+=unnamedplus')

-- scrollbar -> this one seems better
local colors = require("tokyonight.colors").setup()

require("scrollbar").setup({
	handle     = {
		color  = colors.blue0,
	},
	marks      = {
		Search = { color = colors.orange },
		Error  = { color = colors.error },
		Warn   = { color = colors.warning },
		Info   = { color = colors.info },
		Hint   = { color = colors.hint },
		Misc   = { color = colors.purple },
	}
})

-- move easy
local nimode  = {'n', 'i'}
local nivmode = {'n', 'i', 'v'}
local nleader = '<leader>'
local ileader = '<M-,>'

vim.keymap.set(nimode, '<M-Up>', '#')
vim.keymap.set(nimode, '<M-Down>', '*')
vim.keymap.set('n', '<c-p>', '#')
vim.keymap.set('n', '<c-n>', '*')

vim.keymap.set('n', nleader .. 'k', '<c-u>')
vim.keymap.set('n', nleader .. 'j', '<c-d>')
vim.keymap.set('n', ileader .. 'k', '<c-u>')
vim.keymap.set('n', ileader .. 'j', '<c-d>')

-- paste easy
vim.keymap.set('c', '<S-Insert>', '<C-R>+')
vim.keymap.set('n', '<S-Insert>', '<C-R>+')
vim.keymap.set('i', '<S-Insert>', '<C-R>+')

-- save easy
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':bd<CR>')
vim.keymap.set('n', '<leader>x', ':qa<CR>')

-- configs for NERDTree
vim.keymap.set('n', nleader .. 'nt', ':cd %:p:h<CR>:NERDTree<CR>')
vim.keymap.set('i', ileader .. 'nt', '<esc>:cd %:p:h<CR>:NERDTree<CR>')

-- configs for fzf
vim.g.fzf_preview_window = 'right:50%'
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6  }  }
vim.keymap.set('n', nleader .. 'f', ':FZF<CR>')
-- for old fuzzy.vim
-- vim.keymap.set('n', nleader .. 'l', ':BLines<CR>')
-- vim.keymap.set('n', nleader .. 'gf', ':GFiles<CR>')
-- vim.keymap.set('n', nleader .. 'm', ':Fzm<CR>')
-- vim.keymap.set('n', nleader .. 'mm', ':Commands<CR>')

-- for vim-commentary
-- for visual mode, only 'gc' will work
vim.keymap.set('n', nleader .. '/', '<Plug>CommentaryLine')
vim.keymap.set('i', ileader .. '/', '<Plug>CommentaryLine')
vim.keymap.set(nimode, '<C-/>', '<Plug>CommentaryLine')

-- for easy align
-- Start interactive EasyAlign in visual mode (e.g. vipga)
vim.keymap.set('v', 'ga', '<Plug>(EasyAlign)<C-X>')

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
vim.keymap.set('n', nleader .. 'ea', 'vip<Plug>(EasyAlign)<C-X>')

-- For Hop
-- vim.keymap.set('n', nleader .. 's', ':HopAnywhere<CR>')
-- For easymotion
-- vim.g.EasyMotion_smartcase = 1
-- vim.keymap.set('n', nleader .. 's', '<Plug>(easymotion-sn)')
-- vim.keymap.set('i', ileader .. 's', '<Plug>(easymotion-sn)')

--! @brief Configures Telescope settings and loads extensions lazily.
function SetupTelescopePlugin()
	local telescope = require('telescope')
	telescope.setup({
		defaults = {
			layout_strategy = 'vertical',
			layout_config = {
				vertical = { width = 0.8 },
			},
		},
		extensions = {
			aerial = {
				col1_width = 4,
				col2_width = 30,
				format_symbol = function(symbol_path, filetype)
					if filetype == "json" or filetype == "yaml" then
						return table.concat(symbol_path, ".")
					else
						return symbol_path[#symbol_path]
					end
				end,
				show_columns = "both",
			}
		},
	})
	telescope.load_extension("live_grep_args")
	telescope.load_extension("aerial")
	telescope.load_extension("ui-select")
	telescope.load_extension("file_browser")
	telescope.load_extension("bookmarks")
	telescope.load_extension("noice")
end

vim.keymap.set("n", "<C-k>", function() vim.cmd(':Telescope') end) -- Invoke Telescope with <C-K> in normal mode
vim.keymap.set("i", "<C-k>", function() vim.cmd(':Telescope') end) -- Invoke Telescope with <C-K> in insert mode

-- For bookmark
local map = vim.keymap.set
map("n", nleader .. "bb", function() require("bookmarks").bookmark_toggle() end) -- add or remove bookmark at current line
map("n", nleader .. "ba", function() require("bookmarks").bookmark_ann() end) -- add or edit mark annotation at current line
map("n", nleader .. "bs", function() bmlist() end) -- show marked file list in quickfix window
map("i", ileader .. "bb", function() require("bookmarks").bookmark_toggle() end) -- add or remove bookmark at current line
map("i", ileader .. "ba", function() require("bookmarks").bookmark_ann() end) -- add or edit mark annotation at current line
map("i", ileader .. "bs", function() bmlist() end) -- show marked file list in quickfix window

-- For Telescope
vim.keymap.set('n', nleader .. 'ts', ':Telescope<CR>')

vim.keymap.set('n', nleader .. 'url', function() CodeLink() end)
vim.keymap.set('n', '<M-c>', function() CodeLink() end)
vim.keymap.set('i', '<M-c>', function() CodeLink() end)
vim.keymap.set('n', '<M-g>', function() GotoCodeLink() end)
vim.keymap.set('n', nleader .. 'pt', function() CopyAbsolutePath() end)

vim_home_path = vim.fn.stdpath('config') .. path_spliter
local config_file_path = vim.fn.expand('$HOME') .. path_spliter .. '.config' .. path_spliter .. 'nvim' .. path_spliter
local config_file = config_file_path .. 'project_config.json'


local cfg = load_config() -- test file if not exists

-- Setup language servers. clangd is registered here, but disabled by default.
local clangd_background_index = true

local function SetupClangdConfig()
	vim.lsp.config('clangd', {
		cmd = {
			"clangd",
			"--clang-tidy=false",
			"--pretty",
			"--background-index=" .. (clangd_background_index and "true" or "false"),
		},
	})
end

local function StopLspClients(name)
	for _, client in ipairs(vim.lsp.get_clients({ name = name })) do
		client:stop(true)
	end
end

function LspMenu()
	local clients = vim.lsp.get_clients({ name = "clangd" })
	local status = (#clients > 0 and "running" or "stopped") .. ", background-index=" .. (clangd_background_index and "on" or "off")
	vim.ui.select({
		'enable clangd',
		'enable clangd without background index',
		'disable clangd',
		'restart clangd',
		'toggle background index',
		'lsp status',
	}, {
		prompt = 'LSP (' .. status .. ')',
	}, function(sel)
		if sel == 'enable clangd' then
			clangd_background_index = true
			SetupClangdConfig()
			vim.lsp.enable('clangd')
			print("clangd enabled with background index.")
		elseif sel == 'enable clangd without background index' then
			clangd_background_index = false
			SetupClangdConfig()
			vim.lsp.enable('clangd')
			print("clangd enabled without background index.")
		elseif sel == 'disable clangd' then
			vim.lsp.enable('clangd', false)
			StopLspClients("clangd")
			print("clangd disabled.")
		elseif sel == 'restart clangd' then
			SetupClangdConfig()
			StopLspClients("clangd")
			vim.lsp.enable('clangd')
			print("clangd restarted.")
		elseif sel == 'toggle background index' then
			clangd_background_index = not clangd_background_index
			SetupClangdConfig()
			StopLspClients("clangd")
			vim.lsp.enable('clangd')
			print("clangd background index: " .. (clangd_background_index and "on" or "off"))
		elseif sel == 'lsp status' then
			vim.cmd('LspInfo')
		end
	end)
end

SetupClangdConfig()

-- for outline plugin
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
	-- Jump forwards/backwards with '{' and '}'
	vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
	vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
vim.keymap.set("n", "<leader>ol", "<cmd>Telescope aerial<CR>")

vim.keymap.set("n", "<M-d>", function() vim.lsp.buf.hover() end, { desc = "doc" })

--! @brief Set up Copilot with suggestion/panel configurations.
function SetupCopilot()
	require('copilot').setup({
  panel = {
	enabled = false,
  },
  suggestion = {
	enabled                = true,
	auto_trigger           = true,
	hide_during_completion = false,
	debounce               = 15,
	trigger_on_accept      = true,
	keymap                 = nil
  },
  logger = {
	file               = vim.fn.stdpath("log") .. "/copilot-lua.log",
	file_log_level     = vim.log.levels.OFF,
	print_log_level    = vim.log.levels.WARN,
	trace_lsp          = "off", -- "off" | "debug" | "verbose"
	trace_lsp_progress = false,
	log_lsp_messages   = false,
  },
  root_dir = function()
	return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
  end,
  should_attach = function(_, _)
	if not vim.bo.buflisted then
	  return false
	end

	if vim.bo.buftype ~= "" then
	  return false
	end

	return true
  end,
  server = {
	type = "nodejs", -- "nodejs" | "binary"
	custom_server_filepath = nil,
  },
  server_opts_overrides = {},
})
end

--! @brief Disables Copilot suggestions and panel.
function DisableCopilot()
	local has_copilot, copilot = pcall(require, "copilot")
	if has_copilot then
		copilot.setup({
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = false,
			},
		})
	end
end

--! @brief Wrapper function to perform lazy configuration of the Avante plugin.
function SetupAvantePlugin()
	local cfg = load_config()
	if not (cfg.avante_provider and cfg.avante_provider:match("%S")) then
		cfg.avante_provider = "copilot"
	end
	local avante = require("avante")
	local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
	local Plug_opts = {silent = true, noremap = false}
	--! @brief Checks if the current operating system is Windows.
	local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'

	--! @brief Configuration for ACP providers.
	--! @details Appends '.cmd' to commands on Windows because Neovim's process spawn
	--!          requires the full command file extension for batch/cmd scripts.
	local acp_providers_config = {
		["gemini-acp"] = {
			command = is_windows and "gemini.cmd" or "gemini",
			args = { "--acp" },
			env = { NODE_NO_WARNINGS = "1" },
		},
		["claude-code"] = {
			command = is_windows and "claude-agent-acp.cmd" or "claude-agent-acp",
			args = {},
			env = { NODE_NO_WARNINGS = "1" },
		},
		["copilot-acp"] = {
			command = is_windows and "copilot.cmd" or "copilot",
			args = { "--acp" },
		},
		["codex-acp"] = {
			command = is_windows and "codex-acp.cmd" or "codex-acp",
			args = {},
			env = { NODE_NO_WARNINGS = "1" },
		},
	}

	--! @brief Determine if a custom model is configured.
	local has_custom_model = cfg.avante_model and cfg.avante_model:match("%S") ~= nil

	if cfg.avante_provider == "copilot" then
		local copilot_opts = {
			instructions_file = "avante.md",
			provider = cfg.avante_provider,
			behavior = {
				auto_suggestions = false,
			},
			mappings = {
				sidebar = {
					switch_windows = "<C-Tab>",
					reverse_switch_windows = "<C-S-Tab>",
				},
			},
			acp_providers = acp_providers_config,
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			-- Using function prevents requiring mcphub before it's loaded
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		}
		--! @brief Apply custom model to the copilot provider if configured.
		if has_custom_model then
			copilot_opts.providers = {
				copilot = {
					model = cfg.avante_model,
				},
			}
		end
		avante.setup(copilot_opts)
		SetupCopilot()
		-- For copilot
		vim.keymap.set("i", '<M-\\>', function() avante.toggle() end, {silent = true})
		vim.keymap.set("n", '<M-\\>', function() avante.toggle() end, {silent = true})
		vim.keymap.set("i", '<M-r>', function() require("copilot.suggestion").next() end, {silent = true})
		vim.keymap.set("i", '<M-R>', function() require("copilot.suggestion").next() end, {silent = true})
		vim.keymap.set("i", '<M-x>', function() 
			local has_copilot, copilot = pcall(require, "copilot.suggestion")
			if has_copilot and copilot.is_visible() then
				copilot.accept()
			end
		end, {silent = true})
	else
		DisableCopilot()
		--! @brief Load suggestion key into environment variables for the current provider.
		local has_suggestion_key = cfg.suggestion_key and cfg.suggestion_key:match("%S") ~= nil
		if has_suggestion_key then
			if cfg.avante_provider == "gemini" then
				vim.fn.setenv("GEMINI_API_KEY", cfg.suggestion_key)
			elseif cfg.avante_provider == "openai" then
				vim.fn.setenv("OPENAI_API_KEY", cfg.suggestion_key)
			elseif cfg.avante_provider == "claude" then
				vim.fn.setenv("ANTHROPIC_API_KEY", cfg.suggestion_key)
			end
		end

		local is_acp = acp_providers_config[cfg.avante_provider] ~= nil

		--! @brief Set up avante options with conditional auto suggestion support.
		local avante_opts = {
			instructions_file = "avante.md",
			provider = cfg.avante_provider,
			behavior = {
				auto_suggestions = not is_acp and has_suggestion_key,
			},
			providers = {
				ollama = {	
					model = cfg.ollama_model,
				}
			},
			mappings = {
				sidebar = {
					switch_windows = "<C-Tab>",
					reverse_switch_windows = "<C-S-Tab>",
				},
			},
			acp_providers = acp_providers_config,
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			--! @brief Custom tools loader function.
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		}

		if not is_acp and has_suggestion_key then
			avante_opts.mappings = {
				suggestion = {
					accept = "<M-x>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
					toggle_suggestion_display = "<M-\\>",
				},
			}
		end

		avante.setup(avante_opts)

		vim.keymap.set("i", '<M-\\>', function() require("avante").toggle() end, {silent = true})
		vim.keymap.set("n", '<M-\\>', function() require("avante").toggle() end, {silent = true})

		--! @brief Trigger auto suggestion manually if not in ACP mode.
		local function trigger_suggest()
			if is_acp then
				print("[Avante] Suggestion is not available in ACP mode.")
			else
				if has_suggestion_key then
					local ok, api = pcall(require, "avante.api")
					if ok and api.get_suggestion then
						local sugg_ok, suggestion = pcall(api.get_suggestion)
						if sugg_ok and suggestion then
							suggestion:suggest()
						end
					end
				else
					print("[Avante] No suggestion key configured, autocomplete is disabled.")
				end
			end
		end
		vim.keymap.set("i", '<M-r>', trigger_suggest, {silent = true})
		vim.keymap.set("i", '<M-R>', trigger_suggest, {silent = true})
	end
end



function AvanteMenu()
	vim.ui.select({
		'avante ask',
		'avante chat',
		'avante edit',
		'avante refresh',
		'avante toggle',
		'avante clear cache',
		'avante switch provider',
		'avante change model',
		'avante change acp model',
		'avante change acp work mode',
	}, {
		prompt = 'Avante Settings',
	}, function(sel)
		if sel == 'avante ask' then
			vim.cmd('AvanteAsk')
		elseif sel == 'avante chat' then
			vim.cmd('AvanteChat')
		elseif sel == 'avante edit' then
			vim.cmd('AvanteEdit')
		elseif sel == 'avante toggle' then
			vim.cmd('AvanteToggle')
		elseif sel == 'avante clear cache' then
			vim.cmd('AvanteClear')
		elseif sel == 'avante switch provider' then
			vim.cmd('AvanteSwitchProvider')
		elseif sel == 'avante change model' then
			vim.cmd('AvanteModels')
		elseif sel == 'avante refresh' then
			vim.cmd('AvanteRefresh')
		elseif sel == 'avante change acp model' then
			vim.cmd('AvanteACPModels')
		elseif sel == 'avante change acp work mode' then
			vim.cmd('AvanteACPModes')
		end
	end)
end

-- Utilities shortcuts
function UtilityMenu() 
	local word = vim.fn.expand('<cword>')
	local file_path = vim.fn.expand('%:p:h')
	local filename = vim.fn.expand('%:p')
	local linenum = vim.fn.line('.')
	local line_indent = vim.fn.indent(linenum)
	vim.ui.select({ 
		-- 'lookup word',
		'remove duplicate lines without sort',
		'remove duplicate lines with sort',
		'close deleted buffers',
		'clean shada tmp files',
		'show bookmark files',
		'bookmarks reload',
		'json beautify current line',
		'session submenu',
		'lsp submenu',
		'avante submenu',
		'avante snippets',
		'file browser',
		'live grep',
		'fuzzy lines',
		'fuzzy lines lookup',
		'tag begin',
		'tag end',
		'config',
		'config repair',
		'tag faster',
		'cd to file',
		'file remove read only',
		'p4 edit',
		'p4 all buffers add and edit',
		'p4 add',
		'git add',
		'git add all buffer',
		'git commit',
		'codelink tools',
		'diff with buffer',
		-- 'qgrep search',
		-- 'qgrep files',
		'quick zoekt search',
		'zoekt prefix',
		'quick zoekt lookup',
		'zoekt search',
		'zoekt lookup',
		'zoekt close all buffers',
		'enable fold',
		'install nerd font',
		'key bindings help',
		'dashboard',
		'tips and help'
	}, {
		prompt = 'Utilities',
	},
	function(sel)
	if sel == 'lookup word' then
		vim.cmd('QgrepSearch ' .. word)
	elseif sel == 'remove duplicate lines without sort' then
		vim.cmd('g/^\\(.*\\)$\\n\\1/d')
	elseif sel == 'remove duplicate lines with sort' then
		vim.cmd('sort u')
	elseif sel == 'close deleted buffers' then
		CloseDeletedBuffers()
	elseif sel == 'clean shada tmp files' then
		CleanShadaTmpFiles()
	elseif sel == 'show bookmark files' then
		os.execute('explorer \"' .. bookmarks_path .. '\"')
	elseif sel == 'dashboard' then
		vim.cmd('Dashboard')
	elseif sel == 'config' then
		vim.cmd('edit ' .. config_file)
	elseif sel == 'config repair' then
		RepairConfigJson()
	elseif sel == 'enable fold' then
		vim.cmd(':set foldenable')
		vim.cmd(':set foldmethod=syntax')
	elseif sel == 'bookmarks reload' then
		vim.cmd(':Telescope bookmarks reload')
	elseif sel == 'json beautify current line' then
		vim.cmd('%!jq .')
	elseif sel == 'session submenu' then
		SessionMenu()
	elseif sel == 'lsp submenu' then
		LspMenu()
	elseif sel == 'avante submenu' then
		AvanteMenu()
	elseif sel == 'avante snippets' then
		AvanteSnippetMenu()
	elseif sel == 'file browser' then
		FileBrowser(file_path)
	elseif sel == 'live grep' then
		require("telescope").extensions.live_grep_args.live_grep_args()
	elseif sel == 'fuzzy lines' then
		vim.cmd('Lines')
	elseif sel == 'fuzzy lines lookup' then
		vim.cmd('Lines ' .. word)
	elseif sel == 'tag faster' then
		tag_faster()
	elseif sel == 'tag begin' then
		tagWrapper(true)
	elseif sel == 'tag end' then
		tagWrapper(false)
	elseif sel == 'cd to file' then
		vim.cmd('cd ' .. file_path)
	elseif sel == 'file remove read only' then
		vim.cmd('cd ' .. file_path)
		vim.cmd('!attrib -r \"' .. filename .. '\"')
	elseif sel == 'p4 edit' then
		vim.cmd('cd ' .. file_path)
		vim.cmd('!p4 edit \"' .. filename .. '\"')
	elseif sel == 'p4 add' then
		vim.cmd('cd ' .. file_path)
		vim.cmd('!p4 add \"' .. filename .. '\"')
	elseif sel == 'git add' then
		vim.cmd('cd ' .. file_path)
		vim.cmd('!git add -f \"' .. filename .. '\"')
	elseif sel == 'p4 all buffers add and edit' then
		vim.cmd('cd ' .. file_path)
		-- git add all opened files
		local filenames = GetAllBuffers()
		-- add files to git
		for _, fname in ipairs(filenames) do
			vim.cmd('!p4 add \"' .. fname .. '\"')
			vim.cmd('!p4 edit \"' .. fname .. '\"')
		end
	elseif sel == 'git add all buffer' then
		vim.cmd('cd ' .. file_path)
		-- git add all opened files
		local filenames = GetAllBuffers()
		-- add files to git
		for _, fname in ipairs(filenames) do
			vim.cmd('!git add -f \"' .. fname .. '\"')
		end
	elseif sel == 'git commit' then
		vim.cmd('cd ' .. file_path)
		GitCommit(filename)
	elseif sel == 'codelink tools' then
		CodeLinkMenu(filename, linenum)
	elseif sel == 'diff with buffer' then
		vim.cmd('cd ' .. file_path)
		DiffWithBuffer()
	elseif sel == 'qgrep search' then
		vim.cmd('QgrepSearch')
	elseif sel == 'qgrep files' then
		vim.cmd('QgrepFiles')
	elseif sel == 'quick zoekt search' then
		vim.cmd('ZoektSearch')
	elseif sel == 'zoekt prefix' then
		vim.cmd('ZoektSetQueryPrefix')
	elseif sel == 'quick zoekt lookup' then
		vim.cmd('ZoektSearch ' .. word)
	elseif sel == 'zoekt search' then
		vim.cmd('ZoektSearchBuffer')
	elseif sel == 'zoekt lookup' then
		vim.cmd('ZoektSearchBuffer ' .. word)
	elseif sel == 'zoekt close all buffers' then
		vim.cmd('ZoektCloseAll')
	elseif sel == 'install nerd font' then
		CheckAndInstallNerdFont()
	elseif sel == 'key bindings help' then
		ShowKeyBindings()
	elseif sel == 'tips and help' then
		ShowTips()
	end
end)
end
vim.keymap.set('n', nleader .. 'mm', function() UtilityMenu() end)
-- register UtilityMenu to Telescope
vim.api.nvim_create_user_command('MyMenu', UtilityMenu, {})

-- for tab indenting
local opts = { noremap = true, silent = true }
vim.keymap.set("n",	"<Tab>",		 ">>",  opts)
vim.keymap.set("n",	"<S-Tab>",	   "<<",  opts)
vim.keymap.set("v",	"<Tab>",		 ">gv", opts)
vim.keymap.set("v",	"<S-Tab>",	   "<gv", opts)

-- for C-BS
vim.keymap.set("i", "<C-BS>", "<C-W>")

-- switch between tabs
vim.keymap.set('n', '<C-Tab>', ':bnext<CR>')
vim.keymap.set('n', '<C-Pagedown>', ':bnext<CR>')
vim.keymap.set('n', '<C-Pageup>', ':bprevious<CR>')

-- Close all zoekt buffers
vim.api.nvim_create_user_command('ZoektCloseAll', function()
	local buffers = vim.api.nvim_list_bufs()
	local closed_count = 0
	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'filetype') == 'zoekt' then
			vim.api.nvim_buf_delete(buf, { force = true })
			closed_count = closed_count + 1
		end
	end
	print("Closed " .. closed_count .. " zoekt buffers.")
end, { desc = 'Close all zoekt buffers' })
