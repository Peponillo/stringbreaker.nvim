# StringBreaker Usage Examples

This document provides practical usage examples and best practices for the StringBreaker plugin.

## Basic Examples

### 1. Editing JSON Strings

**Scenario**: Code contains a compressed JSON string that needs editing

```lua
-- Original code
local config = '{"database":{"host":"localhost","port":5432,"name":"mydb"},"cache":{"enabled":true,"ttl":3600}}'

-- Steps:
-- 1. Place cursor inside the string
-- 2. Execute :BreakString
-- 3. See formatted content in editing buffer:
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "name": "mydb"
  },
  "cache": {
    "enabled": true,
    "ttl": 3600
  }
}
-- 4. After editing, execute :SaveString
```

### 2. Handling Escape Characters

**Scenario**: Editing strings with many escape characters

```python
# Original Python code
regex_pattern = "\\d{4}-\\d{2}-\\d{2}\\s+\\d{2}:\\d{2}:\\d{2}\\.\\d{3}\\s+\\[\\w+\\]"

# After using BreakString, see in editing buffer:
\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\.\d{3}\s+\[\w+\]

# Much easier to understand and modify the regex
```

### 3. Multi-line String Editing

**Scenario**: Editing multi-line strings containing HTML or SQL

```javascript
// Original JavaScript code
const htmlTemplate = "<div class=\"container\">\\n  <h1>Title</h1>\\n  <p>Content with \\"quotes\\" and 'apostrophes'</p>\\n</div>";

// BreakString editing view:
<div class="container">
  <h1>Title</h1>
  <p>Content with "quotes" and 'apostrophes'</p>
</div>
```

## Visual Mode Examples

### 4. Partial String Editing

**Scenario**: Edit only part of a string

```lua
-- Original code
local message = 'Hello, ' .. name .. '! Welcome to our application. Your ID is: ' .. user_id

-- Select 'Hello, ' .. name .. '! Welcome to our application.' part
-- Execute :BreakString to edit only selected portion
```

### 5. Multi-line Text Editing

**Scenario**: Edit text blocks spanning multiple lines

```sql
-- Select entire SQL query for formatting
SELECT users.name, users.email, profiles.bio 
FROM users 
JOIN profiles ON users.id = profiles.user_id 
WHERE users.active = true AND profiles.public = true;
```

## Preview Function Examples

### 6. Quick Content Check

**Scenario**: Quickly view string content without editing

```lua
-- Cursor on string, execute :PreviewString
local encoded_data = "SGVsbG8gV29ybGQhXG5UaGlzIGlzIGEgdGVzdCBzdHJpbmcu"

-- Preview window shows decoded content without opening editor
```

### 7. Long String Preview

**Scenario**: Check content of very long strings

```python
# Long SQL query string
query = "SELECT u.id, u.name, u.email, p.bio, p.avatar, c.name as company, c.address, c.phone FROM users u LEFT JOIN profiles p ON u.id = p.user_id LEFT JOIN companies c ON u.company_id = c.id WHERE u.active = 1 AND u.created_at > '2023-01-01' ORDER BY u.created_at DESC LIMIT 100"

# PreviewString shows formatted SQL for quick inspection
```

## Lua API Examples

### 8. Automated Workflows

```lua
-- Create custom function to process all strings
local function process_all_strings_in_buffer()
  local stringBreaker = require('string-breaker')
  
  -- Save current position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  
  -- Search all strings
  vim.cmd('normal! gg')
  
  while vim.fn.search('".*"', 'W') > 0 do
    local result = stringBreaker.preview()
    if result.success then
      print(string.format("Found string, length: %d", result.data.length))
      
      -- If string is long, ask whether to edit
      if result.data.length > 100 then
        local choice = vim.fn.confirm('Edit this long string?', '&Yes\n&No\n&Skip', 3)
        if choice == 1 then
          stringBreaker.break_string()
          -- Wait for user editing...
          break
        elseif choice == 2 then
          break
        end
        -- choice == 3 continue to next
      end
    end
  end
  
  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end
```

### 9. Conditional Editing

