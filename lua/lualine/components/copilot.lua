local M = require("lualine.component"):extend()

---@alias CopilotStatus string
---| '"enabled"' # copilot is enabled
---| '"disabled"' # copilot is disabled

---@class CopilotComponentOptions
local default_options = {
  ---@class CopilotSymbols
  symbols = {
    status = {
      enabled = " ",
      disabled = " ",
      running = " ",
    },
  },
  show_running = true,
}

---Check if copilot is enabled
---@return CopilotStatus
local function get_status()
  if vim.g.loaded_copilot == 1 and vim.fn["copilot#Enabled"]() == 1 then
    return "enabled"
  else
    return "disabled"
  end
end

---Show copilot running status
---@return boolean
local function is_running()
  local agent = vim.g.loaded_copilot == 1 and vim.fn["copilot#RunningAgent"]() or nil
  if not agent then
    return false
  end
  -- most of the time, requests is just empty dict.
  local requests = agent.requests or {}

  -- requests is dict with number as index, get status from those requests.
  for _, req in pairs(requests) do
    local req_status = req.status
    if req_status == "running" then
      return true
    end
  end
  return false
end

-- Toggle copilot
local function toggle()
  if get_status() == "enabled" then
    vim.b.copilot_enabled = 0
  else
    vim.b.copilot_enabled = nil
  end
end

---Initialize component
---@param options CopilotComponentOptions
function M:init(options)
  -- Setup click handler
  options.on_click = toggle

  M.super.init(self, options)
  ---@type CopilotComponentOptions
  self.options = vim.tbl_deep_extend("force", default_options, options or {})

  -- Setup options
  self.symbols = self.options.symbols
  self.show_running = self.options.show_running
end

function M:update_status()
  if get_status() == "enabled" then
    -- return symbols.enabled
    if self.show_running and is_running() then
      return self.symbols.status.running
    end
    return self.symbols.status.enabled
  else
    return self.symbols.status.disabled
  end
end

return M
