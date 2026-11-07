-- :ParaTemplate — append a para template to the current buffer.
-- Templates live in ~/.config/para/templates/*.md (daily.md is excluded; it
-- is para's own daily-note template). The template frontmatter is dropped,
-- and {{date}}, {{weekday}} and {{title}} are replaced. Keep these rules in
-- step with the para README.
local M = {}

M.dir = vim.fn.expand("~/.config/para/templates")
local EXCLUDED = { daily = true }

--- Name of the templates/ subfolder for the notebook holding `file`: the
--- nearest ancestor folder whose name matches a subfolder, or nil.
function M.notebook_for(file, dir)
  dir = dir or M.dir
  local path = vim.fn.fnamemodify(file, ":p:h")
  while path ~= "/" and path ~= "" do
    local name = vim.fn.fnamemodify(path, ":t")
    if name ~= "" and vim.fn.isdirectory(dir .. "/" .. name) == 1 then
      return name
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
end

--- Map of template name (file stem) to path. Shared templates sit in the
--- base folder; the notebook's own override them. daily is excluded.
function M.templates(dir, notebook)
  dir = dir or M.dir
  local found = {}
  local folders = { dir }
  if notebook then
    table.insert(folders, dir .. "/" .. notebook)
  end
  for _, folder in ipairs(folders) do
    for _, path in ipairs(vim.fn.glob(folder .. "/*.md", false, true)) do
      local stem = vim.fn.fnamemodify(path, ":t:r")
      if not EXCLUDED[stem] then
        found[stem] = path
      end
    end
  end
  return found
end

--- Sorted template names for a notebook.
function M.list(dir, notebook)
  local names = vim.tbl_keys(M.templates(dir, notebook))
  table.sort(names)
  return names
end

--- Remove a leading `---` frontmatter block from a list of lines.
function M.strip_frontmatter(lines)
  if lines[1] ~= "---" then
    return lines
  end
  for i = 2, #lines do
    if lines[i] == "---" then
      return vim.list_slice(lines, i + 1)
    end
  end
  return lines
end

--- Drop leading blank lines and trailing whitespace, as para does, so an
--- append adds exactly one blank separator line.
function M.trim(lines)
  local first, last = 1, #lines
  while first <= last and not lines[first]:match("%S") do
    first = first + 1
  end
  while last >= first and not lines[last]:match("%S") do
    last = last - 1
  end
  if first > last then
    return {}
  end
  local out = vim.list_slice(lines, first, last)
  out[#out] = out[#out]:gsub("%s+$", "")
  return out
end

--- Title from the lines' frontmatter, or nil.
function M.frontmatter_title(lines)
  if lines[1] ~= "---" then
    return nil
  end
  for i = 2, #lines do
    if lines[i] == "---" then
      return nil
    end
    local title = lines[i]:match("^title:%s*(.-)%s*$")
    if title and title ~= "" then
      return (title:gsub("^[\"'](.*)[\"']$", "%1"))
    end
  end
end

--- Replace only the exact {{date}}, {{weekday}} and {{title}} forms.
function M.render(lines, vars)
  local out = {}
  for _, line in ipairs(lines) do
    line = line:gsub("{{(%a+)}}", function(key)
      return vars[key]
    end)
    table.insert(out, line)
  end
  return out
end

--- Append the named template to the end of a buffer as one undoable change.
function M.append(name, buf, opts)
  opts = opts or {}
  buf = buf or 0
  local file = vim.api.nvim_buf_get_name(buf)
  local notebook = opts.notebook or M.notebook_for(file, opts.dir)
  local path = M.templates(opts.dir, notebook)[name]
  if not path or vim.fn.filereadable(path) == 0 then
    vim.notify("ParaTemplate: cannot read template '" .. name .. "'", vim.log.levels.WARN)
    return false
  end
  local body = M.trim(M.strip_frontmatter(vim.fn.readfile(path)))
  if #body == 0 then
    vim.notify("ParaTemplate: template '" .. name .. "' has no body", vim.log.levels.WARN)
    return false
  end
  local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local title = M.frontmatter_title(buf_lines) or vim.fn.fnamemodify(file, ":t:r")
  local rendered = M.render(body, {
    date = os.date("%Y-%m-%d"),
    weekday = os.date("%A"),
    title = title,
  })
  local last = vim.api.nvim_buf_line_count(buf)
  local only_blank = last == 1 and buf_lines[1] == ""
  if not only_blank then
    table.insert(rendered, 1, "")
  end
  vim.api.nvim_buf_set_lines(buf, only_blank and 0 or last, only_blank and 1 or last, false, rendered)
  return true
end

function M.pick()
  local names = M.list(M.dir, M.notebook_for(vim.api.nvim_buf_get_name(0)))
  if #names == 0 then
    vim.notify("ParaTemplate: no templates in " .. M.dir, vim.log.levels.WARN)
    return
  end
  vim.ui.select(names, { prompt = "Append template" }, function(choice)
    if choice then
      M.append(choice)
    end
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("ParaTemplate", function(args)
    if args.args ~= "" then
      M.append(args.args)
    else
      M.pick()
    end
  end, {
    nargs = "?",
    desc = "Append a para template to the current buffer",
    complete = function()
      return M.list(M.dir, M.notebook_for(vim.api.nvim_buf_get_name(0)))
    end,
  })
end

return M
