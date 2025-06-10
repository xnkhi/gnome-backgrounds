#!/bin/lua
-- Development purposes only

local function SplitString(str, splitChar)
	local resultSplit = {}
	if splitChar == nil then
		splitChar = " "
	end
	if str and splitChar then
		for part in string.gmatch(str, "([^"..splitChar.."]+)") do
			table.insert(resultSplit, part)
		end
	end
	return resultSplit
end

local function retrieveFileName(file)
    return SplitString(file, ".")[1]
end

os.execute("rm backgrounds/*.xml.in")
os.execute("ls backgrounds/ > logs")

local logs = io.open("logs", "r")
local content = logs:read("*a")
local files = SplitString(content, "\n")
io.close(logs)

for _,file in ipairs(files) do
    if file ~= "meson.build" then
        local filename = retrieveFileName(file)
    print(file .. "  |  " .. filename)
    local xml = string.format([[<?xml version="1.0"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>%s</name>
    <filename>@BACKGROUNDDIR@/%s</filename>
    <filename-dark>@BACKGROUNDDIR@/%s</filename-dark>
    <options>zoom</options>
    <shade_type>solid</shade_type>
    <pcolor>#000000</pcolor>
    <scolor>#000000</scolor>
  </wallpaper>
</wallpapers>]], filename, file, file)
    local xmlfile = io.open("backgrounds/" .. filename .. ".xml.in", "w")
    xmlfile:write(xml)
    io.close(xmlfile)
    end
    
end