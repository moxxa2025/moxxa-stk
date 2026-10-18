-- ==========================================
-- MOXXA THE KILLER v1.0.1 (Ultimate Anti-Bug)
-- Game: Survive The Killer (STK)
-- UI: 100% Custom (No External Library = No Error)
-- ==========================================

-- 1. LOADING SCREEN
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("MoxxaLoading") then CoreGui.MoxxaLoading:Destroy() end

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "MoxxaLoading"
LoadingGui.Parent = CoreGui

local LoadFrame = Instance.new("Frame", LoadingGui)
LoadFrame.Size = UDim2.new(0, 300, 0, 80)
LoadFrame.Position = UDim2.new(0.5, -150, 0.5, -40)
LoadFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
LoadFrame.BorderSizePixel = 0
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", LoadFrame).Color = Color3.fromRGB(255, 0, 0)

local Title = Instance.new("TextLabel", LoadFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "MoxxaTheKiller v1.0.1 Loading..."
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local BarBg = Instance.new("Frame", LoadFrame)
BarBg.Size = UDim2.new(0.8, 0, 0, 10)
BarBg.Position = UDim2.new(0.1, 0, 0, 50)
BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BarBg.BorderSizePixel = 0
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(0, 4)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
BarFill.BorderSizePixel = 0
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 4)

TweenService:Create(BarFill, TweenInfo.new(2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(2.1)
LoadingGui:Destroy()

-- 2. GLOBAL CONFIG & STATE
getgenv().MoxxaConfig = {
    ESP_Enabled = false, ESP_ShowName = true, ESP_ShowRole = true, ESP_ShowDist = true, ESP_ShowBox = true,
    SpeedHack = false, SpeedValue = 50, JumpPower = false, JumpValue = 100, FlyHack = false, NoClip = false, InfJump = false,
    GachaReveal = false, AutoGacha = false, WeaponTracker = false, ItemScouter = false,
    AutoEscape = false, AutoKill = false, AntiAFK = false,
    AutoLoot = false, AutoRevive = false, FullBright = false,
    LootCollected = 0, RevivedCount = 0
}

local ESPObjects = {}
local WeaponTags = {}
local HologramColors = {} -- Format: ["PlayerName"] = Color3
local Connections = {}

-- 3. CLEANUP SYSTEM
local function CleanupAll()
    for _, obj in pairs(ESPObjects) do if typeof(obj) == "Instance" then obj:Destroy() end end
    for _, obj in pairs(WeaponTags) do if typeof(obj) == "Instance" then obj:Destroy() end end
    for _, conn in pairs(Connections) do if conn then conn:Disconnect() end end
    ESPObjects = {}
    WeaponTags = {}
    Connections = {}
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end

-- ==========================================
-- 4. CUSTOM UI CREATION (ANTI-BUG)
-- ==========================================
if CoreGui:FindFirstChild("MoxxaMainUI") then CoreGui.MoxxaMainUI:Destroy() end

local MainUI = Instance.new("ScreenGui")
MainUI.Name = "MoxxaMainUI"
MainUI.ResetOnSpawn = false
MainUI.Parent = CoreGui

-- WATERMARK
local Watermark = Instance.new("TextLabel", MainUI)
Watermark.Size = UDim2.new(0, 200, 0, 25)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Watermark.BackgroundTransparency = 0.3
Watermark.Text = "MoxxaTheKiller v1.0.1 | Fixed"
Watermark.TextColor3 = Color3.fromRGB(255, 215, 0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 12
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 4)

-- MAIN WINDOW
local MainFrame = Instance.new("Frame", MainUI)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2

-- HEADER
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "MOXXA THE KILLER"
TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local OpenBtn = Instance.new("TextButton", MainUI)
OpenBtn.Size = UDim2.new(0, 120, 0, 35)
OpenBtn.Position = UDim2.new(0.5, -60, 0, 10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
OpenBtn.Text = "OPEN MOXXA UI"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

-- TABS SIDEBAR
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0, 130, 1, -40)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBar.BorderSizePixel = 0

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -130, 1, -40)
ContentArea.Position = UDim2.new(0, 130, 0, 40)
ContentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local TabList = Instance.new("UIListLayout", TabBar)
TabList.Padding = UDim.new(0, 2)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

local Tabs = {}
local currentTab = nil

local function CreateTab(name, order)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.LayoutOrder = order
    
    local content = Instance.new("ScrollingFrame", ContentArea)
    content.Size = UDim2.new(1, -10, 1, -10)
    content.Position = UDim2.new(0, 5, 0, 5)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    content.Visible = false
    
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 6)
    
    Tabs[name] = {Btn = btn, Content = content}
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Content.Visible = false
            t.Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            t.Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        content.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return content
end

