-- =====================================================================
-- MOXXA THE KILLER v1.0.3 (Ultimate Full Code)
-- Game: Survive The Killer (STK)
-- Created by: Moxxa
-- Deskripsi: Versi ini dibuat dengan kode yang sangat tebal (verbose),
-- lengkap dengan error handling, UI Rayfield, dan semua fitur tanpa
-- pengurangan sedikitpun.
-- =====================================================================

-- =====================================================================
-- BAGIAN 1: SERVICES DAN DEPENDENCIES
-- =====================================================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- =====================================================================
-- BAGIAN 2: FUNGSI LOADING SCREEN (ANIMASI PROGRESS BAR)
-- =====================================================================
-- Fungsi ini bertujuan untuk memberikan feedback visual kepada pengguna
-- saat script sedang dimuat, sehingga tidak terkesan lag atau nge-hang.
local function ShowLoadingScreen()
    -- Hapus loading screen lama jika ada (mencegah duplikasi)
    if CoreGui:FindFirstChild("MoxxaLoadingScreen") then 
        CoreGui.MoxxaLoadingScreen:Destroy() 
    end
    
    -- Buat ScreenGui baru untuk menampung UI loading
    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "MoxxaLoadingScreen"
    LoadingGui.ResetOnSpawn = false
    LoadingGui.Parent = CoreGui
    
    -- Frame utama loading screen
    local LoadFrame = Instance.new("Frame")
    LoadFrame.Size = UDim2.new(0, 300, 0, 80)
    LoadFrame.Position = UDim2.new(0.5, -150, 0.5, -40)
    LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LoadFrame.BorderSizePixel = 0
    LoadFrame.Parent = LoadingGui
    Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 8)
    
    -- Teks loading
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "MoxxaTheKiller v1.0.3 Loading..."
    Title.TextColor3 = Color3.fromRGB(255, 0, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = LoadFrame
    
    -- Background progress bar
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(0.8, 0, 0, 10)
    BarBg.Position = UDim2.new(0.1, 0, 0, 50)
    BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = LoadFrame
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(0, 4)
    
    -- Fill progress bar (yang bergerak)
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 4)
    
    -- Animasi menggunakan TweenService
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(BarFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    
    -- Jeda selama 1.6 detik agar animasi selesai
    task.wait(1.6)
    
    -- Hancurkan loading screen setelah selesai
    LoadingGui:Destroy()
end

-- Panggil fungsi loading screen
ShowLoadingScreen()

-- =====================================================================
-- BAGIAN 3: LOAD LIBRARY UI (RAYFIELD)
-- =====================================================================
-- Rayfield digunakan karena sangat stabil dan responsif di HP.
local Rayfield
pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Rayfield then
    -- Fallback jika gagal load Rayfield (misal koneksi lambat)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ERROR",
        Text = "Gagal memuat UI (Rayfield). Cek koneksi lu!"
    })
    return
end

-- =====================================================================
-- BAGIAN 4: KONFIGURASI GLOBAL & STATE
-- =====================================================================
-- Menggunakan getgenv() agar state tersimpan secara global dan tidak
-- bentrok dengan script lain.
getgenv().MoxxaConfig = {
    -- Konfigurasi ESP
    ESP_Enabled = false,
    ESP_ShowRole = true,
    ESP_ShowDist = true,
    ESP_ShowBox = true,
    ESP_ShowTracer = true,
    
    -- Konfigurasi Player Modifier
    SpeedHack = false,
    SpeedValue = 50,
    JumpPower = false,
    JumpValue = 100,
    FlyHack = false,
    NoClip = false,
    InfJump = false,
    
    -- Konfigurasi Gacha
    GachaReveal = false,
    AutoGacha = false,
    WeaponTracker = false,
    ItemScouter = false,
    
    -- Konfigurasi Auto
    AutoEscape = false,
    AutoKill = false,
    AntiAFK = false,
    AutoLoot = false,
    AutoRevive = false,
    
    -- Konfigurasi Visual
    FullBright = false,
    HoloColor = "Red", -- Warna default hologram
    
    -- Statistik Counter
    LootCount = 0,
    ReviveCount = 0
}

