# Playground - nvim-stringbreaker Plugin Testing

This playground folder contains various example files to test and demonstrate the nvim-stringbreaker plugin functionality. All examples are designed to showcase different string handling scenarios and help users understand how to use the plugin effectively.

## Files Overview

### 1. `ai_prompts.json`
- **Purpose**: Contains AI prompts written in Markdown format
- **Content**: 5 comprehensive AI prompts for different use cases:
  - Code Review Assistant
  - API Documentation Generator
  - Bug Analysis and Debugging
  - Performance Optimization Guide
  - Security Audit Assistant
- **Testing Focus**: Long Markdown content with headers, lists, code blocks, and complex formatting

### 2. `lua_examples.lua`
- **Purpose**: Lua string examples with various quote types and escape sequences
- **Content**: 10 different string examples including:
  - Long single and double-quoted strings
  - Mixed quotes with escape sequences
  - Multi-line strings using `[[]]` syntax
  - Complex formatting with code snippets
  - Nested quotes and special characters
- **Testing Focus**: Lua-specific string syntax and escape handling

### 3. `javascript_examples.js`
- **Purpose**: JavaScript string examples with modern syntax
- **Content**: 12 different string examples including:
  - Long single and double-quoted strings
  - Template literals with embedded expressions
  - Mixed quotes with escape sequences
  - Complex formatting with code snippets
  - Regular expressions and API documentation
- **Testing Focus**: JavaScript string syntax, template literals, and escape sequences

### 4. `python_examples.py`
- **Purpose**: Python string examples with various quote types
- **Content**: 15 different string examples including:
  - Long single and double-quoted strings
  - Multi-line strings using triple quotes
  - Mixed quotes with escape sequences
  - Complex formatting with code snippets
  - Regular expressions, SQL queries, HTML, and YAML content
- **Testing Focus**: Python string syntax, triple quotes, and escape sequences

## How to Use This Playground

### Basic Testing Steps

1. **Open any example file** in Neovim
2. **Navigate to a long string** (look for strings with 200+ characters)
3. **Test the plugin** using one of these methods:
   - **Normal Mode**: Place cursor inside the string and use the plugin
   - **Visual Mode**: Select text and use the plugin
4. **Observe the results** and test different string types

### Recommended Testing Scenarios

#### Scenario 1: Basic String Breaking
- Open `lua_examples.lua`
- Navigate to `long_single_quote` variable
- Place cursor inside the string
- Use the plugin to break the string

#### Scenario 2: Complex Content Handling
- Open `ai_prompts.json`
- Navigate to any `content` field
- Test breaking Markdown content with headers and code blocks

#### Scenario 3: Escape Sequence Testing
- Open `javascript_examples.js`
- Navigate to `mixed_quotes` variable
- Test handling of escape sequences and special characters

#### Scenario 4: Multi-line String Testing
- Open `python_examples.py`
- Navigate to `multiline_triple` variable
- Test breaking triple-quoted strings

#### Scenario 5: Template Literal Testing
- Open `javascript_examples.js`
- Navigate to `templateString` variable
- Test handling of template literals with embedded expressions

### Plugin Commands

The plugin provides these commands for testing:

- `:BreakString` - Break string at cursor or visual selection
- `:PreviewString` - Preview string content without editing
- `:SaveString` - Save changes in string editor buffer
- `:BreakStringCancel` - Cancel string editing

### Keybindings (if configured)

- `<space>fes` - Break string for editing
- `<space>fep` - Preview string content
- `<space>fec` - Cancel string editing
- `<space>fs` - Save string changes (in editor buffer)
- `<space>qq` - Cancel string editing (in editor buffer)

## Testing Checklist

### ✅ Basic Functionality
- [ ] Plugin loads without errors
- [ ] Commands are available
- [ ] Keybindings work (if configured)

### ✅ String Detection
- [ ] Detects strings in normal mode
- [ ] Handles visual mode selection
- [ ] Works with different quote types
- [ ] Handles escape sequences

### ✅ Content Handling
- [ ] Breaks long strings properly
- [ ] Preserves formatting
- [ ] Handles special characters
- [ ] Works with multi-line content

### ✅ Language Support
- [ ] Lua strings work correctly
- [ ] JavaScript strings work correctly
- [ ] Python strings work correctly
- [ ] JSON strings work correctly

### ✅ Edge Cases
- [ ] Empty strings
- [ ] Very long strings
- [ ] Strings with only special characters
- [ ] Nested quotes
- [ ] Complex escape sequences

## Troubleshooting

### Common Issues

1. **Plugin not working**: Ensure nvim-treesitter is installed and configured
2. **Strings not detected**: Check if file type is supported
3. **Formatting issues**: Verify string syntax is correct
4. **Performance problems**: Test with shorter strings first

### Getting Help

- Check the main plugin documentation
- Review the plugin configuration
- Test with simpler strings first
- Check Neovim logs for error messages

## Contributing

If you find issues or want to add more examples:

1. Test your changes with the existing examples
2. Ensure all examples are in English
3. Add comments explaining the testing purpose
4. Update this README if adding new files

## File Structure

```
playground/
├── README.md              # This file
├── ai_prompts.json        # AI prompts in Markdown format
├── lua_examples.lua       # Lua string examples
├── javascript_examples.js # JavaScript string examples
└── python_examples.py     # Python string examples
```

Happy testing! 🚀