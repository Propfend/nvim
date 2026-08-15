local selection_highlight_group = 'KittyScrollbackNvimVisual'

local function fit_paste_window_to_screen(paste_winopts)
    if paste_winopts.width < 1 then
        paste_winopts.col = 0
        paste_winopts.width = vim.o.columns - 1
    end

    return paste_winopts
end

local function reset_highlight(group_name)
    vim.api.nvim_set_hl(0, group_name, {})
end

local function show_kitty_background_through_neovim()
    reset_highlight('Normal')
    reset_highlight('NormalFloat')
    for group_name in pairs(vim.api.nvim_get_hl(0, {})) do
        if group_name:find('^KittyScrollbackNvim') and group_name ~= selection_highlight_group then
            reset_highlight(group_name)
        end
    end
end

return {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
        require('kitty-scrollback').setup({
            {
                paste_window = {
                    filetype = 'sh',
                    yank_register_enabled = false,
                    winopts_overrides = fit_paste_window_to_screen,
                },
                visual_selection_highlight_mode = 'kitty',
                callbacks = {
                    after_setup = show_kitty_background_through_neovim,
                    after_paste_window_ready = show_kitty_background_through_neovim,
                },
            },
        })
    end,
}
