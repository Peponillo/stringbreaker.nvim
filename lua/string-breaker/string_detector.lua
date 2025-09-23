local M = {}

-- Check if a node type represents a string node
-- @param node_type string: The type of the tree-sitter node
-- @return boolean: True if the node type represents a string
local function is_string_node_type(node_type)
  -- Common string node types across different languages
  local string_types = {
    'string',
    'string_literal',
    'interpreted_string_literal',
    'raw_string_literal',
    'quoted_string',
    'string_content',
    'string_fragment',
    'template_string',
    'template_literal',
    'string_value',
    'literal_string',
    'double_quoted_string',
    'single_quoted_string',
    'backtick_quoted_string'
  }

  for _, string_type in ipairs(string_types) do
    if node_type == string_type then
      return true
    end
  end

  return false
end

-- Check if Tree-sitter is available and properly configured
local function check_treesitter()
  -- Check if nvim-treesitter is available
  local ok, ts = pcall(require, 'nvim-treesitter')
  if not ok then
    vim.notify(
      'String Editor: nvim-treesitter plugin is required but not installed. Please install nvim-treesitter first.',
      vim.log.levels.ERROR)
    return false
  end

  -- Check if ts_utils is available
  local ts_ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
  if not ts_ok then
    vim.notify(
      'String Editor: nvim-treesitter.ts_utils is required but not available. Please ensure nvim-treesitter is properly configured.',
      vim.log.levels.ERROR)
    return false
  end

  -- Check if parser is available for current buffer
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

  if filetype == '' then
    vim.notify(
      'String Editor: No filetype detected for current buffer. Tree-sitter requires a valid filetype to parse strings.',
      vim.log.levels.WARN)
    return false
  end

  -- Try to get parser for current filetype
  local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, filetype)
  if not parser_ok or not parser then
    vim.notify(
      string.format(
        'String Editor: No Tree-sitter parser available for filetype "%s". Please install the parser or check your Tree-sitter configuration.',
        filetype), vim.log.levels.WARN)
    return false
  end

  return true
end

-- Get the Tree-sitter node at the current cursor position
-- @return TSNode|nil: The node at cursor position, or nil if not available
function M.get_node_at_cursor()
  -- Check if treesitter is available
  local has_ts, ts = pcall(require, 'nvim-treesitter.ts_utils')
  if not has_ts then
    return nil
  end

  -- Get the node at cursor position
  local node = ts.get_node_at_cursor()
  return node
end

-- Find the topmost string node from a given node (traverse up the tree to find the outermost string)
-- @param node TSNode: Starting node to search from
-- @return TSNode|nil: Topmost string node if found, nil otherwise
function M.find_string_node(node)
  if not node then
    return nil
  end

  local current = node
  local topmost_string_node = nil

  -- Traverse up the tree to find all string nodes and keep the topmost one
  while current do
    local node_type = current:type()

    -- Check if this is a string node type
    if is_string_node_type(node_type) then
      -- Keep track of this string node, but continue traversing up
      -- to find if there's a higher-level string node
      topmost_string_node = current
    end

    -- Move to parent node
    current = current:parent()
  end

  return topmost_string_node
end

-- Detect string at cursor position and return string information
-- @return table|nil: String information table or nil if no string found
function M.detect_string_at_cursor()
  -- Check if treesitter is available
  if not check_treesitter() then
    return {
      success = false,
      error_code = 'TREESITTER_UNAVAILABLE',
      message =
      'Normal mode requires Tree-sitter support. Please install nvim-treesitter or use visual mode to select text.',
      suggestions = {
        'Install and configure nvim-treesitter plugin',
        'Use visual mode to select text for editing',
        'Ensure current file type has corresponding Tree-sitter parser'
      }
    }
  end
  -- Get node at cursor
  local node = M.get_node_at_cursor()
  if not node then
    return nil
  end

  -- Find string node
  local string_node = M.find_string_node(node)
  if not string_node then
    vim.notify('No string node found', vim.log.levels.WARN)
    return nil
  end

  -- Get string content and position information
  local start_row, start_col, end_row, end_col = string_node:range()

  -- Validate the range
  local bufnr = vim.api.nvim_get_current_buf()
  -- Get the text content of the string node
  local content = vim.treesitter.get_node_text(string_node, bufnr)


  -- Validate that we have actual content
  if not content or content == '' then
    return nil
  end

  -- Determine quote type by examining the first character
  local quote_type = string.sub(content, 1, 1)
  if quote_type ~= '"' and quote_type ~= "'" and quote_type ~= '`' then
    -- Fallback: assume double quotes if we can't determine
    quote_type = '"'
  end

  -- Extract inner content (without quotes)
  local inner_content = content
  if #content >= 2 then
    local first_char = string.sub(content, 1, 1)
    local last_char = string.sub(content, -1)

    -- Check for matching quotes
    if (first_char == '"' or first_char == "'" or first_char == '`') and
        last_char == first_char then
      inner_content = string.sub(content, 2, -2)
      quote_type = first_char
    end
  end

  -- Additional validation for malformed strings
  if #content < 2 then
    return nil
  end

  return {
    content = content,
    inner_content = inner_content,
    start_pos = { start_row + 1, start_col }, -- Convert back to 1-based indexing
    end_pos = { end_row + 1, end_col },
    quote_type = quote_type
  }
end

return M
