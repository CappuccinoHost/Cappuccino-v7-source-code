-- Note: ITS PATCHED FOR NOW DUE TO AN UPDATE
-- This is being coded by doggo
-- Note this game doesn't have a lot of cheats on it

--// library

local CreateLib = loadstring(readfile("cappUI.lua"))()


--// Services

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

--// Modules

local BasicModule = require(game.ReplicatedStorage.Modules.Shared.BasicModule)

--// Locals

local LocalPlayer = Players.LocalPlayer

local Map = Workspace.map
local Items = Workspace.Items

local Npc = Map.NPC
local SpecialParts = Map.SpecialParts

local Tinkerers = Npc.Tinkerers
local Bulwark = Npc.Bulwark

local Maxwell = Bulwark.Maxwell

local Betting = SpecialParts.EssianBetting
local Board 
local BoardSurface 

local Combat = game:GetService("ReplicatedStorage").Modules.Shared.Combat

spawn(function()
    Board = Betting:WaitForChild("Board")
    BoardSurface = Board:WaitForChild("SurfaceGui")
end)

--// Variables

local LocalName = LocalPlayer.Data.Character.name.Value

--// Settings

local LAST_FOG_END = Lighting.FogEnd
local TICK_DISABLED = 0

local SETTINGS = {
    WEEP_WEIGHT = false,
    WEIGHT = 0,

    NO_FOG = false,

    HITBOX = false,
    HITBOX_TRANSPARENCY = 0.5,
    
    TINKERER_FARM = false,
    AUTO_PICKUP = false,
    AUTO_KILL = false,
    AUTO_SELL = false,
    AUTO_TELEPORT = false,
    LOOP_TELEPORT = false,
    
    BEN_FARM = false,
    AUTO_BET = false,
    AUTO_BEGIN_BET = false,
    AUTO_KILL_BEN = false,
    WHICH_BEN = 1,
    
    KILL_AURA = false,
    AURA_DISTANCE = 8,
    AURA_COOLDOWN = 0.45,
    AURA_LOCK_NPC = false,
    AURA_LOCK_PLAYER = false,
    AURA_INSTANT_KILL = false,

    OVERWRITE_HIT = false,
    OVERWRITE_HIT_RANGE = 8,
}


--// Tables

local NPCs = {}

local DialogFormat = {
    isNotBetting = function(WhichBen)
        local Table = {
            {1, 7},
            {3, 1},
            {WhichBen, 1},
            {3, 3},
            {1, 1},
            {2, 1},
            {1, 1},
        }

        for _, number in pairs(Table) do
            local AmountOfRepeats = number[2]
            local WhichOption = number[1]

            for i = 1, AmountOfRepeats  do
                game:GetService("ReplicatedStorage").Events.DialogueRemote:FireServer(WhichOption)
                wait(.1)
            end
        end
    end,

    beginBet = function()
        local Table = {
            {2, 1},
            {1, 1},
        }

        for _, number in pairs(Table) do
            local AmountOfRepeats = number[2]
            local WhichOption = number[1]

            for i = 1, AmountOfRepeats  do
                game:GetService("ReplicatedStorage").Events.DialogueRemote:FireServer(WhichOption)
                wait(.1)
            end
        end
    end,
}

--// Functions

local function ParryCharacterChecker(Character, Player)
    local RootPart = Character == nil and nil or Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character == nil and nil or Character:FindFirstChild("Humanoid")

    
    if 
        not Character
        or not RootPart 
    then 
        return "DEBUG[1]", RootPart, Character
    end
end

-- Fuck you
local function ChangeSim()
    sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius", math.huge)
end

-- Returns the Tinkerer that is in range.
local function availableTinkerer(YourLocation)
    for _, tinkerer in pairs(Tinkerers:GetChildren()) do
        local ChatBox = tinkerer:FindFirstChild("ChatBox")
        if ChatBox then
            local DistanceBetweenChatBox = (ChatBox.Position - YourLocation).Magnitude

            if DistanceBetweenChatBox < ChatBox.ClickDetector.MaxActivationDistance then
                return tinkerer
            end
        end
    end

    return false
end

-- Kill aura function that makes the character lock on that character and attack.
local LastSwong = 0
local function LockAttackPosition(Part)
    local WeaponName = LocalPlayer.StarterGear:FindFirstChildWhichIsA("Tool")

    if not WeaponName then 
        return
    end

    local Character = LocalPlayer.Character
    local RootPart = Character == nil and nil or Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character == nil and nil or Character:FindFirstChild("Humanoid")

    if 
        not Character 
        or not RootPart
    then
        return "DEBUG[2]", RootPart, Character
    end

    if tick() - LastSwong > SETTINGS.AURA_COOLDOWN then
        LastSwong = tick()
        local Distance = (RootPart.Position - Part.Position).Magnitude
        local SwingPos = CFrame.new(RootPart.Position, Part.Position) * CFrame.new(0, 0, -(0.5 * Distance))
        local Weapon = Combat[WeaponName.Name]
        local Attack = Weapon:FindFirstChild("BaseAttack") or Weapon:FindFirstChild("BaseAttack2")

        if Attack then 
            game:GetService("ReplicatedStorage").Events.ClientRequest:FireServer("server2", Attack.Name, SwingPos, 3)
        end
    end
