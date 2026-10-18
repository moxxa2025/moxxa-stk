-- =====================================================================
-- MOXXA ONLY | THE ULTIMATE EDITION (100% Explicit Code)
-- Game: Survive The Killer (STK)
-- Developer: Moxxa
-- Fitur: ESP, Gacha, Auto Loot Karim, Auto Heal Karim, Auto Locker Karim
-- Deskripsi: Script ini ditulis secara eksplisit baris per baris tanpa
-- library luar (kecuali request internal) untuk memastikan ukuran file
-- besar, tebal, dan tidak ada fitur yang dikurangi.
-- =====================================================================

-- BAGIAN 1: SERVICES (MENGAMBIL LAYANAN DARI ROBLOX)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

-- BAGIAN 2: KONFIGURASI STATE GLOBAL (MENYIMPAN STATUS FITUR)
getgenv().MoxxaConfig = {
    ESP_Enabled = false,
    ESP_ShowRole = true,
    ESP_ShowDist = true,
    ESP_ShowBox = true,
    ESP_HoloColor = "Red",
    
    SpeedHack = false,
    SpeedValue = 50,
    FlyHack = false,
    NoClip = false,
    InfJump = false,
    
    GachaReveal = false,
    
    AutoLoot = false,
    LootDelay = 0.4,
    LootCount = 0,
    
    AutoHeal = false,
    HealDanger = 40,
    
    AutoLocker = false,
    LockerIn = 35,
    LockerOut = 70,
    
    FullBright = false
}

-- BAGIAN 3: VARIABEL PENYIMPAN OBJEK (AGAR BISA DI-CLEANUP)
local ESPObjects = {}
local UI_Tabs = {}
local UI_Elements = {}

-- BAGIAN 4: FUNGSI CLEANUP (MENGHAPUS SEMUA JEJAK SAAT PANIC)
local function CleanupAll()
    -- Hapus semua ESP
    for _, obj in pairs(ESPObjects) do
        if typeof(obj) == "Instance" then
            pcall(function() obj:Destroy() end)
        end
    end
    ESPObjects = {}
    
    -- Reset kecepatan karakter
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
    
    -- Hapus Fly
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local fly = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MoxxaFly")
            if fly then fly:Destroy() end
        end
    end)
end

-- BAGIAN 5: FUNGSI PEMBUAT UI MANUAL (DARI NOL)
if CoreGui:FindFirstChild("MoxxaMainUI") then CoreGui.MoxxaMainUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoxxaMainUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- WATERMARK
local Watermark = Instance.new("TextLabel", ScreenGui)
Watermark.Size = UDim2.new(0, 220, 0, 30)
Watermark.Position = UDim2.new(0, 15, 0, 15)
Watermark.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Watermark.BackgroundTransparency = 0.3
Watermark.Text = "MOXXA ONLY | Ultimate"
Watermark.TextColor3 = Color3.fromRGB(255, 0, 0)
Watermark.Font = Enum.Font.GothamBlack
Watermark.TextSize = 14
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 6)
local wmStroke = Instance.new("UIStroke", Watermark)
wmStroke.Color = Color3.fromRGB(255, 0, 0)
wmStroke.Thickness = 1

-- MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mfStroke = Instance.new("UIStroke", MainFrame)
mfStroke.Color = Color3.fromRGB(255, 0, 0)
mfStroke.Thickness = 2

-- HEADER
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "MOXXA ONLY | ULTIMATE"
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

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 120, 0, 35)
OpenBtn.Position = UDim2.new(0.5, -60, 0, 15)
OpenBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
OpenBtn.Text = "OPEN MOXXA UI"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- TAB BAR (KIRI)
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0, 130, 1, -40)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBar.BorderSizePixel = 0

-- CONTENT AREA (KANAN)
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -130, 1, -40)
ContentArea.Position = UDim2.new(0, 130, 0, 40)
ContentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local TabList = Instance.new("UIListLayout", TabBar)
TabList.Padding = UDim.new(0, 2)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

-- FUNGSI PEMBUAT TAB
local function CreateTab(name, order)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, 0, 0, 35)
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

    UI_Tabs[name] = {Btn = btn, Content = content}

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(UI_Tabs) do
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

