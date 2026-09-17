local M = {}

local function root()
  return vim.fn.getcwd()
end

local function bin()
  if vim.g.skidora_bin and vim.fn.executable(vim.g.skidora_bin) == 1 then
    return vim.g.skidora_bin
  end
  if vim.fn.executable("skidora") == 1 then
    return "skidora"
  end
  local candidates = {
    root() .. "/target/release/skidora",
    root() .. "/target/debug/skidora",
  }
  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

local function run(args)
  local executable = bin()
  if not executable then
    return {
      code = 1,
      stdout = "",
      stderr = "Skidora binary not found. Please install via 'cargo install --path crates/skidora-cli' or set vim.g.skidora_bin",
    }
  end

  local cmd = { executable, "--path", root() }
  vim.list_extend(cmd, args)

  if vim.system then
    local result = vim.system(cmd, { text = true }):wait()
    return {
      code = result.code or 1,
      stdout = result.stdout or "",
      stderr = result.stderr or "",
    }
  end

  local out = vim.fn.system(cmd)
  return {
    code = vim.v.shell_error,
    stdout = out,
    stderr = "",
  }
end

local function show(text, title)
  local lines = vim.split(text, "\n", { plain = true })
  if lines[#lines] == "" then
    table.remove(lines, #lines)
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  -- Allow closing the popup quickly with 'q' or '<Esc>'
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true, nowait = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true, nowait = true })

  local width = math.min(80, math.max(vim.o.columns - 4, 20))
  local height = math.min(math.max(#lines, 4), math.floor(vim.o.lines * 0.4))

  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = 2,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  }

  if vim.fn.has("nvim-0.8") == 1 then
    win_opts.title = title or "Skidora"
    win_opts.title_pos = "center"
  end

  vim.api.nvim_open_win(buf, true, win_opts)
end

local function notify_err(res)
  local msg = res.stderr
  if not msg or msg == "" then
    msg = res.stdout
  end
  if not msg or msg == "" then
    msg = "Unknown error occurred"
  end
  vim.notify(vim.trim(msg), vim.log.levels.ERROR)
end

function M.init()
  local res = run({ "init" })
  if res.code ~= 0 then
    return notify_err(res)
  end
  vim.notify("Skidora init: " .. vim.trim(res.stdout), vim.log.levels.INFO)
end

function M.status()
  local res = run({ "status" })
  if res.code ~= 0 then
    return notify_err(res)
  end
  show(res.stdout, "Skidora Status")
end

function M.quiet_status()
  local res = run({ "status" })
  if res.code ~= 0 then
    return
  end
  local line = vim.trim(res.stdout):gsub("\n", " | ")
  if line ~= "" then
    vim.notify(line, vim.log.levels.INFO)
  end
end

function M.recover()
  local res = run({ "recover" })
  if res.code ~= 0 then
    return notify_err(res)
  end
  local path = root() .. "/.skidora/recover.md"
  vim.cmd("split " .. vim.fn.fnameescape(path))
end

function M.append(opts)
  local milestone = opts.args
  if not milestone or milestone == "" then
    milestone = vim.fn.input("Milestone: ")
  end
  if not milestone or milestone == "" then
    return
  end
  local res = run({ "append", "--milestone", milestone })
  if res.code ~= 0 then
    return notify_err(res)
  end
  vim.notify("Skidora: milestone appended to recover.md", vim.log.levels.INFO)
end

function M.setup()
  vim.api.nvim_create_user_command("SkidoraInit", M.init, {})
  vim.api.nvim_create_user_command("SkidoraStatus", M.status, {})
  vim.api.nvim_create_user_command("SkidoraRecover", M.recover, {})
  vim.api.nvim_create_user_command("SkidoraAppend", M.append, { nargs = "*" })

  vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    group = vim.api.nvim_create_augroup("SkidoraBars", { clear = true }),
    callback = function()
      if vim.g.skidora_autostatus == false then
        return
      end
      if vim.fn.filereadable(root() .. "/.skidora/recover.md") == 1 then
        M.quiet_status()
      end
    end,
  })
end

return M
