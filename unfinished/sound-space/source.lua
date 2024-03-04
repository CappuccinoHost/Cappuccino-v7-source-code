-- Note this script uses cap_v6 folder in workspace and cap_v6/replays for saving replays
-- 30 july 2022: I made it stable for now but i"ve no idea if there are bugs, i spended 5 hours on this so i hope it's worth it.
-- This is being coded by doggo

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerScripts =  LocalPlayer.PlayerScripts
local MapData = LocalPlayer.MapData

local GameScript = ReplicatedFirst:WaitForChild("GameScript")
local Music = GameScript.Music

local Client = workspace:WaitForChild("Client")
local Cursor = Client:WaitForChild("Cursor")
local GhostCursor = Client:WaitForChild("GhostCursor")

local GuiScript = PlayerScripts["3DGuiScript"]

local GuiScriptSenv = getsenv(GuiScript)
local GameScriptRequire = require(GameScript)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local SettingsShield = RobloxGui.SettingsShield.SettingsShield


local Misc = {
    OverwriteMap = false,
    FullTry = false,
    
    LastMap = 0,

    OverwriteData = "Enter map id here",
    LastData = "",
    LastMapData = "",

    Sounds = {
        ["Hit"] = {
            SoundId = "Enter sound id here",
            Volume = 1,
        },

        ["Miss"] = {
            SoundId = "Enter sound id here",
            Volume = 1,
        },

        ["Click"] = {
            SoundId = "Enter sound id here",
            Volume = 1,
        },
    },
} do
    local HookFunction; HookFunction = hookfunction(GameScriptRequire.LoadMap, function(MapId, Info, Value)
        
        Misc.LastMapData = Info.Data

        -- Full try Song
        if Misc.FullTry and Value then
            -- If the value is true that means it's doing a try out so when making it nil it'll stop the try out and more it the full try
            Value = nil
        end

        -- Overwrite Map Id
        if Misc.LastMap == 0 then
            
            Misc.LastMap = MapId
            Misc.LastData = Info.Data

        elseif Misc.OverwriteMap then

            MapId = Misc.LastMap
            Info.Data = Misc.LastData

        end

        -- Overwrite Map
        if Misc.OverwriteData:find("|") then

            Info.Data = Misc.OverwriteData

        end

        return HookFunction(MapId, Info, Value)
    end)
    
    local HookMetaMethod; HookMetaMethod = hookmetamethod(game, "__newindex", function(instance, property, value)
        if 
            instance:IsA("Sound")
            and property == "Volume"
            and instance.Parent ~= nil
            and Misc.Sounds[instance.Name]
            and tonumber(Misc.Sounds[instance.Name].SoundId)
        then
            instance.SoundId = "rbxassetid://" .. Misc.Sounds[instance.Name].SoundId
            value = Misc.Sounds[instance.Name].Volume ~= 0 and Misc.Sounds[instance.Name].Volume or value

            return HookMetaMethod(instance, property, value);
        end

        return HookMetaMethod(instance, property, value);
    end)
end

local Visual = {
    Ghost = false,
    Highlight = false,
    Overwrite = false,

    HighlightColor = Vector3.new(1, 1, 1),
    OverwriteColor = Vector3.new(1, 1, 1),

    CubeType = "Normal",
    OverwriteCubeType = "Normal",

    OverwriteTransparency = 0,
    HighlightTransparency = 0,
}

