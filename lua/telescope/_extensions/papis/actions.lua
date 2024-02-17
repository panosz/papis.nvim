--
-- PAPIS | TELESCOPE | ACTIONS
--
--
-- With some code from: https://github.com/nvim-telescope/telescope-bibtex.nvim

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local utils = require("papis.utils")

local M = {}

---This function inserts a formatted reference string at the cursor
---@param format_string string @The string to be inserted
---@return function
M.ref_insert = function(format_string)
  return function(prompt_bufnr)
    local entry = string.format(format_string, action_state.get_selected_entry().id.ref)
    actions.close(prompt_bufnr)
    vim.api.nvim_put({ entry }, "", false, true)
  end
end

local insert_format = {
      { "author", "%s ", "" },
      { "title", '"%s"', "" },
      { "journal", "%s", "" },
      { "volume", 'vol. %s', "" },
      { "year", "(%s) ", "" },
    }

M.ref_insert_formatted = function()
  return function(prompt_bufnr)
    actions.close(prompt_bufnr)
    local entry_id = action_state.get_selected_entry().id
    local clean_format = utils.do_clean_format_tbl(insert_format, entry_id)
    local output_fields = {}
    for _, field in ipairs(utils:format_display_strings(entry_id, clean_format)) do
    table.insert(output_fields, field[1])
    end
    local output = table.concat(output_fields, ", ")

    vim.api.nvim_put({output}, "", false, true)
  end
end

---This function opens the files attached to the current entry
---@return function
M.open_file = function()
  return function(prompt_bufnr)
    local papis_id = action_state.get_selected_entry().id.papis_id
    actions.close(prompt_bufnr)
    utils:do_open_attached_files(papis_id)
  end
end

---This function opens the note attached to the current entry
---@return function
M.open_note = function()
  return function(prompt_bufnr)
    local papis_id = action_state.get_selected_entry().id.papis_id
    actions.close(prompt_bufnr)
    utils:do_open_text_file(papis_id, "note")
  end
end

---This function opens the info_file containing this entry's information
---@return function
M.open_info = function()
  return function(prompt_bufnr)
    local papis_id = action_state.get_selected_entry().id.papis_id
    actions.close(prompt_bufnr)
    utils:do_open_text_file(papis_id, "info")
  end
end

return M
