local M = {}

function M.new() 
    return setmetatable({}, { __index = M }) 
end

function M:get_trigger_characters() 
    return {} 
end

function M:get_completions(context, callback)
    local items = {}
    local kind_file = 17 -- CompletionItemKind.File
    -- Try to get kind from blink if available, otherwise fallback to 17
    local ok, types = pcall(require, 'blink.cmp.types')
    if ok then kind_file = types.CompletionItemKind.File end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
            local name = vim.api.nvim_buf_get_name(buf)
            if name ~= "" then
                local basename = vim.fn.fnamemodify(name, ":t")
                table.insert(items, {
                    label = basename,
                    kind = kind_file,
                    detail = name,
                    insertText = basename,
                })
            end
        end
    end
    callback({
        is_incomplete_forward = false,
        is_incomplete_backward = false,
        items = items
    })
    return function() end
end

return M