local Recorder = {
    Record_Table = {},

    Replay = false,
    AutoReplay = false,
    Recording = false,

    MusicSpeed = 0,
    SpeedProcent = 50,

    Path = "cap_v6/replays",
    Method = "Mouse",
    DefText = "none",
} do
    function Recorder:Load(Name)
        -- Decodes the selected file name and then decodes the file and puts it into Recorder.Record_Table
        local Json = HttpService:JSONDecode(readfile(string.format("%s/%s.lua", Recorder.Path, Name)))
        Recorder.Record_Table = Json
    end

    function Recorder:Save(Name)
        -- Encodes Recorder.Record_Table and writes the encoded Recorder.Record_Table in the selected file name
        local Json = HttpService:JSONEncode(Recorder.Record_Table)
        writefile(string.format("%s/%s.lua", Recorder.Path, Name), Json)
    end

    function Recorder:Move(Position, Procent, N)
        -- Moves the mouse to the target position
        local Adjust = N or 153.5
        if Recorder.Method == "Mouse" then
            local CurrentPosition = GhostCursor.Position

            if (CurrentPosition - Position).Magnitude > 0.05 then
                local Cal = {
                    y = Adjust  * (CurrentPosition.y - Position.y),
                    x = Adjust  * (CurrentPosition.z - Position.z),
                }
        
                mousemoverel(Procent / 100 * Cal.x, Procent / 100 * Cal.y)
            end
        elseif Recorder.Method == "Camera" then
            workspace.Camera.CFrame = CFrame.new(workspace.Camera.CFrame.p, Position)
        end
    end

    function Recorder:GetSpeed()
        -- Returns the song speed
        return GameScriptRequire.GetSpeed()
    end

    function Recorder:GetTime()
        -- Returns the song time position
        return math.floor(Music.TimePosition * 50) / 50
    end

    function Recorder:UpdateMusicSpeed()
        -- If the Music speed slider isn"t 0 it'll change the Music PlaybackSpeed the Music speed
        if Recorder.MusicSpeed ~= 0 then
            Music.PlaybackSpeed = Recorder.MusicSpeed
        end
    end

    -- Fast wait because RenderStepped was to slow
    -- Thanks blue for this
    local gotoPos
    local mt = getrawmetatable(game)
    local oldmt = mt.__namecall
    setreadonly(mt,false)
    mt.__namecall = newcclosure(function(self,...)
        (function()
            -- Handles the Music time position and gives the RendetStepped move mouse the position to go to
            if
                Recorder.Replay 
                and Recorder:GetTime() ~= 0
                and Music.PlaybackSpeed ~= 0
            then
                local MusicTime = tostring(Recorder:GetTime())
                local Record_Table = Recorder.Record_Table[MusicTime]

                if Record_Table then
                    gotoPos = Vector3.new(Record_Table.x, Record_Table.y, Record_Table.z)
                end
            end
        end)()
        local args = {...}
        return oldmt(self,unpack(args))
    end)

    RunService.Stepped:Connect(function()
        -- Updates the music speed
        -- Moves the mouse to the target that has been told
        -- Note: This doesn"t work all to well
        Recorder:UpdateMusicSpeed()

        if 
            Recorder.Replay
            and Recorder:GetTime() ~= 0
            and Music.PlaybackSpeed ~= 0
            and gotoPos
            and not SettingsShield.Visible
        then
            Recorder:Move(gotoPos, Recorder.SpeedProcent)
        end
    end)

    Music:GetPropertyChangedSignal("PlaybackSpeed"):Connect(function()
        -- When the PlaybackSpeed of the music gets changed it'll run UpdateMusicSpeed function
        Recorder:UpdateMusicSpeed()
    end)

    GhostCursor:GetPropertyChangedSignal("CFrame"):Connect(function()
        -- When the cursor moves
        if not Recorder.Recording then
            return
        end

        -- Saves the cursor Position if it hasn"t already for the music time position
        local MusicTime = tostring(Recorder:GetTime())
        if not Recorder.Record_Table[MusicTime] then
            Recorder.Record_Table[MusicTime] = {x=GhostCursor.Position.x, y=GhostCursor.Position.y, z=GhostCursor.Position.z}
        end
    end)

    Client.DescendantAdded:Connect(function(child)
        -- When the replay button gets added it'll click ti if Auto replay is on
        if not Recorder.AutoReplay then
            return
        end

        if child.Name == "ReplayButton" then
            repeat task.wait() until not MapData.Playing.Value or child.Parent == nil

            task.wait(0.5)
            
            if child.Parent then
                repeat
                    GuiScriptSenv.OnMouseClickLevel1(child)

                    task.wait(0.1)
                until MapData.Playing.Value or workspace.Camera.CFrame.z > -30 or not Recorder.AutoReplay
            end
        end
    end)
end