end

local function runAura()
    local Character = LocalPlayer.Character
    local RootPart = Character == nil and nil or Character:FindFirstChild("HumanoidRootPart")

    if 
        not Character 
        or not RootPart
    then
        return "DEBUG[3]", RootPart, Character
    end

    if SETTINGS.AURA_LOCK_NPC then 
        for _, npc in pairs(NPCs) do
            if npc ~= nil and npc.Parent ~= nil then
                local Position = npc:GetModelCFrame().Position
                local DistanceBetweenNPC = (RootPart.Position - Position).Magnitude
    
                if
                    DistanceBetweenNPC < SETTINGS.AURA_DISTANCE 
                    and npc.Humanoid.Health > 0
                    and npc:GetAttribute("Blocking") == nil
                then
                    local RootPart = npc.HumanoidRootPart

                    LockAttackPosition(RootPart)

                    if SETTINGS.AURA_INSTANT_KILL then
                        ChangeSim()
                        npc.Humanoid.Health = 0
                    end
                end
            end
        end
    end

    if SETTINGS.AURA_LOCK_PLAYER then
        for _, player in pairs(Players:GetPlayers()) do
            if 
                player.Character 
                and player ~= LocalPlayer 
                and player.Character:FindFirstChild("Humanoid") 
                and player.Character:FindFirstChild("HumanoidRootPart") 
            then
                local Position =  player.Character:GetModelCFrame().Position
                local DistanceBetweenPlayer = (RootPart.Position - Position).Magnitude

                if DistanceBetweenPlayer < SETTINGS.AURA_DISTANCE and player.Character.Humanoid.Health > 0 and player:GetAttribute("Blocking") == nil then
                    local RootPart = player.Character.HumanoidRootPart
                    
                    LockAttackPosition(RootPart)
                end
            end
        end
    end
end

-- This function will kill all npcs, Teleport/Grab the dropped items and sell it.
local function runFarm()
    if not SETTINGS.TINKERER_FARM then 
        return
    end
    
    local Character = LocalPlayer.Character
    local RootPart = Character == nil and nil or Character:FindFirstChild("HumanoidRootPart")
    local hasStrap = nil

    if 
        not Character 
        or not RootPart
    then
        return "DEBUG[4]", RootPart, Character
    end
    
    hasStrap = Character:FindFirstChild("StrapAttach")

    -- Sell items.
    do
        if 
            SETTINGS.AUTO_SELL 
            and hasStrap 
        then
            local Tinkerer = availableTinkerer(RootPart.Position)
    
            if Tinkerer then
                -- Sells the item.
                fireclickdetector(Tinkerer.ChatBox.ClickDetector, 0)
                wait()
                for t=1,3 do game:GetService("ReplicatedStorage").Events.DialogueRemote:FireServer(1) end
            end
        end
    end

    -- Item pick up/teleport to you and kill npcs
    do 
        for _, item in pairs(Items:GetChildren()) do
            if item:FindFirstChild("Detector") then
                local DistanceBetweenItem = (item.Detector.Position - RootPart.Position).Magnitude
                local MaxDistanceClick = item.Detector.ClickDetector.MaxActivationDistance
                
                -- Teleports the Item to you.
                if 
                    SETTINGS.AUTO_TELEPORT 
                    and DistanceBetweenItem < 150 
                then
                    if (not SETTINGS.LOOP_TELEPORT and DistanceBetweenItem > MaxDistanceClick) or SETTINGS.LOOP_TELEPORT then
                        ChangeSim()
                        item.Detector.CFrame = RootPart.CFrame * CFrame.new(0, 0, 2)
                    end
                end
    
                -- Picks up the item.
                if
                    SETTINGS.AUTO_PICKUP 
                    and DistanceBetweenItem < MaxDistanceClick 
                then
                    fireclickdetector(item.Detector.ClickDetector, 0)
                end
            end
        end
    
        if SETTINGS.AUTO_KILL then
            for _, instance in pairs(Workspace:GetChildren()) do
                local isNpc = instance:FindFirstChild("Data") and true or false
                local hasHumanoid = instance:FindFirstChild("Humanoid") and true or false
        
                -- Kills the npc
                if 
                    isNpc 
                    and hasHumanoid 
                then 
                    ChangeSim()
                    instance.Humanoid.Health = 0
                end
            end
        end
    end
