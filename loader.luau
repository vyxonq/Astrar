--[[
    Author: @iamvyxon
    GitHub: https://github.com/iamvyxon
]]

local Loader = {}
Loader.__index = Loader

function Loader.new(cfg)
    local self = setmetatable({}, Loader)
    self.cfg = cfg
    local fluentOk, fluentLib = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    if not fluentOk or not fluentLib then
        warn("[Script Loader] Failed to load Fluent UI library!")
        return self
    end
    self.libs = { Fluent = fluentLib }
    print("[Script Loader] Fluent UI loaded successfully.")
    self:_initUI()
    return self
end

function Loader:_initUI()
    if not self.libs.Fluent then
        warn("[Script Loader] Fluent UI not available, cannot create window.")
        return
    end
    local win = self.libs.Fluent:CreateWindow(self.cfg.Window)
    if not win then
        warn("[Script Loader] Failed to create Fluent window.")
        return
    end
    self.window = win
    self.tabs = {
        Scripts = win:AddTab({ Title = "Scripts", Icon = "list" }),
        Info = win:AddTab({ Title = "Info", Icon = "info" })
    }
    print("[Script Loader] Tabs created.")
    self:_addScriptButtons()
    self:_addInfo()
end

function Loader:_addScriptButtons()
    local scripts = self.cfg.Scripts
    for i = 1, #scripts do
        local script = scripts[i]
        self.tabs.Scripts:AddButton({
            Title = script.Name,
            Description = "Click to load " .. script.Name,
            Tooltip = script.Url,
            Callback = function()
                self:_loadScript(script.Url)
            end
        })
    end
end

function Loader:_loadScript(url)
    self.libs.Fluent:Notify({ Title = "Loading...", Content = url, Duration = 3 })
    if self.window and self.window.Destroy then
        self.window:Destroy()
    end
    if self.libs.Fluent and self.libs.Fluent.Unload then
        self.libs.Fluent:Unload()
    end
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then
        warn("[Script Loader Error]", err)
    end
end

function Loader:_addInfo()
    self.tabs.Info:AddParagraph({
        Title = "About",
        Content = "Script Loader by @iamvyxon\nGitHub: https://github.com/iamvyxon\n\nSelect a script from the Scripts tab. Confirm before loading. Loader UI will close after loading."
    })
end

local Config = {
    Window = {
        Title = "Script Loader",
        SubTitle = "by @Vyxon",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    },
    Scripts = {
        {
            Name = "Astrar Public",
            Url = "https://raw.githubusercontent.com/iamvyxon/Astrar-Public/refs/heads/main/src/Muscle%20Legends/Astrar-Public.lua"
        },
        {
            Name = "Astrar V1",
            Url = "https://raw.githubusercontent.com/iamVyxon/Astrar/refs/heads/main/src/loader.lua"
        }
    }
}

Loader.new(Config)
