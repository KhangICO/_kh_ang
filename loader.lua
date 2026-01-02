--==================================================
--  NOXIGI STYLE LOADER (No Key)
--==================================================

if getgenv()._NOXIGI_LOADED then
    warn("Loader already executed.")
    return
end
getgenv()._NOXIGI_LOADED = true

-- ===== CONFIG =====
getgenv().HubConfig = {
    Version = "1.0.0",
    Game = "Steal a Brainrot",
    MainScript = "https://YOUR_DOMAIN_OR_RAW_LINK/main.lua",
    Timeout = 30, -- seconds
}

-- ===== SERVICES =====
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ===== UTILS =====
local function kick(msg)
    pcall(function()
        LocalPlayer:Kick(msg)
    end)
end

local function notify(title, text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

-- ===== START =====
notify("Noxigi Hub", "Initializing loader...")

-- ===== TIMEOUT PROTECTION =====
task.spawn(function()
    task.wait(getgenv().HubConfig.Timeout)
    if not getgenv()._NOXIGI_MAIN_LOADED then
        kick("Script load timeout\nKick to prevent data loss")
    end
end)

-- ===== LOAD MAIN SCRIPT =====
local success, result = pcall(function()
    return game:HttpGet(getgenv().HubConfig.MainScript)
end)

if not success or not result then
    kick("Failed to fetch main script")
    return
end

local loaded, err = pcall(function()
    loadstring(result)()
end)

if not loaded then
    kick("Main script error:\n" .. tostring(err))
    return
end

getgenv()._NOXIGI_MAIN_LOADED = true
notify("Noxigi Hub", "Loaded successfully ✓")
