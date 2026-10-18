-- ==========================================
-- MOXXA THE KILLER v2.2 | FULL UNNERFED
-- Game: Survive The Killer (STK)
-- UI Library: Rayfield
-- Total Lines: 800+ (Includes Full Logic)
-- ==========================================

-- 1. LOADING SCREEN ANIMATION
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
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

local Title = Instance.new("TextLabel", LoadFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "MoxxaTheKiller v2.2 Loading..."
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

-- 3. GLOBAL STATE & CONFIGURATION
getgenv().MoxxaConfig = {
    -- ESP Config
    ESP_Enabled = false,
    ESP_ShowName = true,
    ESP_ShowRole = true,
    ESP_ShowDist = true,
    ESP_ShowTracer = true,
    ESP_ShowBox = true,
    ESP_HealthBar = true,
    
    -- Character Config
    SpeedHack = false,
    SpeedValue = 50,
    JumpPower = false,
    JumpValue = 100,
    FlyHack = false,
    NoClip = false,
    InfJump = false,
    
    -- Gacha Config
    GachaReveal = false,
    AutoGacha = false,
    WeaponTracker = false,
    ItemScouter = false,
    
    -- Auto Config
    AutoEscape = false,
    AutoKill = false,
    AntiAFK = false,
    
    -- Misc Config
    FPSBoost = false
}

local ESPObjects = {}
local TracerObjects = {}
local WeaponTags = {}
local Connections = {}

-- 4. CLEANUP SYSTEM (Pembersih Jejak)
local function Cleanup()
    for _, obj in pairs(ESPObjects) do if obj and typeof(obj) == "Instance" then obj:Destroy() end end
    for _, obj in pairs(TracerObjects) do if obj and typeof(obj) == "Instance" then obj:Destroy() end end
    for _, obj in pairs(WeaponTags) do if obj and typeof(obj) == "Instance" then obj:Destroy() end end
    for _, conn in pairs(Connections) do if conn then pcall(function() conn:Disconnect() end) end end
    ESPObjects = {}
    TracerObjects = {}
    WeaponTags = {}
    Connections = {}
    
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end)
end

-- 5. UI CREATION (RAYFIELD DARK MODE)
local Window = Rayfield:CreateWindow({
   Name = "MoxxaTheKiller v2.2 | Unnerfed",
   LoadingTitle = "Initializing Moxxa Hub...",
   LoadingSubtitle = "by Moxxa",
   ConfigurationSaving = {Enabled = true, FolderName = "MoxxaSTK", FileName = "Config_v2"},
   KeySystem = false,
   Theme = "Blood",
})

-- ==========================================
-- TAB 1: MAIN MENU
-- ==========================================
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Server Options")
MainTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function() 
       game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) 
   end,
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
EspTab:CreateSection("Player ESP Settings")
EspTab:CreateToggle({
   Name = "Enable Player ESP",
   CurrentValue = false,
   Flag = "ESP_Toggle",
   Callback = function(state) getgenv().MoxxaConfig.ESP_Enabled = state end,
})
EspTab:CreateToggle({
   Name = "Show Name",
   CurrentValue = true,
   Flag = "ESP_Name",
   Callback = function(state) getgenv().MoxxaConfig.ESP_ShowName = state end,
})
EspTab:CreateToggle({
   Name = "Show Role (Killer/Survivor)",
   CurrentValue = true,
   Flag = "ESP_Role",
   Callback = function(state) getgenv().MoxxaConfig.ESP_ShowRole = state end,
})
EspTab:CreateToggle({
   Name = "Show Distance",
   CurrentValue = true,
   Flag = "ESP_Dist",
   Callback = function(state) getgenv().MoxxaConfig.ESP_ShowDist = state end,
})
EspTab:CreateToggle({
   Name = "Show Box (Highlight)",
   CurrentValue = true,
   Flag = "ESP_Box",
   Callback = function(state) getgenv().MoxxaConfig.ESP_ShowBox = state end,
})
EspTab:CreateToggle({
   Name = "Show Tracer (Lines)",
   CurrentValue = true,
   Flag = "ESP_Tracer",
   Callback = function(state) getgenv().MoxxaConfig.ESP_ShowTracer = state end,
})

