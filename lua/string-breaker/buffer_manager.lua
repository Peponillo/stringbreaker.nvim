local M = {}

-- Table to store source file information, keyed by buffer number
local source_info_store = {}

-- Create edit buffer
-- @param content string Content to edit
-- @param source_info table Source file information
-- @return number Buffer number
function M.create_edit_buffer(content, source_info)
  -- Create new buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  if not bufnr or bufnr == 0 then
    return nil
  end

  -- Set buffer content
  local lines = vim.split(content, '\n', { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- Set filetype to stringBreaker
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'stringBreaker')

  -- Set buffer as temporary buffer
  -- vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'acwrite')
  vim.api.nvim_buf_set_option(bufnr, 'swapfile', false)
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')

  -- Set buffer as modified state so user will be prompted when closing
  vim.api.nvim_buf_set_option(bufnr, 'modified', false)

  -- Store source file information
  M.store_source_info(bufnr, source_info)

  vim.api.nvim_create_autocmd('BufWriteCmd', {
    buffer = bufnr,
    callback = function(args)
      require('string-breaker').sync()
      vim.api.nvim_buf_set_option(bufnr, 'modified', false)
    end,
  })

  -- Open buffer in new window
  vim.cmd('split')
  vim.api.nvim_win_set_buf(0, bufnr)

  -- Set buffer name for identification
  local source_name = vim.api.nvim_buf_get_name(source_info.bufnr)
  local display_name = source_name ~= '' and vim.fn.fnamemodify(source_name, ':t') or 'untitled'
  vim.api.nvim_buf_set_name(bufnr, '[String Editor: ' .. display_name .. ']')

  -- Set some useful buffer options
  vim.api.nvim_buf_set_option(bufnr, 'wrap', true)
  vim.api.nvim_buf_set_option(bufnr, 'linebreak', true)

  return bufnr
end

-- Store source file information
-- @param bufnr number Buffer number
-- @param info table Source file information
function M.store_source_info(bufnr, info)
  source_info_store[bufnr] = info
end

-- Get source file information
-- @param bufnr number Buffer number
-- @return table Source file information
function M.get_source_info(bufnr)
  return source_info_store[bufnr]
end

-- Get buffer content and close buffer
-- @param bufnr number Buffer number
-- @return string Buffer content
function M.get_content_and_close(bufnr)
  -- Get buffer content
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, '\n')

  -- Clean up source file information
  source_info_store[bufnr] = nil

  -- Close buffer
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  return content
end

return M
