local M = require("lualine.component"):extend()

local symbols = {
  enabled = " ", -- f113
  disabled = " ", -- f05e
  running = " "
}

local Status = {
  Running = "running",
  None = "",
}


local function is_loaded()
  return vim.g.loaded_copilot == 1
end

local function is_enabled()
  if not is_loaded() then return false end
  if vim.fn["copilot#Enabled"]() == 1 then
    return true
  else
    return false
  end
end


function M:init(options)
  M.super.init(self, options)
  self.inited = false
  self.is_enabled = is_enabled
  self.symbols = symbols
  self.running_agent = is_loaded() and vim.fn['copilot#RunningAgent']() or nil
end

function M:copilot_status()
  local agent = self.running_agent or is_loaded() and vim.fn['copilot#RunningAgent']() or nil
  if not agent then return 'no agent' end
  local requests = agent.requests or {}

  -- requests is dict with number as index, get status from those requests.
  for _, req in pairs(requests) do
    local req_status = req.status
    if req_status == "running" then
      return Status.Running
    end
  end
end

function M:update_status()
  if self.inited then
    if self.is_enabled() then
      -- return symbols.enabled
      local status = self:copilot_status()
      if status == Status.Running then
        return symbols.running
      end
      return symbols.enabled
    else
      return symbols.disabled
    end
  else
    self.inited = true
    return
  end
end

return M