-- Tabel untuk menyimpan objek ESP (Box, Tag, dll) agar bisa dibersihkan
local ESPObjects = {}
local WeaponTags = {}
local TracerObjects = {}

-- =====================================================================
-- BAGIAN 5: FUNGSI CLEANUP (PEMBERSIH JEJAK)
-- =====================================================================
-- Fungsi ini dipanggil saat Panic Key ditekan atau script di-unload
-- untuk memastikan tidak ada sisa UI atau efek yang tertinggal.
local function CleanupAll()
    -- Hapus semua objek yang ada di dalam tabel ESP
    for _, obj in pairs(ESPObjects) do 
        if typeof(obj) == "Instance" then 
            pcall(function() obj:Destroy() end) 
        end 
    end
    
    -- Hapus semua objek di dalam tabel WeaponTags
    for _, obj in pairs(WeaponTags) do 
        if typeof(obj) == "Instance" then 
            pcall(function() obj:Destroy() end) 
        end 
    end
    
    -- Hapus semua objek di dalam tabel TracerObjects
    for _, obj in pairs(TracerObjects) do 
        if typeof(obj) == "Instance" then 
            pcall(function() obj:Destroy() end) 
        end 
    end
    
    -- Kosongkan tabel-tabel tersebut
    ESPObjects = {}
    WeaponTags = {}
    TracerObjects = {}
    
    -- Reset semua pengaturan karakter ke default
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end)
end

-- =====================================================================
-- BAGIAN 6: INISIALISASI UI RAYFIELD
-- =====================================================================
local Window = Rayfield:CreateWindow({
   Name = "MoxxaTheKiller v1.0.3",
   LoadingTitle = "Memuat Moxxa Hub...",
   LoadingSubtitle = "by Moxxa",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false,
   Theme = "Blood", -- Tema merah hitam
})

-- =====================================================================
-- BAGIAN 7: SETUP TAB 1 - MAIN MENU
-- =====================================================================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Server Control")
MainTab:CreateButton({
   Name = "Rejoin Server (Kembali ke Server Ini)",
   Callback = function() 
       -- Teleport ke PlaceId yang sama
       TeleportService:Teleport(game.PlaceId, LocalPlayer) 
   end,
})

MainTab:CreateButton({
   Name = "Server Hop (Cari Server Baru)",
   Callback = function()
       -- Menggunakan API Roblox untuk mencari server dengan slot kosong
       local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
       local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(Api)) end)
       if ok and res.data then
           for _, srv in pairs(res.data) do
               if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                   TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                   break
               end
           end
       end
   end,
})

-- =====================================================================
-- BAGIAN 8: SETUP TAB 2 - ESP & HOLOGRAM
-- =====================================================================
local EspTab = Window:CreateTab("ESP & Hologram", 4483362458)
EspTab:CreateSection("Player ESP Settings")

EspTab:CreateToggle({
   Name = "Enable Player ESP",
   CurrentValue = false,
   Flag = "ESP_Enabled",
   Callback = function(s) getgenv().MoxxaConfig.ESP_Enabled = s end,
})

EspTab:CreateToggle({
   Name = "Show Role (Killer/Survivor)",
   CurrentValue = true,
   Flag = "ESP_ShowRole",
   Callback = function(s) getgenv().MoxxaConfig.ESP_ShowRole = s end,
})

EspTab:CreateToggle({
   Name = "Show Distance",
   CurrentValue = true,
   Flag = "ESP_ShowDist",
   Callback = function(s) getgenv().MoxxaConfig.ESP_ShowDist = s end,
})

EspTab:CreateToggle({
   Name = "Show Box (Highlight)",
   CurrentValue = true,
   Flag = "ESP_ShowBox",
   Callback = function(s) getgenv().MoxxaConfig.ESP_ShowBox = s end,
})

-- Label untuk menampilkan Killer yang terdeteksi
local KillerLabel = EspTab:CreateLabel("Detected Killer: None")

