-- ═══ adamz.zz | SURVIVE THE KILLER | v15 red edition | pass: adamZtYZ4 ═══
print("[adamz.zz] v15 loading")

local ok, err = pcall(function()

local Players = game:GetService("Players")
local RS      = game:GetService("RunService")
local TS      = game:GetService("TweenService")
local UIS     = game:GetService("UserInputService")
local VU      = game:GetService("VirtualUser")
local SG      = game:GetService("StarterGui")
local TP      = game:GetService("TeleportService")
local CS      = game:GetService("CollectionService")
local LP      = Players.LocalPlayer
local PASS    = "adamZtYZ4"

-- theme
local BG     = Color3.fromRGB(8,6,8)
local CARD   = Color3.fromRGB(24,10,13)
local ACC    = Color3.fromRGB(255,30,60)
local ACC2   = Color3.fromRGB(130,0,25)
local TXT    = Color3.fromRGB(240,235,235)
local DIM    = Color3.fromRGB(150,110,115)
local RED    = Color3.fromRGB(255,60,70)
local KILL_C = Color3.fromRGB(255,40,40)
local SURV_C = Color3.fromRGB(0,230,140)
local DOWN_C = Color3.fromRGB(255,150,50)
local LINE   = Color3.fromRGB(58,22,30)
local HOVER  = Color3.fromRGB(31,12,16)

local function N(t,x)
    pcall(function()
        SG:SetCore("SendNotification",{Title=t,Text=x,Duration=3})
    end)
end
local function new(c,p,par)
    local o = Instance.new(c)
    for k,v in pairs(p) do o[k]=v end
    o.Parent = par
    return o
end
local function cor(o,r)
    new("UICorner",{CornerRadius=UDim.new(0,r or 8)},o)
end

local S = {
    ESP=true, LockerESP=false, ExitESP=true,
    SpdOn=false, Spd=30, NoClip=false,
    AutoRescue=true, AutoHeal=false,
    AutoLocker=false, LockerIn=35, LockerOut=70,
    AutoEscape=false,
    Farm=false, FarmDelay=0.4,
    HealDanger=40,
    KillAll=false, KillDelay=0.5,
}

-- root
local root
do
    local o1,r1 = pcall(function() return gethui() end)
    if o1 and r1 then root = r1
    else
        local o2,r2 = pcall(function() return game:GetService("CoreGui") end)
        if o2 and r2 then root = r2 else root = LP:WaitForChild("PlayerGui") end
    end
end
local gui = new("ScreenGui",{Name="adamz.zz_stk",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=9999},root)

-- ═══ GATE — BUILT FIRST ═══
local gate = new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(320,200),BackgroundColor3=BG,BorderSizePixel=0},gui)
cor(gate,10)
local gst = new("UIStroke",{Color=ACC,Thickness=1.2,Transparency=0.25},gate)
local gt = new("TextLabel",{Position=UDim2.fromOffset(0,18),Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=24,TextColor3=TXT,Text="adamz.zz"},gate)
new("UIGradient",{Color=ColorSequence.new(RED,ACC2)},gt)
new("TextLabel",{Position=UDim2.fromOffset(0,50),Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=11,TextColor3=DIM,Text="survive the killer — private build"},gate)
local box = new("TextBox",{Position=UDim2.fromOffset(30,78),Size=UDim2.fromOffset(260,36),BackgroundColor3=CARD,Font=Enum.Font.Gotham,TextSize=15,TextColor3=TXT,PlaceholderText="password...",PlaceholderColor3=DIM,Text="",ClearTextOnFocus=false,BorderSizePixel=0},gate)
cor(box,8)
new("UIStroke",{Color=ACC2,Thickness=1,Transparency=0.4},box)
local gob = new("TextButton",{Position=UDim2.fromOffset(30,124),Size=UDim2.fromOffset(260,34),BackgroundColor3=ACC,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.fromRGB(10,4,5),Text="ACCESS",AutoButtonColor=false,BorderSizePixel=0},gate)
cor(gob,8)
new("UIGradient",{Color=ColorSequence.new(RED,ACC2)},gob)
local stt = new("TextLabel",{Position=UDim2.fromOffset(0,168),Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=10,TextColor3=DIM,Text="awaiting authentication..."},gate)

-- ═══ everything below runs AFTER the gate ═══

local char, hum, hrp
local function ref()
    char = LP.Character
    hum  = char and char:FindFirstChildOfClass("Humanoid")
    hrp  = char and char:FindFirstChild("HumanoidRootPart")
end
ref()

-- v15: fresh-ref check — compares against LP.Character directly because
-- this game leaves corpses around (old refs stay "valid" otherwise)
local function refIfNeeded()
    if char ~= LP.Character or (not hum) or (not hum.Parent) or (not hrp) or (not hrp.Parent) then
        ref()
    end
end

local function getMap()
    local mapName = workspace:GetAttribute("Map")
    if type(mapName) == "string" and mapName ~= "" then
        return workspace:FindFirstChild(mapName)
    end
    return nil
end

-- killer detection
local K_NAME
task.spawn(function()
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local loadMod = rs:WaitForChild("Load", 8)
        if not loadMod then return end
        local Load = require(loadMod)
        local C = Load("Constants")
        local K = C.TEAMS and (C.TEAMS.Killer or C.TEAMS.killer)
        if type(K) == "table" then
            K_NAME = K.name or K.Name
        elseif type(K) == "string" then
            K_NAME = K
        end
        print("[adamz.zz] Constants loaded — killer team name: " .. tostring(K_NAME))
    end)
end)

local killCache, killStamp = {}, {}
local function isKiller(p)
    local now = os.clock()
    if killCache[p] ~= nil and now - (killStamp[p] or 0) < 1 then
        return killCache[p]
    end
    local res = false
    if K_NAME then
        res = (p:GetAttribute("TeamID") == K_NAME)
    else
        local tid = p:GetAttribute("TeamID")
        if type(tid) == "string" and tid:lower():find("killer") then
            res = true
        end
    end
    killCache[p] = res
    killStamp[p] = now
    return res
end

local function killerPos()
    for _, p in ipairs(Players:GetPlayers()) do
        if isKiller(p) and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            if r then return r.Position end
        end
    end
    return nil
end

-- downed detection
local downCache, downStamp = {}, {}
local function isDowned(p)
    local now = os.clock()
    if downCache[p] ~= nil and now - (downStamp[p] or 0) < 0.2 then
        return downCache[p]
    end
    local res = (p:GetAttribute("Downed") == true)
        or (p:GetAttribute("HeldByPlayer") == true)
    downCache[p] = res
    downStamp[p] = now
    return res
end

-- round filter
local function inMyRound(p)
    local c = p.Character
    if not c then return false end
    local myT = LP:GetAttribute("TeamID")
    if myT ~= nil and p:GetAttribute("TeamID") ~= myT then return false end
    if p:GetAttribute("Dead") == true then return false end
    if p:GetAttribute("Escaped") == true then return false end
    return true
end

