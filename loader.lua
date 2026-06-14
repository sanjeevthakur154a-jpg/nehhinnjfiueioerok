--[[
    ================================================================
    [ UNIVERSAL SUN HUB - SIMPLE LUA OBFUSCATOR ]
    A lightweight, pure-Lua obfuscator designed to run on any standard 
    Lua environment. It secures string literals using byte-escapes 
    and minifies code structure to make it harder to read.
    ================================================================
]]

local Obfuscator = {}

-- Helper to convert a string into a byte-escaped string format
local function encryptString(str)
    local escaped = {}
    for i = 1, #str do
        table.insert(escaped, "\\" .. string.byte(str, i))
    end
    return '"' .. table.concat(escaped) .. '"'
end

-- Simple obfuscation function
function Obfuscator.obfuscate(code)
    -- 1. Strip single line comments (except URLs or HTTP requests)
    -- We do a basic replacement of comments that don't look like URLs
    code = code:gsub("%-%-%s-[^\n]*", function(comment)
        if comment:find("http") or comment:find("://") then
            return comment -- Keep comments containing links to avoid breaking HttpGet
        end
        return ""
    end)

    -- 2. Convert string literals to byte-escaped format
    -- Matches both double-quoted and single-quoted strings
    code = code:gsub('"(.-)"', function(str)
        return encryptString(str)
    end)
    code = code:gsub("'(.-)'", function(str)
        return encryptString(str)
    end)

    -- 3. Minify spacing (remove duplicate newlines and excessive spaces)
    code = code:gsub("\r", "")
    code = code:gsub("\n%s*\n", "\n")
    
    return code
end

-- Main runner
local inputPath = "C:\\Users\\Sanjeev\\Documents\\roblox\\key system\\key.lua"
local outputPath = "C:\\Users\\Sanjeev\\Documents\\roblox\\key system\\key_obfuscated.lua"

local file = io.open(inputPath, "r")
if not file then
    print("Error: Could not open input file key.lua")
    return
end

local content = file:read("*all")
file:close()

print("Obfuscating key.lua...")
local obfuscatedContent = Obfuscator.obfuscate(content)

local outFile = io.open(outputPath, "w")
if outFile then
    outFile:write(obfuscatedContent)
    outFile:close()
    print("Successfully generated obfuscated script: key_obfuscated.lua")
else
    print("Error: Could not write obfuscated file.")
end
