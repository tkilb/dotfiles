-- Shared Ctrl+Arrow / Ctrl+hjkl navigation logic for terminal-family buffers
-- (Snacks.terminal / sidekick_terminal), reused from two call sites:
--
-- 1. `nvim/lua/plugins/snacks.lua` overrides Snacks terminal's buffer-local
--    `nav_h`/`nav_j`/`nav_k`/`nav_l` Terminal-mode keys (LazyVim's own
--    `lazyvim/plugins/util.lua` registers these by default, buffer-local, on
--    every Snacks terminal window -- a plain `wincmd` with no herdr
--    awareness). Buffer-local keymaps always win over global ones for the
--    same mode+lhs, so this is the mapping that actually needs replacing:
--    herdr's compiled `herdr-nvim-nav` plugin action always forwards
--    Ctrl+Arrow as the canonical Ctrl+h/j/k/l chord (see herdr-nvim-nav.c),
--    which is exactly what LazyVim's default was silently intercepting.
-- 2. `nvim/lua/config/keymaps.lua` maps the same logic globally in Terminal
--    mode for the raw arrow-key chords (which herdr never actually forwards,
--    but a direct/non-herdr keypress still could) and as a safety net for
--    any terminal-family buffer that isn't a Snacks window.
--
-- Mirrors herdr-nvim-nav's own nav(): wincmd first; at a split edge, the
-- herdr socket call (with an explicit pane_id) falling back to the CLI
-- (also with an explicit --pane, not --current -- --current resolves
-- against whatever pane herdr's server last tracked as globally focused,
-- which is not reliably "this pane" when invoked as a plain piped
-- subprocess rather than typed at a real, currently-focused terminal).
local M = {}

local DIR_NAME = { h = "left", j = "down", k = "up", l = "right" }

local function herdr_bin()
  local bin = vim.env.HERDR_BIN_PATH
  if bin == nil or bin == "" then
    bin = "herdr"
  end
  return bin
end

local function herdr_socket_path()
  local sock = vim.env.HERDR_SOCKET_PATH
  if sock == nil or sock == "" then
    sock = vim.fn.expand("~/.config/herdr/herdr.sock")
  end
  return sock
end

---@return boolean reached false means fall back to the CLI
local function focus_via_socket(dir, herdr_pane)
  local uv = vim.uv or vim.loop
  local pipe = uv.new_pipe(false)
  if not pipe then
    return false
  end

  local payload = vim.json.encode({
    id = "nvim.term-nav",
    method = "pane.focus_direction",
    params = { direction = dir, pane_id = herdr_pane },
  }) .. "\n"

  local reached = nil
  pipe:connect(herdr_socket_path(), function(cerr)
    if cerr then
      reached = false
    else
      pipe:read_start(function(rerr, data)
        reached = not rerr and data ~= nil
      end)
      pipe:write(payload)
    end
  end)

  vim.wait(150, function()
    return reached ~= nil
  end, 1)
  pipe:close()
  return reached == true
end

--- Move focus in `wincmd_dir` ("h"/"j"/"k"/"l") from a terminal-family
--- buffer: within Neovim's splits if one exists that direction, otherwise
--- crossing into the neighbouring herdr pane. Leaves/restores Terminal mode
--- as needed around the move.
---@param wincmd_dir "h"|"j"|"k"|"l"
function M.terminal_nav(wincmd_dir)
  -- Neovim disallows window/buffer-mutating commands (E565: "Not allowed to
  -- change text or change window") when called synchronously from inside a
  -- Terminal-mode keymap's Lua callback -- the same restriction LazyVim's
  -- own default `term_nav()` works around by deferring the real `wincmd`
  -- call via `vim.schedule()`. Without this, `wincmd` always errors (silently,
  -- since keymap callback errors from terminal-mode input aren't surfaced),
  -- so the "did we move to a neighboring Neovim split" check was always
  -- false, and every direction fell through to the herdr escape regardless
  -- of whether a real Neovim split neighbor existed.
  vim.schedule(function()
    local win_before = vim.api.nvim_get_current_win()
    local buf_before = vim.api.nvim_get_current_buf()
    vim.cmd("stopinsert")

    -- If the terminal is currently zoomed (`<C-,>` / `Snacks.zen.zoom()`),
    -- Neovim's window list still contains the other (hidden) splits, but
    -- the current window is the zen float itself -- `wincmd` from inside it
    -- would either silently "succeed" by moving to a real-but-invisible
    -- split (via Neovim's floating-window-relative directional lookup) or
    -- fail to find anything, neither of which is the "unzoom and reveal
    -- what's actually there" behavior we want. Unzoom first (same toggle
    -- `Snacks.zen.zoom()` call used by `<C-,>` and `toggle_terminal()`,
    -- which just closes the existing zoom window when one is open) so the
    -- real split layout is what `wincmd` below operates on, then fall
    -- through to the normal split-neighbor-or-herdr-escape logic.
    --
    -- Deliberately does NOT try to preserve/restore zoom when there's no
    -- split neighbor (i.e. when this falls through to the herdr escape):
    -- two different attempts at that (unzoom-then-rezoom, and an
    -- `nvim_win_call`-based no-touch probe) were tried and reverted per
    -- user direction -- the former visibly flickered zoom-out/zoom-in on
    -- every herdr-escape press, the latter broke zoom state across
    -- repeated back-and-forth presses. Losing zoom on herdr-escape is the
    -- accepted, simplest-and-most-consistent behavior.
    local zen_win = Snacks.zen and Snacks.zen.win
    if zen_win and zen_win:valid() and zen_win.win == win_before then
      Snacks.zen.zoom()
      win_before = vim.api.nvim_get_current_win()
    end

    vim.cmd("wincmd " .. wincmd_dir)
    if vim.api.nvim_get_current_win() ~= win_before then
      return -- moved to a neighboring Neovim split
    end

    -- At a split edge: cross into the surrounding multiplexer, same as
    -- herdr-nvim-nav's own socket call (with CLI fallback).
    local herdr_pane = vim.env.HERDR_PANE_ID
    if herdr_pane ~= nil and herdr_pane ~= "" then
      local dir = DIR_NAME[wincmd_dir]
      if not focus_via_socket(dir, herdr_pane) then
        vim.fn.system({ herdr_bin(), "pane", "focus", "--direction", dir, "--pane", herdr_pane })
      end
    end

    -- Didn't cross out (nothing to do, or no herdr around) and we're still
    -- looking at the same terminal buffer: resume Terminal mode so typing
    -- keeps going straight to the pty.
    if vim.api.nvim_get_current_win() == win_before and vim.api.nvim_get_current_buf() == buf_before then
      if vim.bo[buf_before].buftype == "terminal" then
        vim.cmd("startinsert")
      end
    end
  end)
end

return M
