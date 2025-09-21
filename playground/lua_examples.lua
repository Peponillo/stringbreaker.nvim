-- Lua Examples for nvim-stringbreaker Plugin Testing
-- This file contains various string examples to test the plugin functionality

local config = {
    name = "nvim-stringbreaker",
    version = "1.0.0",
    description = "A Neovim plugin for breaking long strings into multiple lines",
    author = "Your Name",
    license = "MIT"
}

-- Example 1: Long string with single quotes
local long_single_quote =
'This is a very long string that contains multiple sentences and should be broken into multiple lines for better readability. The string includes various punctuation marks like periods, commas, and exclamation marks! It also contains special characters such as @, #, $, %, ^, &, *, (, ), _, +, -, =, [, ], {, }, |, ;, :, ", \', <, >, ?, and /. This string is designed to test the nvim-stringbreaker plugin\'s ability to handle long text content and properly format it across multiple lines.'

-- Example 2: Long string with double quotes
local long_double_quote =
"This is another very long string that demonstrates the plugin's ability to handle double-quoted strings. It contains multiple paragraphs of text that would benefit from being split across multiple lines. The string includes various types of content: regular text, numbers like 123 and 456, special characters like !@#$%^&*(), and even some escaped characters like \"quotes\" and \\backslashes\\. This comprehensive example should thoroughly test the string breaking functionality."

-- Example 3: String with mixed quotes and escapes
local mixed_quotes =
"This string contains 'single quotes' and \"double quotes\" along with various escape sequences like \\n for newlines, \\t for tabs, \\r for carriage returns, and \\\\ for backslashes. It also includes unicode characters like \u{1F600} (smiling face) and \u{1F4BB} (laptop). The string is designed to test the plugin's handling of complex escape sequences and special characters."

-- Example 4: Multi-line string using [[]] syntax
local multiline_bracket = "[[\nThis is a multi-line string using the double bracket syntax.\nIt can contain multiple lines of text without needing escape sequences.\nThe string includes:\n- Bullet points\n- Numbers: 1, 2, 3\n- Special characters: !@#$%^&*()\n- Quotes: 'single' and \"double\"\n- Backslashes: \\ and \\\\\nThis format is useful for long text content that doesn't need escaping. \"OK\"\n]]"

-- Example 5: String with complex formatting
local complex_formatting =
"This string contains complex formatting elements including:\n1. Numbered lists with items\n2. Code snippets like 'function example() { return true; }'\n3. File paths like /usr/local/bin/example\n4. URLs like https://www.example.com/path?param=value&other=123\n5. JSON-like structures: {\"key\": \"value\", \"number\": 42}\n6. Regular expressions: /^[a-zA-Z0-9]+$/\n7. SQL queries: SELECT * FROM users WHERE id = 1\n8. HTML tags: <div class=\"container\">content</div>\nThis comprehensive example tests various formatting scenarios."

-- Example 6: String with nested quotes
local nested_quotes =
'This string demonstrates nested quote handling with "double quotes inside single quotes" and \'single quotes inside double quotes\'. It also includes escaped quotes like \\"escaped double\\" and \\\'escaped single\\\'. The string contains various combinations: "mixed \'nested\' quotes" and \'mixed "nested" quotes\'. This tests the plugin\'s ability to properly handle quote nesting and escaping.'

-- Example 7: String with code-like content
local code_like_content =
"This string contains code-like content that should be properly formatted:\n\nfunction calculateTotal(items) {\n  let total = 0;\n  for (let item of items) {\n    if (item.price && item.quantity) {\n      total += item.price * item.quantity;\n    }\n  }\n  return total;\n}\n\nconst result = calculateTotal([\n  { name: 'Apple', price: 1.50, quantity: 3 },\n  { name: 'Banana', price: 0.75, quantity: 5 },\n  { name: 'Orange', price: 2.00, quantity: 2 }\n]);\n\nconsole.log('Total:', result);"

-- Example 8: String with error messages
local error_messages =
"Error handling examples:\n\n1. Validation Error: 'The input data does not meet the required criteria. Please check your input and try again.'\n2. Network Error: \"Network connection failed. Please check your internet connection and try again later.\"\n3. Permission Error: 'Access denied. You do not have sufficient permissions to perform this action.'\n4. File Not Found: \"The specified file could not be found. Please verify the file path and ensure the file exists.\"\n5. Invalid Format: 'The file format is not supported. Please use a supported file format and try again.'"

-- Example 9: String with configuration data
local config_data =
"Configuration options for the plugin:\n\n{\n  \"preview\": {\n    \"max_length\": 1000,\n    \"use_float\": true,\n    \"width\": 80,\n    \"height\": 20\n  },\n  \"keybindings\": {\n    \"break_string\": \"<space>fes\",\n    \"preview\": \"<space>fep\",\n    \"save\": \"<space>fs\",\n    \"cancel\": \"<space>qq\"\n  },\n  \"filetypes\": [\n    \"lua\",\n    \"javascript\",\n    \"python\",\n    \"json\",\n    \"yaml\"\n  ]\n}"

-- Example 10: String with documentation
local documentation =
"nvim-stringbreaker Plugin Documentation\n\n## Overview\nThis Neovim plugin provides functionality to break long strings into multiple lines for better readability and code maintenance.\n\n## Features\n- Automatic string detection using Tree-sitter\n- Support for multiple programming languages\n- Visual mode text selection\n- Preview functionality\n- Configurable keybindings\n\n## Installation\nUse your preferred plugin manager:\n\n### Packer\n```lua\nuse {\n  'your-username/nvim-stringbreaker',\n  requires = { 'nvim-treesitter/nvim-treesitter' }\n}\n```\n\n### Lazy.nvim\n```lua\n{\n  'your-username/nvim-stringbreaker',\n  dependencies = { 'nvim-treesitter/nvim-treesitter' }\n}\n```\n\n## Usage\n1. Place cursor inside a string or select text in visual mode\n2. Use the configured keybinding to break the string\n3. Edit the content in the opened buffer\n4. Save changes or cancel editing\n\n## Configuration\nSee the configuration section for available options and customization."

-- Function to demonstrate string usage
function demonstrate_strings()
    print("Lua string examples loaded successfully!")
    print("String lengths:")
    print("- long_single_quote: " .. #long_single_quote .. " characters")
    print("- long_double_quote: " .. #long_double_quote .. " characters")
    print("- mixed_quotes: " .. #mixed_quotes .. " characters")
    print("- complex_formatting: " .. #complex_formatting .. " characters")
    print("- documentation: " .. #documentation .. " characters")
end

-- Call the demonstration function
demonstrate_strings()
