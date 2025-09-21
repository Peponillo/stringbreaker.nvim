# Python Examples for nvim-stringbreaker Plugin Testing
# This file contains various string examples to test the plugin functionality

config = {
    "name": "nvim-stringbreaker",
    "version": "1.0.0",
    "description": "A Neovim plugin for breaking long strings into multiple lines",
    "author": "Your Name",
    "license": "MIT"
}

# Example 1: Long string with single quotes
long_single_quote = 'This is a very long string that contains multiple sentences and should be broken into multiple lines for better readability. The string includes various punctuation marks like periods, commas, and exclamation marks! It also contains special characters such as @, #, $, %, ^, &, *, (, ), _, +, -, =, [, ], {, }, |, ;, :, ", \', <, >, ?, and /. This string is designed to test the nvim-stringbreaker plugin\'s ability to handle long text content and properly format it across multiple lines.'

# Example 2: Long string with double quotes
long_double_quote = "This is another very long string that demonstrates the plugin's ability to handle double-quoted strings. It contains multiple paragraphs of text that would benefit from being split across multiple lines. The string includes various types of content: regular text, numbers like 123 and 456, special characters like !@#$%^&*(), and even some escaped characters like \"quotes\" and \\backslashes\\. This comprehensive example should thoroughly test the string breaking functionality."

# Example 3: String with mixed quotes and escapes
mixed_quotes = "This string contains 'single quotes' and \"double quotes\" along with various escape sequences like \\n for newlines, \\t for tabs, \\r for carriage returns, and \\\\ for backslashes. It also includes unicode characters like \U0001F600 (smiling face) and \U0001F4BB (laptop). The string is designed to test the plugin's handling of complex escape sequences and special characters."

# Example 4: Multi-line string using triple quotes
multiline_triple = """
This is a multi-line string using triple quotes.
It can contain multiple lines of text without needing escape sequences.
The string includes:
- Bullet points
- Numbers: 1, 2, 3
- Special characters: !@#$%^&*()
- Quotes: 'single' and "double"
- Backslashes: \ and \\
This format is useful for long text content that doesn't need escaping.
"""

# Example 5: String with complex formatting
complex_formatting = "This string contains complex formatting elements including:\n1. Numbered lists with items\n2. Code snippets like 'def example(): return True'\n3. File paths like /usr/local/bin/example\n4. URLs like https://www.example.com/path?param=value&other=123\n5. JSON-like structures: {\"key\": \"value\", \"number\": 42}\n6. Regular expressions: r'^[a-zA-Z0-9]+$'\n7. SQL queries: SELECT * FROM users WHERE id = 1\n8. HTML tags: <div class=\"container\">content</div>\nThis comprehensive example tests various formatting scenarios."

# Example 6: String with nested quotes
nested_quotes = 'This string demonstrates nested quote handling with "double quotes inside single quotes" and \'single quotes inside double quotes\'. It also includes escaped quotes like \\"escaped double\\" and \\\'escaped single\\\'. The string contains various combinations: "mixed \'nested\' quotes" and \'mixed "nested" quotes\'. This tests the plugin\'s ability to properly handle quote nesting and escaping.'

# Example 7: String with code-like content
code_like_content = "This string contains code-like content that should be properly formatted:\n\ndef calculate_total(items):\n    total = 0\n    for item in items:\n        if item.get('price') and item.get('quantity'):\n            total += item['price'] * item['quantity']\n    return total\n\nitems = [\n    {'name': 'Apple', 'price': 1.50, 'quantity': 3},\n    {'name': 'Banana', 'price': 0.75, 'quantity': 5},\n    {'name': 'Orange', 'price': 2.00, 'quantity': 2}\n]\n\nresult = calculate_total(items)\nprint(f'Total: {result}')"

# Example 8: String with error messages
error_messages = "Error handling examples:\n\n1. Validation Error: 'The input data does not meet the required criteria. Please check your input and try again.'\n2. Network Error: \"Network connection failed. Please check your internet connection and try again later.\"\n3. Permission Error: 'Access denied. You do not have sufficient permissions to perform this action.'\n4. File Not Found: \"The specified file could not be found. Please verify the file path and ensure the file exists.\"\n5. Invalid Format: 'The file format is not supported. Please use a supported file format and try again.'"

# Example 9: String with configuration data
config_data = "Configuration options for the plugin:\n\n{\n  \"preview\": {\n    \"max_length\": 1000,\n    \"use_float\": true,\n    \"width\": 80,\n    \"height\": 20\n  },\n  \"keybindings\": {\n    \"break_string\": \"<space>fes\",\n    \"preview\": \"<space>fep\",\n    \"save\": \"<space>fs\",\n    \"cancel\": \"<space>qq\"\n  },\n  \"filetypes\": [\n    \"lua\",\n    \"javascript\",\n    \"python\",\n    \"json\",\n    \"yaml\"\n  ]\n}"

