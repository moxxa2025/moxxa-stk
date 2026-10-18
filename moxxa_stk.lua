-- ==========================================
-- MOXXA THE KILLER v2.0 | PREMIUM
-- Game: Survive The Killer (STK)
-- UI Library: Rayfield (Aesthetic, Anti-Bug)
-- ==========================================

-- 1. LOADING SCREEN ANIMATION
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

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

local Title = Instance.new("TextLabel", LoadFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "MoxxaTheKiller Loading..."
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

TweenService:Create(BarFill, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(1.6)
LoadingGui:Destroy()

-- 2. LOAD RAYFIELD LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 3. SERVICES & VARIABLES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- GLOBAL STATE (Anti-Bug)
getgenv().MoxxaConfig = {
    ESP_Enabled = false, ESP_Role = true, ESP_Dist = true, ESP_Box = true,
    SpeedHack = false, SpeedVal = 50,
    JumpPower = false, JumpVal = 100,
    Fly = false,
    NoClip = false,
    InfJump = false,
    AutoGacha = false,
    WeaponTracker = false,
    AutoEscape = false,
    AutoKill = false,
    AntiAFK = false
}

local ESPObjects = {}
local Connections = {}
local WeaponList = {}

-- CLEANUP FUNCTION
local function Cleanup()
    for _, obj in pairs(ESPObjects) do if obj and typeof(obj) == "Instance" then obj:Destroy() end end
    for _, conn in pairs(Connections) do if conn then conn:Disconnect() end end
    ESPObjects = {}
    Connections = {}
end

-- 4. UI CREATION (RAYFIELD)
local Window = Rayfield:CreateWindow({
   Name = "MoxxaTheKiller v2.0 | Premium",
   LoadingTitle = "Initializing Moxxa Hub...",
   LoadingSubtitle = "by Moxxa",
   ConfigurationSaving = {Enabled = true, FolderName = "MoxxaSTK", FileName = "Config"},
   KeySystem = false,
   Theme = "Blood", -- Tema merah/hitam bawaan Rayfield
})

-- ==========================================
-- TAB 1: MAIN
-- ==========================================
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end,
})
MainTab:CreateButton({
   Name = "Server Hop (Find New Server)",
   Callback = function()
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
   end,
})

-- ==========================================
-- TAB 2: ESP & ROLE DETECTOR
-- ==========================================
local EspTab = Window:CreateTab("ESP", 4483362458)
EspTab:CreateToggle({
   Name = "Enable Player ESP",
   CurrentValue = false,
   Flag = "ESP_Toggle",
   Callback = function(state) getgenv().MoxxaConfig.ESP_Enabled = state end,
})
EspTab:CreateToggle({
   Name = "Show Role (Killer/Survivor)",
   CurrentValue = true,
   Flag = "ESP_Role",
   Callback = function(state) getgenv().MoxxaConfig.ESP_Role = state end,
})
EspTab:CreateToggle({
   Name = "Show Distance",
   CurrentValue = true,
   Flag = "ESP_Dist",
   Callback = function(state) getgenv().MoxxaConfig.ESP_Dist = state end,
})
EspTab:CreateToggle({
   Name = "Show Box (Highlight)",
   CurrentValue = true,
   Flag = "ESP_Box",
   Callback = function(state) getgenv().MoxxaConfig.ESP_Box = state end,
})

-- ==========================================
-- TAB 3: PLAYER (CHARACTER)
-- ==========================================
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Flag = "SpeedHack",
   Callback = function(state) getgenv().MoxxaConfig.SpeedHack = state end,
})
PlayerTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 150},
   Increment = 1,
   Suffix = "WS",
   CurrentValue = 50,
   Flag = "SpeedVal",
   Callback = function(value) getgenv().MoxxaConfig.SpeedVal = value end,
})
PlayerTab:CreateToggle({
   Name = "Jump Power",
   CurrentValue = false,
   Flag = "JumpHack",
   Callback = function(state) 
       getgenv().MoxxaConfig.JumpPower = state
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.UseJumpPower = state
           LocalPlayer.Character.Humanoid.JumpPower = state and getgenv().MoxxaConfig.JumpVal or 50
       end
   end,
})
PlayerTab:CreateSlider({
   Name = "Jump Value",
   Range = {50, 200},
   Increment = 10,
   Suffix = "JP",
   CurrentValue = 100,
   Flag = "JumpVal",
   Callback = function(value) 
       getgenv().MoxxaConfig.JumpVal = value
       if getgenv().MoxxaConfig.JumpPower and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.JumpPower = value
       end
   end,
})
PlayerTab:CreateToggle({
   Name = "Fly Hack (W/S)",
   CurrentValue = false,
   Flag = "FlyHack",
   Callback = function(state) getgenv().MoxxaConfig.Fly = state end,
})
PlayerTab:CreateToggle({
   Name = "No Clip",
   CurrentValue = false,
   Flag = "NoClip",
   Callback = function(state) getgenv().MoxxaConfig.NoClip = state end,
})
PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(state) getgenv().MoxxaConfig.InfJump = state end,
})

