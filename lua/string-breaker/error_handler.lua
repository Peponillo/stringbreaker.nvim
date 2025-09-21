-- Unified error handling module
-- Provides consistent error response format and error handling utilities

local M = {}

-- Error code definitions
M.ERROR_CODES = {
  TREESITTER_UNAVAILABLE = 'TREESITTER_UNAVAILABLE',
  NO_STRING_FOUND = 'NO_STRING_FOUND',
  INVALID_SELECTION = 'INVALID_SELECTION',
  BUFFER_NOT_MODIFIABLE = 'BUFFER_NOT_MODIFIABLE',
  UNSUPPORTED_MODE = 'UNSUPPORTED_MODE',
  EMPTY_CONTENT = 'EMPTY_CONTENT',
  USER_CANCELLED = 'USER_CANCELLED',
  BUFFER_CREATION_FAILED = 'BUFFER_CREATION_FAILED',
  SAVE_FAILED = 'SAVE_FAILED',
  NOT_IN_EDIT_BUFFER = 'NOT_IN_EDIT_BUFFER',
  CANCEL_FAILED = 'CANCEL_FAILED',
  UNEXPECTED_ERROR = 'UNEXPECTED_ERROR'
}

-- Error message templates
local ERROR_MESSAGES = {
  [M.ERROR_CODES.TREESITTER_UNAVAILABLE] = 'Normal mode requires Tree-sitter support. Please install nvim-treesitter or use visual mode to select text.',
  [M.ERROR_CODES.NO_STRING_FOUND] = 'No string found at cursor position. Please place cursor inside a string or use visual mode to select text.',
  [M.ERROR_CODES.INVALID_SELECTION] = 'Invalid visual selection. Please select valid text content.',
  [M.ERROR_CODES.BUFFER_NOT_MODIFIABLE] = 'Current buffer is not modifiable. Cannot edit strings in read-only buffer.',
  [M.ERROR_CODES.UNSUPPORTED_MODE] = 'Unsupported editor mode. Please use this feature in normal mode or visual mode.',
  [M.ERROR_CODES.EMPTY_CONTENT] = 'Empty content detected. No content available for editing or preview.',
  [M.ERROR_CODES.USER_CANCELLED] = 'User cancelled the operation.',
  [M.ERROR_CODES.BUFFER_CREATION_FAILED] = 'Failed to create edit buffer. Please try again.',
  [M.ERROR_CODES.SAVE_FAILED] = 'Error occurred while saving string.',
  [M.ERROR_CODES.NOT_IN_EDIT_BUFFER] = 'This operation can only be used in string edit buffer.',
  [M.ERROR_CODES.CANCEL_FAILED] = 'Error occurred while cancelling edit.',
  [M.ERROR_CODES.UNEXPECTED_ERROR] = 'Unexpected error occurred.'
}

-- Suggestion templates
local ERROR_SUGGESTIONS = {
  [M.ERROR_CODES.TREESITTER_UNAVAILABLE] = {
    'Install and configure nvim-treesitter plugin',
    'Use visual mode to select text to edit',
    'Ensure current file type has corresponding Tree-sitter parser'
  },
  [M.ERROR_CODES.NO_STRING_FOUND] = {
    'Move cursor inside string quotes',
    'Use visual mode to select text to edit',
    'Check if current file syntax is correctly recognized'
  },
  [M.ERROR_CODES.INVALID_SELECTION] = {
    'Ensure non-empty text content is selected',
    'Check if selection range is correct',
    'Re-select text content'
  },
  [M.ERROR_CODES.BUFFER_NOT_MODIFIABLE] = {
    'Check if file is read-only',
    'Ensure file write permissions',
    'Try using :set modifiable command'
  },
  [M.ERROR_CODES.UNSUPPORTED_MODE] = {
    'Press Esc to return to normal mode',
    'Use v key to enter visual mode and select text',
    'Check current editor state'
  },
  [M.ERROR_CODES.EMPTY_CONTENT] = {
    'Select text that contains content',
    'Check if string actually contains text',
    'Try selecting a larger text range'
  },
  [M.ERROR_CODES.BUFFER_CREATION_FAILED] = {
    'Check memory usage',
    'Restart Neovim and try again',
    'Check plugin configuration'
  },
  [M.ERROR_CODES.SAVE_FAILED] = {
    'Ensure this function is called in string edit buffer',
    'Check if original file is still modifiable',
    'Verify file permissions'
  },
  [M.ERROR_CODES.NOT_IN_EDIT_BUFFER] = {
    'Ensure this function is called in string edit buffer',
    'Use break() function to start editing string'
  },
  [M.ERROR_CODES.UNEXPECTED_ERROR] = {
    'Check plugin installation and configuration',
    'View Neovim logs for detailed information',
    'Restart Neovim and try again'
  }
}

-- Create standard error response
-- @param error_code string Error code
-- @param custom_message string|nil Custom error message
-- @param details string|nil Detailed error information
-- @return table Error response
function M.create_error_response(error_code, custom_message, details)
  local message = custom_message or ERROR_MESSAGES[error_code] or ERROR_MESSAGES[M.ERROR_CODES.UNEXPECTED_ERROR]
  local suggestions = ERROR_SUGGESTIONS[error_code] or {}
  
  return {
    success = false,
    error_code = error_code,
    message = message,
    details = details,
    suggestions = suggestions
  }
end

-- Create success response
-- @param message string Success message
-- @param data table|nil Return data
-- @return table Success response
function M.create_success_response(message, data)
  return {
    success = true,
    message = message,
    data = data
  }
end

-- Wrap function call and handle errors
-- @param func function Function to execute
-- @param error_code string Default error code
-- @return table API response
function M.safe_call(func, error_code)
  local success, result = pcall(func)
  
  if not success then
    return M.create_error_response(
      error_code or M.ERROR_CODES.UNEXPECTED_ERROR,
      nil,
      tostring(result)
    )
  end
  
  return result
end

-- Validate API response format
-- @param response table Response object
-- @return boolean Whether it's a valid response
function M.validate_response(response)
  if type(response) ~= 'table' then
    return false
  end
  
  -- Must have success field
  if type(response.success) ~= 'boolean' then
    return false
  end
  
  -- Must have message field
  if type(response.message) ~= 'string' then
    return false
  end
  
  -- If it's an error response, must have error_code
  if not response.success and type(response.error_code) ~= 'string' then
    return false
  end
  
  return true
end

-- Show error message to user
-- @param response table Error response
function M.show_error(response)
  if not response or response.success then
    return
  end
  
  vim.notify(response.message, vim.log.levels.ERROR)
  
  if response.suggestions and #response.suggestions > 0 then
    vim.notify('Suggestions: ' .. table.concat(response.suggestions, ', '), vim.log.levels.INFO)
  end
  
  if response.details then
    vim.notify('Details: ' .. response.details, vim.log.levels.DEBUG)
  end
end

-- Show success message to user
-- @param response table Success response
function M.show_success(response)
  if not response or not response.success then
    return
  end
  
  vim.notify(response.message, vim.log.levels.INFO)
end

return M