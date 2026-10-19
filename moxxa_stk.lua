-- =====================================================================
-- MOXXA THE KILLER v1.0.7 (Full Merge & Anti-Bug)
-- Game: Survive The Killer (STK)
-- Developer: Moxxa (Merged with Karim's Method)
-- Fitur: ESP, Gacha, Auto Loot (Karim), Auto Heal (Karim), Auto Locker (Karim)
-- =====================================================================

-- =====================================================================
-- BAGIAN 1: SERVICES (MENGAMBIL LAYANAN DARI ROBLOX)
-- =====================================================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

-- =====================================================================
-- BAGIAN 2: KONFIGURASI STATE GLOBAL (TEMPAT NYIMPEN STATUS FITUR)
-- =====================================================================
getgenv().MoxxaConfig = {
    -- Fitur ESP
    ESP_Enabled = false,
    ESP_ShowRole = true,
    ESP_ShowDist = true,
    ESP_ShowBox = true,
    ESP_HoloColor = "Red",
    
    -- Fitur Player Modifier
    SpeedHack = false,
    SpeedValue = 50,
    FlyHack = false,
    NoClip = false,
    InfJump = false,
    
    -- Fitur Gacha
    GachaReveal = false,
    
    -- Fitur Auto Loot (Method Karim)
    AutoLoot = false,
    LootDelay = 1.2,
    LootCount = 0,
    
    -- Fitur Auto Heal (Method Karim)
    AutoHeal = false,
    HealDanger = 40,
    
    -- Fitur Auto Locker (Method Karim)
    AutoLocker = false,
    LockerIn = 35,
    LockerOut = 70,
    
    -- Fitur Visual
    FullBright = false
}

-- Tabel untuk menyimpan objek ESP agar bisa dibersihkan
local ESPObjects = {}

-- =====================================================================
-- BAGIAN 3: FUNGSI CLEANUP (PEMBERSIH JEJAK SAAT PANIC KEY)
-- =====================================================================
local function CleanupAll()
    -- Hapus semua objek ESP
    for _, obj in pairs(ESPObjects) do
        if typeof(obj) == "Instance" then
            pcall(function() obj:Destroy() end)
        end
    end
    ESPObjects = {}
    
    -- Reset kecepatan karakter ke default
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
    
    -- Hapus fitur Fly
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local fly = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MoxxaFly")
            if fly then fly:Destroy() end
        end
    end)
end

-- =====================================================================
-- BAGIAN 4: LOAD LIBRARY UI (RAYFIELD)
-- =====================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- =====================================================================
-- BAGIAN 5: INISIALISASI UI WINDOW
-- =====================================================================
local Window = Rayfield:CreateWindow({
   Name = "MOXXA THE KILLER | v1.0.7",
   LoadingTitle = "Memuat Moxxa Hub...",
   LoadingSubtitle = "Developer: Moxxa",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false,
   Theme = "Blood",
})

-- =====================================================================
-- BAGIAN 6: TAB 1 - ESP & MAIN
-- =====================================================================
local EspTab = Window:CreateTab("ESP & Main", 4483362458)

EspTab:CreateSection("Player ESP Settings")
EspTab:CreateToggle({
   Name = "Enable Player ESP",
   CurrentValue = false,
   Flag = "ESP_Enabled",
   Callback = function(state) getgenv().MoxxaConfig.ESP_Enabled = state end,
})
EspTab:CreateToggle({
   Name = "Show Role (Killer/Survivor)",
   CurrentValue = true,
   Flag = "ESP_ShowRole",
   Callback = function(state) getgenv().MoxxaConfig.ESP_ShowRole = state end,
})
EspTab:CreateToggle({
   Name = "Show Distance",
   CurrentValue = true,
   Flag = "ESP_ShowDist",
   Callback = function(state) getgenv().MoxxaConfig.ESP_ShowDist = state end,
})
EspTab:CreateSection("Killer Detector")
local KillerLabel = EspTab:CreateLabel("Detected Killer: None")

-- =====================================================================
-- BAGIAN 7: TAB 2 - PLAYER MODIFIER
-- =====================================================================
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
   Name = "Fly Hack",
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

-- =====================================================================
-- BAGIAN 8: TAB 3 - FARM & AUTO (METHOD KARIM)
-- =====================================================================
local FarmTab = Window:CreateTab("Farm & Auto", 4483362458)

FarmTab:CreateSection("Auto Loot (Karim Method - Safe)")
local LootLabel = FarmTab:CreateLabel("Loot Collected: 0")

