return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"nvimtools/hydra.nvim",
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local rust_analyzer_features = {}
		local rust_analyzer_config

		local function delete_default_lsp_keymap(mode, lhs)
			pcall(vim.keymap.del, mode, lhs, { buffer = false })
		end

		delete_default_lsp_keymap("n", "grr")
		delete_default_lsp_keymap("n", "gra")
		delete_default_lsp_keymap("n", "grn")
		delete_default_lsp_keymap("n", "gri")
		delete_default_lsp_keymap("n", "grt")
		delete_default_lsp_keymap("n", "grx")
		delete_default_lsp_keymap("x", "gra")

		local function get_rust_analyzer_clients()
			if vim.lsp.get_clients then
				return vim.lsp.get_clients({ name = "rust_analyzer" })
			end
			return vim.lsp.get_active_clients({ name = "rust_analyzer" })
		end

		local function get_rust_project_root(bufnr)
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local start = bufname ~= "" and bufname or vim.fn.getcwd()

			if vim.fs and vim.fs.root then
				local cargo_root = vim.fs.root(start, { "Cargo.toml" })
				if cargo_root then
					return cargo_root
				end
			end

			for _, client in ipairs(get_rust_analyzer_clients()) do
				if client.config and client.config.root_dir and vim.lsp.buf_is_attached(bufnr, client.id) then
					return client.config.root_dir
				end
			end

			return vim.fn.getcwd()
		end

		local function is_rust_feature_enabled(feature)
			return vim.tbl_contains(rust_analyzer_features, feature)
		end

		local function apply_rust_analyzer_features()
			local settings = rust_analyzer_config.settings["rust-analyzer"]
			settings.cargo.features = vim.deepcopy(rust_analyzer_features)
			settings.check.features = vim.deepcopy(rust_analyzer_features)
			vim.lsp.config.rust_analyzer = rust_analyzer_config
		end

		local function restart_rust_analyzer()
			if vim.lsp.enable then
				pcall(vim.lsp.enable, "rust_analyzer", false)
				vim.defer_fn(function()
					pcall(vim.lsp.enable, "rust_analyzer", true)
				end, 100)
				return
			end

			if vim.fn.exists(":LspRestart") == 2 then
				pcall(vim.cmd, "LspRestart rust_analyzer")
				return
			end

			for _, client in ipairs(get_rust_analyzer_clients()) do
				client.stop()
			end
		end

		local function toggle_rust_feature(feature)
			feature = vim.trim(feature or "")
			if feature == "" then
				return
			end

			local enabled = is_rust_feature_enabled(feature)
			if enabled then
				rust_analyzer_features = vim.tbl_filter(function(current)
					return current ~= feature
				end, rust_analyzer_features)
			else
				table.insert(rust_analyzer_features, feature)
				table.sort(rust_analyzer_features)
			end

			apply_rust_analyzer_features()
			restart_rust_analyzer()

			local active = #rust_analyzer_features > 0 and table.concat(rust_analyzer_features, ", ") or "none"
			local action = enabled and "Disabled" or "Enabled"
			vim.notify(("%s rust-analyzer Cargo feature `%s`; active: %s"):format(action, feature, active), vim.log.levels.INFO)
		end

		local function prompt_for_rust_feature()
			vim.ui.input({ prompt = "Cargo feature: " }, function(input)
				if input then
					toggle_rust_feature(input)
				end
			end)
		end

		local function load_rust_features(callback)
			if not vim.system then
				callback(nil, "vim.system is unavailable")
				return
			end

			local root = get_rust_project_root(0)
			vim.system({ "cargo", "metadata", "--no-deps", "--format-version", "1" }, { cwd = root, text = true }, function(result)
				vim.schedule(function()
					if result.code ~= 0 then
						local stderr = result.stderr or ""
						local stdout = result.stdout or ""
						callback(nil, vim.trim(stderr ~= "" and stderr or stdout))
						return
					end

					local ok, metadata = pcall(vim.json.decode, result.stdout or "")
					if not ok then
						callback(nil, "Could not parse cargo metadata")
						return
					end

					local workspace_members = {}
					for _, id in ipairs(metadata.workspace_members or {}) do
						workspace_members[id] = true
					end

					local workspace_count = vim.tbl_count(workspace_members)
					local features_by_name = {}
					for _, package in ipairs(metadata.packages or {}) do
						if workspace_members[package.id] then
							for feature in pairs(package.features or {}) do
								local name = workspace_count > 1 and (package.name .. "/" .. feature) or feature
								features_by_name[name] = true
							end
						end
					end

					local features = vim.tbl_keys(features_by_name)
					table.sort(features)
					callback(features)
				end)
			end)
		end

		local function pick_rust_feature()
			load_rust_features(function(features, err)
				if not features or vim.tbl_isempty(features) then
					if err then
						vim.notify("Could not load Cargo features: " .. err, vim.log.levels.WARN)
					else
						vim.notify("No Cargo features found in this workspace", vim.log.levels.INFO)
					end
					prompt_for_rust_feature()
					return
				end

				Snacks.picker.pick({
					title = "Cargo features",
					format = "text",
					layout = "select",
					items = vim.tbl_map(function(feature)
						return {
							text = (is_rust_feature_enabled(feature) and "[x] " or "[ ] ") .. feature,
							value = feature,
						}
					end, features),
					confirm = function(picker, item)
						picker:close()
						if item then
							toggle_rust_feature(item.value)
						end
					end,
				})
			end)
		end

		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }

			vim.keymap.set("n", "gd", function()
				Snacks.picker.lsp_definitions()
			end, opts)
			vim.keymap.set("n", "gr", function()
				Snacks.picker.lsp_references()
			end, vim.tbl_extend("force", opts, { nowait = true }))
			vim.keymap.set("n", "gtt", function()
				Snacks.picker.lsp_type_definitions()
			end, opts)
			vim.keymap.set("n", "gti", function()
				Snacks.picker.lsp_implementations()
			end, opts)
			vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
			vim.keymap.set({ "n", "v" }, "<localleader>x", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

			if vim.bo[bufnr].filetype == "rust" then
				vim.keymap.set("n", "<localleader>p", function()
					vim.lsp.buf_request(bufnr, "experimental/parentModule", vim.lsp.util.make_position_params(0, client.offset_encoding), function(_, result)
						if not result or vim.tbl_isempty(result) then
							vim.notify("No parent module found", vim.log.levels.INFO)
							return
						end
						vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
					end)
				end, vim.tbl_extend("force", opts, { desc = "Go to parent module" }))
				vim.keymap.set("n", "<localleader>lf", pick_rust_feature, vim.tbl_extend("force", opts, { desc = "Toggle Cargo feature" }))
			end
		end

		vim.keymap.set("n", "<localleader>el", function()
			Snacks.picker.diagnostics()
		end, { desc = "List diagnostics" })

		local Hydra = require("hydra")
		Hydra({
			name = "Diagnostics",
			mode = "n",
			body = "<localleader>e",
			heads = {
				{
					"n",
					function()
						vim.diagnostic.goto_next()
					end,
					{ desc = "next diagnostic" },
				},
				{
					"p",
					function()
						vim.diagnostic.goto_prev()
					end,
					{ desc = "prev diagnostic" },
				},
				{
					"l",
					function()
						Snacks.picker.diagnostics()
					end,
					{ exit = true, desc = "list diagnostics" },
				},
				{ "q", nil, { exit = true, desc = "quit" } },
				{ "<Esc>", nil, { exit = true, desc = "quit" } },
			},
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.diagnostic.config({
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "✘",
					[vim.diagnostic.severity.WARN] = "▲",
					[vim.diagnostic.severity.HINT] = "⚑",
					[vim.diagnostic.severity.INFO] = "»",
				},
			},
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		vim.keymap.set("n", "<localleader>es", function()
			vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
		end, { desc = "Show diagnostic" })

		vim.lsp.config("*", {
			root_markers = { ".git" },
			capabilities = capabilities,
			on_attach = on_attach,
		})

		rust_analyzer_config = {
			cmd = { "rust-analyzer" },
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						targetDir = "target/ra",
					},
					check = {
						command = "clippy",
					},
				},
			},
		}
		vim.lsp.config.rust_analyzer = rust_analyzer_config
		vim.lsp.enable("rust_analyzer")

		vim.api.nvim_create_user_command("RustToggleFeature", function(command)
			if command.args ~= "" then
				toggle_rust_feature(command.args)
				return
			end
			pick_rust_feature()
		end, { nargs = "?", desc = "Toggle a rust-analyzer Cargo feature" })

		vim.lsp.enable("pyright")

		vim.lsp.enable("clangd")

		vim.lsp.enable("nil_ls")

		vim.lsp.enable("hls")

		vim.lsp.enable("lua_ls")
		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		}

		vim.lsp.enable("leanls")
		vim.lsp.config.leanls = {
			cmd = { "lean", "--server" },
			filetypes = { "lean" },
			root_markers = { "lakefile.lean", "lean-toolchain", "leanpkg.toml", ".git" },
			capabilities = capabilities,
			on_attach = on_attach,
		}
	end,
}