-- FUNGSI PEMBUAT TOGGLE SWITCH
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

-- FUNGSI PEMBUAT SLIDER
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
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
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

-- =====================================================================
-- BAGIAN 6: SETUP TAB & FITUR DI DALAMNYA
-- =====================================================================
local TabESP = CreateTab("ESP & Main", 1)
local TabPlayer = CreateTab("Player", 2)
local TabFarm = CreateTab("Farm & Auto", 3)
local TabLocker = CreateTab("Locker", 4)
local TabGacha = CreateTab("Gacha", 5)
local TabSettings = CreateTab("Settings", 6)

-- ISI TAB ESP
CreateToggle(TabESP, "Enable Player ESP", false, function(s) getgenv().MoxxaConfig.ESP_Enabled = s end)
CreateToggle(TabESP, "Show Role (Killer/Survivor)", true, function(s) getgenv().MoxxaConfig.ESP_ShowRole = s end)
CreateToggle(TabESP, "Show Distance", true, function(s) getgenv().MoxxaConfig.ESP_ShowDist = s end)
local KillerLabel = Instance.new("TextLabel", TabESP)
KillerLabel.Size = UDim2.new(1, -10, 0, 30)
KillerLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KillerLabel.Text = "Detected Killer: None"
KillerLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
KillerLabel.Font = Enum.Font.GothamBold
Instance.new("UICorner", KillerLabel).CornerRadius = UDim.new(0, 4)

-- ISI TAB PLAYER
CreateToggle(TabPlayer, "Speed Hack", false, function(s) getgenv().MoxxaConfig.SpeedHack = s end)
CreateSlider(TabPlayer, "Speed Value", 16, 150, 50, function(v) getgenv().MoxxaConfig.SpeedValue = v end)
CreateToggle(TabPlayer, "Fly Hack", false, function(s) getgenv().MoxxaConfig.FlyHack = s end)
CreateToggle(TabPlayer, "No Clip", false, function(s) getgenv().MoxxaConfig.NoClip = s end)

-- ISI TAB FARM (METHOD KARIM)
local LootLabel = Instance.new("TextLabel", TabFarm)
LootLabel.Size = UDim2.new(1, -10, 0, 30)
LootLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LootLabel.Text = "Loot Collected: 0"
LootLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
LootLabel.Font = Enum.Font.GothamBold
Instance.new("UICorner", LootLabel).CornerRadius = UDim.new(0, 4)

CreateToggle(TabFarm, "Auto Loot (FireTouch)", false, function(s) 
    getgenv().MoxxaConfig.AutoLoot = s 
    if s then
        task.spawn(function()
            while getgenv().MoxxaConfig.AutoLoot do
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local target = nil
                    for _, loot in ipairs(CollectionService:GetTagged("Loot")) do
                        if loot:IsDescendantOf(Workspace) then
                            local b = loot:FindFirstChild("Border", true)
                            if b and b:IsA("BasePart") then target = {loot = loot, b = b} break end
                        end
                    end
                    if target then
                        hrp.CFrame = target.b.CFrame + Vector3.new(0, 1.5, 0)
                        pcall(function()
                            firetouchinterest(hrp, target.b, 0)
                            task.wait(0.05)
                            firetouchinterest(hrp, target.b, 1)
                        end)
                        CollectionService:RemoveTag(target.loot, "Loot")
                        getgenv().MoxxaConfig.LootCount = getgenv().MoxxaConfig.LootCount + 1
                        LootLabel.Text = "Loot Collected: " .. getgenv().MoxxaConfig.LootCount
                        task.wait(getgenv().MoxxaConfig.LootDelay)
                    else
                        task.wait(1)
                    end
                else
                    task.wait(0.2)
                end
            end
        end)
    end
end)
CreateSlider(TabFarm, "Loot Delay", 0.1, 1.5, 0.4, function(v) getgenv().MoxxaConfig.LootDelay = v end)

