-- String Editor Plugin Entry Point
-- This file is loaded automatically by Neovim when the plugin is installed

-- Prevent loading twice
if vim.g.loaded_string_editor then
  return
end
vim.g.loaded_string_editor = 1

-- Setup the plugin
require('string-breaker').setup()
