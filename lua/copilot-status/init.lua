local M = {}

---Check if copilot is enabled
---@return boolean
M.is_enabled = function()
  if vim.g.loaded_copilot == 1 and vim.fn["copilot#Enabled"]() == 1 then
    return true
  else
    return false
  end
end

---Show copilot running status
---@return boolean
M.is_running = function()
  local agent = vim.g.loaded_copilot == 1 and vim.fn["copilot#RunningClient"]() or nil
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

return M