```lua
-- Decide whether to edit based on string content
local function smart_string_edit()
  local stringBreaker = require('string-breaker')
  
  local preview_result = stringBreaker.preview()
  if not preview_result.success then
    vim.notify("Cannot preview string: " .. preview_result.message, vim.log.levels.WARN)
    return
  end
  
  local content = preview_result.data.content
  local length = preview_result.data.length
  
  -- Decide operation based on content characteristics
  if content:match('^%s*{.*}%s*$') then
    -- JSON string
    vim.notify("Detected JSON string, length: " .. length)
    if length > 50 then
      stringBreaker.break_string()
    end
  elseif content:match('SELECT.*FROM') then
    -- SQL query
    vim.notify("Detected SQL query")
    stringBreaker.break_string()
  elseif content:match('<[^>]+>') then
    -- HTML content
    vim.notify("Detected HTML content")
    stringBreaker.break_string()
  else
    vim.notify("Regular string, length: " .. length)
  end
end
```

### 10. Batch Processing

```lua
-- Batch format all JSON strings in file
local function format_all_json_strings()
  local stringBreaker = require('string-breaker')
  
  -- Search all possible JSON strings
  local patterns = {
    '"{[^"]*}"',  -- Simple JSON objects
    '"\\[.*\\]"', -- JSON arrays
  }
  
  for _, pattern in ipairs(patterns) do
    vim.cmd('normal! gg')
    
    while vim.fn.search(pattern, 'W') > 0 do
      local result = stringBreaker.preview()
      if result.success then
        local content = result.data.content
        
        -- Check if valid JSON
        local ok, parsed = pcall(vim.fn.json_decode, content)
        if ok then
          -- Format JSON
          local formatted = vim.fn.json_encode(parsed)
          
          -- Can auto-replace or ask user here
          print("Found JSON: " .. content:sub(1, 50) .. "...")
        end
      end
    end
  end
end
```

## Advanced Configuration Examples

### 11. Custom Preview Configuration

```lua
-- Adjust preview settings based on content type
local stringBreaker = require('string-breaker')

-- Set different preview configurations for different content types
local function setup_dynamic_preview()
  local original_preview = stringBreaker.preview
  
  stringBreaker.preview = function()
    local result = original_preview()
    
    if result.success then
      local content = result.data.content
      
      -- Adjust display based on content
      if content:match('^%s*{') or content:match('^%s*%[') then
        -- JSON content uses large window
        stringBreaker.setup({
          preview = { width = 120, height = 40 }
        })
      elseif content:match('SELECT') then
        -- SQL uses wide window
        stringBreaker.setup({
          preview = { width = 150, height = 20 }
        })
      else
        -- Default settings
        stringBreaker.setup({
          preview = { width = 80, height = 20 }
        })
      end
    end
    
    return result
  end
end
```

### 12. Keymap Integration

```lua
-- Create smart keymaps
local function setup_smart_keymaps()
  local stringBreaker = require('string-breaker')
  
  -- Smart edit: normal mode detects strings, visual mode edits selection
  vim.keymap.set({'n', 'v'}, '<leader>se', function()
    local mode = vim.fn.mode()
    
    if mode == 'v' or mode == 'V' or mode == '\22' then
      -- Visual mode: edit directly
      vim.cmd('BreakString')
    else
      -- Normal mode: preview first, then decide
      local result = stringBreaker.preview()
      if result.success then
        if result.data.length > 200 then
          local choice = vim.fn.confirm(
            'String is long (' .. result.data.length .. ' characters), confirm edit?',
            '&Edit\n&Cancel',
            1
          )
          if choice == 1 then
            vim.cmd('BreakString')
          end
        else
          vim.cmd('BreakString')
        end
      end
    end
  end, { desc = 'Smart string edit' })
  
  -- Quick preview
  vim.keymap.set({'n', 'v'}, '<leader>sp', ':PreviewString<CR>', 
    { desc = 'Preview string' })
  
  -- Shortcuts in editing buffer
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'stringBreaker',
    callback = function()
      local opts = { buffer = true, silent = true }
      
      -- Quick save
      vim.keymap.set('n', '<C-s>', function()
        stringBreaker.save()
      end, opts)
      
      -- Quick cancel
      vim.keymap.set('n', '<C-q>', function()
        stringBreaker.cancel()
      end, opts)
      
      -- Preview original content
      vim.keymap.set('n', '<leader>po', function()
        local buffer_manager = require('string-breaker.buffer_manager')
        local source_info = buffer_manager.get_source_info(0)
        if source_info then
          vim.notify('Original content: ' .. (source_info.original_content or 'N/A'))
        end
      end, opts)
    end
  })
end
```

