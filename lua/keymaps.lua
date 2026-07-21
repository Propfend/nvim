vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })

vim.opt.virtualedit = "onemore"

vim.keymap.set("i", "<Esc>", "<Esc>l", { desc = "Exit insert mode without moving left" })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<C-Tab>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
    desc = 'Accept Copilot suggestion',
})

vim.keymap.set({ 'i', 'n' }, '<leader>q', function()
    local pattern = vim.fn.getreg '/'
    if pattern == '' then
        vim.notify('No active search pattern', vim.log.levels.WARN)
        return
    end

    local replacement = vim.fn.input("Replace '" .. pattern .. "' with: ")
    if replacement == '' then
        return
    end

    local escaped_repl = vim.fn.escape(replacement, '\\/')

    vim.cmd(':%s/' .. pattern .. '/' .. escaped_repl .. '/g')
end)

vim.keymap.set({ 'n', 'v' }, 'cc', ':CopilotChatFix<CR>', { desc = 'Fix the selected codeblock using Copilot' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '[E]xpand diagnostic message' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local function move_terminal_cursor(motion, escape_sequence)
    return function()
        vim.cmd('normal! ' .. motion)
        if vim.fn.line '.' == vim.fn.line '$' then
            vim.fn.chansend(vim.b.terminal_job_id, escape_sequence)
        end
    end
end

vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'Start terminal buffers in Normal mode, so insert mode requires pressing i',
    group = vim.api.nvim_create_augroup('terminal-normal-mode', { clear = true }),
    callback = function(args)
        vim.cmd 'stopinsert'
        vim.keymap.set('n', 'j', move_terminal_cursor('h', '\27[D'), {
            buffer = args.buf,
            desc = 'Move cursor left, keeping the live shell cursor in sync',
        })
        vim.keymap.set('n', '<Char-231>', move_terminal_cursor('l', '\27[C'), {
            buffer = args.buf,
            desc = 'Move cursor right, keeping the live shell cursor in sync',
        })
    end,
})

vim.keymap.set({ 'n', 'v' }, ',', '<Cmd>BufferPrevious<CR>', { desc = 'Switch to previous window' })
vim.keymap.set({ 'n', 'v' }, '.', '<Cmd>BufferNext<CR>', { desc = 'Switch to next window' })
vim.keymap.set({ 'n', 'v' }, 'q', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })

local function is_floating_window()
    local win_config = vim.api.nvim_win_get_config(0)

    return win_config.relative ~= ''
end

local function close_floating_windows()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local win_config = vim.api.nvim_win_get_config(win)
        if win_config.relative ~= '' then
            pcall(vim.api.nvim_win_close, win, true)
        end
    end
end

local function find_source_lsp_client()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local win_config = vim.api.nvim_win_get_config(win)
        if win_config.relative == '' then
            local buf = vim.api.nvim_win_get_buf(win)
            local clients = vim.lsp.get_clients { bufnr = buf }

            for _, client in ipairs(clients) do
                if client:supports_method 'workspace/symbol' then
                    return client, buf
                end
            end
        end
    end

    return nil, nil
end

local function resolve_symbol_location(word, callback)
    local client, source_buf = find_source_lsp_client()
    if not client then
        return
    end

    client:request('workspace/symbol', { query = word }, function(err, result)
        if err or not result or #result == 0 then
            return
        end

        local exact_match = nil

        for _, symbol in ipairs(result) do
            if symbol.name == word then
                exact_match = symbol
                break
            end
        end

        local selected = exact_match or result[1]
        if selected and selected.location then
            callback(client, selected.location)
        end
    end, source_buf)
end

vim.keymap.set('n', 'K', function()
    if not is_floating_window() then
        vim.lsp.buf.hover { border = 'rounded' }

        return
    end

    local word = vim.fn.expand '<cword>'
    if word == '' then
        return
    end

    resolve_symbol_location(word, function(client, location)
        local target_bufnr = vim.uri_to_bufnr(location.uri)
        vim.fn.bufload(target_bufnr)

        client:request('textDocument/hover', {
            textDocument = { uri = location.uri },
            position = location.range.start,
        }, function(hover_err, hover_result)
            if hover_err or not hover_result then
                return
            end

            vim.schedule(function()
                close_floating_windows()

                local contents = vim.lsp.util.convert_input_to_markdown_lines(hover_result.contents)
                vim.lsp.util.open_floating_preview(contents, 'markdown', {
                    border = 'rounded',
                    focus_id = 'textDocument/hover',
                    focus = true,
                })
            end)
        end, target_bufnr)
    end)
end)

vim.keymap.set('n', 'gdf', '<Cmd>Gdiffsplit<CR>')

vim.keymap.set('n', 'dg', '<Cmd>diffget<CR>')

vim.keymap.set('n', 'dp', '<Cmd>diffput<CR>')

vim.keymap.set({ 'n', 'v' }, 'j', '<Left>')
vim.keymap.set({ 'n', 'v' }, 'k', '<Up>')
vim.keymap.set({ 'n', 'v' }, 'l', '<Down>')
vim.keymap.set({ 'n', 'v' }, '<Char-231>', '<Right>')

vim.keymap.set('n', '<leader>k', function()
    require('treesitter-context').go_to_context(vim.v.count1)
end, { silent = true })

vim.keymap.set('n', 'gd', function()
    if not is_floating_window() then
        vim.lsp.buf.definition()

        return
    end

    local word = vim.fn.expand '<cword>'
    if word == '' then
        return
    end

    resolve_symbol_location(word, function(_, location)
        vim.schedule(function()
            close_floating_windows()
            vim.lsp.util.show_document_with({ focus = true }, location, 'utf-8', false)
        end)
    end)
end, { silent = true })

vim.keymap.set('n', 'gr', function()
    if not is_floating_window() then
        vim.lsp.buf.references()

        return
    end

    local word = vim.fn.expand '<cword>'
    if word == '' then
        return
    end

    resolve_symbol_location(word, function(_, location)
        vim.schedule(function()
            close_floating_windows()
            vim.lsp.util.jump_to_location(location, 'utf-8', false)
            vim.lsp.buf.references()
        end)
    end)
end, { silent = true })

vim.keymap.set('n', 'h', '<Nop>')

vim.keymap.set('v', '<leader>w', function()
    local tag = vim.fn.input 'HTML tag: '
    if tag == '' then
        return
    end
    vim.cmd('normal! `>a</' .. tag .. '>\27`<i<' .. tag .. '>\27')
end, { desc = 'Wrap selection in HTML tag' })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
--
-- -- Firenvim
if vim.g.started_by_firenvim == true then
    vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*',
        callback = function()
            vim.fn.timer_start(15, function()
                vim.cmd 'startinsert'
            end)
        end,
    })
end

vim.g.firenvim_config = {
    globalSettings = { alt = "all" },
    localSettings = {
        [".*"] = {
            cmdline  = "neovim",
            content  = "text",
            priority = 0,
            selector = "textarea, input",
            takeover = "always"
        }
    }
}