end

-- Will autobet when in range and will auto kill the Ben that you didn't bet on.
local function runBetFarm()
    wait()
    
    if not Board or not SETTINGS.BEN_FARM then 
        return 
    end

    local isBetting = BoardSurface.TextBottom.Text:find(LocalName)
    local isRoundStarted = BoardSurface.TextTop.Text == "In round." and true or false
    local isReadyToBegin = BoardSurface.TextTop.Text == "Ready to begin." and true or false

    local DistanceBetweenChatBox = (Maxwell.ChatBox.Position - workspace.Camera.Focus.p).Magnitude -- Was to lazy to make the character/humanoidrootpart checks and check the rootpart.

    if 
        SETTINGS.AUTO_BET 
        and not isBetting 
    then
        if DistanceBetweenChatBox < Maxwell.ChatBox.ClickDetector.MaxActivationDistance then
           -- print("Betting.")

            fireclickdetector(Maxwell.ChatBox.ClickDetector, 0)
            wait(.1)
            DialogFormat.isNotBetting(SETTINGS.WHICH_BEN)
        end
        return
    elseif 
        SETTINGS.AUTO_BEGIN_BET 
        and isReadyToBegin 
    then
        if DistanceBetweenChatBox < Maxwell.ChatBox.ClickDetector.MaxActivationDistance then
            --print("Beginning bet.")

            fireclickdetector(Maxwell.ChatBox.ClickDetector, 0)
            wait(.1)
            DialogFormat.beginBet()
            wait(1)
        end
        return
    elseif 
        SETTINGS.AUTO_KILL_BEN 
        and isRoundStarted 
    then
        local BenNumberToKill = SETTINGS.WHICH_BEN == 1 and 2 or 1
        local Ben = workspace:FindFirstChild("Ben" .. tostring(BenNumberToKill))
        
        if Ben ~= nil and Ben:FindFirstChild("Humanoid") then 
            --print("Trying to kill", Ben, ":(")

            ChangeSim()            
            Ben.Humanoid.Health = 0
        end
    end
end

--// Lighting changec connection wthing omg it's night time already

Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
    if tick() - TICK_DISABLED < 0.5 then
        Lighting.FogEnd = LAST_FOG_END
    end

    if not SETTINGS.NO_FOG then 
        return
    end

    Lighting.FogEnd = 2e9
end)

--// Attribute

game.Players.LocalPlayer:GetAttributeChangedSignal("weight"):Connect(function()
    if SETTINGS.WEEP_WEIGHT then
        LocalPlayer:SetAttribute("weight", SETTINGS.WEIGHT)
    end
end)

--// Main

for _, instance in pairs(Workspace:GetChildren()) do
    if instance:FindFirstChild("Data") then
        table.insert(NPCs, instance)
        ParryCharacterChecker(instance)
    end
end

Workspace.ChildAdded:Connect(function(child)
    wait(0.2)
    if child:FindFirstChild("Data") then 
        table.insert(NPCs, child)
        ParryCharacterChecker(child)
    end
end)

--LockAttackPosition(workspace.Camera.CFrame.p)