local function pickSafeTarget(fromPos)
    local kp = killerPos()
    local cands = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 and not isKiller(p) and not isDowned(p) and inMyRound(p) then
                local score
                if not kp then
                    score = -(r.Position - fromPos).Magnitude
                else
                    score = (r.Position - kp).Magnitude
                end
                table.insert(cands, {r=r, score=score})
            end
        end
    end
    if #cands == 0 then return nil end
    table.sort(cands, function(a,b) return a.score > b.score end)
    return cands[math.random(1, math.min(3, #cands))].r
end

-- ═══ LOCKERS ═══
local lockerCache, lockerStamp = {}, 0
local function getLockers(force)
    local now = os.clock()
    if not force and now - lockerStamp < 0.25 and lockerCache then return lockerCache end
    local out = {}
    for _, l in ipairs(CS:GetTagged("Locker")) do
        if l:IsDescendantOf(workspace) then
            local inner = l:FindFirstChild("InnerBounds", true)
            if inner and inner:IsA("BasePart") then
                local prompt = l:FindFirstChildWhichIsA("ProximityPrompt", true)
                table.insert(out, {
                    model=l, inner=inner, prompt=prompt,
                    occupant=l:GetAttribute("Occupant") or "",
                })
            end
        end
    end
    lockerCache, lockerStamp = out, now
    return out
end
local function myLocker()
    for _, lk in ipairs(getLockers()) do
        if lk.occupant == LP.Name then return lk end
    end
    return nil
end

local function enterSafestLocker()
    ref()
    if not hrp or myLocker() then return false end
    local kp = killerPos()
    local best, bestScore = nil, -math.huge
    for _, lk in ipairs(getLockers(true)) do
        if lk.occupant == "" then
            local score
            if kp then
                score = (kp - lk.inner.Position).Magnitude
            else
                score = -(lk.inner.Position - hrp.Position).Magnitude
            end
            if score > bestScore then bestScore, best = score, lk end
        end
    end
    if not best then return false end
    hrp.CFrame = CFrame.new(best.inner.Position)
    task.wait(0.12)
    if best.prompt then
        pcall(function() fireproximityprompt(best.prompt) end)
    end
    return true
end

local function findSaferLocker(kp, currentLk)
    local myDist = (kp - currentLk.inner.Position).Magnitude
    local best, bestScore = nil, 0
    for _, lk in ipairs(getLockers(true)) do
        if lk.occupant == "" then
            local kd = (kp - lk.inner.Position).Magnitude
            local md = (lk.inner.Position - hrp.Position).Magnitude
            if kd > myDist + 25 and md < 400 then
                local score = kd - myDist
                if score > bestScore then bestScore, best = score, lk end
            end
        end
    end
    return best
end

local function exitMyLocker()
    ref()
    if not hrp then return false end
    local lk = myLocker()
    if not lk then return false end
    if lk.prompt then
        pcall(function() fireproximityprompt(lk.prompt) end)
    end
    task.wait(0.1)
    local dc = lk.model:FindFirstChild("DoorConstraints", true)
    local hinge = dc and (dc:FindFirstChild("HingeLeft") or dc:FindFirstChild("HingeRight"))
    local outPos
    if hinge and hinge:IsA("BasePart") then
        local dir = hinge.Position - lk.inner.Position
        outPos = hinge.Position + (dir.Magnitude > 0.1 and dir.Unit or Vector3.new(0,0,1)) * 3
    else
        outPos = lk.inner.Position + Vector3.new(0, 0, 4)
    end
    hrp.CFrame = CFrame.new(outPos + Vector3.new(0, 1.5, 0))
    return true
end

-- ═══ EXITS ═══
local exitCache, exitStamp = {}, 0
local exitTravel = {}
local function getExits(force)
    local now = os.clock()
    if not force and now - exitStamp < 2 and exitCache then return exitCache end
    local out = {}
    local m = getMap()
    local root2 = m or workspace
    local function check(model)
        if model:IsA("Model") and model:FindFirstChild("ExitEffect") then
            local dw = model:FindFirstChild("Doorway")
            local d1 = dw and dw:FindFirstChild("Door1")
            local dest1 = dw and dw:FindFirstChild("Door1Destination")
            if d1 and dest1 and (not exitTravel[model]) then
                exitTravel[model] = {travel = (d1.Position - dest1.Position).Magnitude}
            end
            table.insert(out, {
                model=model,
                trigger=model:FindFirstChild("Trigger"),
                door1=d1,
                dest1=dest1,
            })
        end
    end
    for _, d in ipairs(root2:GetChildren()) do
        check(d)
        if d:IsA("Folder") or d:IsA("Model") then
            for _, d2 in ipairs(d:GetChildren()) do check(d2) end
        end
    end
    for md in pairs(exitTravel) do
        if not md.Parent then exitTravel[md] = nil end
    end
    exitCache, exitStamp = out, now
    return out
end
local function exitOpen(ex)
    if not ex.model.Parent then return false end
    if not (ex.door1 and ex.dest1) then
        return ex.trigger and (ex.trigger:FindFirstChild("ExitIcon") ~= nil)
    end
    local remaining = (ex.door1.Position - ex.dest1.Position).Magnitude
    if remaining < 1.5 then return true end
    local info = exitTravel[ex.model]
    if info and info.travel and info.travel > 1 then
        return remaining < info.travel * 0.3
    end
    return false
end

-- ═══ ESCAPE routine ═══
local escapeBusy = false
local function tryEscape(ex)
    if escapeBusy then return end
    escapeBusy = true
    task.spawn(function()
        ref()
        if not hrp then escapeBusy = false return end
        local trig = ex.trigger
        if not trig then escapeBusy = false return end

        hrp.CFrame = CFrame.new(trig.Position)
        hrp.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.1)

        local parts = {}
        if char then
            for _, p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") then table.insert(parts, p) end
            end
        end
        if #parts == 0 then parts = {hrp} end

        local prompt = ex.model:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            pcall(function() fireproximityprompt(prompt) end)
        end

        for i = 1, 6 do
            for _, p in ipairs(parts) do
                pcall(function()
                    firetouchinterest(p, trig, 0)
                    firetouchinterest(p, trig, 1)
                end)
            end
            task.wait(0.08)
            if LP:GetAttribute("Escaped") == true then
                N("escape","registered — you're out")
                escapeBusy = false
                return
            end
        end

        local dir = nil
        local pp = ex.model.PrimaryPart or ex.model:FindFirstChildWhichIsA("BasePart")
        if pp then
            local look = pp.CFrame.LookVector
            if Vector3.new(look.X, 0, look.Z).Magnitude > 0.3 then
                dir = Vector3.new(look.X, 0, look.Z).Unit
            end
        end
        if not dir then dir = Vector3.new(0, 0, -1) end
        local startPos = trig.Position - dir * 5
        for t = 0, 1, 0.08 do
            hrp.CFrame = CFrame.new(startPos + dir * (t * 11))
            for _, p in ipairs(parts) do
                pcall(function()
                    firetouchinterest(p, trig, 0)
                    firetouchinterest(p, trig, 1)
                end)
            end
            task.wait(0.04)
            if LP:GetAttribute("Escaped") == true then break end
        end

        if LP:GetAttribute("Escaped") == true then
            N("escape","registered — you're out")
        else
            hrp.CFrame = CFrame.new(trig.Position)
            for i = 1, 10 do
                for _, p in ipairs(parts) do
                    pcall(function()
                        firetouchinterest(p, trig, 0)
                        firetouchinterest(p, trig, 1)
                    end)
                end
                task.wait(0.1)
                if LP:GetAttribute("Escaped") == true then break end
            end
            if LP:GetAttribute("Escaped") == true then
                N("escape","registered — you're out")
            else
                N("escape","standing on the exit — walk in if needed")
            end
        end
        escapeBusy = false
    end)
end

-- ═══ RESCUE ═══
local R = {
    active=false, mode=nil, target=nil, origin=nil,
    manual=false, wasDown=false, clearSince=nil, nextRepick=0,
}

local function endRescue(goHome)
    if goHome and R.origin then
        ref()
        if hrp then
            hrp.CFrame = R.origin
            N("rescue","done — took you back to your spot")
        end
    end
    R.active, R.mode, R.target, R.origin = false, nil, nil, nil
    R.manual, R.wasDown, R.clearSince, R.nextRepick = false, false, nil, 0
end

local function startGetHealed(manual)
    ref()
    if not hrp or R.active then return end
    local t = pickSafeTarget(hrp.Position)
    if not t then
        N("rescue","no safe in-round players found")
        return
    end
    R.active, R.mode, R.target = true, "get_healed", t
    R.origin = hrp.CFrame
    R.manual = manual and true or false
    R.wasDown = isDowned(LP)
    R.clearSince, R.nextRepick = nil, 0
    local pn = t.Parent and Players:GetPlayerFromCharacter(t.Parent)
    N("rescue","sticking to " .. (pn and pn.Name or "target") .. " — G to come home")
end

local function startHealThem(target)
    ref()
    if not hrp or R.active then return end
    if typeof(target) ~= "Instance" then return end
    local kp = killerPos()
    if kp then
        local d = (kp - target.Position).Magnitude
        if d < S.HealDanger then
            N("rescue","killer is camping them (" .. math.floor(d) .. " studs) — too dangerous")
            return
        end
    end
    R.active, R.mode, R.target = true, "heal_them", target
    R.origin = hrp.CFrame
    R.manual, R.wasDown, R.clearSince, R.nextRepick = false, false, nil, 0
    local tp = target.Parent and Players:GetPlayerFromCharacter(target.Parent)
    N("rescue","healing " .. (tp and tp.Name or "target") .. " — G to come home")
end

local function threatRepick()
    local t = R.target
    if not t or not t.Parent or not t:IsDescendantOf(workspace) then return true end
    local kp = killerPos()
    if kp and (kp - t.Position).Magnitude < 25 then return true end
    return false
end

local nextAutoHeal = 0
local function stepRescue(dt)
    dt = dt or (1/60)
    if not R.active then
        if S.AutoRescue and (not isKiller(LP)) and hum and hum.Health > 0 and isDowned(LP) then
            startGetHealed(false)
            return
        end
        if S.AutoHeal and (not isKiller(LP)) and hum and hum.Health > 0
            and (not isDowned(LP)) and LP:GetAttribute("Escaped") ~= true
            and (not myLocker()) and hrp and os.clock() > nextAutoHeal then
            nextAutoHeal = os.clock() + 0.6
            local kp = killerPos()
            local best, bd = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and (not isKiller(p)) and inMyRound(p) and isDowned(p) then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if r and h and h.Health > 0 then
                        if (not kp) or (kp - r.Position).Magnitude >= S.HealDanger then
                            local d = (r.Position - hrp.Position).Magnitude
                            if d < bd then bd, best = d, r end
                        end
                    end
                end
            end
            if best then startHealThem(best) end
        end
        return
    end

    ref()
    if not hrp or not hum or hum.Health <= 0 or LP:GetAttribute("Dead") == true then
        endRescue(false)
        return
    end

    if R.mode == "heal_them" and isDowned(LP) then
        local nt = pickSafeTarget(hrp.Position)
        if nt then
            R.mode, R.target, R.wasDown, R.clearSince = "get_healed", nt, true, nil
            N("rescue","you went down — resticking to safest")
        end
    end

    local t = R.target
    local tAlive = t and t.Parent and t:IsDescendantOf(workspace)

    if R.mode == "get_healed" then
        local down = isDowned(LP)
        if down then R.wasDown = true end
        local shouldEnd = false
        if R.wasDown then
            shouldEnd = (not down)
        else
            shouldEnd = (not R.manual) and (not down)
        end
        if shouldEnd then
            R.clearSince = R.clearSince or os.clock()
            if os.clock() - R.clearSince > 0.5 then
                endRescue(true)
                return
            end
        else
            R.clearSince = nil
            if os.clock() > R.nextRepick and threatRepick() then
                R.nextRepick = os.clock() + 2
                local nt = pickSafeTarget(hrp.Position)
                if nt then R.target = nt end
            end
        end
    elseif R.mode == "heal_them" then
        local tp = tAlive and t.Parent and Players:GetPlayerFromCharacter(t.Parent)
        if not tp then
            endRescue(true)
            return
        end
        local kp = killerPos()
        if kp and t and (kp - t.Position).Magnitude < 25 then
            N("rescue","killer got too close — took you out")
            endRescue(true)
            return
        end
        if not isDowned(tp) then
            R.clearSince = R.clearSince or os.clock()
            if os.clock() - R.clearSince > 0.5 then
                endRescue(true)
                return
            end
        else
            R.clearSince = nil
        end
    end

    -- smooth follow
    t = R.target
    if t and t.Parent and hrp and (not myLocker()) then
        if R.mode == "get_healed" and LP:GetAttribute("HeldByPlayer") == true then
            return
        end
        local gap = (hrp.Position - t.Position).Magnitude
        if gap > 30 then
            hrp.CFrame = t.CFrame + Vector3.new(0, 2, 0)
        elseif gap > 3.5 then
            local desired = t.Position - hrp.Position
            local flat = Vector3.new(desired.X, 0, desired.Z)
            if flat.Magnitude > 0.5 then
                local dir = flat.Unit
                local chaseSpeed = 26
                if R.mode == "get_healed" and isDowned(LP) then
                    chaseSpeed = 14
                end
                local step = dir * math.min(chaseSpeed * dt, flat.Magnitude)
                local newPos = hrp.Position + step
                if (newPos - t.Position).Magnitude > 0.1 then
                    hrp.CFrame = CFrame.lookAt(newPos, t.Position)
                else
                    hrp.CFrame = CFrame.new(newPos)
                end
                local v = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = Vector3.new(0, math.min(v.Y, 5), 0)
            end
        end
    end
end

-- ═══ KILLER MODE ═══
local killSkip = {}
local killCount = 0
local lastKillerRole = false
local clearedNotified = false

local function pickVictim(preferStanding)
    ref()
    if not hrp then return nil end
    local now = os.clock()
    local best, bd = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (not isKiller(p)) and ((killSkip[p] or 0) < now) then
            if p:GetAttribute("Dead") ~= true and p:GetAttribute("Escaped") ~= true then
                local played = p:GetAttribute("PlayedThisRound")
                local tid = p:GetAttribute("TeamID")
                if played == true or (tid ~= nil and tid ~= (K_NAME or "?")) then
                    local c = p.Character
                    local r = c and c:FindFirstChild("HumanoidRootPart")
                    local h = c and c:FindFirstChildOfClass("Humanoid")
                    if r and h and h.Health > 0 then
                        if (not preferStanding) or (not isDowned(p)) then
                            local d = (r.Position - hrp.Position).Magnitude
                            if d < bd then bd, best = d, r end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function victimDead(v)
    local p = v.Parent and Players:GetPlayerFromCharacter(v.Parent)
    if p and p:GetAttribute("Dead") == true then return true end
    local h = v.Parent and v.Parent:FindFirstChildOfClass("Humanoid")
    if h and h.Health <= 0 then return true end
    return false
end

local function getKnife()
    if char then
        local t = char:FindFirstChildOfClass("Tool")
        if t then return t end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        local t = bp:FindFirstChildOfClass("Tool")
        if t then return t end
    end
    return nil
end

local function killerHunt()
    while gui.Parent do
        local amK = isKiller(LP)
        if amK and (not lastKillerRole) then
            killCount = 0
            killSkip = {}
            clearedNotified = false
            if S.KillAll then
                N("killer mode","you're the killer — sweeping")
            end
        end
        lastKillerRole = amK

        if S.KillAll and amK then
            ref()
            if hrp and hum and hum.Health > 0 then
                local v = pickVictim(true)
                if not v then v = pickVictim(false) end
                if v then
                    clearedNotified = false
                    local knife = getKnife()
                    if knife and knife.Parent ~= char then
                        pcall(function() hum:EquipTool(knife) end)
                        task.wait(0.15)
                    end
                    local t0 = os.clock()
                    while os.clock() - t0 < 5 do
                        if (not S.KillAll) or (not isKiller(LP)) then break end
                        if (not v.Parent) or victimDead(v) then break end
                        if (v.Position - hrp.Position).Magnitude > 6 then
                            hrp.CFrame = CFrame.lookAt((v.CFrame * CFrame.new(0, 0, -1.8)).Position, v.Position)
                        else
                            hrp.CFrame = CFrame.lookAt(hrp.Position, v.Position)
                        end
                        if knife then
                            pcall(function() knife:Activate() end)
                        end
                        pcall(function()
                            local m = UIS:GetMouseLocation()
                            VU:ClickButton1(Vector2.new(m.X, m.Y))
                        end)
                        task.wait(0.22)
                    end
                    local vp2 = v.Parent and Players:GetPlayerFromCharacter(v.Parent)
                    if victimDead(v) then
                        killCount = killCount + 1
                        if vp2 then
                            N("killer mode", vp2.Name .. " down — " .. killCount .. " killed")
                        else
                            N("killer mode", killCount .. " killed")
                        end
                    elseif vp2 then
                        killSkip[vp2] = os.clock() + 8
                        N("killer mode","stuck on " .. vp2.Name .. " — skipping")
                    end
                    task.wait(S.KillDelay)
                else
                    if not clearedNotified then
                        clearedNotified = true
                        N("killer mode","round cleared — " .. killCount .. " killed")
                    end
                    task.wait(1)
                end
            else
                task.wait(0.3)
            end
        else
            task.wait(0.4)
        end
    end
end

-- ═══ HUB ═══
local function buildHub()
    ref()
    LP.CharacterAdded:Connect(function()
        ref()
        task.wait(0.2)
        ref()
    end)

    -- window (glass)
    local win = new("Frame",{Visible=true,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(560,400),BackgroundColor3=BG,BackgroundTransparency=0.15,ClipsDescendants=true,BorderSizePixel=0},gui)
    cor(win,12)
    new("UIStroke",{Color=LINE,Thickness=1.2,Transparency=0.05},win)

    -- header (glass)
    local hdr = new("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=CARD,BackgroundTransparency=0.2,BorderSizePixel=0},win)
    cor(hdr,12)
    new("Frame",{Position=UDim2.fromOffset(0,34),Size=UDim2.new(1,0,0,14),BackgroundColor3=CARD,BackgroundTransparency=0.2,BorderSizePixel=0},hdr)
    new("Frame",{Position=UDim2.fromOffset(0,47),Size=UDim2.new(1,0,0,1),BackgroundColor3=LINE,BorderSizePixel=0},hdr)
    local ttl = new("TextLabel",{Position=UDim2.fromOffset(16,7),Size=UDim2.fromOffset(105,20),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=TXT,Text="adamz.zz"},hdr)
    new("UIGradient",{Color=ColorSequence.new(RED,ACC2)},ttl)
    new("TextLabel",{Position=UDim2.fromOffset(16,26),Size=UDim2.fromOffset(190,13),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=DIM,Text="// survive the killer"},hdr)
    local minB = new("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-48,0.5,0),Size=UDim2.fromOffset(28,24),BackgroundColor3=BG,Text="–",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=DIM,AutoButtonColor=false,BorderSizePixel=0},hdr)
    cor(minB,6)
    local closeB = new("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.fromOffset(28,24),BackgroundColor3=BG,Text="X",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=RED,AutoButtonColor=false,BorderSizePixel=0},hdr)
    cor(closeB,6)

    do
        local dg,ds,ps
        hdr.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dg,ds,ps=true,i.Position,win.Position
                i.Changed:Connect(function()
                    if i.UserInputState==Enum.UserInputState.End then dg=false end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local d=i.Position-ds
                win.Position=UDim2.new(ps.X.Scale,ps.X.Offset+d.X,ps.Y.Scale,ps.Y.Offset+d.Y)
            end
        end)
    end

    local body = new("Frame",{Position=UDim2.fromOffset(0,48),Size=UDim2.new(1,0,1,-48),BackgroundTransparency=1},win)

    -- v15 minimize: hide body FIRST, then collapse — no reflow mess
    local mini=false
    minB.MouseButton1Click:Connect(function()
        mini=not mini
        if mini then
            body.Visible=false
            TS:Create(win,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(560,48)}):Play()
        else
            TS:Create(win,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(560,400)}):Play()
            task.delay(0.16,function()
                if not mini then body.Visible=true end
            end)
        end
    end)
    closeB.MouseButton1Click:Connect(function()
        win.Visible=false
    end)

    -- sidebar (glass)
    local side = new("Frame",{Size=UDim2.new(0,142,1,0),BackgroundColor3=CARD,BackgroundTransparency=0.25,BorderSizePixel=0},body)
    cor(side,10)
    new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.fromOffset(1,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=LINE,BorderSizePixel=0},side)
    new("TextLabel",{Position=UDim2.fromOffset(14,12),Size=UDim2.new(1,-24,0,15),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=DIM,Text="CONTROL PANEL"},side)
    local sideList = new("Frame",{Position=UDim2.fromOffset(8,34),Size=UDim2.new(1,-16,1,-44),BackgroundTransparency=1},side)
    new("UIListLayout",{Padding=UDim.new(0,3)},sideList)

    local content = new("Frame",{Position=UDim2.fromOffset(142,0),Size=UDim2.new(1,-142,1,0),BackgroundTransparency=1},body)
    local pageHost = new("Frame",{Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,1,-24),BackgroundTransparency=1},content)

    -- footer (v15: knife badge removed, text only)
    local footer = new("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,1,1,0),Size=UDim2.new(1,0,0,24),BackgroundTransparency=1},content)
    new("Frame",{Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-20,0,1),BackgroundColor3=LINE,BorderSizePixel=0},footer)
    new("TextLabel",{Position=UDim2.fromOffset(10,5),Size=UDim2.fromOffset(150,14),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=9,TextColor3=DIM,TextXAlignment=Enum.TextXAlignment.Left,Text="adamz.stk // session"},footer)
    local kText = new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-10,0,5),Size=UDim2.fromOffset(200,14),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=10,TextColor3=DIM,TextXAlignment=Enum.TextXAlignment.Right,Text=""},footer)

    -- ═══ icons ═══
    local function icon(parent,kind,on)
        local holder=new("Frame",{Position=UDim2.fromOffset(4,2),Size=UDim2.fromOffset(22,30),BackgroundTransparency=1},parent)
        local c=on and ACC or DIM
        if kind=="visuals" then
            local eye=new("Frame",{Position=UDim2.fromOffset(3,10),Size=UDim2.fromOffset(16,10),BackgroundTransparency=1,BorderSizePixel=0},holder)
            cor(eye,99)
            new("UIStroke",{Color=c,Thickness=1.4},eye)
            local pupil=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(4,4),BackgroundColor3=c,BorderSizePixel=0},eye)
            cor(pupil,99)
        elseif kind=="rescue" then
            local circ=new("Frame",{Position=UDim2.fromOffset(4,8),Size=UDim2.fromOffset(14,14),BackgroundTransparency=1,BorderSizePixel=0},holder)
            cor(circ,99)
            new("UIStroke",{Color=c,Thickness=1.4},circ)
            new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(8,2),BackgroundColor3=c,BorderSizePixel=0},circ)
            new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(2,8),BackgroundColor3=c,BorderSizePixel=0},circ)
        elseif kind=="game" then
            local sq1=new("Frame",{Position=UDim2.fromOffset(4,8),Size=UDim2.fromOffset(5,5),BackgroundColor3=c,BorderSizePixel=0},holder)
            local sq2=new("Frame",{Position=UDim2.fromOffset(11,8),Size=UDim2.fromOffset(5,5),BackgroundColor3=c,BorderSizePixel=0},holder)
            local sq3=new("Frame",{Position=UDim2.fromOffset(4,15),Size=UDim2.fromOffset(5,5),BackgroundColor3=c,BorderSizePixel=0},holder)
            local sq4=new("Frame",{Position=UDim2.fromOffset(11,15),Size=UDim2.fromOffset(5,5),BackgroundColor3=c,BorderSizePixel=0},holder)
            cor(sq1,1)cor(sq2,1)cor(sq3,1)cor(sq4,1)
        elseif kind=="farm" then
            local bx=new("Frame",{Position=UDim2.fromOffset(3,9),Size=UDim2.fromOffset(14,11),BackgroundTransparency=1,BorderSizePixel=0},holder)
            cor(bx,2)
            new("UIStroke",{Color=c,Thickness=1.3},bx)
            new("Frame",{Position=UDim2.fromOffset(8,11),Size=UDim2.fromOffset(4,4),BackgroundColor3=c,BorderSizePixel=0,Rotation=45},holder)
        elseif kind=="player" then
            local head=new("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.fromScale(0.5,0.25),Size=UDim2.fromOffset(7,7),BackgroundColor3=c,BorderSizePixel=0},holder)
            cor(head,99)
            local bod=new("Frame",{AnchorPoint=Vector2.new(0.5,1),Position=UDim2.fromScale(0.5,0.86),Size=UDim2.fromOffset(15,8),BackgroundColor3=c,BorderSizePixel=0},holder)
            cor(bod,5)
        elseif kind=="killer" then
            local blade=new("Frame",{Position=UDim2.fromOffset(12,6),Size=UDim2.fromOffset(3,11),BackgroundColor3=c,BorderSizePixel=0,Rotation=-38},holder)
            cor(blade,2)
            local guard=new("Frame",{Position=UDim2.fromOffset(8,14),Size=UDim2.fromOffset(9,2),BackgroundColor3=c,BorderSizePixel=0,Rotation=-38},holder)
            cor(guard,2)
            local grip=new("Frame",{Position=UDim2.fromOffset(4,18),Size=UDim2.fromOffset(3,6),BackgroundColor3=c,BorderSizePixel=0,Rotation=-38},holder)
            cor(grip,1)
        end
        return holder
    end

    -- ═══ components ═══
    local function row(parent,h)
        return new("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1},parent)
    end
    local function sec(parent,text)
        local r=row(parent,31)
        new("TextLabel",{Position=UDim2.fromOffset(3,4),Size=UDim2.new(1,-6,0,14),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=DIM,Text=string.upper(text)},r)
        new("Frame",{Position=UDim2.fromOffset(0,23),Size=UDim2.new(1,-5,0,1),BackgroundColor3=LINE,BorderSizePixel=0},r)
    end
    local function T(parent,text,def,cb,keyhint)
        local r=new("Frame",{Size=UDim2.new(1,-4,0,38),BackgroundColor3=CARD,BackgroundTransparency=0.15,BorderSizePixel=0},parent)
        cor(r,7)
        new("UIStroke",{Color=ACC2,Thickness=1,Transparency=0.25},r)
        new("TextLabel",{Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-115,1,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=TXT,Text=text},r)
        if keyhint then
            new("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-56,0.5,0),Size=UDim2.fromOffset(32,14),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=9,TextColor3=DIM,TextXAlignment=Enum.TextXAlignment.Right,Text="["..keyhint.."]"},r)
        end
        local track=new("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.fromOffset(38,19),BackgroundColor3=BG,BorderSizePixel=0},r)
        cor(track,99)
        local stroke=new("UIStroke",{Color=ACC2,Thickness=1,Transparency=0.1},track)
        local knob=new("Frame",{Position=UDim2.fromOffset(3,3),Size=UDim2.fromOffset(13,13),BackgroundColor3=DIM,BorderSizePixel=0},track)
        cor(knob,99)
        local state=false
        local function set(v)
            state=v
            stroke.Color=v and ACC or ACC2
            knob.BackgroundColor3=v and ACC or DIM
            TS:Create(knob,TweenInfo.new(0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=v and UDim2.fromOffset(22,3) or UDim2.fromOffset(3,3)}):Play()
            cb(v)
        end
        local hit=new("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false,BorderSizePixel=0},r)
        hit.MouseButton1Click:Connect(function() set(not state) end)
        r.MouseEnter:Connect(function() TS:Create(r,TweenInfo.new(0.12),{BackgroundColor3=HOVER}) end)
        r.MouseLeave:Connect(function() TS:Create(r,TweenInfo.new(0.12),{BackgroundColor3=CARD}) end)
        if def then set(true) end
    end
    local function SL(parent,text,mn,mx,def,cb,dec)
        dec=dec or 0
        local r=new("Frame",{Size=UDim2.new(1,-4,0,48),BackgroundColor3=CARD,BackgroundTransparency=0.15,BorderSizePixel=0},parent)
        cor(r,7)
        new("UIStroke",{Color=ACC2,Thickness=1,Transparency=0.25},r)
        new("TextLabel",{Position=UDim2.fromOffset(12,5),Size=UDim2.new(1,-75,0,15),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=TXT,Text=text},r)
        local vl=new("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,5,0),Size=UDim2.fromOffset(54,15),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=ACC,TextXAlignment=Enum.TextXAlignment.Right,Text=tostring(def)},r)
        local tr=new("Frame",{Position=UDim2.new(0,12,1,-13),Size=UDim2.new(1,-24,0,4),BackgroundColor3=LINE,BorderSizePixel=0},r)
        cor(tr,99)
        local fl=new("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=ACC,BorderSizePixel=0},tr)
        cor(fl,99)
        local function upd(a)
            a=math.clamp(a,0,1)
            local val=math.floor((mn+(mx-mn)*a)*(10^dec)+0.5)/(10^dec)
            fl.Size=UDim2.new(a,0,1,0)
            vl.Text=string.format("%."..dec.."f",val)
            cb(val)
        end
        upd((def-mn)/(mx-mn))
        local dg=false
        tr.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dg=true
                upd((i.Position.X-tr.AbsolutePosition.X)/math.max(tr.AbsoluteSize.X,1))
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dg and i.UserInputType==Enum.UserInputType.MouseMovement then
                upd((i.Position.X-tr.AbsolutePosition.X)/math.max(tr.AbsoluteSize.X,1))
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then dg=false end
        end)
        r.MouseEnter:Connect(function() TS:Create(r,TweenInfo.new(0.12),{BackgroundColor3=HOVER}) end)
        r.MouseLeave:Connect(function() TS:Create(r,TweenInfo.new(0.12),{BackgroundColor3=CARD}) end)
    end

    -- ═══ single scrollable page — v15: NATIVE scrolling (wheel sinks, no camera zoom, mobile touch works, visible scrollbar) ═══
    local page = new("ScrollingFrame",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ScrollBarThickness=3,ScrollBarImageColor3=ACC,BorderSizePixel=0,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(0,0,0,0),ScrollingDirection=Enum.ScrollingDirection.Y},pageHost)
    new("UIListLayout",{Padding=UDim.new(0,5)},page)
    new("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),PaddingTop=UDim.new(0,11),PaddingBottom=UDim.new(0,10)},page)

    local NAV = {}
    local activeNav = 1
    local navSuppressUntil = 0

    local function applyNavVisuals(idx)
        for i,n in ipairs(NAV) do
            local on = i == idx
            n.lbl.TextColor3 = on and TXT or DIM
            n.lbl.Font = on and Enum.Font.GothamBold or Enum.Font.Gotham
            n.btn.BackgroundTransparency = on and 0 or 1
            n.btn.BackgroundColor3 = on and HOVER or CARD
            n.ind.Visible = on
            if n.iconFrame then n.iconFrame:Destroy() end
            n.iconFrame = icon(n.btn, n.kind, on)
        end
    end

    local function maxScroll()
        local m = page.AbsoluteCanvasSize.Y - page.AbsoluteSize.Y
        if m < 0 then m = 0 end
        return m
    end

    local function selectNav(idx)
        local nav = NAV[idx]
        if not nav then return end
        activeNav = idx
        applyNavVisuals(idx)
        navSuppressUntil = os.clock() + 0.6
        if nav.section and nav.section.Parent then
            local scrollPos = nav.section.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y - 8
            if scrollPos < 0 then scrollPos = 0 end
            local ms = maxScroll()
            if scrollPos > ms then scrollPos = ms end
            TS:Create(page, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, scrollPos)}):Play()
        end
    end

    local function addNav(label, kind, sectionRef)
        local btn=new("TextButton",{Size=UDim2.new(1,0,0,34),BackgroundColor3=CARD,BackgroundTransparency=1,Text="",AutoButtonColor=false,BorderSizePixel=0},sideList)
        cor(btn,7)
        local ind=new("Frame",{Position=UDim2.fromOffset(0,7),Size=UDim2.fromOffset(3,20),BackgroundColor3=ACC,BorderSizePixel=0,Visible=false},btn)
        cor(ind,2)
        local iconFrame=icon(btn,kind,false)
        local lbl=new("TextLabel",{Position=UDim2.fromOffset(32,0),Size=UDim2.new(1,-38,1,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=DIM,Text=label},btn)
        local idx=#NAV+1
        btn.MouseEnter:Connect(function()
            if activeNav ~= idx then btn.BackgroundTransparency=0.5 end
        end)
        btn.MouseLeave:Connect(function()
            if activeNav ~= idx then btn.BackgroundTransparency=1 end
        end)
        btn.MouseButton1Click:Connect(function() selectNav(idx) end)
        local entry = {btn=btn, ind=ind, lbl=lbl, kind=kind, iconFrame=iconFrame, section=sectionRef}
        table.insert(NAV, entry)
        return entry
    end

    -- ═══ ESP ═══
    local esp={}
    local function espFor(p)
        local e=esp[p]
        if not e then return end
        if e.h then e.h:Destroy() e.h=nil end
        if e.bb then e.bb:Destroy() e.bb=nil end
        local c=p.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") then return end
        local head=c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
        if not head then return end
        e.h=new("Highlight",{FillColor=SURV_C,FillTransparency=0.75,OutlineColor=SURV_C,OutlineTransparency=0.2,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Enabled=S.ESP,Adornee=c},c)
        e.bb=new("BillboardGui",{Size=UDim2.fromOffset(170,42),StudsOffset=Vector3.new(0,2.3,0),AlwaysOnTop=true,Enabled=S.ESP,Adornee=head},head)
        e.name=new("TextLabel",{Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,0,15),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=TXT,TextStrokeTransparency=0.8,Text=p.Name},e.bb)
        e.sub=new("TextLabel",{Position=UDim2.fromOffset(0,15),Size=UDim2.new(1,0,0,12),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=10,TextColor3=DIM,TextStrokeTransparency=0.85,Text=""},e.bb)
        local hb=new("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,31),Size=UDim2.fromOffset(80,3),BackgroundColor3=Color3.fromRGB(20,10,12),BorderSizePixel=0},e.bb)
        e.hpfill=new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=SURV_C,BorderSizePixel=0},hb)
    end
    local function addE(p)
        if p==LP or esp[p] then return end
        esp[p]={}
        espFor(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.3)
            espFor(p)
        end)
    end
    for _,p in Players:GetPlayers() do addE(p) end
    Players.PlayerAdded:Connect(addE)
    Players.PlayerRemoving:Connect(function(p)
        if esp[p] then
            if esp[p].h then esp[p].h:Destroy() end
            if esp[p].bb then esp[p].bb:Destroy() end
        end
        esp[p]=nil
        downCache[p]=nil
        killCache[p]=nil
        killSkip[p]=nil
    end)

    local lockerHL,exitE={},{}

    -- ═══ loot farm ═══
    local farmOrigin,farmCount,farmDone=nil,0,false
    task.spawn(function()
        while gui.Parent do
            if S.Farm then
                ref()
                if hrp and (not R.active) and (not isKiller(LP)) then
                    local target=nil
                    for _,loot in ipairs(CS:GetTagged("Loot")) do
                        if loot:IsDescendantOf(workspace) then
                            local b=loot:FindFirstChild("Border",true)
                            if b and b:IsA("BasePart") then target={loot=loot,b=b} break end
                        end
                    end
                    if target then
                        if not farmOrigin then farmOrigin=hrp.CFrame farmDone=false end
                        farmCount=farmCount+1
                        hrp.CFrame=target.b.CFrame+Vector3.new(0,1.5,0)
                        pcall(function()
                            firetouchinterest(hrp,target.b,0)
                            task.wait(0.05)
                            firetouchinterest(hrp,target.b,1)
                        end)
                        CS:RemoveTag(target.loot,"Loot")
                        task.wait(S.FarmDelay)
                    else
                        if farmOrigin and (not farmDone) then
                            hrp.CFrame=farmOrigin
                            farmDone=true
                            N("farm","cleared — "..farmCount.." total, watching respawns")
                        end
                        task.wait(1)
                    end
                else
                    task.wait(0.2)
                end
            else
                task.wait(0.3)
            end
        end
    end)

    -- ═══ sections ═══

    -- VISUALS
    local visualsSection = new("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y},page)
    new("UIListLayout",{Padding=UDim.new(0,5)},visualsSection)
    do
        sec(visualsSection,"players")
        T(visualsSection,"player esp",true,function(v) S.ESP=v end)
    end

    -- RESCUE
    local rescueSection = new("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y},page)
    new("UIListLayout",{Padding=UDim.new(0,5)},rescueSection)
    do
        sec(rescueSection,"when you're downed")
        T(rescueSection,"auto rescue",true,function(v) S.AutoRescue=v end,"G")
        sec(rescueSection,"helping others")
        T(rescueSection,"auto heal downed players",false,function(v)
            S.AutoHeal=v
            if v then N("rescue","auto heal on — will chain to every safe downed player") end
        end)
        SL(rescueSection,"min killer distance to heal",20,80,40,function(v) S.HealDanger=v end)
    end

    -- GAME
    local gameSection = new("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y},page)
    new("UIListLayout",{Padding=UDim.new(0,5)},gameSection)
    do
        sec(gameSection,"lockers")
        T(gameSection,"auto locker (hide from killer)",false,function(v) S.AutoLocker=v end,"H")
        SL(gameSection,"hide when killer within",15,80,35,function(v) S.LockerIn=v end)
        SL(gameSection,"come out when killer beyond",30,150,70,function(v) S.LockerOut=v end)
        T(gameSection,"locker esp (green = free, red = taken)",false,function(v) S.LockerESP=v end)
        sec(gameSection,"escape")
        T(gameSection,"auto escape (waits for doors to open)",false,function(v) S.AutoEscape=v end)
        T(gameSection,"exit esp",true,function(v) S.ExitESP=v end)
    end

    -- KILLER MODE
    local killerSection = new("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y},page)
    new("UIListLayout",{Padding=UDim.new(0,5)},killerSection)
    do
        sec(killerSection,"massacre")
        T(killerSection,"kill all (sweep the round)",false,function(v)
            S.KillAll=v
            if v and isKiller(LP) then
                N("killer mode","sweeping the round")
            elseif v then
                N("killer mode","armed — starts the moment you become the killer")
            end
        end)
        SL(killerSection,"delay between kills",0.2,2,0.5,function(v) S.KillDelay=v end,2)
    end

    -- FARM
    local farmSection = new("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y},page)
    new("UIListLayout",{Padding=UDim.new(0,5)},farmSection)
    do
        sec(farmSection,"loot")
        T(farmSection,"loot auto-farm",false,function(v)
            S.Farm=v
            if v then
                ref()
                farmOrigin,farmCount,farmDone=(hrp and hrp.CFrame) or nil,0,false
                N("farm","running — tps back when the map's cleared")
            else
                farmOrigin=nil
            end
        end)
        SL(farmSection,"delay between loot",0.1,1.5,0.4,function(v) S.FarmDelay=v end,2)
    end

    -- PLAYER (v15: + noclip)
    local playerSection = new("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y},page)
    new("UIListLayout",{Padding=UDim.new(0,5)},playerSection)
    do
        sec(playerSection,"movement")
        T(playerSection,"speed hack",false,function(v)
            S.SpdOn=v
            if not v then
                refIfNeeded()
                if hum and hum.Parent then hum.WalkSpeed = 16 end
                pcall(function() LP:SetAttribute("WalkSpeed", 16) end)
            end
        end)
        SL(playerSection,"walkspeed",16,150,30,function(v) S.Spd=v end)
    end

    -- ═══ nav wiring ═══
    addNav("visuals","visuals",visualsSection)
    addNav("rescue","rescue",rescueSection)
    addNav("game","game",gameSection)
    addNav("killer mode","killer",killerSection)
    addNav("farm","farm",farmSection)
    addNav("player","player",playerSection)
    selectNav(1)

    task.spawn(killerHunt)

    -- ═══ LOOPS ═══
    local dead = false
    local eT, fT, wT, lkT, spyT = 0, 0, 0, 0, 0
    local nextHop = 0
    local hopping = false
    local knownKiller = nil
    local exitDoneRound = false
    local exitCooldown = 0
    RS.Heartbeat:Connect(function(dt)
        if dead or (not gui.Parent) then return end
        refIfNeeded()

        pcall(stepRescue, dt)

        -- scroll-spy (native scroll, bottom-override)
        spyT = spyT + dt
        if spyT >= 0.2 then
            spyT = 0
            if os.clock() > navSuppressUntil then
                local ms = maxScroll()
                local current = 1
                if ms > 0 and page.CanvasPosition.Y >= ms - 4 then
                    current = #NAV
                else
                    local threshold = page.AbsoluteSize.Y * 0.35
                    for i, n in ipairs(NAV) do
                        if n.section and n.section.Parent then
                            local off = n.section.AbsolutePosition.Y - page.AbsolutePosition.Y
                            if off <= threshold then current = i end
                        end
                    end
                end
                if current ~= activeNav then
                    activeNav = current
                    applyNavVisuals(current)
                end
            end
        end

        -- auto locker
        lkT = lkT + dt
        if lkT >= 0.3 then
            lkT = 0
            if S.AutoLocker and hrp and hum and (not isKiller(LP)) then
                local lk = myLocker()
                if lk then
                    local kp = killerPos()
                    if (not kp) or (kp - hrp.Position).Magnitude > S.LockerOut then
                        pcall(exitMyLocker)
                    elseif kp and (not hopping) and os.clock() > nextHop and (kp - hrp.Position).Magnitude < 15 then
                        local better = findSaferLocker(kp, lk)
                        if better then
                            hopping = true
                            nextHop = os.clock() + 3
                            task.spawn(function()
                                if exitMyLocker() then
                                    task.wait(0.1)
                                    enterSafestLocker()
                                end
                                hopping = false
                            end)
                        end
                    end
                elseif hum.Health > 0 and (not isDowned(LP)) then
                    local kp = killerPos()
                    if kp and (kp - hrp.Position).Magnitude < S.LockerIn then
                        pcall(enterSafestLocker)
                    end
                end
            end
        end

        -- auto escape
        wT = wT + dt
        if wT >= 0.4 then
            wT = 0
            if S.AutoEscape then
                if LP:GetAttribute("Escaped") == true then
                    if not exitDoneRound then
                        exitDoneRound = true
                        N("escape","escaped — auto exit re-arms next round")
                    end
                else
                    if exitDoneRound then
                        exitDoneRound = false
                    end
                    if hrp and hum and hum.Health > 0
                        and (not isDowned(LP)) and (not isKiller(LP))
                        and LP:GetAttribute("Dead") ~= true
                        and (not escapeBusy) and os.clock() > exitCooldown then
                        for _, ex in ipairs(getExits()) do
                            if exitOpen(ex) and ex.trigger then
                                exitCooldown = os.clock() + 10
                                N("escape","doors open — going through")
                                tryEscape(ex)
                                break
                            end
                        end
                    end
                end
            end
        end

        -- player ESP
        eT = eT + dt
        if eT >= 0.15 then
            eT = 0
            local myPos = hrp and hrp.Position
            for p, e in pairs(esp) do
                local c = p.Character
                local head = c and (c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart"))
                local stale = (not e.h) or (not e.h.Parent) or (e.h.Adornee ~= c)
                    or (not e.bb) or (not e.bb.Parent) or (e.bb.Adornee ~= head)
                if stale then
                    pcall(espFor, p)
                    e = esp[p]
                end
                if e then
                    local killer = isKiller(p)
                    local downed = (not killer) and isDowned(p)
                    local roleC = killer and KILL_C or (downed and DOWN_C or SURV_C)
                    if e.h and e.h.Parent then
                        e.h.Enabled = S.ESP
                        e.h.FillColor = roleC
                        e.h.OutlineColor = roleC
                    end
                    if e.bb and e.bb.Parent then
                        e.bb.Enabled = S.ESP
                        if S.ESP then
                            if e.name then
                                e.name.Text = p.Name
                                e.name.TextColor3 = roleC
                            end
                            if e.sub then
                                local role = killer and "KILLER" or (downed and "DOWNED" or "")
                                if downed then
                                    local b = p:GetAttribute("BleedOutHealth")
                                    if type(b) == "number" then
                                        role = "DOWNED · bleed " .. math.floor(b) .. "/200"
                                    end
                                end
                                if myPos and e.bb.Adornee then
                                    local studs = math.floor((e.bb.Adornee.Position - myPos).Magnitude + 0.5)
                                    if role ~= "" then
                                        e.sub.Text = role .. " · " .. studs .. " studs"
                                    else
                                        e.sub.Text = studs .. " studs"
                                    end
                                else
                                    e.sub.Text = role
                                end
                            end
                            if e.hpfill then
                                local h = c and c:FindFirstChildOfClass("Humanoid")
                                if h and h.MaxHealth > 0 and h.MaxHealth < math.huge then
                                    local frac = math.clamp(h.Health / h.MaxHealth, 0, 1)
                                    e.hpfill.Size = UDim2.new(frac, 0, 1, 0)
                                    e.hpfill.BackgroundColor3 = SURV_C:Lerp(KILL_C, 1 - frac)
                                else
                                    e.hpfill.Size = UDim2.new(1, 0, 1, 0)
                                end
                            end
                        end
                    end
                end
            end
        end

        -- locker + exit ESP + footer text
        fT = fT + dt
        if fT >= 0.5 then
            fT = 0
            if S.LockerESP then
                local seen = {}
                for _, lk in ipairs(getLockers(true)) do
                    seen[lk.model] = true
                    local h = lockerHL[lk.model]
                    if (not h) or (not h.Parent) then
                        h = new("Highlight",{DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Adornee=lk.model},lk.model)
                        lockerHL[lk.model] = h
                    end
                    h.FillTransparency = 0.6
                    h.OutlineTransparency = 0.1
                    if lk.occupant == "" then
                        h.FillColor, h.OutlineColor = SURV_C, SURV_C
                    else
                        h.FillColor, h.OutlineColor = KILL_C, KILL_C
                    end
                end
                for m, h in pairs(lockerHL) do
                    if (not seen[m]) or (not m.Parent) then
                        h:Destroy()
                        lockerHL[m] = nil
                    end
                end
            else
                for _, h in pairs(lockerHL) do h:Destroy() end
                lockerHL = {}
            end
            if S.ExitESP then
                local seen = {}
                for _, ex in ipairs(getExits(true)) do
                    seen[ex.model] = true
                    local e = exitE[ex.model]
                    if (not e) or (not e.h) or (not e.h.Parent) then
                        e = {}
                        e.h = new("Highlight",{DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Adornee=ex.model},ex.model)
                        local anchor = ex.trigger or ex.door1
                        if anchor then
                            e.bb = new("BillboardGui",{Size=UDim2.fromOffset(120,16),StudsOffset=Vector3.new(0,4,0),AlwaysOnTop=true,Adornee=anchor},anchor)
                            e.lbl = new("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=TXT,TextStrokeTransparency=0.7,Text="EXIT"},e.bb)
                        end
                        exitE[ex.model] = e
                    end
                    local open = exitOpen(ex)
                    local col = open and SURV_C or DOWN_C
                    e.h.FillColor, e.h.OutlineColor = col, col
                    e.h.FillTransparency = 0.55
                    e.h.OutlineTransparency = 0.1
                    if e.lbl then
                        if open then
                            e.lbl.Text = "EXIT — OPEN"
                            e.lbl.TextColor3 = SURV_C
                        else
                            e.lbl.Text = "EXIT"
                            e.lbl.TextColor3 = DOWN_C
                        end
                    end
                end
                for m, e in pairs(exitE) do
                    if (not seen[m]) or (not m.Parent) then
                        if e.h then e.h:Destroy() end
                        if e.bb then e.bb:Destroy() end
                        exitE[m] = nil
                    end
                end
            else
                for _, e in pairs(exitE) do
                    if e.h then e.h:Destroy() end
                    if e.bb then e.bb:Destroy() end
                end
                exitE = {}
            end

            -- footer text
            local amK = isKiller(LP)
            local kp = killerPos()
            if amK then
                kText.Text = "YOU · " .. killCount .. " kills"
                kText.TextColor3 = KILL_C
            elseif kp and hrp then
                local kd = math.floor((kp - hrp.Position).Magnitude + 0.5)
                kText.Text = "killer " .. kd .. "m"
                if kd < 35 then
                    kText.TextColor3 = KILL_C
                elseif kd < 80 then
                    kText.TextColor3 = DOWN_C
                else
                    kText.TextColor3 = DIM
                end
            else
                kText.Text = "no killer"
                kText.TextColor3 = DIM
            end
        end

        -- killer announce
        local kName = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and isKiller(p) then
                kName = p.Name
                break
            end
        end
        if kName and kName ~= knownKiller then
            knownKiller = kName
            N("adamz.zz","killer detected: " .. kName)
        elseif (not kName) and knownKiller then
            knownKiller = nil
        end

        -- v15 speed: fresh refs every frame + game attribute override
        if S.SpdOn then
            refIfNeeded()
            if hum and hum.Parent then
                hum.WalkSpeed = S.Spd
            end
            pcall(function()
                if LP:GetAttribute("WalkSpeed") ~= S.Spd then
                    LP:SetAttribute("WalkSpeed", S.Spd)
                end
            end)
        end
    end)

    UIS.InputBegan:Connect(function(i, gp)
        if dead or (not gui.Parent) then return end
        if gp then return end
        if i.KeyCode == Enum.KeyCode.RightShift then
            win.Visible = not win.Visible
        end
        if i.KeyCode == Enum.KeyCode.G then
            ref()
            if R.active then
                endRescue(true)
                N("rescue","returned to your spot")
            elseif hrp and (not isKiller(LP)) then
                startGetHealed(true)
            end
        end
        if i.KeyCode == Enum.KeyCode.H then
            if myLocker() then
                pcall(exitMyLocker)
                N("locker","exited")
            else
                if not enterSafestLocker() then N("locker","no empty lockers") end
            end
        end
    end)

    -- anti-afk (always on)
    LP.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end

-- gate wiring
local function access()
    if box.Text == PASS then
        stt.Text = "access granted"
        stt.TextColor3 = ACC
        task.delay(0.25, function()
            if gate.Parent then gate:Destroy() end
            local okHub, errHub = pcall(buildHub)
            if not okHub then
                print("[adamz.zz] HUB ERROR: " .. tostring(errHub))
                N("adamz.zz error", tostring(errHub))
            end
        end)
    else
        stt.Text = "wrong password"
        stt.TextColor3 = RED
        gst.Color = RED
        box.Text = ""
        task.spawn(function()
            local base = gate.Position
            local offs = { -8, 6, -4, 2, 0 }
            for _, off in ipairs(offs) do
                if not gate.Parent then break end
                gate.Position = base + UDim2.fromOffset(off, 0)
                task.wait(0.04)
            end
        end)
        task.delay(1, function()
            if gst.Parent then gst.Color = ACC end
        end)
    end
end
gob.MouseButton1Click:Connect(access)
box.FocusLost:Connect(function(e)
    if e then access() end
end)

N("adamz.zz","injected — enter the password")

end)

-- error surface
if not ok then
    print("[adamz.zz] FATAL ERROR: " .. tostring(err))
    pcall(function()
        local p2 = game:GetService("Players").LocalPlayer
        local pg = p2:WaitForChild("PlayerGui", 5)
        if not pg then return end
        local sgui = Instance.new("ScreenGui")
        sgui.Name = "adamz_err"
        sgui.ResetOnSpawn = false
        sgui.DisplayOrder = 999999
        sgui.Parent = pg
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 0, 100)
        lbl.Position = UDim2.new(0, 10, 0, 10)
        lbl.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        lbl.TextWrapped = true
        lbl.TextSize = 12
        lbl.Font = Enum.Font.Gotham
        lbl.Text = "adamz.zz ERROR (send this to dev):\n" .. tostring(err)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Top
        lbl.Parent = sgui
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = lbl
    end)
    pcall(function()
        SG:SetCore("SendNotification",{Title="adamz.zz error",Text=tostring(err),Duration=15})
    end)
end
-- ==========================================
-- INJEKSI MOXXA: FULL REBRAND & BYPASS
-- ==========================================
task.spawn(function()
    task.wait(0.5)
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local LP = game:GetService("Players").LocalPlayer
    
    -- A. LOOPING GANTI NAMA DI SELURUH UI
    -- Ini bakal ngeganti tulisan Adam/Karim jadi MOXXA | STG secara real-time
    RunService.Heartbeat:Connect(function()
        pcall(function()
            for _, v in pairs(CoreGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    local txt = string.lower(v.Text)
                    if string.find(txt, "adam") or string.find(txt, "karim") or string.find(txt, "private build") then
                        v.Text = "MOXXA | STG"
                        v.TextColor3 = Color3.fromRGB(255, 0, 0) -- Warna Merah
                    end
                end
            end
        end)
    end)

    -- B. HAPUS UI LOGIN ASLI & BIKIN UI LOGIN MOXXA
    task.wait(1) -- Nunggu UI Karim muncul
    for _, v in pairs(CoreGui:GetDescendants()) do
        if v:IsA("TextButton") and v.Text == "ACCESS" then
            -- Hancurkan Frame Login Asli
            if v.Parent and v.Parent.Parent then
                pcall(function() v.Parent.Parent:Destroy() end)
            end
        end
    end

    -- Bikin UI Login MOXXA
    local LoginGui = Instance.new("ScreenGui")
    LoginGui.Name = "MoxxaLogin"
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
    Input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
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
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12

    -- C. LOGIKA PASSWORD MOXXA
    Btn.MouseButton1Click:Connect(function()
        if Input.Text == "moxxatzy" then
            LoginGui:Destroy()
            
            -- Nyalain Gacha Reveal Otomatis
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