CreateToggle(TabFarm, "Auto Heal Downed Players", false, function(s) 
    getgenv().MoxxaConfig.AutoHeal = s 
    if s then
        task.spawn(function()
            while getgenv().MoxxaConfig.AutoHeal do
                task.wait(0.2)
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local kp = nil
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local isK = false
                                for _, t in pairs(p.Character:GetChildren()) do
                                    if t:IsA("Tool") and (t.Name:lower():find("knife") or t.Name:lower():find("axe")) then isK = true end
                                end
                                pcall(function() if p:GetAttribute("Role") == "Killer" then isK = true end end)
                                if isK then kp = p.Character.HumanoidRootPart.Position break end
                            end
                        end
                        local bestTarget = nil
                        local minD = math.huge
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                local r = p.Character:FindFirstChild("HumanoidRootPart")
                                local h = p.Character:FindFirstChildOfClass("Humanoid")
                                if r and h and h.Health <= 0 then
                                    if (not kp) or (kp - r.Position).Magnitude >= getgenv().MoxxaConfig.HealDanger then
                                        local d = (r.Position - hrp.Position).Magnitude
                                        if d < minD then minD = d bestTarget = r end
                                    end
                                end
                            end
                        end
                        if bestTarget then
                            local gap = (hrp.Position - bestTarget.Position).Magnitude
                            if gap > 30 then
                                hrp.CFrame = bestTarget.CFrame + Vector3.new(0, 2, 0)
                            elseif gap > 3.5 then
                                local desired = bestTarget.Position - hrp.Position
                                local flat = Vector3.new(desired.X, 0, desired.Z)
                                if flat.Magnitude > 0.5 then
                                    local dir = flat.Unit
                                    local step = dir * math.min(26 * 0.1, flat.Magnitude)
                                    local newPos = hrp.Position + step
                                    hrp.CFrame = CFrame.lookAt(newPos, bestTarget.Position)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end)
CreateSlider(TabFarm, "Heal Danger Distance", 20, 80, 40, function(v) getgenv().MoxxaConfig.HealDanger = v end)

-- ISI TAB LOCKER (METHOD KARIM)
CreateToggle(TabLocker, "Auto Locker (Hide)", false, function(s) getgenv().MoxxaConfig.AutoLocker = s end)
CreateSlider(TabLocker, "Hide within (Studs)", 15, 80, 35, function(v) getgenv().MoxxaConfig.LockerIn = v end)
CreateSlider(TabLocker, "Come out beyond (Studs)", 30, 150, 70, function(v) getgenv().MoxxaConfig.LockerOut = v end)

-- ISI TAB GACHA
CreateToggle(TabGacha, "Gacha Reveal (Tembus Pandang)", false, function(s) getgenv().MoxxaConfig.GachaReveal = s end)

-- ISI TAB SETTINGS
CreateToggle(TabSettings, "Full Bright", false, function(s) 
    if s then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 3
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.Brightness = 1
    end
end)

local PanicBtn = Instance.new("TextButton", TabSettings)
PanicBtn.Size = UDim2.new(1, -10, 0, 40)
PanicBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
PanicBtn.Text = "🚨 PANIC KEY (DISABLE ALL) 🚨"
PanicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PanicBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", PanicBtn).CornerRadius = UDim.new(0, 6)
PanicBtn.MouseButton1Click:Connect(function()
    for k, v in pairs(getgenv().MoxxaConfig) do if type(v) == "boolean" then getgenv().MoxxaConfig[k] = false end end
    CleanupAll()
end)

-- =====================================================================
-- BAGIAN 7: LOGIKA BERJALAN (BACKGROUND LOOPS)
-- =====================================================================

-- 7.1 AUTO LOCKER LOOP
local lockerCache, lockerStamp = {}, 0
local function getLockers(force)
    local now = tick()
    if not force and now - lockerStamp < 0.25 and lockerCache then return lockerCache end
    local out = {}
    for _, l in ipairs(CollectionService:GetTagged("Locker")) do
        if l and l:IsA("Model") and l.PrimaryPart then
            table.insert(out, {model = l, pos = l.PrimaryPart.Position})
        end
    end
    lockerCache, lockerStamp = out, now
    return out
end

local function myLocker()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    for _, lk in ipairs(getLockers()) do
        if (char.HumanoidRootPart.Position - lk.pos).Magnitude < 5 then return lk end
    end
    return nil
end

local function enterSafestLocker()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or myLocker() then return false end
    local closestLk = nil
    local minDist = 999
    for _, lk in ipairs(getLockers(true)) do
        local dist = (hrp.Position - lk.pos).Magnitude
        if dist < minDist and dist < 50 then minDist = dist closestLk = lk end
    end
    if closestLk then hrp.CFrame = CFrame.new(closestLk.pos) return true end
    return false
end

local function exitMyLocker()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
end

RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().MoxxaConfig.AutoLocker then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local kp = nil
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local isK = false
                    for _, t in pairs(p.Character:GetChildren()) do
                        if t:IsA("Tool") and (t.Name:lower():find("knife") or t.Name:lower():find("axe")) then isK = true end
                    end
                    pcall(function() if p:GetAttribute("Role") == "Killer" then isK = true end end)
                    if isK then kp = p.Character.HumanoidRootPart.Position break end
                end
            end

            local lk = myLocker()
            if lk then
                if (not kp) or (kp - hrp.Position).Magnitude > getgenv().MoxxaConfig.LockerOut then pcall(exitMyLocker) end
            else
                if kp and (kp - hrp.Position).Magnitude < getgenv().MoxxaConfig.LockerIn then pcall(enterSafestLocker) end
            end
        end
    end)
