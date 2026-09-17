local M = {}

local function bin()
  return vim.g.skidora_bin or "skidora"
end

local function root()
  return vim.fn.getcwd()
end

local function run(args)
  local cmd = { bin(), "--path", root() }
  vim.list_extend(cmd, args)
  local result
  if vim.system then
    result = vim.system(cmd, { text = true }):wait()
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
  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(math.max(#lines, 4), math.floor(vim.o.lines * 0.4))
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = 2,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = title or "Skidora",
  })
end

local function notify_err(res)
  local msg = res.stderr
  if msg == "" then
    msg = res.stdout
  end
  vim.notify(msg, vim.log.levels.ERROR)
end

function M.init()
  local res = run({ "init" })
  if res.code ~= 0 then
    return notify_err(res)
  end
  vim.notify("Skidora init: " .. vim.trim(res.stdout))
end

function M.status()
  local res = run({ "status" })
  if res.code ~= 0 then
    return notify_err(res)
  end
  show(res.stdout, "Skidora status")
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
  if milestone == "" then
    return
  end
  local res = run({ "append", "--milestone", milestone })
  if res.code ~= 0 then
    return notify_err(res)
  end
  vim.notify("Skidora: milestone appended to recover.md")
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
