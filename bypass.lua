local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer

task.spawn(function()
    task.wait(2) -- Tunggu UI Karim muncul
    
    -- HANCURKAN TOTAL LAYAR LOGIN KARIM
    for _, v in pairs(CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and (v.Text:lower():find("adam") or v.Text:lower():find("private build") or v.Text:lower():find("moxxa")) then
            if v.Parent and v.Parent.Parent then
                pcall(function() v.Parent.Parent:Destroy() end) 
            end
        end
    end

    -- BIKIN LAYAR LOGIN MOXXA DARI NOL
    local LoginGui = Instance.new("ScreenGui")
    LoginGui.Name = "MoxxaRealLogin"
    LoginGui.Parent = CoreGui

    local Frame = Instance.new("Frame", LoginGui)
    Frame.Size = UDim2.new(0, 350, 0, 250)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", Frame)
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = "MOXXA | STG"
    Title.TextColor3 = Color3.fromRGB(255, 0, 0)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 28

    local Input = Instance.new("TextBox", Frame)
    Input.Size = UDim2.new(0.8, 0, 0, 40)
    Input.Position = UDim2.new(0.1, 0, 0, 90)
    Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.PlaceholderText = "password..."
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 16
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.8, 0, 0, 40)
    Btn.Position = UDim2.new(0.1, 0, 0, 150)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Btn.Text = "ACCESS"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 16
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Status = Instance.new("TextLabel", Frame)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0, 200)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12

    -- LOGIKA PASSWORD
    Btn.MouseButton1Click:Connect(function()
        if Input.Text == "moxxatzy" then
            LoginGui:Destroy()
            
            -- Fitur Gacha lu nyala otomatis
            getgenv().MoxxaGacha = true
            RunService.Heartbeat:Connect(function()
                pcall(function()
                    if getgenv().MoxxaGacha then
                        for _, g in pairs(LP.PlayerGui:GetDescendants()) do
                            if g:IsA("ImageLabel") or g:IsA("Frame") then
                                local n = string.lower(g.Name)
                                if string.find(n, "card") or string.find(n, "cover") or string.find(n, "gacha") then
                                    if g:IsA("ImageLabel") then g.ImageTransparency = 0.85 else g.BackgroundTransparency = 0.85 end
                                end
                            end
                        end
                    end
                end)
            end)
            
        else
            Status.Text = "wrong password"
            Input.Text = ""
        end
    end)
end)
