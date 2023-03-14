local M = require("lualine.component"):extend()

---@alias CopilotRunningStatus string
---| '"running"' # copilot is running
---| '"idle"' # copilot is idle

local symbols = {
  enabled = " ", -- f113
  disabled = " ", -- f05e
  running = " ",
}

---Check if copilot is enabled
---@return boolean
local function enabled()
  if vim.g.loaded_copilot == 1 and vim.fn["copilot#Enabled"]() == 1 then
    return true
  else
    return false
  end
end

---Show copilot running status
---@return CopilotRunningStatus
local function running_status()
  local agent = vim.g.loaded_copilot == 1 and vim.fn["copilot#RunningAgent"]() or nil
  if not agent then
    return "idle"
  end
  -- most of the time, requests is just empty dict.
  local requests = agent.requests or {}

  -- requests is dict with number as index, get status from those requests.
  for _, req in pairs(requests) do
    local req_status = req.status
    if req_status == "running" then
      return "running"
    end
  end
  return "idle"
end

function M:init(options)
  M.super.init(self, options)
  self.options = self.options or {}
  self.symbols = vim.tbl_deep_extend("keep", self.options.symbols or {}, symbols)
  -- show copilot running status, default: true
  self.show_running = self.options.show_running ~= false and true or false
end

function M:update_status()
  if enabled() then
    -- return symbols.enabled
    local status = self.show_running and running_status() or "idle"
    if status == "running" then
      return self.symbols.running
    end
    return self.symbols.enabled
  else
    return self.symbols.disabled
  end
end

return M
