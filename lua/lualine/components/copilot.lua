local copilot = require "copilot-status"

local M = require("lualine.component"):extend()

---@class CopilotComponentOptions
---@field on_click function inherit from lualine.component
local default_options = {
  symbols = {
    status = {
      enabled = " ",
      disabled = " ",
    },
    spinners = require("copilot-status.spinners").dots,
  },
  show_running = true,
}

local spinner_count = 1

---Return a spinner from the list of spinners
---@param spinners table
---@return string
local function get_spinner(spinners)
  local spinner = spinners[spinner_count]
  spinner_count = spinner_count + 1
  if spinner_count > #spinners then
    spinner_count = 1
  end
  return spinner
end

---Initialize component
---@override
---@param options CopilotComponentOptions
function M:init(options)
  -- Setup click handler
  options.on_click = function()
    if copilot.get_status() == "enabled" then
      vim.b.copilot_enabled = 0
    else
      vim.b.copilot_enabled = nil
    end
  end

  M.super.init(self, options)

  -- For backwards compatibility
  if options.symbols then
    if options.symbols.enabled then
      options.symbols.status = options.symbols.status or {}
      options.symbols.status.enabled = options.symbols.enabled
    end
    if options.symbols.disabled then
      options.symbols.status = options.symbols.status or {}
      options.symbols.status.disabled = options.symbols.disabled
    end
  end

  self.options = vim.tbl_deep_extend("force", default_options, options or {})
end

---@override
function M:update_status()
  if copilot.get_status() == "enabled" then
    -- return symbols.enabled
    if self.options.show_running and copilot.is_running() then
      return get_spinner(self.options.symbols.spinners)
    end
    return self.options.symbols.status.enabled
  else
    return self.options.symbols.status.disabled
  end
end

return M