CreateLib({
    theme = {
        accent = Color3.fromRGB(124, 170, 255),
        blur = true
    },
    tabs = {
        {name = "Rage", content = {
            {type = "toggle", state = false, text = "Kill Aura (Blatant)", callback = function(toggle)
                SETTINGS.KILL_AURA = toggle

                while SETTINGS. KILL_AURA do task.wait()
                    runAura()
                end
            end},

            {type = "toggle", state = SETTINGS.AURA_LOCK_NPC, text = "Target NPC(s)", callback = function(toggle)
                SETTINGS.AURA_LOCK_NPC = toggle
            end},

            {type = "toggle", state = SETTINGS.AURA_LOCK_PLAYER, text = "Target Player(s)", callback = function(toggle)
                SETTINGS.AURA_LOCK_PLAYER = toggle
            end},

            {type = "toggle", state = SETTINGS.AURA_INSTANT_KILL, text = "Instant Kill (NPC Only)", callback = function(toggle)
                SETTINGS.AURA_INSTANT_KILL = toggle
            end},

            {type = 'slider', min = 1, max = 15, value = SETTINGS.AURA_DISTANCE, float = 0.2, deg = ' studs', text = 'Aura Distance', callback = function(Number)
                SETTINGS.AURA_DISTANCE = Number
            end},

            {type = 'slider', min = 0, max = 2, value = SETTINGS.AURA_COOLDOWN, float = 0.01, deg = ' seconds', text = 'Aura Swing Cooldown', callback = function(Number)
                SETTINGS.AURA_COOLDOWN = Number
            end},
        }},

        --{name = "Combat", content = {
            --{type = "toggle", state = false, text = "Overwrite Hit", callback = function(toggle)
            --    SETTINGS.OVERWRITE_HIT = toggle
            --end},
            --
            --{type = 'slider', min = 0, max = 50, value = SETTINGS.OVERWRITE_HIT_RANGE, float = 0.1, deg = ' studs', text = 'Hit Max Range', callback = function(Number)
            --    SETTINGS.OVERWRITE_HIT_RANGE = Number
            --end},
        --}},

        {name = "Farms", content = {
            -- Tinkerer

           

            {type = "toggle", state = false, text = "Tinkerer(s) Farm", callback = function(toggle)
                SETTINGS.TINKERER_FARM = toggle
                
                while SETTINGS.TINKERER_FARM do task.wait()
                    runFarm()
                end
            end},

            {type = "toggle", state = SETTINGS.AUTO_PICKUP, text = "Auto Pickup", callback = function(toggle)
                SETTINGS.AUTO_PICKUP = toggle
            end},

            {type = "toggle", state = SETTINGS.AUTO_SELL, text = "Auto Sell", callback = function(toggle)
                SETTINGS.AUTO_SELL = toggle
            end},

            {type = "toggle", state = SETTINGS.AUTO_TELEPORT, text = "Auto Teleport", callback = function(toggle)
                SETTINGS.AUTO_TELEPORT = toggle
            end},

            {type = "toggle", state = SETTINGS.AUTO_KILL, text = "Auto Kill", callback = function(toggle)
                SETTINGS.AUTO_KILL = toggle
            end},

            {type = "toggle", state = SETTINGS.LOOP_TELEPORT, text = "Loop Teleport", callback = function(toggle)
                SETTINGS.LOOP_TELEPORT = toggle
            end},


            -- Betting

            {type = "toggle", state = SETTINGS. BEN_FARM, text = "Betting Farm", callback = function(toggle)
                SETTINGS.BEN_FARM = toggle
                
                while SETTINGS.BEN_FARM do task.wait()
                    runBetFarm()
                end
            end},

            {type = "toggle", state = SETTINGS.AUTO_BET, text = "Auto Bet On Ben x", callback = function(toggle)
                SETTINGS.AUTO_BET = toggle
            end},

            {type = "toggle", state = SETTINGS.AUTO_BEGIN_BET, text = "Auto Begin Bet", callback = function(toggle)
                SETTINGS.AUTO_BEGIN_BET = toggle
            end},

            {type = "toggle", state = SETTINGS.AUTO_KILL_BEN, text = "Auto Kill Enemy Ben", callback = function(toggle)
                SETTINGS.AUTO_KILL_BEN = toggle
            end},

            {type = 'slider', min = 1, max = 2, value = SETTINGS.WHICH_BEN, float = 1, deg = ' Ben', text = 'Bet For Ben x', callback = function(Number)
                SETTINGS.WHICH_BEN = Number
            end},
        }},

        {name = "Movement", content = {
            {type = "toggle", state = SETTINGS.WEEP_WEIGHT, text = "Overwrite Weight", callback = function(toggle)
                SETTINGS.WEEP_WEIGHT = toggle
                if SETTINGS.WEEP_WEIGHT then
                    LocalPlayer:SetAttribute("weight", SETTINGS.WEIGHT)
                end
            end},
            
            {type = 'textbox', placeholder = 'Weight Number', text = 'Weight Change To', clear = false, callback = function(string)
                SETTINGS.WEIGHT = string
                if SETTINGS.WEEP_WEIGHT then
                    LocalPlayer:SetAttribute("weight", SETTINGS.WEIGHT)
                end
            end},
        }},

        {name = "Visual", content = {
            {type = "toggle", state = false, text = "No Fog", callback = function(toggle)
                SETTINGS.NO_FOG = toggle

                if SETTINGS.NO_FOG then
                    LAST_FOG_END = Lighting.FogEnd < 500 and Lighting.FogEnd or LAST_FOG_END
                    wait()
                    Lighting.FogEnd = 2e9
                else
                    TICK_DISABLED = tick()
                end
            end},


            {type = "toggle", state = false, text = "Show Hitbox", callback = function(toggle)
                SETTINGS.HITBOX = toggle
            end},

            {type = 'slider', min = 0, max = 1, value = SETTINGS.HITBOX_TRANSPARENCY, float = 0.1, deg = ' Transparency', text = 'Hitbox Transparency', callback = function(Number)
                SETTINGS.HITBOX_TRANSPARENCY = Number
            end},
            
        }},

        {name = "Misc", content = {

        }},
    }
})

-- Autoparry

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then

    end
end


-- Hitbox
game.DescendantAdded:Connect(function(child)


    wait()
    if child.Name == "Hitbox" then 
        if SETTINGS.HITBOX then 
            child.Transparency = SETTINGS.HITBOX_TRANSPARENCY
        end
    end
end)