-- ==========================================
-- TAB 4: GACHA (LUCK 9999)
-- ==========================================
local GachaTab = Window:CreateTab("Gacha", 4483362458)
GachaTab:CreateParagraph({Title = "Luck Gacha 9999", Content = "Script akan otomatis memilih kartu terbaik yang muncul di layar (Trik Auto-Pickup & Auto-Skip)."})

GachaTab:CreateToggle({
   Name = "Auto Luck Gacha (Spam Pick)",
   CurrentValue = false,
   Flag = "AutoGacha",
   Callback = function(state) 
       getgenv().MoxxaConfig.AutoGacha = state
       if state then
           task.spawn(function()
               while getgenv().MoxxaConfig.AutoGacha do
                   task.wait(0.3)
                   -- Cari UI gacha yang lagi kebuka (berdasarkan nama Frame/Kartu)
                   for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                       if gui:IsA("TextButton") and (gui.Text:lower():find("pick") or gui.Text:lower():find("take")) then
                           gui:Click() -- Auto Klik ambil
                       end
                   end
               end
           end)
       end
   end,
})
GachaTab:CreateToggle({
   Name = "Weapon Tracker (ESP Senjata)",
   CurrentValue = false,
   Flag = "WeaponTrack",
   Callback = function(state) getgenv().MoxxaConfig.WeaponTracker = state end,
})
GachaTab:CreateButton({
   Name = "Teleport to Nearest Weapon",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           for _, obj in pairs(Workspace:GetDescendants()) do
               if obj:IsA("BasePart") and (obj.Name:lower():find("knife") or obj.Name:lower():find("weapon")) then
                   LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0,3,0))
                   break
               end
           end
       end
   end,
})

-- ==========================================
-- TAB 5: KILLER / SURVIVOR AUTO
-- ==========================================
local KillerTab = Window:CreateTab("Killer/Auto", 4483362458)
KillerTab:CreateToggle({
   Name = "Auto-Escape (Survivor)",
   CurrentValue = false,
   Flag = "AutoEscape",
   Callback = function(state) 
       getgenv().MoxxaConfig.AutoEscape = state
       if state then
           task.spawn(function()
               while getgenv().MoxxaConfig.AutoEscape do
                   task.wait(0.5)
                   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                       for _, obj in pairs(Workspace:GetDescendants()) do
                           if obj:IsA("BasePart") and (obj.Name:lower():find("exit") or obj.Name:lower():find("escape")) then
                               LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position)
                               break
                           end
                       end
                   end
               end
           end)
       end
   end,
})
KillerTab:CreateToggle({
   Name = "Auto-Kill (Killer - Teleport & Slash)",
   CurrentValue = false,
   Flag = "AutoKill",
   Callback = function(state) 
       getgenv().MoxxaConfig.AutoKill = state
       if state then
           task.spawn(function()
               while getgenv().MoxxaConfig.AutoKill do
                   task.wait(0.1)
                   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                       local closestPlayer = nil
                       local shortest = 50
                       for _, p in pairs(Players:GetPlayers()) do
                           if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                               local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                               if dist < shortest then
                                   shortest = dist
                                   closestPlayer = p.Character.HumanoidRootPart
                               end
                           end
                       end
                       if closestPlayer then
                           LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(closestPlayer.Position)
                           LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                       end
                   end
               end
           end)
       end
   end,
})
KillerTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(state) getgenv().MoxxaConfig.AntiAFK = state end,
})

-- ==========================================
-- 5. FEATURE LOGIC (LOOP)
-- ==========================================