local Assist = {
    Enabled = false,
    Hover = false,
    SpeedProcent = 50,
    InsideProcent = 50,
    SwitchDelay = 0,
} do
    local Times = 0
    local Cubes = {}
    local ClosestCube
    local ClosestAlreadyConnected = false
    local LastSwitchTick = 0

    Client.ChildAdded:Connect(function(cube)
        -- When a cube gets addeed
        if
            cube.Name ~= "Cube_Mesh" 
            and not cube:FindFirstChild("EffectColor") 
        then 
            -- Checks if it isn"t a cube and if it isn"t then it'll stop
            return
        end

        -- If Anti cube ghost is on it'll change the cube transparency to the orginal aka 0 and get overwrited by the overwite transparency
        local Orginal = 0
        if Visual.Ghost then
            cube:GetPropertyChangedSignal("Transparency"):Connect(function()
                if Visual.Highlight and ClosestCube and ClosestCube.Cube == cube then
                    cube.Transparency = Visual.HighlightTransparency
                else
                    cube.Transparency = Orginal
                end
            end)
        end

        -- Overwrites the cube if Overwrite cube is on
        -- It changes the Transparency, MeshType, and Color
        if Visual.Overwrite then
            if Visual.OverwriteTransparency ~= 0 then
                Orginal = Visual.OverwriteTransparency

                cube:GetPropertyChangedSignal("Transparency"):Connect(function()
                    if 
                        (Visual.Overwrite and ClosestCube and ClosestCube.Cube ~= cube or not Visual.Overwrite) 
                        and cube.Transparency < Visual.OverwriteTransparency 
                    then
                        cube.Transparency = Visual.OverwriteTransparency
                    end
                end)
            end

            local Mesh = cube:FindFirstChildWhichIsA("SpecialMesh")
            if Mesh then
                cube.Color = Color3.new(Visual.OverwriteColor.x, Visual.OverwriteColor.y, Visual.OverwriteColor.z)
                Mesh.VertexColor = Visual.OverwriteColor

                local Type = Visual.OverwriteCubeType == "Normal" and "FileMesh" or Visual.OverwriteCubeType
                if Mesh.MeshType ~= Type then
                    Mesh.MeshType = Type
                end
            end
        end

        table.insert(Cubes, {
            Cube = cube,
            Tick = tick(),
        })
    end)

    RunService.RenderStepped:Connect(function()
        -- Cube Checks and set up ish
        if
            Cubes[1]
            and Cubes[1].Cube.Parent == nil
        then
            table.remove(Cubes, 1)
            
            ClosestAlreadyConnected = false
            LastSwitchTick = tick()
        end

        if
            Cubes[1]
            and Cubes[1].Cube.Parent ~= nil
        then
            ClosestCube = Cubes[1]
        end

        -- If highlight is enabled it'll check if there's a CLosest Cube and then changes that Cube's properties
        -- It changes the Transparency, MeshType, and Color
        if
            Visual.Highlight
            and ClosestCube
        then
            local Mesh = ClosestCube.Cube:FindFirstChildWhichIsA("SpecialMesh")
            if Mesh then
                ClosestCube.Cube.Transparency = Visual.HighlightTransparency
                ClosestCube.Cube.Color = Color3.new(Visual.HighlightColor.x, Visual.HighlightColor.y, Visual.HighlightColor.z)
                Mesh.VertexColor = Visual.HighlightColor -- I"ve no idea why it wants Vector3 and not Color3

                local Type = Visual.CubeType == "Normal" and "FileMesh" or Visual.CubeType
                if Mesh.MeshType ~= Type then
                    Mesh.MeshType = Type
                end

                if not ClosestAlreadyConnected then
                    ClosestCube.Cube:GetPropertyChangedSignal("Transparency"):Connect(function()
                        if ClosestCube.Cube.Transparency < Visual.HighlightTransparency then
                            ClosestCube.Cube.Transparency = Visual.HighlightTransparency
                        end
                    end)
                end

                ClosestAlreadyConnected = true
            end
        end

        -- Aim Assist
        -- Kinda Same checks as Replayer
        if not Assist.Enabled then
            return
        end

        if
            Recorder:GetTime() ~= 0
            and Music.PlaybackSpeed ~= 0
            and not SettingsShield.Visible
            and ClosestCube
            and tick() - LastSwitchTick >= (Assist.SwitchDelay / 1000)
        then
            local Distance = (Vector2.new(ClosestCube.Cube.Position.y, ClosestCube.Cube.Position.z) - Vector2.new(GhostCursor.Position.y, GhostCursor.Position.z)).Magnitude
            if
                Assist.Hover
                and Distance > (Assist.InsideProcent / 100 * 1.75) 
                or not Assist.Hover
            then
                Recorder:Move(Vector3.new(0, math.floor(ClosestCube.Cube.Position.y), math.floor(ClosestCube.Cube.Position.z)), Assist.SpeedProcent, 20)
            end
        end
    end)