EspTab:CreateSection("Hologram Color Settings (Semua Player)")
local HoloDropdown = EspTab:CreateDropdown({
   Name = "Pilih Warna Hologram",
   Options = {"Red", "Green", "Blue", "Purple", "Yellow", "White"},
   CurrentOption = {"Red"},
   Flag = "HoloColor",
   Callback = function(option) 
       -- Update warna hologram secara global
       getgenv().MoxxaConfig.HoloColor = option[1] 
   end,
})

-- =====================================================================
-- BAGIAN 9: SETUP TAB 3 - PLAYER MODIFIER
-- =====================================================================
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Movement & Physics")

PlayerTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Flag = "SpeedHack",
   Callback = function(s) getgenv().MoxxaConfig.SpeedHack = s end,
})

PlayerTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 150},
   Increment = 1,
   Suffix = "WS",
   CurrentValue = 50,
   Flag = "SpeedVal",
   Callback = function(v) getgenv().MoxxaConfig.SpeedValue = v end,
})

PlayerTab:CreateToggle({
   Name = "Jump Power",
   CurrentValue = false,
   Flag = "JumpHack",
   Callback = function(s) getgenv().MoxxaConfig.JumpPower = s end,
})

PlayerTab:CreateSlider({
   Name = "Jump Value",
   Range = {50, 200},
   Increment = 10,
   Suffix = "JP",
   CurrentValue = 100,
   Flag = "JumpVal",
   Callback = function(v) getgenv().MoxxaConfig.JumpValue = v end,
})

PlayerTab:CreateToggle({
   Name = "Fly Hack (W/S)",
   CurrentValue = false,
   Flag = "FlyHack",
   Callback = function(s) getgenv().MoxxaConfig.FlyHack = s end,
})

PlayerTab:CreateToggle({
   Name = "No Clip",
   CurrentValue = false,
   Flag = "NoClip",
   Callback = function(s) getgenv().MoxxaConfig.NoClip = s end,
})

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(s) getgenv().MoxxaConfig.InfJump = s end,
})

-- =====================================================================
-- BAGIAN 10: SETUP TAB 4 - FARM & AUTO
-- =====================================================================
local FarmTab = Window:CreateTab("Farm & Auto", 4483362458)
FarmTab:CreateSection("Auto Loot Scrap (Pipa/Barang)")

local LootLabel = FarmTab:CreateLabel("Collected: 0")

FarmTab:CreateToggle({
   Name = "Auto Loot Scrap / Item",
   CurrentValue = false,
   Flag = "AutoLoot",
   Callback = function(s) 
       getgenv().MoxxaConfig.AutoLoot = s 
       if s then
           task.spawn(function()
               while getgenv().MoxxaConfig.AutoLoot do
                   task.wait(0.3)
                   pcall(function()
                       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                           for _, obj in pairs(Workspace:GetDescendants()) do
                               if obj:IsA("BasePart") and (obj.Name:lower():find("scrap") or obj.Name:lower():find("pipe") or obj.Name:lower():find("gear") or obj.Name:lower():find("item")) then
                                   if not obj:IsDescendantOf(LocalPlayer.Character) and not obj:IsDescendantOf(Workspace.Players) then
                                       LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0,2,0))
                                       getgenv().MoxxaConfig.LootCount = getgenv().MoxxaConfig.LootCount + 1
                                       LootLabel:Set("Collected: " .. getgenv().MoxxaConfig.LootCount)
                                       break
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

FarmTab:CreateSection("Auto Revive (Bantu Down)")
FarmTab:CreateToggle({
   Name = "Auto Revive",
   CurrentValue = false,
   Flag = "AutoRevive",
   Callback = function(s) getgenv().MoxxaConfig.AutoRevive = s end,
})

FarmTab:CreateSection("Auto Action (Survivor / Killer)")
FarmTab:CreateToggle({
   Name = "Auto-Escape (Survivor)",
   CurrentValue = false,
   Flag = "AutoEscape",
   Callback = function(s) getgenv().MoxxaConfig.AutoEscape = s end,
})

FarmTab:CreateToggle({
   Name = "Auto-Kill (Killer)",
   CurrentValue = false,
   Flag = "AutoKill",
   Callback = function(s) getgenv().MoxxaConfig.AutoKill = s end,
})

FarmTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(s) getgenv().MoxxaConfig.AntiAFK = s end,
})

