local copilot = require "copilot-status"

local M = require("lualine.component"):extend()

---@class CopilotComponentOptions
---@field on_click function inherit from lualine.component
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

-- Toggle copilot
local function toggle()
  if copilot.get_status() == "enabled" then
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
  if copilot.get_status() == "enabled" then
    -- return symbols.enabled
    if self.show_running and copilot.is_running() then
      return self.symbols.status.running
    end
    return self.symbols.status.enabled
  else
    return self.symbols.status.disabled
  end
end

return M