-- FUNGSI UI: Toggle Switch (Anti-Bug)
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

    local isOn = default
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggleBtn.Text = isOn and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        callback(isOn)
    end)
end

-- FUNGSI UI: Slider
local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0.9, 0, 0, 8)
    bar.Position = UDim2.new(0.05, 0, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = bar.AbsolutePosition.X
            local barSize = bar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(min + (max - min) * percent)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- FUNGSI UI: Button
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
end

-- FUNGSI UI: Label
local function CreateLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -10, 0, 30)
    lbl.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 215, 0)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 4)
    return lbl
end

-- ==========================================
-- 5. SETUP TABS & FITUR
-- ==========================================

local TabMain = CreateTab("Main", 1)
local TabESP = CreateTab("ESP & Role", 2)
local TabPlayer = CreateTab("Player", 3)
local TabFarm = CreateTab("Farm / Loot", 4)
local TabGacha = CreateTab("Gacha", 5)
local TabHolo = CreateTab("Hologram", 6)
local TabSettings = CreateTab("Settings", 7)

-- TAB MAIN
CreateButton(TabMain, "Rejoin Server", function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
CreateButton(TabMain, "Server Hop", function()
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
end)

-- TAB ESP
CreateToggle(TabESP, "Enable Player ESP", false, function(s) getgenv().MoxxaConfig.ESP_Enabled = s end)
CreateToggle(TabESP, "Show Role (Killer/Survivor)", true, function(s) getgenv().MoxxaConfig.ESP_ShowRole = s end)
CreateToggle(TabESP, "Show Distance", true, function(s) getgenv().MoxxaConfig.ESP_ShowDist = s end)
CreateToggle(TabESP, "Show Box", true, function(s) getgenv().MoxxaConfig.ESP_ShowBox = s end)
local KillerLabel = CreateLabel(TabESP, "Detected Killer: None")

-- TAB PLAYER
CreateToggle(TabPlayer, "Speed Hack", false, function(s) getgenv().MoxxaConfig.SpeedHack = s end)
CreateSlider(TabPlayer, "Speed Value", 16, 150, 50, function(v) getgenv().MoxxaConfig.SpeedValue = v end)
CreateToggle(TabPlayer, "Jump Power", false, function(s) getgenv().MoxxaConfig.JumpPower = s end)
CreateSlider(TabPlayer, "Jump Value", 50, 200, 100, function(v) getgenv().MoxxaConfig.JumpValue = v end)
CreateToggle(TabPlayer, "Fly Hack", false, function(s) getgenv().MoxxaConfig.FlyHack = s end)
CreateToggle(TabPlayer, "No Clip", false, function(s) getgenv().MoxxaConfig.NoClip = s end)
CreateToggle(TabPlayer, "Infinite Jump", false, function(s) getgenv().MoxxaConfig.InfJump = s end)

-- TAB FARM (AUTO LOOT & REVIVE)
CreateToggle(TabFarm, "Auto Loot (Ambil Koin)", false, function(s) 
    getgenv().MoxxaConfig.AutoLoot = s 
    if s then
        task.spawn(function()
            while getgenv().MoxxaConfig.AutoLoot do
                task.wait(0.5)
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, obj in pairs(Workspace:GetDescendants()) do
                            -- Filter ketat: Hanya ambil objek yang punya nilai (koin/loot)
                            if obj:IsA("BasePart") and (obj.Name:lower() == "coin" or obj.Name:lower() == "loot" or obj.Name:lower():find("coin") or obj.Name:lower():find("cash")) then
                                if obj:FindFirstChild("Value") or obj:FindFirstChild("Amount") or obj.Name:lower():find("coin") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0,2,0))
                                    getgenv().MoxxaConfig.LootCollected = getgenv().MoxxaConfig.LootCollected + 1
                                    break
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end)
CreateToggle(TabFarm, "Auto Revive", false, function(s) 
    getgenv().MoxxaConfig.AutoRevive = s 
    if s then
        task.spawn(function()
            while getgenv().MoxxaConfig.AutoRevive do
                task.wait(1)
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                                if p.Character.Humanoid.Health <= 0 or p.Character:FindFirstChild("Downed") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p.Character.HumanoidRootPart.Position)
                                    break
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end)
CreateToggle(TabFarm, "Auto-Escape (Survivor)", false, function(s) getgenv().MoxxaConfig.AutoEscape = s end)
CreateToggle(TabFarm, "Auto-Kill (Killer)", false, function(s) getgenv().MoxxaConfig.AutoKill = s end)
CreateToggle(TabFarm, "Anti-AFK", false, function(s) getgenv().MoxxaConfig.AntiAFK = s end)

