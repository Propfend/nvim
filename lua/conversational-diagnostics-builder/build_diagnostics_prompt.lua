local CONVERSATIONAL_DIAGNOSTICS_ASSISTANT_PROMPT = [[Compile an array of diagnostics for the document in the next message.

Respond with one JSON object and nothing else. No prose, no explanation, no markdown code fences.

The object must have exactly one key, "diagnostics", holding an array. Each element must have exactly these six keys:
  row, col, end_row, end_col - 1-based integers, end_col exclusive
  message                    - string
  severity                   - integer, 1 error, 2 warning, 3 information, 4 hint

If the user does not specify the diagnostic severity level, it must default to warning (code 2).

Do not emit LSP range objects with line and character keys. Do not emit a bare array. The top level must be the object described above.

Following is the json schema, the response must follow this format: ]]

local function build_diagnostics_prompt(assistant_prompt, user_prompt)
    return assistant_prompt .. '\n\nThe response diagnostics must follow this logic: ' .. user_prompt
end

if describe then
    describe('build_diagnostics_prompt', function()
        local assistant_prompt = 'Compile an array of diagnostics for the document in the next message.'
        local user_prompt = 'Flag every occurrence of the word I with warning severity.'

        it('joins the assistant prompt and the user prompt with the logic sentence', function()
            assert.equals(
                assistant_prompt .. '\n\nThe response diagnostics must follow this logic: ' .. user_prompt,
                build_diagnostics_prompt(assistant_prompt, user_prompt)
            )
        end)

        it('keeps the assistant prompt at the start so the cached prefix stays stable', function()
            assert.equals(assistant_prompt, build_diagnostics_prompt(assistant_prompt, user_prompt):sub(1, #assistant_prompt))
        end)

        it('places the user prompt at the end', function()
            assert.equals(user_prompt, build_diagnostics_prompt(assistant_prompt, user_prompt):sub(-#user_prompt))
        end)
    end)
end

return {
    build_diagnostics_prompt = build_diagnostics_prompt,
    CONVERSATIONAL_DIAGNOSTICS_ASSISTANT_PROMPT = CONVERSATIONAL_DIAGNOSTICS_ASSISTANT_PROMPT,
}