# Example 10: String with documentation
documentation = "nvim-stringbreaker Plugin Documentation\n\n## Overview\nThis Neovim plugin provides functionality to break long strings into multiple lines for better readability and code maintenance.\n\n## Features\n- Automatic string detection using Tree-sitter\n- Support for multiple programming languages\n- Visual mode text selection\n- Preview functionality\n- Configurable keybindings\n\n## Installation\nUse your preferred plugin manager:\n\n### Packer\n```lua\nuse {\n  'your-username/nvim-stringbreaker',\n  requires = { 'nvim-treesitter/nvim-treesitter' }\n}\n```\n\n### Lazy.nvim\n```lua\n{\n  'your-username/nvim-stringbreaker',\n  dependencies = { 'nvim-treesitter/nvim-treesitter' }\n}\n```\n\n## Usage\n1. Place cursor inside a string or select text in visual mode\n2. Use the configured keybinding to break the string\n3. Edit the content in the opened buffer\n4. Save changes or cancel editing\n\n## Configuration\nSee the configuration section for available options and customization."

# Example 11: String with regular expressions
regex_examples = "Regular expression examples:\n\n1. Email validation: r'^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$'\n2. Phone number: r'^\\+?[\\d\\s\\-\\(\\)]+$'\n3. URL validation: r'^https?:\\/\\/[\\w\\-]+(\\.[\\w\\-]+)+([\\w\\-\\.,@?^=%&:\\/~\\+#]*[\\w\\-\\@?^=%&\\/~\\+#])?$'\n4. IPv4 address: r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'\n5. Strong password: r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$'"

# Example 12: String with API documentation
api_documentation = "API Documentation Example:\n\n## User Management API\n\n### Create User\n**Endpoint**: POST /api/users\n**Description**: Creates a new user account\n\n**Request Body**:\n```json\n{\n  \"username\": \"johndoe\",\n  \"email\": \"john@example.com\",\n  \"password\": \"securePassword123\",\n  \"profile\": {\n    \"firstName\": \"John\",\n    \"lastName\": \"Doe\",\n    \"bio\": \"Software developer with 5+ years of experience\"\n  }\n}\n```\n\n**Response**:\n```json\n{\n  \"success\": true,\n  \"data\": {\n    \"id\": 123,\n    \"username\": \"johndoe\",\n    \"email\": \"john@example.com\",\n    \"createdAt\": \"2024-01-15T10:30:00Z\"\n  }\n}\n```\n\n**Error Responses**:\n- 400: Bad Request - Invalid input data\n- 409: Conflict - Username or email already exists\n- 500: Internal Server Error - Server error occurred"

# Example 13: String with SQL queries
sql_queries = "SQL Query Examples:\n\n1. Select all users: SELECT * FROM users;\n2. Select with conditions: SELECT id, username, email FROM users WHERE active = 1 AND created_at > '2024-01-01';\n3. Join query: SELECT u.username, p.title FROM users u JOIN posts p ON u.id = p.user_id WHERE u.role = 'admin';\n4. Insert query: INSERT INTO users (username, email, password_hash) VALUES ('johndoe', 'john@example.com', 'hashed_password_here');\n5. Update query: UPDATE users SET last_login = NOW() WHERE id = 123;\n6. Delete query: DELETE FROM users WHERE id = 456 AND active = 0;"

# Example 14: String with HTML content
html_content = "HTML Content Example:\n\n<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>Example Page</title>\n    <style>\n        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; }\n        .container { max-width: 800px; margin: 0 auto; }\n        .header { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }\n    </style>\n</head>\n<body>\n    <div class=\"container\">\n        <div class=\"header\">\n            <h1>Welcome to the Example Page</h1>\n            <p>This is a sample HTML page with embedded CSS styles.</p>\n        </div>\n    </div>\n</body>\n</html>"

# Example 15: String with YAML configuration
yaml_config = "YAML Configuration Example:\n\n# Application Configuration\napp:\n  name: \"My Application\"\n  version: \"1.0.0\"\n  debug: false\n  port: 8080\n\n# Database Configuration\ndatabase:\n  host: \"localhost\"\n  port: 5432\n  name: \"myapp_db\"\n  username: \"db_user\"\n  password: \"secure_password\"\n  ssl: true\n\n# Logging Configuration\nlogging:\n  level: \"INFO\"\n  format: \"%(asctime)s - %(name)s - %(levelname)s - %(message)s\"\n  file: \"/var/log/myapp.log\"\n  max_size: \"10MB\"\n  backup_count: 5\n\n# Feature Flags\nfeatures:\n  enable_api: true\n  enable_webhooks: false\n  enable_analytics: true\n  maintenance_mode: false"

# Function to demonstrate string usage
def demonstrate_strings():
    print("Python string examples loaded successfully!")
    print("String lengths:")
    print(f"- long_single_quote: {len(long_single_quote)} characters")
    print(f"- long_double_quote: {len(long_double_quote)} characters")
    print(f"- mixed_quotes: {len(mixed_quotes)} characters")
    print(f"- multiline_triple: {len(multiline_triple)} characters")
    print(f"- complex_formatting: {len(complex_formatting)} characters")
    print(f"- documentation: {len(documentation)} characters")
    print(f"- regex_examples: {len(regex_examples)} characters")
    print(f"- api_documentation: {len(api_documentation)} characters")
    print(f"- sql_queries: {len(sql_queries)} characters")
    print(f"- html_content: {len(html_content)} characters")
    print(f"- yaml_config: {len(yaml_config)} characters")

# Call the demonstration function
if __name__ == "__main__":
    demonstrate_strings()
