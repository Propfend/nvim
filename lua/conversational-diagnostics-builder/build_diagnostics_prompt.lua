local CONVERSATIONAL_DIAGNOSTICS_ASSISTANT_PROMPT =
    [[Compile an array of diagnostics in the LSP format. If the user does no specify the diagnostic severity level, it must default to warning (code 2). Following is the json schema, the response must follow this format: ]]

local function build_diagnostics_prompt()
    local user_prompt = vim.g.none_ls_diagnostics_user_prompt

    return CONVERSATIONAL_DIAGNOSTICS_ASSISTANT_PROMPT .. user_prompt
end

return build_diagnostics_prompt