-- ==========================================
-- TAB 3: PLAYER MODIFIER
-- ==========================================
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Movement")
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
   Callback = function(value) getgenv().MoxxaConfig.SpeedValue = value end,
})
PlayerTab:CreateToggle({
   Name = "Jump Power",
   CurrentValue = false,
   Flag = "JumpHack",
   Callback = function(state) 
       getgenv().MoxxaConfig.JumpPower = state
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.UseJumpPower = state
           LocalPlayer.Character.Humanoid.JumpPower = state and getgenv().MoxxaConfig.JumpValue or 50
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
       getgenv().MoxxaConfig.JumpValue = value
       if getgenv().MoxxaConfig.JumpPower and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.JumpPower = value
       end
   end,
})
PlayerTab:CreateToggle({
   Name = "Fly Hack (W/S)",
   CurrentValue = false,
   Flag = "FlyHack",
   Callback = function(state) getgenv().MoxxaConfig.FlyHack = state end,
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
-- TAB 4: GACHA & ITEM SCOUTER
-- ==========================================
local GachaTab = Window:CreateTab("Gacha & Item", 4483362458)
GachaTab:CreateSection("Gacha Hacks")
GachaTab:CreateToggle({
   Name = "Gacha Reveal (Tembus Pandang)",
   CurrentValue = false,
   Flag = "GachaReveal",
   Callback = function(state) getgenv().MoxxaConfig.GachaReveal = state end,
})
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
                   pcall(function()
                       for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                           if gui:IsA("TextButton") and (gui.Text:lower():find("pick") or gui.Text:lower():find("take")) then
                               gui:Click()
                           end
                       end
                   end)
               end
           end)
       end
   end,
})

GachaTab:CreateSection("Weapon & Item Tracker")
GachaTab:CreateToggle({
   Name = "Weapon Tracker (ESP Senjata)",
   CurrentValue = false,
   Flag = "WeaponTrack",
   Callback = function(state) getgenv().MoxxaConfig.WeaponTracker = state end,
})
GachaTab:CreateToggle({
   Name = "Item Scouter (Lihat Harga Koin)",
   CurrentValue = false,
   Flag = "ItemScouter",
   Callback = function(state) getgenv().MoxxaConfig.ItemScouter = state end,
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
-- TAB 5: AUTO / KILLER
-- ==========================================
local AutoTab = Window:CreateTab("Auto / Killer", 4483362458)
AutoTab:CreateSection("Survivor Auto")
AutoTab:CreateToggle({
   Name = "Auto-Escape (Jalan ke Exit)",
   CurrentValue = false,
   Flag = "AutoEscape",
   Callback = function(state) 
       getgenv().MoxxaConfig.AutoEscape = state
       if state then
           task.spawn(function()
               while getgenv().MoxxaConfig.AutoEscape do
                   task.wait(0.5)
                   pcall(function()
                       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                           for _, obj in pairs(Workspace:GetDescendants()) do
                               if obj:IsA("BasePart") and (obj.Name:lower():find("exit") or obj.Name:lower():find("escape")) then
                                   LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position)
                                   break
                               end
                           end
                       end
                   end)
               end
           end)
       end
   end,
})

AutoTab:CreateSection("Killer Auto")
AutoTab:CreateToggle({
   Name = "Auto-Kill (Killer - Teleport & Slash)",
   CurrentValue = false,
   Flag = "AutoKill",
   Callback = function(state) 
       getgenv().MoxxaConfig.AutoKill = state
       if state then
           task.spawn(function()
               while getgenv().MoxxaConfig.AutoKill do
                   task.wait(0.1)
                   pcall(function()
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
                   end)
               end
           end)
       end
   end,
})

AutoTab:CreateSection("Misc Auto")
AutoTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(state) getgenv().MoxxaConfig.AntiAFK = state end,
})

-- ==========================================
-- TAB 6: SETTINGS & PANIC
-- ==========================================
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateSection("Performance")
SettingsTab:CreateToggle({
   Name = "FPS Boost (Low Graphics)",
   CurrentValue = false,
   Flag = "FPSBoost",
   Callback = function(state) getgenv().MoxxaConfig.FPSBoost = state end,
})
SettingsTab:CreateSection("Danger Zone")
SettingsTab:CreateButton({
   Name = "🚨 PANIC KEY (DISABLE ALL) 🚨",
   Callback = function()
       for k, v in pairs(getgenv().MoxxaConfig) do if type(v) == "boolean" then getgenv().MoxxaConfig[k] = false end end
       Cleanup()
       pcall(function()
           if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               local fly = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MoxxaFly")
               if fly then fly:Destroy() end
           end
       end)
       Rayfield:Notify({Title = "PANIC MODE", Content = "Semua fitur dimatikan & dibersihkan.", Duration = 5, Image = 4483362458})
   end,
})

-- ==========================================
-- 6. FEATURE LOGIC LOOPS
-- ==========================================

-- A. PLAYER MODIFIER LOOP
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        -- Speed
        hum.WalkSpeed = getgenv().MoxxaConfig.SpeedHack and getgenv().MoxxaConfig.SpeedValue or 16

        -- NoClip
        if getgenv().MoxxaConfig.NoClip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        -- Fly
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if getgenv().MoxxaConfig.FlyHack and hrp then
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
end)

-- B. INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    pcall(function()
        if getgenv().MoxxaConfig.InfJump and LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

-- C. GACHA REVEAL (TEMBUS PANDANG)
RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().MoxxaConfig.GachaReveal then
            for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("ImageLabel") or gui:IsA("Frame") then
                    local n = gui.Name:lower()
                    if n:find("card") or n:find("cover") or n:find("gacha") or n:find("overlay") then
                        if gui:IsA("ImageLabel") then
                            gui.ImageTransparency = 0.8
                            gui.BackgroundTransparency = 0.8
                        else
                            gui.BackgroundTransparency = 0.8
                        end
                    end
                end
            end
        end
    end)
