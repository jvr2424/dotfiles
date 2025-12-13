_G.thousands_sep = function(separator)
    separator = separator or ","

    local line = vim.api.nvim_get_current_line()

    local reversed_line = string.reverse(line)

    local pattern = "(%d%d%d)"
    local with_separators = reversed_line:gsub(pattern, "%1" .. separator)

    if #line % 3 == 0 then
        with_separators = with_separators:sub(1, -2)
    end

    with_separators = string.reverse(with_separators)

    vim.api.nvim_set_current_line(with_separators)
end

_G.thousands_sep_comma = function()
    _G.thousands_sep(",")
end

_G.thousands_sep_underscore = function()
    _G.thousands_sep("_")
end

_G.wrap_in_fstring = function(add_equal)
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- retrieve the line and process the selected portion
    local line = vim.fn.getline(start_pos[2])
    local pre_selection = string.sub(line, 1, start_pos[3] - 1)
    local post_selection = string.sub(line, end_pos[3] + 1)

    local selected_text = string.sub(line, start_pos[3], end_pos[3])

    -- construct the f string
    local f_string
    if add_equal then
        f_string = 'f"{' .. selected_text .. '=}"'
    else
        f_string = 'f"{' .. selected_text .. '}"'
    end

    -- combine everything and replace the line
    local new_line = pre_selection .. f_string .. post_selection
    vim.fn.setline(start_pos[2], new_line)
end

_G.wrap_in_fstring_std = function()
    _G.wrap_in_fstring(false)
end

_G.wrap_in_fstring_equal = function()
    _G.wrap_in_fstring(true)
end

-- Function to execute selected text via DuckDB and store results in the d register
vim.api.nvim_create_user_command("ExecDuckDB", function()
    -- Get the selected text
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])

    -- Handle the case where only a portion of the first/last line is selected
    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
    else
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end

    local query = table.concat(lines, "\n")

    -- Create a temporary file for the DuckDB output
    local tmp_file = vim.fn.tempname()

    -- Execute DuckDB command
    local cmd = string.format('duckdb -csv -c "%s" > %s', query:gsub('"', '\\"'), tmp_file)
    vim.fn.system(cmd)

    -- Read the output and store in register d
    local output = vim.fn.readfile(tmp_file)
    vim.fn.setreg("d", table.concat(output, "\n"))

    -- Clean up
    vim.fn.delete(tmp_file)

    -- Notify the user
    vim.notify("DuckDB result stored in register 'd'", vim.log.levels.INFO)
end, { range = true })

vim.keymap.set("n", "<leader>gb", function()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\\n'")
    if vim.v.shell_error == 0 and branch ~= "" then
        vim.api.nvim_put({ branch }, "c", true, true)
    else
        print("Not in a git repository or no branch found")
    end
end, { desc = "Insert git branch name" })

vim.keymap.set("n", "<leader>fy", function()
    vim.ui.select({ "Filename", "Relative path", "Absolute path" }, { prompt = "Copy to clipboard:" }, function(choice)
        local result
        if choice == "Filename" then
            result = vim.fn.expand("%:t")
        elseif choice == "Relative path" then
            result = vim.fn.expand("%:.")
        elseif choice == "Absolute path" then
            result = vim.fn.expand("%:p")
        end
        if result then
            vim.fn.setreg("+", result)
            print("Copied: " .. result)
        end
    end)
end, { desc = "Copy file path (choose format)" })

-- Map <leader>xd in visual mode to the command
vim.api.nvim_set_keymap("v", "<leader>xd", ":ExecDuckDB<CR>", { noremap = true, silent = true })

-- Map the function to key combos
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>lua thousands_sep_comma()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>lua thousands_sep_underscore()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>f", ":lua wrap_in_fstring_std()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>F", ":lua wrap_in_fstring_equal()<CR>", { noremap = true, silent = true })

-- highlight and drag
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

--format file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