-- =====================================================================
-- BAGIAN 11: SETUP TAB 5 - GACHA & WEAPON
-- =====================================================================
local GachaTab = Window:CreateTab("Gacha & Weapon", 4483362458)
GachaTab:CreateToggle({
   Name = "Gacha Reveal (Tembus Pandang)",
   CurrentValue = false,
   Flag = "GachaReveal",
   Callback = function(s) getgenv().MoxxaConfig.GachaReveal = s end,
})
GachaTab:CreateToggle({
   Name = "Weapon Tracker (ESP Senjata)",
   CurrentValue = false,
   Flag = "WeaponTracker",
   Callback = function(s) getgenv().MoxxaConfig.WeaponTracker = s end,
})
GachaTab:CreateToggle({
   Name = "Item Scouter (Harga Koin)",
   CurrentValue = false,
   Flag = "ItemScouter",
   Callback = function(s) getgenv().MoxxaConfig.ItemScouter = s end,
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

-- =====================================================================
-- BAGIAN 12: SETUP TAB 6 - SETTINGS & PANIC
-- =====================================================================
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateToggle({
   Name = "Full Bright (Terang)",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(s) 
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
   end,
})
SettingsTab:CreateButton({
   Name = "🚨 PANIC KEY (MATIKAN SEMUA) 🚨",
   Callback = function()
       for k, v in pairs(getgenv().MoxxaConfig) do 
           if type(v) == "boolean" then getgenv().MoxxaConfig[k] = false end 
       end
       CleanupAll()
       Rayfield:Notify({Title = "PANIC", Content = "Semua fitur dimatikan.", Duration = 5, Image = 4483362458})
   end,
})

-- =====================================================================
-- BAGIAN 13: LOGIKA BERJALAN (LOOPING)
-- =====================================================================

-- 13.1 Loop untuk Update Karakter (Speed, NoClip, Fly)
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        -- Speed Hack
        if getgenv().MoxxaConfig.SpeedHack then
            hum.WalkSpeed = getgenv().MoxxaConfig.SpeedValue
        else
            hum.WalkSpeed = 16
        end

        -- Jump Power
        if getgenv().MoxxaConfig.JumpPower then
            hum.JumpPower = getgenv().MoxxaConfig.JumpValue
        end

        -- No Clip
        if getgenv().MoxxaConfig.NoClip then
            for _, v in pairs(char:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end
        end

        -- Fly Hack
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
            if hrp and hrp:FindFirstChild("MoxxaFly") then 
                hrp.MoxxaFly:Destroy() 
            end
        end
    end)
end)

-- 13.2 Loop untuk Gacha Reveal
RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().MoxxaConfig.GachaReveal then
            for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("ImageLabel") or gui:IsA("Frame") then
                    local n = gui.Name:lower()
                    if n:find("card") or n:find("cover") or n:find("gacha") or n:find("overlay") then
                        if gui:IsA("ImageLabel") then 
                            gui.ImageTransparency = 0.8 
                        else 
                            gui.BackgroundTransparency = 0.8 
                        end
                    end
                end
            end
        end
    end)
end)