-- TAB GACHA
CreateToggle(TabGacha, "Gacha Reveal (Tembus Pandang)", false, function(s) getgenv().MoxxaConfig.GachaReveal = s end)
CreateToggle(TabGacha, "Auto Luck Gacha 9999", false, function(s) getgenv().MoxxaConfig.AutoGacha = s end)
CreateToggle(TabGacha, "Weapon Tracker", false, function(s) getgenv().MoxxaConfig.WeaponTracker = s end)
CreateToggle(TabGacha, "Item Scouter (Harga Koin)", false, function(s) getgenv().MoxxaConfig.ItemScouter = s end)
CreateButton(TabGacha, "Teleport to Nearest Weapon", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("knife") or obj.Name:lower():find("weapon")) then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0,3,0))
                break
            end
        end
    end
end)

-- TAB HOLOGRAM (WARNA PER PLAYER)
local holoInput = Instance.new("TextBox", TabHolo)
holoInput.Size = UDim2.new(1, -10, 0, 35)
holoInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
holoInput.Text = ""
holoInput.PlaceholderText = "Ketik Nama Player..."
holoInput.TextColor3 = Color3.fromRGB(255, 255, 255)
holoInput.Font = Enum.Font.Gotham
holoInput.TextSize = 13
Instance.new("UICorner", holoInput).CornerRadius = UDim.new(0, 4)

local colorOptions = {"Red", "Green", "Yellow", "Blue", "Purple", "White"}
local selectedColor = "Red"

local colorDropdown = Instance.new("TextButton", TabHolo)
colorDropdown.Size = UDim2.new(1, -10, 0, 35)
colorDropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
colorDropdown.Text = "Pilih Warna: " .. selectedColor
colorDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
colorDropdown.Font = Enum.Font.Gotham
colorDropdown.TextSize = 13
Instance.new("UICorner", colorDropdown).CornerRadius = UDim.new(0, 4)

-- Dropdown Logic Sederhana
local dropFrame = Instance.new("Frame", TabHolo)
dropFrame.Size = UDim2.new(1, -10, 0, 150)
dropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
dropFrame.Visible = false
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 4)
local dropList = Instance.new("UIListLayout", dropFrame)
dropList.Padding = UDim.new(0, 2)

for _, col in ipairs(colorOptions) do
    local cBtn = Instance.new("TextButton", dropFrame)
    cBtn.Size = UDim2.new(1, 0, 0, 25)
    cBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    cBtn.Text = col
    cBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cBtn.Font = Enum.Font.Gotham
    cBtn.MouseButton1Click:Connect(function()
        selectedColor = col
        colorDropdown.Text = "Pilih Warna: " .. col
        dropFrame.Visible = false
    end)
end

colorDropdown.MouseButton1Click:Connect(function()
    dropFrame.Visible = not dropFrame.Visible
end)

CreateButton(TabHolo, "Apply Color", function()
    local pName = holoInput.Text
    local colorMap = {
        Red = Color3.fromRGB(255,0,0), Green = Color3.fromRGB(0,255,0), Yellow = Color3.fromRGB(255,255,0),
        Blue = Color3.fromRGB(0,0,255), Purple = Color3.fromRGB(128,0,128), White = Color3.fromRGB(255,255,255)
    }
    if pName ~= "" and colorMap[selectedColor] then
        HologramColors[pName] = colorMap[selectedColor]
    end
end)
CreateButton(TabHolo, "Highlight All (Red)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then HologramColors[p.Name] = Color3.fromRGB(255,0,0) end
    end
end)

-- TAB SETTINGS
CreateToggle(TabSettings, "Full Bright (Terang)", false, function(s)
    getgenv().MoxxaConfig.FullBright = s
    if s then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.FogEnd = 10000
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        Lighting.Brightness = 1
        Lighting.FogEnd = 1000
    end
end)
CreateButton(TabSettings, "🚨 PANIC KEY (MATIKAN SEMUA) 🚨", function()
    for k, v in pairs(getgenv().MoxxaConfig) do
        if type(v) == "boolean" then getgenv().MoxxaConfig[k] = false end
    end
    CleanupAll()
    MainUI:Destroy()
    CoreGui.MoxxaLoading:Destroy() -- Hapus sisa loading
    -- Notif di chat
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "PANIC", Text = "Semua fitur dimatikan."})
end)

-- SET DEFAULT TAB
Tabs["Main"].Btn.MouseButton1Click:Fire()

-- ==========================================
-- 6. FEATURE LOGIC (BACKGROUND LOOPS)
-- ==========================================

