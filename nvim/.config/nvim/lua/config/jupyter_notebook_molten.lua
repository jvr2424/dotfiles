-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
--
            { import = "config.jupyter_notebook" },
    -- ##########################################
    vim.g.python3_host_prog = vim.fn.expand("~/.virtualvenvs/neovim/bin/python3")
    -- jupyter_notebook setup
    -- automatically import output chunks from a jupyter notebook
    -- tries to find a kernel that matches the kernel in the jupyter notebook
    -- falls back to a kernel that matches the name of the active venv (if any)
    local imb = function(e) -- init molten buffer
        vim.schedule(function()
            local kernels = vim.fn.MoltenAvailableKernels()
            local try_kernel_name = function()
                local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
                return metadata.kernelspec.name
            end
            local ok, kernel_name = pcall(try_kernel_name)
            if not ok or not vim.tbl_contains(kernels, kernel_name) then
                kernel_name = nil
                local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
                print(venv)
                if venv ~= nil then
                    kernel_name = string.match(venv, "/.+/(.+)")
                    print(kernel_name)
                end
            end
            if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
                vim.cmd(("MoltenInit %s"):format(kernel_name))
            end
            -- local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            -- if venv ~= nil then
            --     -- vim.g.python3_host_prog = vim.fn.expand("~/.virtualvenvs/neovim/bin/python3")
            --     vim.g.python3_host_prog = venv .. "/bin/python"
            --
            --     -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
            --     venv = string.match(venv, "/.+/(.+)")
            --     vim.cmd(("MoltenInit %s"):format(venv))
            -- else
            --     vim.cmd("MoltenInit python3")
            -- end
            vim.cmd("MoltenImportOutput")
        end)
    end

    -- automatically import output chunks from a jupyter notebook
    vim.api.nvim_create_autocmd("BufAdd", {
        pattern = { "*.ipynb" },
        callback = imb,
    })

    -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.ipynb" },
        callback = function(e)
            if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
                imb(e)
            end
        end,
    })
    -- automatically export output chunks to a jupyter notebook on write
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.ipynb" },
        callback = function()
            if require("molten.status").initialized() == "Molten" then
                vim.cmd("MoltenExportOutput!")
            end
        end,
    })


    -- ##########################################
return {
    {
        "benlubas/molten-nvim", --"dubrayn/molten-nvim", -- fork of "benlubas/molten-nvim" - REPL
        version = "^1.0.0",
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_auto_init_behavior = "init"
            vim.g.molten_enter_output_behavior = "open_and_enter"
            vim.g.molten_auto_image_popup = false
            vim.g.molten_auto_open_output = false
            vim.g.molten_output_crop_border = false
            vim.g.molten_output_virt_lines = true
            vim.g.molten_output_win_max_height = 50
            vim.g.molten_output_win_style = "minimal"
            vim.g.molten_output_win_hide_on_leave = false
            vim.g.molten_virt_text_output = true
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_max_lines = 10000
            vim.g.molten_cover_empty_lines = false
            vim.g.molten_copy_output = true
            vim.g.molten_output_show_exec_time = false

            vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
                { desc = "evaluate operator", silent = true })
            vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>",
                { desc = "open output window", silent = true })
            vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
            vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
                { desc = "execute visual selection", silent = true })
            vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>",
                { desc = "close output window", silent = true })
            vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })

            -- if you work with html outputs:
            vim.keymap.set("n", "<localleader>mx", ":MoltenOpenInBrowser<CR>",
                { desc = "open output in browser", silent = true })


            --
        end,
    },
    {
        'quarto-dev/quarto-nvim',
        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        ft = { "quarto", "markdown" },
        init = function()
            local runner = require("quarto.runner")
            vim.keymap.set("n", "<C-Enter>", runner.run_cell, { desc = "run cell", silent = true })
            vim.keymap.set("n", "<leader>ja", runner.run_above, { desc = "run cell and above", silent = true })
            vim.keymap.set("n", "<leader>jA", runner.run_all, { desc = "run all cells", silent = true })
            vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
            vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
            vim.keymap.set("n", "<localleader>RA", function()
                runner.run_all(true)
            end, { desc = "run all cells of all languages", silent = true })
        end,
        opts = {
            debug = false,
            closePreviewOnExit = true,
            lspFeatures = {
                enabled = true,
                chunks = "curly",
                languages = { "python", },
                diagnostics = {
                    enabled = true,
                    triggers = { "BufWritePost" },
                },
                completion = {
                    enabled = true,
                },
            },
            keymap = {
                -- NOTE: setup your own keymaps:
                hover = "gh",
                definition = "gd",
                rename = "<leader>rn",
                references = "gH",
                format = "<leader>gf",
            },
            codeRunner = {
                enabled = true,
                default_method = 'molten',          -- 'molten' or 'slime'
                ft_runners = { python = 'molten' }, -- filetype to runner, ie. `{ python = "molten" }`.
                -- Takes precedence over `default_method`
                never_run = { "yaml" },             -- filetypes which are never sent to a code runner
            },
        },
    },
    {
        "GCBallesteros/jupytext.nvim",
        config = true,
        init = function()
            require("jupytext").setup({
                style = "markdown",
                output_extension = "md",
                force_ft = "markdown",
            })
        end
        -- Depending on your nvim distro or config you may need to make the loading not lazy
        -- lazy=false,
    },
}
