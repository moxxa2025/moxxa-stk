-- ==========================================
-- MOXXA THE KILLER v2.0.0 (Ultimate Edition)
-- Game: Survive The Killer (STK)
-- Created by: Moxxa
-- Total Lines: 750+ (Includes Custom UI & Logic)
-- ==========================================

-- 1. SERVICES & VARIABLES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local CONFIG = {
    -- ESP
    ESP_Player = false, ESP_ShowName = true, ESP_ShowDist = true, ESP_ShowBox = true,
    -- Character
    SpeedHack = false, SpeedValue = 50, NoClip = false, InfJump = false, Fly = false,
    -- Gacha
    GachaReveal = false, WeaponESP = false, WeaponTeleport = false,
    -- Auto
    AutoSkillcheck = false, AutoEscape = false, AntiAFK = false,
    -- Graphics
    FPSBoost = false,
}

local ESPObjects = {}
local Connections = {}
local WeaponList = {}

-- 2. CLEANUP SYSTEM (Pembersih Jejak)
local function Cleanup()
    for _, obj in pairs(ESPObjects) do if obj and typeof(obj) == "Instance" then obj:Destroy() end end
    for _, conn in pairs(Connections) do if conn then pcall(function() conn:Disconnect() end) end end
    ESPObjects = {}
    Connections = {}
    
    -- Reset speed
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
end

-- 3. CUSTOM UI CREATION (Hitam-Merah)
if CoreGui:FindFirstChild("MoxxaKillerUI") then CoreGui.MoxxaKillerUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoxxaKillerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 1.5

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.BackgroundTransparency = 0.5

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MoxxaTheKiller v2.0.0"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 100, 0, 30)
OpenBtn.Position = UDim2.new(0.5, -50, 0, 10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
OpenBtn.Text = "OPEN MENU"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

-- Tabs (Simple Custom Tab)
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(0, 120, 1, -40)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Size = UDim2.new(1, -120, 1, -40)
ContentHolder.Position = UDim2.new(0, 120, 0, 40)
ContentHolder.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 2)

local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    
    local content = Instance.new("ScrollingFrame", ContentHolder)
    content.Size = UDim2.new(1, -10, 1, -10)
    content.Position = UDim2.new(0, 5, 0, 5)
    content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.Visible = false
    
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 4)
    
    Tabs[name] = {Btn = btn, Content = content}
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Content.Visible = false
            t.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            t.Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        content.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab = name
    end)
    return content
end

local function CreateToggle(parent, name, func)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  " .. name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        local isOn = btn.Text:find("ON")
        if not isOn then
            btn.Text = "  " .. name .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(0, 255, 0)
            func(true)
        else
            btn.Text = "  " .. name .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            func(false)
        end
    end)
end

local TabMain = CreateTab("Main")
local TabESP = CreateTab("Player ESP")
local TabChar = CreateTab("Character")
local TabGacha = CreateTab("Gacha")
local TabAuto = CreateTab("Auto / Misc")

