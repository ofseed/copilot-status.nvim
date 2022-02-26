local M = require("lualine.component"):extend()

local symbols = {
  enabled = "", -- f113
  disabled = "", -- f05e
}

local function is_enabled()
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
end

function M:update_status()
  if self.inited then
    if self.is_enabled() then
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
