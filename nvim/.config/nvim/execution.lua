vim.keymap.set("n", "<leader>r", function()
  vim.cmd("write")
  local ft = vim.bo.filetype
  local file = vim.fn.shellescape(vim.fn.expand("%"))
  local output = vim.fn.expand("%:p:r")
  local hasMakeFile = vim.fn.filereadable("makefile") == 1

  if hasMakeFile then
    vim.cmd("split | terminal make run")
  elseif ft == "cpp" then
    vim.cmd(
      'split | terminal bash -c "clang++ -std=c++23 -Wall -Wextra '
      .. file
      .. " -o "
      .. output
      .. " $(pkg-config --cflags --libs raylib)" --Use if using raylib.h on c++
      .. " && "
      .. output
      .. '"'
    )
  elseif ft == "c" then
    vim.cmd(
      "split | terminal clang -Wall -Wextra "
      .. file
      .. " -o "
      .. output
      .. " && "
      .. output
    )
  elseif ft == "python" then
    vim.cmd("botright split")
    vim.cmd("resize 12")
    local venv = vim.fn.getcwd() .. "/.venv/bin/python"
    local python = vim.fn.executable(venv) == 1 and venv or "python3"
    vim.cmd("terminal " .. python .. " " .. file)
  elseif ft == "cs" then
    vim.cmd("split | terminal dotnet run")
  elseif ft == "html" then
    vim.cmd("botright split")
    vim.cmd("resize 10")
    vim.cmd('terminal bash -c "python3 -m http.server 8000 & sleep 1 && xdg-open http://localhost:8000/'
      .. file
      .. '"'
    )
  else
    vim.notify("THERE IS NO RUNNER FOR THIS FILE TYPE YOU DONKEY", vim.log.levels.ERROR)
  end
end)