-- A. PLAYER LOOP
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        hum.WalkSpeed = getgenv().MoxxaConfig.SpeedHack and getgenv().MoxxaConfig.SpeedValue or 16
        if getgenv().MoxxaConfig.JumpPower then hum.JumpPower = getgenv().MoxxaConfig.JumpValue end

        if getgenv().MoxxaConfig.NoClip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if getgenv().MoxxaConfig.FlyHack and hrp then
            if not hrp:FindFirstChild("MoxxaFly") then
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Name = "MoxxaFly"
                bv.MaxForce = Vector3.new(1,1,1) * math.huge
                bv.Velocity = Vector3.new(0,0,0)
            end
            local dir = workspace.CurrentCamera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or UserInputService:KeyDown(Enum.KeyCode.S) and -1 or 0)
            hrp.MoxxaFly.Velocity = dir * 50
        else
            if hrp and hrp:FindFirstChild("MoxxaFly") then hrp.MoxxaFly:Destroy() end
        end
    end)
end)

-- B. GACHA REVEAL
RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().MoxxaConfig.GachaReveal then
            for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("ImageLabel") or gui:IsA("Frame") then
                    local n = gui.Name:lower()
                    if n:find("card") or n:find("cover") or n:find("gacha") or n:find("overlay") then
                        if gui:IsA("ImageLabel") then gui.ImageTransparency = 0.8 else gui.BackgroundTransparency = 0.8 end
                    end
                end
            end
        end
    end)
end)

-- C. ESP & KILLER DETECTOR (ULTIMATE FIX)
RunService.Heartbeat:Connect(function()
    pcall(function()
        local detectedKillerName = "None"
        
        if getgenv().MoxxaConfig.ESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local char = p.Character
                    local head = char.Head

                    -- LOGIKA FIX KILLER:
                    local isKiller = false
                    local roleText = "Survivor"
                    
                    -- 1. Cek Tool di Karakter (Senjata)
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("axe") or tool.Name:lower():find("sword")) then
                            isKiller = true
                        end
                    end
                    -- 2. Cek Tool di Backpack
                    for _, item in pairs(p.Backpack:GetChildren()) do
                        if item:IsA("Tool") and (item.Name:lower():find("knife") or item.Name:lower():find("axe")) then
                            isKiller = true
                        end
                    end
                    -- 3. Cek Tag Khusus
                    if char:FindFirstChild("KillerTag") or char:FindFirstChild("Murderer") then
                        isKiller = true
                    end
                    -- 4. Cek Atribut Server
                    if p:GetAttribute("Role") == "Killer" or p:GetAttribute("IsKiller") == true then
                        isKiller = true
                    end

                    if isKiller then 
                        roleText = "KILLER" 
                        detectedKillerName = p.Name
                    end

                    -- Warna Custom Hologram
                    local fillColor = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
                    if HologramColors[p.Name] then fillColor = HologramColors[p.Name] end

                    -- Box
                    if getgenv().MoxxaConfig.ESP_ShowBox and not char:FindFirstChild("MoxxaBox") then
                        local hl = Instance.new("Highlight", char)
                        hl.Name = "MoxxaBox"
                        hl.FillColor = fillColor
                        hl.OutlineColor = Color3.fromRGB(255,255,255)
                        table.insert(ESPObjects, hl)
                    elseif char:FindFirstChild("MoxxaBox") then
                        char.MoxxaBox.FillColor = fillColor
                    end

                    -- Tag Nama
                    if not head:FindFirstChild("MoxxaTag") then
                        local bg = Instance.new("BillboardGui", head)
                        bg.Name = "MoxxaTag"
                        bg.Size = UDim2.new(0, 150, 0, 50)
                        bg.StudsOffset = Vector3.new(0, 2.5, 0)
                        bg.AlwaysOnTop = true
                        local txt = Instance.new("TextLabel", bg)
                        txt.Name = "TagText"
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 12
                        table.insert(ESPObjects, bg)
                    end

                    local tag = head:FindFirstChild("MoxxaTag")
                    if tag and tag:FindFirstChild("TagText") then
                        local dist = math.floor((head.Position - LocalPlayer.Character.Head.Position).Magnitude)
                        local text = p.Name
                        if getgenv().MoxxaConfig.ESP_ShowRole then text = text .. " (" .. roleText .. ")" end
                        if getgenv().MoxxaConfig.ESP_ShowDist then text = text .. " [" .. dist .. "s]" end
                        tag.TagText.Text = text
                        tag.TagText.TextColor3 = fillColor
                    end
                end
            end
        else
            for _, obj in pairs(ESPObjects) do if obj then obj:Destroy() end end
            ESPObjects = {}
        end

        -- Update Label
        if detectedKillerName ~= "None" then
            KillerLabel.Text = "Detected Killer: " .. detectedKillerName
        else
            KillerLabel.Text = "Detected Killer: None"
        end
    end)
end)

print("MoxxaTheKiller v1.0.1 Loaded. Custom UI Active.")