## Error Handling Examples

### 13. Graceful Error Handling

```lua
-- Create wrapper function with error handling
local function safe_string_edit()
  local stringBreaker = require('string-breaker')
  
  local result = stringBreaker.break_string()
  
  if not result.success then
    -- Provide different solutions based on error type
    if result.error_code == 'TREESITTER_UNAVAILABLE' then
      vim.notify('Tree-sitter unavailable, try visual mode', vim.log.levels.WARN)
      vim.notify('Use v to select text, then retry', vim.log.levels.INFO)
      
    elseif result.error_code == 'NO_STRING_FOUND' then
      vim.notify('No string found, try these methods:', vim.log.levels.WARN)
      vim.notify('1. Move cursor inside string', vim.log.levels.INFO)
      vim.notify('2. Use visual mode to select text', vim.log.levels.INFO)
      
    elseif result.error_code == 'BUFFER_NOT_MODIFIABLE' then
      vim.notify('Buffer is read-only, try:', vim.log.levels.WARN)
      vim.notify(':set modifiable', vim.log.levels.INFO)
      
    else
      -- Generic error handling
      vim.notify('Operation failed: ' .. result.message, vim.log.levels.ERROR)
      
      if result.suggestions then
        for i, suggestion in ipairs(result.suggestions) do
          vim.notify(i .. '. ' .. suggestion, vim.log.levels.INFO)
        end
      end
    end
    
    return false
  end
  
  return true
end
```

### 14. Auto-retry Mechanism

```lua
-- String editing with auto-retry
local function auto_retry_string_edit()
  local stringBreaker = require('string-breaker')
  
  -- First try normal mode
  local result = stringBreaker.break_string()
  
  if not result.success and result.error_code == 'TREESITTER_UNAVAILABLE' then
    -- Tree-sitter unavailable, prompt user to use visual mode
    vim.notify('Tree-sitter unavailable, please select text to edit', vim.log.levels.WARN)
    
    -- Wait for user to enter visual mode
    vim.defer_fn(function()
      if vim.fn.mode():match('[vV\22]') then
        local visual_result = stringBreaker.break_string()
        if not visual_result.success then
          vim.notify('Visual mode editing also failed: ' .. visual_result.message, vim.log.levels.ERROR)
        end
      else
        vim.notify('Please use v to enter visual mode and select text', vim.log.levels.INFO)
      end
    end, 1000)
    
  elseif not result.success and result.error_code == 'NO_STRING_FOUND' then
    -- No string found, try expanding search range
    vim.notify('No string found at current position, searching nearby...', vim.log.levels.INFO)
    
    -- Search for strings in current line
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    
    -- Search forward for quotes
    local quote_pos = line:find('["\']', col + 1)
    if quote_pos then
      vim.api.nvim_win_set_cursor(0, {vim.api.nvim_win_get_cursor(0)[1], quote_pos})
      vim.notify('Found string, retrying edit...', vim.log.levels.INFO)
      
      vim.defer_fn(function()
        stringBreaker.break_string()
      end, 500)
    else
      vim.notify('No string found nearby, please select manually', vim.log.levels.WARN)
    end
  end
end
```

### 15. Canceling String Editing

**Scenario**: Different ways to cancel string editing without saving

