local M = {}

local function edit_file(uri, _)
  -- If the file picker is cancelled, the callback still runs
  if not uri then return end

  local line = tonumber(uri:match('#L(%d+)') or 1) -- Extract the line number, default to 1
  local path = uri:gsub('^file://', ''):gsub('#L%d+', '') -- Remove the protocol and line number

  vim.cmd(string.format('edit +%d %s', line, path))
end

local function open_file_command(command)
  -- command.arguments[1] is a list of one or more file uris
  local uris = command.arguments[1]

  if #uris == 1 then
    edit_file(uris[1])
  else
    -- Display a file picker
    vim.ui.select(command.arguments[1], {
      prompt = 'Select a file to jump to',
      format_item = function(uri)
        -- Only show everything after the last slash, not the full uri
        return uri:match('^.+/(.+)$')
      end,
    }, edit_file)
  end
end

local function setup_refresh_autocmd()
  vim.api.nvim_create_autocmd({ 'LspAttach', 'BufEnter', 'CursorHold', 'InsertLeave' }, {
    pattern = { '*.rb', '*.erb' },
    callback = function(args) vim.lsp.codelens.refresh({ bufnr = args.buf }) end,
    desc = 'Refresh active code lenses',
  })
end

local function run_test(command)
  local args = command.arguments
  local test_command = args[3]
  vim.cmd("redraw")
  vim.cmd("!" .. test_command)
end

local function run_test_in_terminal(command)
  local args = command.arguments
  local test_command = args[3]
  vim.g.VimuxOrientation = "h"
  vim.g.VimuxHeight = "50"
  vim.fn.VimuxRunCommand(test_command)
  vim.fn.system("tmux select-pane -t 1")
end

local function debug_test(command)
  local args = command.arguments
  local test_command = args[3]

  -- Split the command into arguments
  local cmd_args = {}
  for arg in test_command:gmatch("%S+") do
    table.insert(cmd_args, arg)
  end

  -- Extract the command and the rest of the arguments
  table.remove(cmd_args, 1) -- ignore the first argument since it runs ruby
  local cmd = table.remove(cmd_args, 1)

  -- Start the debug session
  require("dap").run({
    type = "ruby",
    name = "debug test",
    request = "attach",
    localfs = true,
    command = cmd,
    script = cmd_args,
  })
end

vim.lsp.commands["rubyLsp.runTest"] = run_test
vim.lsp.commands["rubyLsp.runTestInTerminal"] = run_test_in_terminal
vim.lsp.commands["rubyLsp.debugTest"] = debug_test
vim.lsp.commands["rubyLsp.openFile"] = open_file_command
setup_refresh_autocmd()

return M