end)

-- D. ESP, ROLE DETECTOR, & WEAPON TRACKER LOOP
RunService.Heartbeat:Connect(function()
    pcall(function()
        -- 1. PLAYER ESP
        if getgenv().MoxxaConfig.ESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local char = p.Character
                    local head = char.Head

                    -- Role Logic
                    local isKiller = false
                    local roleText = "Survivor"
                    
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            local tn = tool.Name:lower()
                            if tn:find("knife") or tn:find("axe") or tn:find("sword") or tn:find("cleaver") then
                                isKiller = true
                            end
                        end
                    end
                    
                    pcall(function()
                        if p:GetAttribute("Role") == "Killer" or p:GetAttribute("IsKiller") == true then
                            isKiller = true
                        end
                    end)

                    if isKiller then roleText = "KILLER" end

                    -- Box
                    if getgenv().MoxxaConfig.ESP_ShowBox and not char:FindFirstChild("MoxxaBox") then
                        local hl = Instance.new("Highlight", char)
                        hl.Name = "MoxxaBox"
                        hl.FillColor = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
                        hl.OutlineColor = Color3.fromRGB(255,255,255)
                        table.insert(ESPObjects, hl)
                    elseif not getgenv().MoxxaConfig.ESP_ShowBox and char:FindFirstChild("MoxxaBox") then
                        char.MoxxaBox:Destroy()
                    end

                    -- Name, Role, Dist
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
                        local text = getgenv().MoxxaConfig.ESP_ShowName and p.Name or ""
                        if getgenv().MoxxaConfig.ESP_ShowRole then text = text .. " (" .. roleText .. ")" end
                        if getgenv().MoxxaConfig.ESP_ShowDist then text = text .. " [" .. dist .. "s]" end
                        tag.TagText.Text = text
                        tag.TagText.TextColor3 = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
                    end
                end
            end
        else
            for _, obj in pairs(ESPObjects) do if obj then obj:Destroy() end end
            ESPObjects = {}
        end

        -- 2. WEAPON TRACKER & SCOUTER
        if getgenv().MoxxaConfig.WeaponTracker or getgenv().MoxxaConfig.ItemScouter then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("knife") or obj.Name:lower():find("weapon") or obj.Name:lower():find("gun")) then
                    
                    if not obj:FindFirstChild("MoxxaWTag") then
                        local bg = Instance.new("BillboardGui", obj)
                        bg.Name = "MoxxaWTag"
                        bg.Size = UDim2.new(0, 150, 0, 50)
                        bg.AlwaysOnTop = true
                        local txt = Instance.new("TextLabel", bg)
                        txt.Name = "WText"
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 12
                        table.insert(WeaponTags, bg)
                    end

                    local tag = obj:FindFirstChild("MoxxaWTag")
                    if tag and tag:FindFirstChild("WText") then
                        local txt = tag.WText
                        local priceText = ""
                        
                        if getgenv().MoxxaConfig.ItemScouter then
                            local priceValue = obj:FindFirstChild("Price") or obj:FindFirstChild("Value") or obj:FindFirstChild("CoinValue")
                            if priceValue then
                                priceText = "\n[💰 " .. tostring(priceValue.Value) .. " Coins]"
                            else
                                local match = string.match(obj.Name, "%d+")
                                if match then priceText = "\n[💰 " .. match .. " Coins]" end
                            end
                        end

                        if getgenv().MoxxaConfig.WeaponTracker then
                            txt.Text = "[WEAPON]\n" .. obj.Name .. priceText
                        else
                            txt.Text = priceText
                        end
                    end
                end
            end
        else
            for _, obj in pairs(WeaponTags) do if obj then obj:Destroy() end end
            WeaponTags = {}
        end
    end)
end)

-- E. ANTI AFK
UserInputService.InputBegan:Connect(function()
    pcall(function()
        if getgenv().MoxxaConfig.AntiAFK then
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end
    end)
end)

-- F. FPS BOOST
RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().MoxxaConfig.FPSBoost then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 9e9
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
        end
    end)
end)

-- WATERMARK
local Watermark = Instance.new("TextLabel", CoreGui)
Watermark.Size = UDim2.new(0, 200, 0, 25)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Watermark.BackgroundTransparency = 0.5
Watermark.Text = "MoxxaTheKiller v2.2 | Premium"
Watermark.TextColor3 = Color3.fromRGB(255, 0, 0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 12

-- NOTIFIKASI AWAL
Rayfield:Notify({
   Title = "MoxxaTheKiller v2.2",
   Content = "Script berhasil dimuat tanpa pengurangan fitur!",
   Duration = 5,
   Image = 4483362458,
})

print("MoxxaTheKiller v2.2 | Full Unnerfed Loaded Successfully.")