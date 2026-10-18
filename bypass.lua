local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

task.spawn(function()
    task.wait(3) -- Nunggu script Karim muncul
    
    -- Ganti Nama
    for _, v in pairs(CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and (v.Text:lower():find("adam") or v.Text:lower():find("private build")) then
            v.Text = "MOXXA | STG"
            v.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end

    -- Cari & Paksa Klik Access
    local inputBox, accessBtn
    for _, v in pairs(CoreGui:GetDescendants()) do
        if v:IsA("TextBox") then inputBox = v end
        if v:IsA("TextButton") and v.Text:lower():find("access") then accessBtn = v end
    end

    if inputBox and accessBtn then
        inputBox.Text = "BYPASS"
        task.wait(0.1)
        accessBtn:Click() -- Nembak tombol access paksa masuk
    end
end)
