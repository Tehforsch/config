return function(config)
	local default_root_dir = vim.lsp.config.rust_analyzer.root_dir
	local command = config.cmd
	local settings_file = "src/etc/rust_analyzer_zed.json"

	config.root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, function(name, path)
			return name == "src" and vim.uv.fs_stat(vim.fs.joinpath(path, settings_file)) ~= nil
		end)
		if root then
			on_dir(root)
		else
			default_root_dir(bufnr, on_dir)
		end
	end

	config.cmd = function(dispatchers, client_config)
		local root = client_config.root_dir
		local path = root and vim.fs.joinpath(root, settings_file)
		if path and vim.uv.fs_stat(path) then
			local content = table.concat(vim.fn.readfile(path), "\n")
			local settings = vim.json.decode(content, { skip_comments = true }).lsp["rust-analyzer"].initialization_options
			local version = vim.trim(vim.fn.readfile(vim.fs.joinpath(root, "src/version"))[1])
			settings.cargo.extraEnv.CFG_RELEASE = vim.env.CFG_RELEASE or (version .. "-dev")
			local env = vim.tbl_extend("force", client_config.cmd_env or {}, settings.cargo.extraEnv)
			for key, value in pairs(settings.server.extraEnv) do
				env[key] = vim.fs.joinpath(root, value)
			end
			settings.server = nil

			if vim.env.NIX_LD_LIBRARY_PATH then
				env.LD_LIBRARY_PATH = table.concat({
					env.LD_LIBRARY_PATH or vim.env.LD_LIBRARY_PATH or "",
					vim.env.NIX_LD_LIBRARY_PATH,
				}, ":")
			end

			settings.procMacro.server = vim.fs.joinpath(root, settings.procMacro.server)
			settings.rustfmt.overrideCommand[1] = vim.fs.joinpath(root, settings.rustfmt.overrideCommand[1])
			local bootstrap = vim.env.IN_NIX_SHELL and vim.fn.exepath("x") or ""
			for _, override in ipairs({ settings.check.overrideCommand, settings.cargo.buildScripts.overrideCommand }) do
				override[1] = bootstrap ~= "" and bootstrap or vim.fs.joinpath(root, "x")
				table.remove(override, 2)
			end

			client_config.settings["rust-analyzer"].cargo.targetDir = nil
			client_config.settings["rust-analyzer"] = vim.tbl_deep_extend("force", client_config.settings["rust-analyzer"], settings)
			client_config.cmd_env = env
			client_config.cmd_cwd = root
		end

		return vim.lsp.rpc.start(command, dispatchers, {
			cwd = client_config.cmd_cwd,
			env = client_config.cmd_env,
			detached = client_config.detached,
		})
	end

	return config
end
