-- WARNING this works in LuaJIT but fails in OpenResty; it somehow ignores the path

-- there is no way to find the correct load path / current user from OpenResty
local CODE_PATH = "/Users/tangent/.luarocks/share/lua/5.1/"

local lapis
local success, error_message = pcall(function() return require("lapis") end)

if success then
  lapis = error_message
else
  package.path = package.path .. ";" .. CODE_PATH .. "?.lua;" .. CODE_PATH .. "?/init.lua"
  lapis = require("lapis")
end

lapis.serve("app")