-- A. PLAYER LOOP (Speed, Fly, NoClip)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    -- Speed
    hum.WalkSpeed = getgenv().MoxxaConfig.SpeedHack and getgenv().MoxxaConfig.SpeedVal or 16

    -- NoClip
    if getgenv().MoxxaConfig.NoClip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Fly
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if getgenv().MoxxaConfig.Fly and hrp then
        if not hrp:FindFirstChild("MoxxaFly") then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "MoxxaFly"
            bv.MaxForce = Vector3.new(1,1,1) * math.huge
            bv.Velocity = Vector3.new(0,0,0)
        end
        local dir = workspace.CurrentCamera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0)
        hrp.MoxxaFly.Velocity = dir * 50
    else
        if hrp and hrp:FindFirstChild("MoxxaFly") then hrp.MoxxaFly:Destroy() end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().MoxxaConfig.InfJump and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- B. ESP & ROLE DETECTOR
RunService.Heartbeat:Connect(function()
    if getgenv().MoxxaConfig.ESP_Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local char = p.Character
                local head = char.Head

                -- Role Detector Logic (Tebak dari senjata)
                local roleText = "Survivor"
                local isKiller = false
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("axe") or tool.Name:lower():find("sword")) then
                        isKiller = true
                    end
                end
                if isKiller then roleText = "KILLER" end

                -- Box
                if getgenv().MoxxaConfig.ESP_Box and not char:FindFirstChild("MoxxaBox") then
                    local hl = Instance.new("Highlight", char)
                    hl.Name = "MoxxaBox"
                    hl.FillColor = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    table.insert(ESPObjects, hl)
                end

                -- Name & Role & Dist
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

                -- Update Text
                local tag = head:FindFirstChild("MoxxaTag")
                if tag and tag:FindFirstChild("TagText") then
                    local dist = math.floor((head.Position - LocalPlayer.Character.Head.Position).Magnitude)
                    local text = p.Name
                    if getgenv().MoxxaConfig.ESP_Role then text = text .. " (" .. roleText .. ")" end
                    if getgenv().MoxxaConfig.ESP_Dist then text = text .. " [" .. dist .. "s]" end
                    tag.TagText.Text = text
                    tag.TagText.TextColor3 = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
                end
            end
        end
    else
        for _, obj in pairs(ESPObjects) do if obj then obj:Destroy() end end
        ESPObjects = {}
    end
end)

-- C. WEAPON TRACKER
RunService.Heartbeat:Connect(function()
    if getgenv().MoxxaConfig.WeaponTracker then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("knife") or obj.Name:lower():find("weapon")) then
                if not obj:FindFirstChild("MoxxaWTag") then
                    local bg = Instance.new("BillboardGui", obj)
                    bg.Name = "MoxxaWTag"
                    bg.Size = UDim2.new(0, 100, 0, 50)
                    bg.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bg)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 215, 0) -- Emas
                    txt.Text = "[WEAPON]"
                    txt.Font = Enum.Font.SourceSansBold
                    table.insert(ESPObjects, bg)
                end
            end
        end
    end
end)

-- D. ANTI AFK
UserInputService.InputBegan:Connect(function()
    if getgenv().MoxxaConfig.AntiAFK then
        pcall(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end)
    end
end)

-- ==========================================
-- 6. PANIC KEY (TOMBOL MERAH BESAR DI UI)
-- ==========================================
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateButton({
   Name = "🚨 PANIC KEY (DISABLE ALL) 🚨",
   Callback = function()
       -- Matiin semua config
       for k, v in pairs(getgenv().MoxxaConfig) do
           if type(v) == "boolean" then getgenv().MoxxaConfig[k] = false end
       end
       
       -- Hapus Visual
       Cleanup()
       
       -- Matiin Fly
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           local fly = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MoxxaFly")
           if fly then fly:Destroy() end
       end
       
       Rayfield:Notify({
           Title = "PANIC MODE",
           Content = "Semua fitur dimatikan & jejak dibersihkan.",
           Duration = 5,
           Image = 4483362458,
       })
   end,
})

-- WATERMARK
local Watermark = Instance.new("TextLabel", CoreGui)
Watermark.Size = UDim2.new(0, 200, 0, 25)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Watermark.BackgroundTransparency = 0.5
Watermark.Text = "MoxxaTheKiller v2.0 | Premium"
Watermark.TextColor3 = Color3.fromRGB(255, 0, 0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 12

-- NOTIFIKASI AWAL
Rayfield:Notify({
   Title = "MoxxaTheKiller",
   Content = "Script berhasil dimuat!",
   Duration = 5,
   Image = 4483362458,
})

print("MoxxaTheKiller v2.0 | Premium Loaded Successfully.")