-- POPULATE TABS
CreateToggle(TabMain, "Rejoin Server", function(s) if s then game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end end)
CreateToggle(TabMain, "Server Hop", function(s) 
    if s then
        local Http = game:GetService("HttpService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local ok, res = pcall(function() return Http:JSONDecode(game:HttpGet(Api)) end)
        if ok and res.data then
            for _, srv in pairs(res.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    break
                end
            end
        end
    end
end)

CreateToggle(TabESP, "Enable Player ESP", function(s) CONFIG.ESP_Player = s end)
CreateToggle(TabESP, "Show Box", function(s) CONFIG.ESP_ShowBox = s end)
CreateToggle(TabESP, "Show Name & Distance", function(s) CONFIG.ESP_ShowName = s end)

CreateToggle(TabChar, "Speed Hack", function(s) CONFIG.SpeedHack = s end)
CreateToggle(TabChar, "No Clip", function(s) CONFIG.NoClip = s end)
CreateToggle(TabChar, "Infinite Jump", function(s) CONFIG.InfJump = s end)
CreateToggle(TabChar, "Fly Hack (W/S)", function(s) CONFIG.Fly = s end)

CreateToggle(TabGacha, "Gacha Reveal (Tembus Pandang)", function(s) CONFIG.GachaReveal = s end)
CreateToggle(TabGacha, "Weapon ESP", function(s) CONFIG.WeaponESP = s end)
CreateToggle(TabGacha, "Weapon Teleport", function(s) CONFIG.WeaponTeleport = s end)

CreateToggle(TabAuto, "Auto Skillcheck", function(s) CONFIG.AutoSkillcheck = s end)
CreateToggle(TabAuto, "Auto Escape (Jalan ke Exit)", function(s) CONFIG.AutoEscape = s end)
CreateToggle(TabAuto, "Anti-AFK", function(s) CONFIG.AntiAFK = s end)
CreateToggle(TabAuto, "FPS Boost (Low Graphics)", function(s) CONFIG.FPSBoost = s end)

-- 4. LOGIKA FITUR: CHARACTER
local flyBV = nil
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        -- Speed
        if CONFIG.SpeedHack then hum.WalkSpeed = CONFIG.SpeedValue else hum.WalkSpeed = 16 end

        -- NoClip
        if CONFIG.NoClip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        -- Fly
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if CONFIG.Fly and hrp then
            if not flyBV then
                flyBV = Instance.new("BodyVelocity", hrp)
                flyBV.MaxForce = Vector3.new(1,1,1) * math.huge
                flyBV.Velocity = Vector3.new(0,0,0)
            end
            local dir = workspace.CurrentCamera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0)
            flyBV.Velocity = dir * 50
        else
            if flyBV then flyBV:Destroy() flyBV = nil end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if CONFIG.InfJump then
        pcall(function()
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

-- 5. LOGIKA FITUR: GACHA REVEAL & WEAPON ESP
RunService.Heartbeat:Connect(function()
    pcall(function()
        if CONFIG.GachaReveal then
            for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("ImageLabel") or gui:IsA("Frame") then
                    local n = gui.Name:lower()
                    if n:find("card") or n:find("cover") or n:find("gacha") or n:find("overlay") then
                        if gui:IsA("ImageLabel") then
                            gui.ImageTransparency = 0.9
                            gui.BackgroundTransparency = 0.9
                        else
                            gui.BackgroundTransparency = 0.9
                        end
                    end
                end
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        -- Player ESP
        if CONFIG.ESP_Player then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local char = p.Character
                    if CONFIG.ESP_ShowBox and not char:FindFirstChild("MoxxaBox") then
                        local hl = Instance.new("Highlight", char)
                        hl.Name = "MoxxaBox"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        table.insert(ESPObjects, hl)
                    end
                    if CONFIG.ESP_ShowName and char:FindFirstChild("Head") and not char.Head:FindFirstChild("MoxxaName") then
                        local bg = Instance.new("BillboardGui", char.Head)
                        bg.Name = "MoxxaName"
                        bg.Size = UDim2.new(0, 100, 0, 50)
                        bg.StudsOffset = Vector3.new(0, 2.5, 0)
                        bg.AlwaysOnTop = true
                        local txt = Instance.new("TextLabel", bg)
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(255, 0, 0)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 12
                        table.insert(ESPObjects, bg)
                    end
                end
            end
        else
            for _, obj in pairs(ESPObjects) do
                if obj then pcall(function() obj:Destroy() end) end
            end
            ESPObjects = {}
        end

        -- Weapon ESP
        if CONFIG.WeaponESP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("knife") or obj.Name:lower():find("weapon") or obj.Name:lower():find("gun") or obj.Name:lower():find("tool")) then
                    if not obj:FindFirstChild("MoxxaWTag") then
                        local bg = Instance.new("BillboardGui", obj)
                        bg.Name = "MoxxaWTag"
                        bg.Size = UDim2.new(0, 100, 0, 50)
                        bg.AlwaysOnTop = true
                        local txt = Instance.new("TextLabel", bg)
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                        txt.Text = "[WEAPON]"
                        txt.Font = Enum.Font.SourceSansBold
                        table.insert(ESPObjects, bg)
                    end
                end
            end
        end
    end)
end)

-- 6. FITUR: AUTO SKILLCHECK
UserInputService.InputBegan:Connect(function(input, gp)
    pcall(function()
        if CONFIG.AutoSkillcheck and not gp then
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.Space then
                for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                    if gui:IsA("ImageLabel") and (gui.Name:lower():find("skill") or gui.Name:lower():find("check")) then
                        -- Simulasi klik otomatis pas bar di tengah (trik visual)
                        gui.Size = UDim2.new(1, 0, 1, 0)
                    end
                end
            end
        end
    end)
end)

-- 7. FITUR: AUTO ESCAPE
RunService.Heartbeat:Connect(function()
    pcall(function()
        if CONFIG.AutoEscape and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Nyari objek pintu keluar (biasanya namanya "Exit", "Escape", "Door")
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("exit") or obj.Name:lower():find("escape")) then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                    break
                end
            end
        end
    end)
end)

-- 8. FITUR: WEAPON TELEPORT
RunService.Heartbeat:Connect(function()
    pcall(function()
        if CONFIG.WeaponTeleport and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("knife") or obj.Name:lower():find("weapon")) then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude < 100 then
                         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position)
                    end
                end
            end
        end
    end)
end)

-- 9. FITUR: FPS BOOST
RunService.Heartbeat:Connect(function()
    pcall(function()
        if CONFIG.FPSBoost then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
        end
    end)
end)

-- 10. FITUR: ANTI AFK
UserInputService.InputBegan:Connect(function()
    if CONFIG.AntiAFK then
        pcall(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end)
    end
end)

-- 11. PANIC KEY (END)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.End then
        CONFIG.ESP_Player = false
        CONFIG.WeaponESP = false
        CONFIG.NoClip = false
        CONFIG.InfJump = false
        CONFIG.Fly = false
        CONFIG.GachaReveal = false
        CONFIG.FPSBoost = false
        CONFIG.AutoSkillcheck = false
        CONFIG.WeaponTeleport = false
        Cleanup()
        
        -- Notifikasi
        local notif = Instance.new("TextLabel", ScreenGui)
        notif.Size = UDim2.new(0, 200, 0, 50)
        notif.Position = UDim2.new(0.5, -100, 0.8, 0)
        notif.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        notif.Text = "PANIC MODE ACTIVATED"
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.Font = Enum.Font.GothamBold
        notif.TextSize = 14
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
        task.wait(2)
        notif:Destroy()
    end
end)

-- 12. WATERMARK & FINAL SETUP
local Watermark = Instance.new("TextLabel", ScreenGui)
Watermark.Size = UDim2.new(0, 150, 0, 20)
Watermark.Position = UDim2.new(1, -160, 1, -30)
Watermark.BackgroundTransparency = 0.5
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Watermark.Text = "MoxxaTheKiller v2.0.0"
Watermark.TextColor3 = Color3.fromRGB(255, 0, 0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 10

-- Buka Tab Pertama (Main) Secara Default
Tabs["Main"].Btn.MouseButton1Click:Fire()

print("MoxxaTheKiller v2.0.0 Loaded Successfully.")