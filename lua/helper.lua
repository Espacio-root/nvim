local M = {}

M.arduino_compile = function()
  local sketch_path = vim.fn.expand("%:p:h")   -- Get the current file's directory
  local fqbn = "arduino:avr:uno"               -- Replace with your board's FQBN
  local port = "/dev/ttyUSB0"                  -- Replace with your board's port
  local compile_upload_cmd = string.format(
    "arduino-cli compile --fqbn %s --upload -p %s %s",
    fqbn, port, sketch_path
  )

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Define window configuration for a floating window
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local win_height = math.ceil(height * 0.8)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "rounded"
  })

  -- Run the command and capture output
  vim.fn.termopen(compile_upload_cmd, {
    on_exit = function(_, exit_code)
      -- Optional: Add highlighting based on exit code
      if exit_code == 0 then
        vim.api.nvim_buf_set_name(buf, "Arduino Compile & Upload [Success]")
      else
        vim.api.nvim_buf_set_name(buf, "Arduino Compile & Upload [Failed]")
      end
    end
  })

  -- Set buffer-local keymapping to close the window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

  -- Start in insert mode (for terminal buffer)
  vim.cmd('startinsert')
end
return M