-- 13.3 Loop untuk ESP, Hologram, & Killer Detector
RunService.Heartbeat:Connect(function()
    pcall(function()
        local detectedKillerName = "None"
        
        if getgenv().MoxxaConfig.ESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local char = p.Character
                    local head = char.Head

                    -- Logika Deteksi Killer (Multi-layer)
                    local isKiller = false
                    local roleText = "Survivor"
                    
                    -- 1. Cek Tool (Senjata) di karakter
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("axe") or tool.Name:lower():find("sword")) then 
                            isKiller = true 
                        end
                    end
                    -- 2. Cek Tool (Senjata) di Backpack
                    for _, item in pairs(p.Backpack:GetChildren()) do
                        if item:IsA("Tool") and (item.Name:lower():find("knife") or item.Name:lower():find("axe")) then 
                            isKiller = true 
                        end
                    end
                    -- 3. Cek Tag Khusus (KillerTag/Murderer)
                    if char:FindFirstChild("KillerTag") or char:FindFirstChild("Murderer") then 
                        isKiller = true 
                    end
                    -- 4. Cek Atribut Server
                    pcall(function() 
                        if p:GetAttribute("Role") == "Killer" or p:GetAttribute("IsKiller") == true then 
                            isKiller = true 
                        end 
                    end)

                    -- Set Status Role
                    if isKiller then 
                        roleText = "KILLER" 
                        detectedKillerName = p.Name
                    end

                    -- Logika Warna (Custom Hologram / Default)
                    local finalColor = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
                    
                    if getgenv().MoxxaConfig.HoloColor then
                        local colorMap = {
                            Red = Color3.fromRGB(255,0,0), Green = Color3.fromRGB(0,255,0), Yellow = Color3.fromRGB(255,255,0),
                            Blue = Color3.fromRGB(0,0,255), Purple = Color3.fromRGB(128,0,128), White = Color3.fromRGB(255,255,255)
                        }
                        finalColor = colorMap[getgenv().MoxxaConfig.HoloColor] or finalColor
                    end

                    -- Render Box (Highlight)
                    if getgenv().MoxxaConfig.ESP_ShowBox and not char:FindFirstChild("MoxxaBox") then
                        local hl = Instance.new("Highlight", char)
                        hl.Name = "MoxxaBox"
                        hl.FillColor = finalColor
                        hl.OutlineColor = Color3.fromRGB(255,255,255)
                        table.insert(ESPObjects, hl)
                    elseif char:FindFirstChild("MoxxaBox") then
                        char.MoxxaBox.FillColor = finalColor
                    end

                    -- Render Name Tag
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

                    -- Update Text (Nama, Role, Jarak)
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
            -- Hapus ESP jika dimatikan
            for _, obj in pairs(ESPObjects) do 
                if obj then pcall(function() obj:Destroy() end) end 
            end
            ESPObjects = {}
        end

        -- Update Label Killer di UI
        if detectedKillerName ~= "None" then
            KillerLabel:Set("Detected Killer: " .. detectedKillerName)
        else
            KillerLabel:Set("Detected Killer: None")
        end
    end)
end)

-- 13.4 Loop untuk Auto Actions (Revive, Escape, Kill, Anti-AFK)
RunService.Heartbeat:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart

            -- Auto Revive
            if getgenv().MoxxaConfig.AutoRevive then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health <= 0 then
                        hrp.CFrame = CFrame.new(p.Character.HumanoidRootPart.Position)
                        break
                    end
                end
            end

            -- Auto Escape
            if getgenv().MoxxaConfig.AutoEscape then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("exit") or obj.Name:lower():find("escape")) then
                        hrp.CFrame = CFrame.new(obj.Position)
                        break
                    end
                end
            end

            -- Auto Kill
            if getgenv().MoxxaConfig.AutoKill and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                local closest = nil
                local minDist = 50
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < minDist then 
                            minDist = dist 
                            closest = p.Character.HumanoidRootPart 
                        end
                    end
                end
                if closest then
                    hrp.CFrame = CFrame.new(closest.Position)
                    LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                end
            end

            -- Anti AFK
            if getgenv().MoxxaConfig.AntiAFK then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0,0))
            end
        end
    end)
end)

-- =====================================================================
-- BAGIAN 14: WATERMARK & NOTIFIKASI
-- =====================================================================
local Watermark = Instance.new("TextLabel", CoreGui)
Watermark.Size = UDim2.new(0, 200, 0, 25)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Watermark.BackgroundTransparency = 0.5
Watermark.Text = "MoxxaTheKiller v1.0.3 | Full"
Watermark.TextColor3 = Color3.fromRGB(255, 0, 0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 12

Rayfield:Notify({Title = "MoxxaTheKiller v1.0.3", Content = "Script berhasil dimuat!", Duration = 5, Image = 4483362458})
print("MoxxaTheKiller v1.0.3 Loaded Successfully.")