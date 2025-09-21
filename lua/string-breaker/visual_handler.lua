local M = {}

-- Get visual selection text and position information
-- @return table|nil Visual selection information or nil if no selection
function M.get_visual_selection()
  local function compare_positions(pos1, pos2)
    -- Compare by line first, and by column second
    if pos1[2] < pos2[2] or (pos1[2] == pos2[2] and pos1[3] < pos2[3]) then
      return true
    else
      return false
    end
  end


  -- Check if currently in visual mode
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then -- \22 is Ctrl-V
    return nil
  end

  local visual_pos = vim.fn.getpos('v')
  local cursor_pos = vim.fn.getpos('.')

  local start_pos, end_pos

  -- Compare and assign
  if compare_positions(visual_pos, cursor_pos) then
    start_pos, end_pos = visual_pos, cursor_pos
  else
    start_pos, end_pos = cursor_pos, visual_pos
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local start_row = start_pos[2] - 1 -- Convert to 0-based
  local start_col = start_pos[3] - 1
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3]

  -- Validate line number range
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if start_row >= line_count or end_row >= line_count or start_row < 0 or end_row < 0 then
    return nil
  end

  -- Get selected text
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
  if not lines or #lines == 0 then
    return nil
  end

  local content = ""
  if #lines == 1 then
    -- Single line selection
    local line = lines[1] or ""
    if start_col >= #line then
      return nil
    end
    -- For character visual mode, end_col needs adjustment
    if mode == 'v' then
      end_col = math.min(end_col, #line)
    else
      end_col = #line
    end
    content = string.sub(line, start_col + 1, end_col)
  else
    -- Multi-line selection
    for i, line in ipairs(lines) do
      if i == 1 then
        -- First line: from start_col to end of line
        if start_col < #line then
          content = content .. string.sub(line, start_col + 1)
        end
      elseif i == #lines then
        -- Last line: from beginning of line to end_col
        if mode == 'v' then
          -- Character visual mode
          content = content .. "\n" .. string.sub(line, 1, math.min(end_col, #line))
        else
          -- Line visual mode or block visual mode
          content = content .. "\n" .. line
        end
      else
        -- Middle lines: complete lines
        content = content .. "\n" .. line
      end
    end
  end

  -- Validate content is not empty
  if not content or content == "" then
    return nil
  end

  return {
    content = content,
    start_pos = { start_row + 1, start_col }, -- Convert back to 1-based
    end_pos = { end_row + 1, end_col },       -- Adjust end_col
    mode = mode,
    bufnr = bufnr
  }
end

-- Validate if visual selection is valid
-- @param selection table Visual selection information
-- @return boolean Whether selection is valid
function M.validate_selection(selection)
  if not selection then
    return false
  end

  -- Check required fields
  if not selection.content or not selection.start_pos or not selection.end_pos or not selection.bufnr then
    return false
  end

  -- Check content is not empty
  if selection.content == "" then
    return false
  end

  -- Check position information is valid
  if not selection.start_pos[1] or not selection.start_pos[2] or
      not selection.end_pos[1] or not selection.end_pos[2] then
    return false
  end

  -- Check buffer is valid
  if not vim.api.nvim_buf_is_valid(selection.bufnr) then
    return false
  end

  return true
end

-- Detect quote type of selected content
-- @param content string Selected content
-- @return string Quote type
local function detect_quote_type(content)
  if not content or content == '' then
    return ''
  end

  -- Check if content is surrounded by quotes
  local first_char = string.sub(content, 1, 1)
  local last_char = string.sub(content, -1)

  -- If first and last characters are the same and are quotes, determine quote type
  if (first_char == '"' or first_char == "'" or first_char == '`') and
      last_char == first_char then
    return first_char
  end

  -- If content starts with quote but is not fully surrounded by quotes, try to detect quote type
  if first_char == '"' or first_char == "'" or first_char == '`' then
    return first_char
  end

  -- Default return empty string, indicating no quotes
  return ''
end

-- Extract content inside quotes
-- @param content string Complete content
-- @param quote_type string Quote type
-- @return string Content inside quotes
local function extract_inner_content(content, quote_type)
  if not content or content == '' or quote_type == '' then
    return content
  end

  -- If content is surrounded by quotes, extract inner content
  if #content >= 2 then
    local first_char = string.sub(content, 1, 1)
    local last_char = string.sub(content, -1)

    if first_char == quote_type and last_char == quote_type then
      return string.sub(content, 2, -2)
    end
  end

  return content
end

-- Convert visual selection to string information format
-- @param selection table Visual selection information
-- @return table String information format
function M.selection_to_string_info(selection)
  if not M.validate_selection(selection) then
    return nil
  end

  -- Detect quote type
  local quote_type = detect_quote_type(selection.content)
  local inner_content = extract_inner_content(selection.content, quote_type)

  return {
    content = selection.content,
    inner_content = inner_content,
    start_pos = selection.start_pos,
    end_pos = selection.end_pos,
    quote_type = quote_type,
    source_type = 'visual',
    mode_info = {
      visual_mode = selection.mode,
      bufnr = selection.bufnr
    }
  }
end

-- Get current visual selection and convert to string information
-- @return table|nil String information or nil
function M.get_current_visual_string_info()
  local selection = M.get_visual_selection()
  if not selection then
    return nil
  end

  return M.selection_to_string_info(selection)
end

-- Check if in visual mode
-- @return boolean Whether in visual mode
function M.is_visual_mode()
  local mode = vim.fn.mode()
  return mode == 'v' or mode == 'V' or mode == '\22'
end

return M