end



local Library = loadstring(readfile("cappUI.lua"))() do
    Library({
        theme = {
            accent = Color3.fromRGB(124, 170, 255),
            blur = false
        },

        tabs = {
            {name = "Recorder", content = {
                {type ="textlabel", text ="Status:", align ="left", color = Color3.new(1, 1, 1), thickness = 1},

                {type ="textbox", placeholder = Recorder.DefText, text = "File name", clear = false, callback = function(v)
                    Recorder.DefText = v
                end},

                {type ="folder", name ="Main", size = 230, content = {
                    {type = "toggle", state = Recorder.Recording, text = "Record", callback = function(toggle)
                        Recorder.Recording = toggle
                    end},
    
                    {type = "toggle", state = Recorder.Replay, text = "Replay", callback = function(toggle)
                        Recorder.Replay = toggle
                    end},
    
                    {type ="button", text ="Save File", callback = function()
                        Recorder:Save(Recorder.DefText)
                    end},
    
                    {type ="button", text ="Load File", callback = function()
                        Recorder:Load(Recorder.DefText)
                    end},
                    
                    {type ="button", text ="Reset Recording", callback = function()
                        Recorder.Record_Table = {}
                    end},

                    {type ="dropdown", text ="Move Method", options = {
                       "Mouse",
                       "Camera",
                    }, def ="Mouse", callback = function(method)
                        Recorder.Method = method
                    end},

                    {type ="slider", min = 1, max = 100, value = Recorder.SpeedProcent, float = 0.05, deg =" %", text ="Mouse Speed", callback = function(Number)
                        Recorder.SpeedProcent = Number
                    end},
    
                    {type = 'locked', text = "Set Music speed"},
                    --{type ="slider", min = 0, max = 10, value = Recorder.MusicSpeed, float = 0.1, deg =" Speed", text ="Music speed BROKEN (0=Normal)", callback = function(Number)
                    --    Recorder.MusicSpeed = Number
                    --    Recorder:UpdateMusicSpeed()
                    --end},
                }},
            }},

            {name = "Assist", content = {
                {type ="folder", name ="Aim Assist", size = 230, content = {
                    {type ="togglebind", state =  Assist.Enabled, key ="Y", text ="Enable", callback = function(toggle)
                        Assist.Enabled = toggle
                    end},

                    {type = "toggle", state = Assist.Hover, text = "Stop When Inside", callback = function(toggle)
                        Assist.Hover = toggle
                    end},

                    {type ="slider", min = 1, max = 100, value = Assist.SpeedProcent, float = 1, deg =" %", text ="Inside", callback = function(Number)
                        Assist.InsideProcent = Number
                    end},

                    {type ="slider", min = 0, max = 1000, value = Assist.SwitchDelay, float = 1, deg =" Milliseconds", text ="Switch Delay", callback = function(Number)
                        Assist.SwitchDelay = Number
                    end},

                    {type ="slider", min = 1, max = 100, value = Assist.SpeedProcent, float = 0.05, deg =" %", text ="Mouse Speed", callback = function(Number)
                        Assist.SpeedProcent = Number
                    end},
                }},
            }},

            {name = "Visual", content = {
                {type = "toggle", state = Visual.Ghost, text = "Anti Cube Ghost", callback = function(toggle)
                    Visual.Ghost = toggle
                end},

                {type ="folder", name ="Highlight Nearest Cube", size = 190, content = {
                    {type = "toggle", state = Visual.Highlight, text = "Enable", callback = function(toggle)
                        Visual.Highlight = toggle
                    end},

                    {type ="dropdown", text ="Highligth Cube Type", options = {
                       "Normal",
                       "Head",
                       "Wedge",
                       "Brick",
                       "Sphere",
                       "Cylinder",
                    }, def ="Normal", callback = function(type_)
                        Visual.CubeType = type_
                    end},
                    
                    {type ="slider", min = 0, max = 1, value = Visual.HighlightTransparency, float = 0.1, deg =" Transparency", text ="Highlight Transparency", callback = function(Number)
                        Visual.HighlightTransparency = Number
                    end},

                    {type ="colorpicker", color = {255, 255, 255}, text ="Hightlight Color", callback = function(color)
                        Visual.HighlightColor = Vector3.new(color.R, color.G, color.B)
                    end},
                }},

                {type ="folder", name ="Overwrite Cube", size = 190, content = {
                    {type = "toggle", state = Visual.Overwrite, text = "Enable", callback = function(toggle)
                        Visual.Overwrite = toggle
                    end},

                    {type ="colorpicker", color = {255, 255, 255}, text ="Overwrite Color", callback = function(color)
                        Visual.OverwriteColor = Vector3.new(color.R, color.G, color.B)
                    end},

                    {type ="slider", min = 0, max = 1, value = Visual.OverwriteTransparency, float = 0.1, deg =" Transparency", text ="Overwrite Transparency", callback = function(Number)
                        Visual.OverwriteTransparency = Number
                    end},
                    
                    {type ="dropdown", text ="Overwrite Cube Type", options = {
                       "Normal",
                       "Head",
                       "Wedge",
                       "Brick",
                       "Sphere",
                       "Cylinder",
                    }, def ="Normal", callback = function(type_)
                        Visual.OverwriteCubeType = type_
                    end},
                }},
            }},
            
            {name = "Misc", content = {
                {type = "toggle", state = Recorder.AutoReplay, text = "Auto Replay", callback = function(toggle)
                    Recorder.AutoReplay = toggle
                end},

                {type ="folder", name ="Sound", size = 190, content = {
                    {type ="textbox", placeholder = Misc.Sounds.Hit, text = "Hit", clear = false, callback = function(v)
                        Misc.Sounds.Hit.SoundId = v
                    end},
                    {type ="slider", min = 0, max = 10, value = Misc.Sounds.Hit.Volume, float = 0.2, deg =" Volume", text ="", callback = function(Number)
                        Misc.Sounds.Hit.Volume = Number
                    end},


                    {type ="textbox", placeholder = Misc.Sounds.Miss, text = "Miss", clear = false, callback = function(v)
                        Misc.Sounds.Miss.SoundId = v
                    end},
                    {type ="slider", min = 0, max = 10, value = Misc.Sounds.Miss.Volume, float = 0.2, deg =" Volume", text ="", callback = function(Number)
                        Misc.Sounds.Miss.Volume = Number
                    end},


                    {type ="textbox", placeholder = Misc.Sounds.Click, text = "Click", clear = false, callback = function(v)
                        Misc.Sounds.Click.SoundId = v
                    end},
                    {type ="slider", min = 0, max = 10, value = Misc.Sounds.Click.Volume, float = 0.2, deg =" Volume", text ="", callback = function(Number)
                        Misc.Sounds.Click.Volume = Number
                    end},
                }},
                {type ="folder", name ="Overwrite", size = 190, content = {
                    {type ="textlabel", text = "For Map Id you need to toggle and join\nany shop map and then play any map.", align ="left", color = Color3.new(1, 1, 1), thickness = 1},

                    {type ="textbox", placeholder = Misc.OverwriteData, text = "Map Data", clear = false, callback = function(v)
                        Misc.OverwriteData = v
                    end},
    
                    {type = "toggle", state = Misc.Overwrite, text = "Last Map Overwrite", callback = function(toggle)
                        Misc.OverwriteMap = toggle

                        Misc.LastMap = 0
                        Misc.LastData = ""
                    end},

                    {type ="button", text ="Copy Last Map Data", callback = function()
                        setclipboard(Misc.LastMapData)
                    end},
                }},

                {type ="folder", name ="Shop", size = 80, content = {
                    {type = "toggle", state = Misc.FullTry, text = "Full Try Songs", callback = function(toggle)
                        Misc.FullTry = toggle
                    end},
                }},
            }},
        }
    })
end

-- Why're we still here... just to suffer...