```lua
-- Method 1: Using the BreakStringCancel command (works from anywhere)
vim.keymap.set('n', '<leader>sc', ':BreakStringCancel<CR>', { desc = 'Cancel string editing' })

-- Method 2: Using the Lua API directly
local function smart_cancel()
  local stringBreaker = require('string-breaker')
  local result = stringBreaker.cancel()
  
  if result.success then
    vim.notify('✓ ' .. result.message, vim.log.levels.INFO)
  else
    vim.notify('✗ ' .. result.message, vim.log.levels.WARN)
  end
end

vim.keymap.set('n', '<leader>cx', smart_cancel, { desc = 'Smart cancel with feedback' })

-- Method 3: Conditional cancel (only if in edit buffer)
local function conditional_cancel()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  
  if filetype == 'stringBreaker' then
    vim.cmd('BreakStringCancel')
  else
    vim.notify('Not in string editing buffer', vim.log.levels.INFO)
  end
end

-- Method 4: Cancel with confirmation
local function confirm_cancel()
  local choice = vim.fn.confirm('Cancel string editing?', '&Yes\n&No', 2)
  if choice == 1 then
    vim.cmd('BreakStringCancel')
  end
end
```

## Integration Examples

### 16. LSP Integration

```lua
-- Auto-process strings after LSP formatting
local function format_with_string_processing()
  -- First execute LSP formatting
  vim.lsp.buf.format()
  
  -- Wait for formatting to complete, then process strings
  vim.defer_fn(function()
    local stringBreaker = require('string-breaker')
    
    -- Find all strings that need processing
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd('normal! gg')
    
    local processed = 0
    while vim.fn.search('".*\\\\n.*"', 'W') > 0 do
      local result = stringBreaker.preview()
      if result.success and result.data.length > 50 then
        -- Auto-format long strings
        processed = processed + 1
      end
    end
    
    vim.api.nvim_win_set_cursor(0, cursor_pos)
    vim.notify('Formatting complete, processed ' .. processed .. ' strings', vim.log.levels.INFO)
  end, 1000)
end
```

### 17. Filetype Integration

```lua
-- Provide different string processing based on file type
local function setup_filetype_integration()
  local stringBreaker = require('string-breaker')
  
  -- JavaScript/TypeScript: handle template strings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'javascript', 'typescript'},
    callback = function()
      vim.keymap.set('n', '<leader>st', function()
        -- Find template strings
        if vim.fn.search('`.*`', 'c') > 0 then
          stringBreaker.break_string()
        else
          vim.notify('No template string found', vim.log.levels.WARN)
        end
      end, { buffer = true, desc = 'Edit template string' })
    end
  })
  
  -- Python: handle f-strings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
      vim.keymap.set('n', '<leader>sf', function()
        if vim.fn.search('f["\'].*["\']', 'c') > 0 then
          stringBreaker.break_string()
        else
          vim.notify('No f-string found', vim.log.levels.WARN)
        end
      end, { buffer = true, desc = 'Edit f-string' })
    end
  })
  
  -- SQL: handle query strings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'sql', 'mysql', 'postgresql'},
    callback = function()
      vim.keymap.set('n', '<leader>sq', function()
        if vim.fn.search('SELECT\\|INSERT\\|UPDATE\\|DELETE', 'c') > 0 then
          stringBreaker.break_string()
        end
      end, { buffer = true, desc = 'Edit SQL query' })
    end
  })
end
```

## Custom Commands and Shortcuts

### 18. Preview and Edit Combined

```lua
-- Create custom command that previews first, then asks to edit
vim.api.nvim_create_user_command('StringPreviewEdit', function()
  local stringBreaker = require('string-breaker')
  
  local preview_result = stringBreaker.preview()
  if preview_result.success then
    local length = preview_result.data.length
    local source = preview_result.data.source_type
    
    local choice = vim.fn.confirm(
      string.format('String found (%s source, %d chars). Action?', source, length),
      '&Edit\n&Preview Only\n&Cancel',
      1
    )
    
    if choice == 1 then
      stringBreaker.break_string()
    elseif choice == 2 then
      -- Preview was already shown, do nothing
      vim.notify('Preview complete', vim.log.levels.INFO)
    end
  else
    vim.notify('No string found: ' .. preview_result.message, vim.log.levels.WARN)
  end
end, { 
  desc = 'Preview string content then optionally edit',
  range = true 
})
```