FarmTab:CreateToggle({
   Name = "Auto Loot (Safe Teleport)",
   CurrentValue = false,
   Flag = "AutoLoot",
   Callback = function(state) 
       getgenv().MoxxaConfig.AutoLoot = state 
       if state then
           task.spawn(function()
               while getgenv().MoxxaConfig.AutoLoot do
                   pcall(function()
                       local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                       if hrp then
                           -- Pake CollectionService persis Karim, tapi teleport-nya di-delay biar ga ke-kick
                           for _, loot in ipairs(CollectionService:GetTagged("Loot")) do
                               if loot:IsDescendantOf(Workspace) then
                                   local b = loot:FindFirstChild("Border", true)
                                   if b and b:IsA("BasePart") then
                                       hrp.CFrame = b.CFrame + Vector3.new(0, 1.5, 0)
                                       -- Nunggu 0.8 detik biar server ngedeteksi kita nyentuh (koin masuk)
                                       task.wait(0.8) 
                                       break 
                                   end
                               end
                           end
                       end
                   end)
                   task.wait(getgenv().MoxxaConfig.LootDelay)
               end
           end)
       end
   end,
})
FarmTab:CreateSlider({
   Name = "Loot Delay (Detik)",
   Range = {0.5, 3.0},
   Increment = 0.1,
   CurrentValue = 1.2,
   Callback = function(value) getgenv().MoxxaConfig.LootDelay = value end,
})

FarmTab:CreateSection("Auto Heal (Karim Method)")
FarmTab:CreateToggle({
   Name = "Auto Heal Downed Players",
   CurrentValue = false,
   Flag = "AutoHeal",
   Callback = function(state) 
       getgenv().MoxxaConfig.AutoHeal = state 
       if state then
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
   end,
})
FarmTab:CreateSlider({
   Name = "Heal Danger Distance",
   Range = {20, 80},
   Increment = 1,
   CurrentValue = 40,
   Callback = function(value) getgenv().MoxxaConfig.HealDanger = value end,
})

-- =====================================================================
-- BAGIAN 9: TAB 4 - AUTO LOCKER (METHOD KARIM)
-- =====================================================================
local LockerTab = Window:CreateTab("Auto Locker", 4483362458)
LockerTab:CreateSection("Auto Hide Settings")
LockerTab:CreateToggle({
   Name = "Auto Locker (Hide)",
   CurrentValue = false,
   Flag = "AutoLocker",
   Callback = function(state) getgenv().MoxxaConfig.AutoLocker = state end,
})
LockerTab:CreateSlider({
   Name = "Hide within (Studs)",
   Range = {15, 80},
   Increment = 1,
   CurrentValue = 35,
   Callback = function(value) getgenv().MoxxaConfig.LockerIn = value end,
})
LockerTab:CreateSlider({
   Name = "Come out beyond (Studs)",
   Range = {30, 150},
   Increment = 1,
   CurrentValue = 70,
   Callback = function(value) getgenv().MoxxaConfig.LockerOut = value end,
})

-- =====================================================================
-- BAGIAN 10: TAB 5 - GACHA (FITUR LU)
-- =====================================================================
local GachaTab = Window:CreateTab("Gacha", 4483362458)
GachaTab:CreateSection("Gacha Modifier")
GachaTab:CreateToggle({
   Name = "Gacha Reveal (Tembus Pandang)",
   CurrentValue = false,
   Flag = "GachaReveal",
   Callback = function(state) getgenv().MoxxaConfig.GachaReveal = state end,
})

-- =====================================================================
-- BAGIAN 11: TAB 6 - SETTINGS & PANIC
-- =====================================================================
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateSection("Visuals")
SettingsTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(state) 
       getgenv().MoxxaConfig.FullBright = state 
       if state then
           Lighting.Ambient = Color3.fromRGB(255, 255, 255)
           Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
           Lighting.Brightness = 3
           Lighting.ClockTime = 12
           Lighting.FogEnd = 10000
       else
           Lighting.Ambient = Color3.fromRGB(70, 70, 70)
           Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
           Lighting.Brightness = 1
           Lighting.FogEnd = 1000
       end
   end,
})

SettingsTab:CreateSection("Danger Zone")
SettingsTab:CreateButton({
   Name = "🚨 PANIC KEY (DISABLE ALL) 🚨",
   Callback = function()
       for k, v in pairs(getgenv().MoxxaConfig) do 
           if type(v) == "boolean" then 
               getgenv().MoxxaConfig[k] = false 
           end 
       end
       CleanupAll()
       Rayfield:Notify({
           Title = "PANIC", 
           Content = "Semua fitur dimatikan & dibersihkan.", 
           Duration = 5
       })
   end,
})

-- =====================================================================
-- BAGIAN 12: LOGIKA BERJALAN (BACKGROUND LOOPS)
-- =====================================================================

-- 12.1 AUTO LOCKER LOOP (METHOD KARIM)
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

-- 12.2 ESP & KILLER LOOP
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
        if detectedKillerName ~= "None" then KillerLabel:Set("Detected Killer: " .. detectedKillerName) else KillerLabel:Set("Detected Killer: None") end
    end)
end)

-- 12.3 GACHA REVEAL LOOP
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

-- 12.4 PLAYER MODIFIER LOOP (SPEED, FLY, NOCLIP)
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

-- WATERMARK
local Watermark = Instance.new("TextLabel", CoreGui)
Watermark.Size = UDim2.new(0, 200, 0, 25)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Watermark.BackgroundTransparency = 0.5
Watermark.Text = "MOXXA THE KILLER v1.0.7"
Watermark.TextColor3 = Color3.fromRGB(255, 0, 0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 12

print("MOXXA THE KILLER v1.0.7 (Full Merge) Loaded Successfully.")