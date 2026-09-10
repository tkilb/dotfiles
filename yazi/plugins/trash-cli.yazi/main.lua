--- @since 25.5.28
---
--- Trash selected/hovered files via `trash-put` (trash-cli), which is
--- consistent across macOS and Linux. If `trash-put` isn't installed (or
--- fails), fall back to Yazi's own built-in `remove` action so this stays
--- portable across every machine, regardless of whether trash-cli is set up.

local selected_or_hovered = ya.sync(function()
	local tab, urls = cx.active, {}
	for _, f in pairs(tab.selected) do
		urls[#urls + 1] = f.url or f
	end
	if #urls == 0 and tab.current.hovered then
		urls[1] = tab.current.hovered.url
	end
	return urls
end)

local function entry()
	local urls = selected_or_hovered()
	if #urls == 0 then
		return
	end

	local body = {}
	for _, url in ipairs(urls) do
		body[#body + 1] = tostring(url)
	end

	local confirmed = ya.confirm({
		pos = { "center", w = 60, h = 20 },
		title = ui.Line(string.format("Trash %d selected file(s)?", #urls)):style(th.confirm.title),
		body = ui.Text(table.concat(body, "\n")),
	})
	if not confirmed then
		return
	end

	local args = {}
	for _, url in ipairs(urls) do
		args[#args + 1] = tostring(url)
	end

	local status = Command("trash-put"):arg(args):status()
	if status and status.success then
		ya.emit("escape", { select = true })
	else
		-- trash-put missing or failed: fall back to Yazi's native trash.
		ya.emit("remove", {})
	end
end

return { entry = entry }