### 19. Mode-Aware Editing

```lua
-- Create mode-aware editing function
local function mode_aware_edit()
  local stringBreaker = require('string-breaker')
  local mode = stringBreaker._get_mode()
  
  if mode == 'visual' then
    vim.notify('Visual mode: editing selection', vim.log.levels.INFO)
    local result = stringBreaker.break_string()
    if not result.success then
      vim.notify('Visual edit failed: ' .. result.message, vim.log.levels.ERROR)
    end
  elseif mode == 'normal' then
    vim.notify('Normal mode: detecting string at cursor', vim.log.levels.INFO)
    local result = stringBreaker.break_string()
    if not result.success then
      if result.error_code == 'TREESITTER_UNAVAILABLE' then
        vim.notify('Tree-sitter unavailable. Use visual mode to select text.', vim.log.levels.WARN)
      elseif result.error_code == 'NO_STRING_FOUND' then
        vim.notify('No string at cursor. Use visual mode to select text.', vim.log.levels.WARN)
      else
        vim.notify('Edit failed: ' .. result.message, vim.log.levels.ERROR)
      end
    end
  else
    vim.notify('Unsupported mode: ' .. mode, vim.log.levels.WARN)
  end
end

-- Create the command
vim.api.nvim_create_user_command('SmartStringEdit', mode_aware_edit, {
  desc = 'Smart string editing based on current mode',
  range = true
})
```

### 20. Batch String Processing

```lua
-- Process all strings in buffer with user interaction
local function interactive_batch_process()
  local stringBreaker = require('string-breaker')
  
  -- Save current position
  local original_pos = vim.api.nvim_win_get_cursor(0)
  
  -- Track statistics
  local stats = {
    total_found = 0,
    edited = 0,
    skipped = 0,
    errors = 0
  }
  
  -- Search all strings
  vim.cmd('normal! gg')
  
  while vim.fn.search('"[^"]*"', 'W') > 0 do
    stats.total_found = stats.total_found + 1
    
    -- Preview the string
    local preview_result = stringBreaker.preview()
    if preview_result.success then
      local content = preview_result.data.content
      local length = preview_result.data.length
      
      -- Show preview snippet
      local snippet = content:sub(1, 50)
      if length > 50 then
        snippet = snippet .. '...'
      end
      
      local choice = vim.fn.confirm(
        string.format('String %d: "%s" (%d chars)', stats.total_found, snippet, length),
        '&Edit\n&Skip\n&Stop\n&Preview',
        2
      )
      
      if choice == 1 then
        -- Edit
        local edit_result = stringBreaker.break_string()
        if edit_result.success then
          stats.edited = stats.edited + 1
          -- Wait for user to finish editing
          vim.notify('Press any key when done editing...', vim.log.levels.INFO)
          vim.fn.getchar()
        else
          stats.errors = stats.errors + 1
          vim.notify('Edit failed: ' .. edit_result.message, vim.log.levels.ERROR)
        end
      elseif choice == 2 then
        -- Skip
        stats.skipped = stats.skipped + 1
      elseif choice == 3 then
        -- Stop
        break
      elseif choice == 4 then
        -- Preview (already shown, continue)
        stats.skipped = stats.skipped + 1
      end
    else
      stats.errors = stats.errors + 1
    end
  end
  
  -- Restore position
  vim.api.nvim_win_set_cursor(0, original_pos)
  
  -- Show final statistics
  vim.notify(string.format(
    'Batch processing complete:\nTotal: %d, Edited: %d, Skipped: %d, Errors: %d',
    stats.total_found, stats.edited, stats.skipped, stats.errors
  ), vim.log.levels.INFO)
end

-- Create the command
vim.api.nvim_create_user_command('BatchStringProcess', interactive_batch_process, {
  desc = 'Interactively process all strings in buffer'
})
```

These examples demonstrate the powerful functionality and flexibility of the StringBreaker plugin. By combining different features, you can create custom solutions that fit your specific workflow needs.