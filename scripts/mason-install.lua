-- Headless: install any Mason package from config/tools.lua that isn't present,
-- wait for the installs to finish, and exit non-zero if one failed.
-- Run via `just tools` (which sets NVIM_SKIP_MASON_ENSURE so the config's own
-- startup installer doesn't race this one).
local registry = require("mason-registry")
local want = require("config.tools").mason

local function get(name)
  local ok, pkg = pcall(registry.get_package, name)
  return ok and pkg or nil
end

-- Make sure the registry index exists (first run on a fresh machine).
local need_refresh = false
for _, name in ipairs(want) do
  if not get(name) then need_refresh = true end
end
if need_refresh then
  local done = false
  registry.refresh(function() done = true end)
  vim.wait(120000, function() return done end, 200)
end

local pending, errors = 0, {}
for _, name in ipairs(want) do
  local pkg = get(name)
  if not pkg then
    errors[#errors + 1] = name .. ": not in registry"
  elseif pkg:is_installed() then
    io.write("mason: " .. name .. " ok\n")
  elseif pkg:is_installing() then
    io.write("mason: " .. name .. " already installing, waiting\n")
    pending = pending + 1
    vim.wait(600000, function() return not pkg:is_installing() end, 500)
    pending = pending - 1
  else
    io.write("mason: installing " .. name .. "\n")
    pending = pending + 1
    pkg:install({}, function(success, err)
      if not success then errors[#errors + 1] = name .. ": " .. tostring(err) end
      pending = pending - 1
    end)
  end
end

vim.wait(600000, function() return pending == 0 end, 500)

for _, name in ipairs(want) do
  local pkg = get(name)
  if pkg and not pkg:is_installed() then errors[#errors + 1] = name .. ": not installed after run" end
end

if #errors > 0 then
  io.write("mason: FAILED\n  " .. table.concat(errors, "\n  ") .. "\n")
  os.exit(1)
end
io.write("mason: all " .. #want .. " packages installed\n")
os.exit(0)