end)

-- 7.2 ESP & KILLER LOOP
RunService.Heartbeat:Connect(function()
    pcall(function()
        local detectedKillerName = "None"
        if getgenv().MoxxaConfig.ESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local char = p.Character
                    local head = char.Head
                    local isKiller = false
                    local roleText = "Survivor"
                    
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("axe")) then isKiller = true end
                    end
                    pcall(function() if p:GetAttribute("Role") == "Killer" then isKiller = true end end)
                    if isKiller then roleText = "KILLER" detectedKillerName = p.Name end

                    local finalColor = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)

                    if not char:FindFirstChild("MoxxaBox") then
                        local hl = Instance.new("Highlight", char)
                        hl.Name = "MoxxaBox"
                        hl.FillColor = finalColor
                        hl.OutlineColor = Color3.fromRGB(255,255,255)
                        table.insert(ESPObjects, hl)
                    else
                        char.MoxxaBox.FillColor = finalColor
                    end

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
                        tag.TagText.TextColor3 = finalColor
                    end
                end
            end
        else
            for _, obj in pairs(ESPObjects) do if obj then pcall(function() obj:Destroy() end) end end
            ESPObjects = {}
        end
        if detectedKillerName ~= "None" then KillerLabel.Text = "Detected Killer: " .. detectedKillerName else KillerLabel.Text = "Detected Killer: None" end
    end)
end)

-- 7.3 GACHA REVEAL LOOP
RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().MoxxaConfig.GachaReveal then
            for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("ImageLabel") or gui:IsA("Frame") then
                    local n = gui.Name:lower()
                    if n:find("card") or n:find("cover") or n:find("gacha") then
                        if gui:IsA("ImageLabel") then gui.ImageTransparency = 0.8 else gui.BackgroundTransparency = 0.8 end
                    end
                end
            end
        end
    end)
end)

-- 7.4 PLAYER MODIFIER LOOP
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        hum.WalkSpeed = getgenv().MoxxaConfig.SpeedHack and getgenv().MoxxaConfig.SpeedValue or 16

        if getgenv().MoxxaConfig.NoClip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if getgenv().MoxxaConfig.FlyHack and hrp then
            if not hrp:FindFirstChild("MoxxaFly") then
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Name = "MoxxaFly"
                bv.MaxForce = Vector3.new(1,1,1) * math.huge
            end
            local dir = workspace.CurrentCamera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0)
            hrp.MoxxaFly.Velocity = dir * 50
        else
            if hrp and hrp:FindFirstChild("MoxxaFly") then hrp.MoxxaFly:Destroy() end
        end
    end)
end)

-- SET TAB PERTAMA KEBUKA
UI_Tabs["ESP & Main"].Btn.MouseButton1Click:Fire()

print("MOXXA ONLY (Ultimate Edition) Loaded.")