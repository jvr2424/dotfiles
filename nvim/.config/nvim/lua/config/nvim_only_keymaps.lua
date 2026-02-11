-- keybinds.lua
-- Function to add visual selection to quickfix list
local function add_selection_to_qf()
    -- Get the visual selection range
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line = start_pos[2]
    local end_line = end_pos[2]

    -- Get current buffer info
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)

    -- Get the selected text
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
    local text = table.concat(lines, "\n")

    -- Get current quickfix list
    local qf_list = vim.fn.getqflist()

    -- Add new entry
    table.insert(qf_list, {
        bufnr = bufnr,
        filename = filename,
        lnum = start_line,
        end_lnum = end_line,
        col = start_pos[3],
        text = text,
        type = "I",
    })

    -- Update quickfix list
    vim.fn.setqflist(qf_list, "r")

    print(string.format("Added %d line(s) to quickfix", end_line - start_line + 1))
end

-- Function to copy all quickfix entries' text to clipboard
local function copy_qf_contents()
    local qf_list = vim.fn.getqflist()

    if #qf_list == 0 then
        print("Quickfix list is empty")
        return
    end

    local contents = {}
    for _, item in ipairs(qf_list) do
        table.insert(contents, item.text)
    end

    local text = table.concat(contents, "\n")

    -- Copy to system clipboard (+ register) and unnamed register
    vim.fn.setreg("+", text)
    vim.fn.setreg('"', text)

    print(string.format("Copied %d quickfix entries to clipboard", #qf_list))
end

-- Function to paste quickfix contents at cursor
local function paste_qf_contents()
    local qf_list = vim.fn.getqflist()

    if #qf_list == 0 then
        print("Quickfix list is empty")
        return
    end

    local contents = {}
    for _, item in ipairs(qf_list) do
        -- Split multi-line text into separate lines
        local text = item.text or ""
        for line in text:gmatch("[^\r\n]+") do
            table.insert(contents, line)
        end
    end

    -- Get cursor position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- Insert the text at cursor position
    vim.api.nvim_buf_set_lines(0, row, row, false, contents)

    print(string.format("Pasted %d quickfix entries", #qf_list))
end

-- Function to clear quickfix list
local function clear_qf()
    vim.fn.setqflist({}, "r")
    print("Cleared quickfix list")
end

-- Function to safely go to next quickfix item
local function qf_next()
    local qf_list = vim.fn.getqflist()
    if #qf_list == 0 then
        print("Quickfix list is empty")
        return
    end

    local ok, err = pcall(vim.cmd, "cnext")
    if not ok then
        -- Wrap around to first item
        vim.cmd("cfirst")
        print("Wrapped to first quickfix item")
    end
end

-- Function to safely go to previous quickfix item
local function qf_prev()
    local qf_list = vim.fn.getqflist()
    if #qf_list == 0 then
        print("Quickfix list is empty")
        return
    end

    local ok, err = pcall(vim.cmd, "cprev")
    if not ok then
        -- Wrap around to last item
        vim.cmd("clast")
        print("Wrapped to last quickfix item")
    end
end

-- Keybindings
local opts = { noremap = true, silent = true }

-- Visual mode: Add selection to quickfix (Leader + qa)
vim.keymap.set("v", "<leader>qa", function()
    add_selection_to_qf()
    -- Return to normal mode
    -- vim.cmd("normal! ")
end, vim.tbl_extend("force", opts, { desc = "Add selection to quickfix" }))

-- Normal mode: Open quickfix window (Leader + qo)
vim.keymap.set("n", "<leader>qo", ":copen<CR>", vim.tbl_extend("force", opts, { desc = "Open quickfix window" }))

-- Normal mode: Close quickfix window (Leader + qc)
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", vim.tbl_extend("force", opts, { desc = "Close quickfix window" }))

-- Normal mode: Copy all quickfix contents to clipboard (Leader + qy)
vim.keymap.set("n", "<leader>qy", copy_qf_contents, vim.tbl_extend("force", opts, { desc = "Copy quickfix contents" }))

-- Normal mode: Paste quickfix contents at cursor (Leader + qp)
vim.keymap.set(
    "n",
    "<leader>qp",
    paste_qf_contents,
    vim.tbl_extend("force", opts, { desc = "Paste quickfix contents" })
)

-- Normal mode: Clear quickfix list (Leader + qx)
vim.keymap.set("n", "<leader>qx", clear_qf, vim.tbl_extend("force", opts, { desc = "Clear quickfix list" }))

-- Normal mode: Next quickfix item (Leader + qj)
vim.keymap.set("n", "<leader>qj", qf_next, vim.tbl_extend("force", opts, { desc = "Next quickfix item" }))

-- Normal mode: Previous quickfix item (Leader + qk)
vim.keymap.set("n", "<leader>qk", qf_prev, vim.tbl_extend("force", opts, { desc = "Previous quickfix item" }))

-- Optional: Toggle quickfix window (Leader + qq)
vim.keymap.set("n", "<leader>qq", function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_exists = true
            break
        end
    end

    if qf_exists then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end, vim.tbl_extend("force", opts, { desc = "Toggle quickfix window" }))

print("Quickfix keybinds loaded!")
