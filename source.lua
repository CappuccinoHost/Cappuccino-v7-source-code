--[[
    If you paid for this source code you got scammed.
    The original source: https://github.com/CappuccinoHost/Cappuccino-v7-source-code
    Discord: https://discord.gg/U2u29MEVZs

    Feel free to fork!
]]

getgenv().CappuccinoLoaded = true

wait(0.5)

local function getExploit()
    if syn and type(syn) == 'table' and syn.protect_gui then
        return 'synapse'
    end
    return 'krnl'
end

getgenv().exploit = getExploit()

if exploit == 'krnl' then
    getgenv().syn = {
        request = function(s)
            return http_request(s)
        end
    }
end

local function ErrorMessage(str)
    pcall(function()
        workspace['cap_error']:Destroy()
    end)

    local m = Instance.new('Message', workspace)
    m.Name = 'cap_error'

    m.Text = ('Cappuccino failed to launch/encountered an error.\n\nerror (show to devs):\n%s\n\n\n\nTry one of these solutions:\n1. Go into "workspace" folder inside your exploit folder and remove "cappuccino-v7" folder\n\n\n\nIf none of these worked for you,\nplease go to our Discord server and open a ticket.\n\nTo hide this message press RightShift.'):format(str)

    local uis;uis = game:service('UserInputService').InputBegan:Connect(function(k, t)
        if t then
            return
        end

        if k.KeyCode == Enum.KeyCode.RightShift then
            m:Destroy()
            uis:Disconnect()
        end
    end)
end

xpcall(function()
    if not lgVarsTbl then
        lgVarsTbl = {
            DiscordUsername = game:service('Players').LocalPlayer.DisplayName,
            hoursRemaining = '1',
            expirationDateTime = 'N/A',
            totalExecutions = 'N/A',
        }
    end

    if not isLGPremium then
        isLGPremium = function()
            return false
        end
    end

    --#region Setup
    --#endregion

    --#region Settings 
    local ENABLE_PLAYER_DATA = true
    --#endregion

    --#region Services
    local Players = game:GetService("Players")
    local Teams = game:GetService("Teams")
    local CoreGui = game:GetService("CoreGui")
    local Lighting = game:GetService("Lighting")

    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")

    local ReplicatedFirst = game:GetService("ReplicatedFirst")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local Marketplace = game:GetService('MarketplaceService')
    --#endregion

    --#region Instances
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local CurrentCamera = workspace.CurrentCamera
    --#endregion

    --#region Tables
    local ListOfConnections = {}
    local PlayerData = {}
    local Connection = {}
    local Library = {}
    --#endregion


    --#region Meta tables 
    local PlayerMeta = {}
    PlayerMeta.__index = PlayerMeta
    --#endregion


    --#region Values
    local LocalName = LocalPlayer.Name
    local LocalId = LocalPlayer.UserId

    local IsTyping = false

    local PlaceId = game.PlaceId
    local GameId = game.GameId
    local JobId = game.JobId
    --#endregion


    --#region Connection functions
    function Connection:Disconnect(Name : string)
        if not ListOfConnections[Name] then
            return
        end

        ListOfConnections[Name]:Disconnect()
        ListOfConnections[Name] = nil
    end
    function Connection:Create(Name : string, Event : event, Callback)
        Connection:Disconnect(Name)

        ListOfConnections[Name] = Event:Connect(Callback)

        return ListOfConnections[Name]
    end
    function Connection:Disable()
        for Name, _ in pairs(ListOfConnections) do
            Connection:Disconnect(Name)
        end
    end
    --#endregion


    --#region Functions 
    local function CreateFile(Path, Text)
        local Split = Path:split("/")
        local File = ""
        for Number, String in ipairs(Split) do
            File = ("%s/%s"):format(File, String)

            if Number == #Split then
                writefile(File, Text or "TEXT IS NIL")

                break
            end

            if not isfolder(File) then
                makefolder(File)
            end
        end

        return File
    end
    local function OnInputEnded(Input, Typing)
        IsTyping = Typing
    end
    local function instance(className,properties,children,funcs)
        local object = Instance.new(className)
        
        for i,v in pairs(properties or {}) do
            object[i] = v
        end
        for i, self in pairs(children or {}) do
            self.Parent = object
        end
        for i,func in pairs(funcs or {}) do
            func(object)
        end
        return object
    end
    local function udim2(x1,x2,y1,y2)
        local t = tonumber
        return UDim2.new(t(x1), t(x2), t(y1), t(y2))
    end
    local function rgb(r,g,b) 
        return Color3.fromRGB(r,g,b)
    end
    local function fixInt(int) 
        return tonumber(string.format('%.02f', int)) 
    end
    local function round(exact, quantum)
        local quant, frac = math.modf(exact/quantum)
        return FixInt(quantum * (quant + (frac > 0.5 and 1 or 0)))
    end
    local function ts(object,tweenInfo,properties)
        if tweenInfo[2] and typeof(tweenInfo[2]) == 'string' then
            tweenInfo[2] = Enum.EasingStyle[ tweenInfo[2] ]
        end
        game:service('TweenService'):create(object, TweenInfo.new(unpack(tweenInfo)), properties):Play()
    end
    local function scale(unscaled, minAllowed, maxAllowed, min, max)
        return (maxAllowed - minAllowed) * (unscaled - min) / (max - min) + minAllowed
    end
    --#endregion


    -- --#region PlayerMeta functions
    function PlayerMeta.OnPlayerAdded(Player : Instance)
        local self = setmetatable({}, PlayerMeta)
        local PlayerName = Player.Name

        --#region Self assign 
        self.Player = Player
        self.Character = self.Player.Character or nil

        self.Humanoid = self.Character and self.Character:FindFirstChild("Humanoid") or nil
        self.HumanoidRootPart = self.Character and self.Character:FindFirstChild("HumanoidRootPart") or nil
        --#endregion

        --#region Functions 
        local function OnChildAdded(Child : Instance)
            local ChildName = Child.Name
            if ChildName == "HumanoidRootPart" then
                self.HumanoidRootPart = Child
            elseif ChildName == "Humanoid" then
                self.Humanoid = Child
            end
        end
        local function OnChildRemoved(Child : Instance)
            local ChildName = Child.Name
            if ChildName == "HumanoidRootPart" then
                self.HumanoidRootPart = nil
            elseif ChildName == "Humanoid" then
                self.Humanoid = nil
            end
        end
        local function OnCharacterAdded(Character : Model)
            self.Character = Character

            Connection:Create(PlayerName .. "-ChilAdded", Character.ChildAdded, OnChildAdded)
            Connection:Create(PlayerName .. "-ChildRemoved", Character.ChildRemoved, OnChildRemoved)
        end
        local function OnCharacterRemoving(Character : Model)
            self.Character = nil
            self.Humanoid = nil
            self.HumanoidRootPart = nil
        end
        --#endregion

        --#region Connections 
        Connection:Create(PlayerName .. "-CharacterAdded", Player.CharacterAdded, OnCharacterAdded)
        Connection:Create(PlayerName .. "-CharacterRemoving", Player.CharacterRemoving, OnCharacterRemoving)
        --#endregion

        --#region Setup 
        if self.Character then
            OnCharacterAdded(self.Character)
        end

        PlayerData[PlayerName] = self
        --#endregion
        
        return self
    end
    function PlayerMeta.OnPlayerRemoving(Player : Instance)
        local PlayerName = Player.Name
        if not PlayerData[PlayerName] then return end

        PlayerData[PlayerName] = nil
    end
    function PlayerMeta:GetCFrame()
        local HumanoidRootPart = self.HumanoidRootPart
        if not HumanoidRootPart then return end
        return HumanoidRootPart.CFrame
    end
    function PlayerMeta:GetEquiptTool()
        local Character = self.Character
        if not Character then return end
        return Character:FindFirstChildWhichIsA("Tool")
    end
    function PlayerMeta:GetTracks()
        local Humanoid = self.Humanoid
        if not Humanoid then return end
        return Humanoid:GetPlayingAnimationTracks()
    end
    function PlayerMeta:GetMagnitude(Position : Vector3)
        local HumanoidRootPart = self.HumanoidRootPart
        if not HumanoidRootPart then return end
        return (HumanoidRootPart.Position - Position).Magnitude
    end
    --#endregion


    --#region Lib setup 
    if not blurModule then
        if game.PlaceId ~= 6678877691 then
            getgenv().blurModule = loadstring(syn.request({Url = 'https://raw.githubusercontent.com/CappuccinoHost/Cappuccino-v7-source-code/main/assets/blurmodule.lua', Method = 'GET'}).Body)()
        else
            local blurModule = {}
            function blurModule:BindFrame()

            end
            getgenv().blurModule = blurModule
        end
    end

    if game.PlaceId ~= 6678877691 then
        print('adding blur')
        if not game:service('Lighting'):FindFirstChild('cap_blur') then
            instance('DepthOfFieldEffect', {
                Parent = game:service('Lighting'),
                FarIntensity = 0,
                Name = 'cap_blur',
                FocusDistance = 51.5,
                InFocusRadius = 50,
                NearIntensity = 1,
                Enabled = true
            })
        end
    end
    --#endregion


    --#region Save folder
    local function CapWrite(fileName, data)
        CreateFile(('cappuccino-v7/%s'):format(fileName), data)
    end

    if not isfolder('cappuccino-v7') then
        makefolder('cappuccino-v7')
    end

    local function CapRead(fileName)
        return readfile(('cappuccino-v7/%s'):format(fileName))
    end

    local function CapIsFile(fileName)
        return isfile(('cappuccino-v7/%s'):format(fileName))
    end
    --#endregion


    --#region Generating all default save files
    if not CapIsFile('ui/config.json') then
        CapWrite('ui/config.json', HttpService:JSONEncode({
            CloseNotification = true,
            ClassicClose = false,
            ShowUiBind = 'RightShift',
            ShowMouseCursor = false,
            TotalExecutions = 0
        }))
    end

    local UiConfig = HttpService:JSONDecode(CapRead('ui/config.json'))

    local function CapSaveUiConfig()
        CapWrite('ui/config.json', HttpService:JSONEncode(UiConfig))
    end

    if not UiConfig.TotalExecutions then
        UiConfig.TotalExecutions = 0
    end

    UiConfig.TotalExecutions = UiConfig.TotalExecutions + 1
    CapSaveUiConfig()
    --#endregion


    --#region Luraph functions
    if not LPH_OBFUSCATED then
        LPH_JIT_MAX = function(...) return (...) end
        LPH_NO_VIRTUALIZE = function(...) return (...) end
    end
    --#endregion


    --#region Notifications
    local function instance(className,properties,children,funcs)
        local object = Instance.new(className)
        
        for i,v in pairs(properties or {}) do
            object[i] = v
        end
        for i, self in pairs(children or {}) do
            self.Parent = object
        end
        for i,func in pairs(funcs or {}) do
            func(object)
        end
        return object
    end
    
    local function ts(object,tweenInfo,properties)
        if tweenInfo[2] and typeof(tweenInfo[2]) == 'string' then
            tweenInfo[2] = Enum.EasingStyle[ tweenInfo[2] ]
        end
        game:service('TweenService'):create(object, TweenInfo.new(unpack(tweenInfo)), properties):Play()
    end
    
    local function udim2(x1,x2,y1,y2)
        local t = tonumber
        return UDim2.new(t(x1), t(x2), t(y1), t(y2))
    end
    
    local function rgb(r,g,b) 
        return Color3.fromRGB(r,g,b)
    end
    
    local function fixInt(int) 
        return tonumber(string.format('%.02f', int)) 
    end
    
    local function round(exact, quantum)
        local quant, frac = math.modf(exact/quantum)
        return fixInt(quantum * (quant + (frac > 0.5 and 1 or 0)))
    end
    
    local function scale(unscaled, minAllowed, maxAllowed, min, max)
        return (maxAllowed - minAllowed) * (unscaled - min) / (max - min) + minAllowed
    end
    
    local function glow(frame, radius, step, color)
        local instances = {}
    
        local folder = instance('Folder', {
            Parent = frame,
            Name = 'glow'
        })
        
        local function newInstance(thick)
            local new = instance('Frame', {
                Parent = folder,
                BackgroundTransparency = 1,
                Size = udim2(1, 0, 1, 0)
            }, {
                (function()
                    local d, c = nil, frame:FindFirstChildWhichIsA('UICorner')
                    if c then
                        d = instance('UICorner', {
                            CornerRadius = c.CornerRadius
                        })
    
                        c:GetPropertyChangedSignal('CornerRadius'):Connect(function()
                            d.CornerRadius = c.CornerRadius
                        end)
                    end
                    return d
                end)(),
                instance('UIStroke', {
                    Transparency = 0.95,
                    Thickness = thick,
                    Color = typeof(color) == 'Color3' and color or Color3.new(0, 0, 0)
                })
            })
            
            table.insert(instances, new.UIStroke)
        end
    
        for a=1,radius,step do
            newInstance(a)
        end
    
        local function change(func)
            for a,v in next, instances do
                func(v)
            end
        end
    
        return {
            setColor = function(c)
                change(function(v)
                    ts(v, {0.3, 'Exponential'}, {
                        Color = c
                    })
                end)
            end,
            hide = function()
                change(function(v)
                    ts(v, {0.2, 'Exponential'}, {
                        Transparency = 1
                    })
                end)
            end,
            show = function()
                change(function(v)
                    ts(v, {0.2, 'Exponential'}, {
                        Transparency = 0.95
                    })
                end)
            end
        }
    end
    
    local function corner(a, b)
        return instance('UICorner', {
            CornerRadius = UDim.new(a, b)
        })
    end
    
    
    local core = game:service('CoreGui')
    local tservice = game:service('TextService')
    
    
    pcall(function()
        core['cap_notif']:Destroy()
    end)
    
    local sgui = instance('ScreenGui', {
        Name = 'cap_notif',
        Parent = core,
    }, {
        instance('Frame', {
            Name = 'main',
            Position = udim2(0, 40, 0, 0),
            Size = udim2(0, 0, 1, -40),
            BackgroundTransparency = 1
        }, {
            instance('UIListLayout', {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = 'Left',
                VerticalAlignment = 'Bottom',
            })
        })
    })
    
    local function notify(data)
        data.Title = typeof(data.Title) == 'string' and data.Title or '[empty]'
        data.Text = typeof(data.Text) == 'string' and data.Text or nil
        data.Options = typeof(data.Options) == 'table' and data.Options or nil
        data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
        data.Duration = typeof(data.Duration) == 'number' and data.Duration or nil
        data.Image = typeof(data.Image) == 'string' and data.Image or nil
    
        if data.CloseOnCallback ~= false then
            data.CloseOnCallback = true
        end
    
        local finalX = tservice:GetTextSize((data.Text and #data.Title > #data.Text and data.Title or data.Text) or data.Title, (data.Text and #data.Title > #data.Text and 14 or 13), 'Ubuntu', Vector2.new(math.huge, math.huge)).X + (data.Image and 80 or 40)
        local finalY = data.Text and 60 or (data.Image and 60 or 30)
        local mainGlow
        local notifFrame
        local close
    
        if data.Duration then
            finalX = finalX + 12
        end
    
        if data.Options then
            finalX = finalX + 24
        end
    
        local function extend()
            local line = instance('Frame', {
                Parent = notifFrame,
                Size = udim2(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = rgb(255, 255, 255),
                BackgroundTransparency = 1,
                Position = udim2(0, notifFrame.AbsoluteSize.X, 0, 0),
            })
    
            local optionFrame = instance('Frame', {
                Parent = notifFrame,
                BackgroundTransparency = 1,
                Position = udim2(0, notifFrame.AbsoluteSize.X + 15, 0, 0),
                Size = udim2(1, -(notifFrame.AbsoluteSize.X + 15), 1, 0)
            }, {
                instance('UIListLayout', {
                    Padding = UDim.new(0, 8),
                    FillDirection = 'Horizontal',
                    HorizontalAlignment = 'Left',
                    VerticalAlignment = 'Center'
                })
            })
    
            local fX = (data.Duration and 30 or 22)
            local c = 0
    
            for a,v in next, data.Options do
                local nX = tservice:GetTextSize(v, 14, 'Ubuntu', Vector2.new(math.huge, math.huge)).X + 10
                fX = fX + nX + 8
    
                local button = instance('TextButton', {
                    Text = v,
                    Font = 'Ubuntu',
                    TextSize = 14,
                    BackgroundColor3 = rgb(255, 255, 255),
                    BackgroundTransparency = 1,
                    TextColor3 = rgb(200, 200, 200),
                    Size = udim2(0, nX, 1, (data.Text and -30 or -10)),
                    BorderSizePixel = 0,
                    Parent = optionFrame,
                    TextTransparency = 1,
                    AutoButtonColor = false
                }, {corner(0, (data.Text and 6 or 8))}, {
                    function(self)
                        delay(c * 0.1, function()
                            ts(self, {0.3, 'Exponential'}, {
                                TextTransparency = 0
                            })
                        end)
    
                        self.MouseEnter:Connect(function()
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundTransparency = 0.8
                            })
                        end)
    
                        self.MouseLeave:Connect(function()
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundTransparency = 1
                            })
                        end)
    
                        self.MouseButton1Up:Connect(function()
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundColor3 = rgb(150, 150, 255),
                                TextColor3 = rgb(150, 150, 255)
                            })
    
                            delay(0.5, function()
                                ts(self, {0.3, 'Exponential'}, {
                                    BackgroundColor3 = rgb(255, 255, 255),
                                    TextColor3 = rgb(200, 200, 200)
                                })
                            end)
    
                            data.Callback(v)
    
                            if data.CloseOnCallback then
                                delay(0.4, function()
                                    close()
                                end)
                            end
                        end)
                    end
                })
    
                c = c + 1
            end
    
            ts(line, {0.3, 'Exponential'}, {
                BackgroundTransparency = 0.7
            })
    
            ts(notifFrame, {0.3, 'Exponential'}, {
                Size = udim2(0, notifFrame.AbsoluteSize.X + fX, 0, notifFrame.AbsoluteSize.Y)
            })
        end
    
        notifFrame = instance('Frame', {
            Parent = sgui.main,
            Size = udim2(0, 0, 0, 0),
            BackgroundColor3 = rgb(30, 30, 30),
            ClipsDescendants = true,
            BorderSizePixel = 0
        }, {
            corner(0, 12),
            instance('ImageLabel', {
                Size = udim2(0, (data.Image and 48 or 0), 0, (data.Text and 48 or 24)),
                Position = udim2(0, 7, 0.5, (data.Text and -23 or -12)),
                BackgroundTransparency = 1,
                Image = ('rbxassetid://%s'):format(data.Image or '')
            }, {
                instance('TextLabel', {
                    Position = udim2(1, 9, 0, 0),
                    Size = udim2(0, 4, (data.Text and 0.5 or 1), 0),
                    TextXAlignment = 'Left',
                    BackgroundTransparency = 1,
                    TextColor3 = rgb(255, 255, 255),
                    Font = 'Ubuntu',
                    RichText = true,
                    Text = data.Title,
                    TextSize = 14
                }),
                instance('TextLabel', {
                    Position = udim2(1, 9, 0.5, 0),
                    Size = udim2(0, 4, 0.45, 0),
                    BackgroundTransparency = 1,
                    Text = (data.Text or ''),
                    Font = 'Ubuntu',
                    RichText = true,
                    TextColor3 = rgb(210, 210, 210),
                    TextXAlignment = 'Left',
                    TextSize = 13
                })
            }),
            instance('TextLabel', {
                Size = udim2(0, 10, 0, 18),
                Position = udim2(1, -18, 0, 0),
                TextYAlignment = 'Bottom',
                Font = 'Ubuntu',
                TextSize = 10,
                TextColor3 = rgb(190, 190, 250),
                BackgroundTransparency = 1,
                RichText = true,
                Text = data.Duration and '<b>' .. tostring(data.Duration) .. '</b>' or '',
                Name = 'duration'
            }),
            instance('ImageButton', {
                Position = udim2(1, -35, 0.5, -10),
                Size = udim2(0, 20, 0, 20),
                Image = 'rbxassetid://10872983349',
                BackgroundColor3 = rgb(12, 12, 12),
                BackgroundTransparency = 1,
                Visible = data.Options and true or false,
                Name = 'extend'
            }, {corner(0, 9)}, {
                function(self)
                    self.MouseEnter:Connect(function()
                        ts(self, {0.3, 'Exponential'}, {
                            BackgroundTransparency = 0
                        })
                    end)
    
                    self.MouseLeave:Connect(function()
                        ts(self, {0.3, 'Exponential'}, {
                            BackgroundTransparency = 1
                        })
                    end)
    
                    self.MouseButton1Down:Connect(function()
                        ts(self, {0.3, 'Exponential'}, {
                            Position = udim2(1, -25, 0.5, 0),
                            Size = udim2(0, 0, 0, 0)
                        })
                        
                        delay(0.3, function()
                            self:Destroy()
                        end)
    
                        extend()
                    end)
                end
            })
        })
    
        close = function()
            notifFrame.ClipsDescendants = true
            mainGlow.hide()
            
            ts(notifFrame, {0.3, 'Exponential'}, {
                Size = udim2(0, 0, 0, finalY)
            })
    
            delay(0.3, function()
                ts(notifFrame, {0.3, 'Exponential'}, {
                    Size = udim2(0, 0, 0, 0)
                })
    
                delay(0.3, function()
                    notifFrame:Destroy()
                end)
            end)
        end
    
        mainGlow = glow(notifFrame, 3, 1)
    
        ts(notifFrame, {0.3, 'Exponential'}, {
            Size = udim2(0, finalX, 0, finalY)
        })
    
        delay(0.3, function()
            notifFrame.ClipsDescendants = false
        end)
    
        if data.Duration then
            spawn(function()
                local n = data.Duration
                while wait(1) do
                    n = n - 1
    
                    if n <= 0 then
                        break
                    end
    
                    notifFrame.duration.Text = '<b>' .. tostring(n) .. '</b>'
                end
            end)
    
            delay(data.Duration, close)
        end
    
        local d = {}
    
        function d:Close()
            close()
        end
    
        return d
    end
    
    
    _G.notify = notify

    local function notify(data)
        return _G.notify(data)
    end
    --#endregion


    --#region UI library
    local function instance(className,properties,children,funcs)
        local object = Instance.new(className)
        
        for i,v in pairs(properties or {}) do
            object[i] = v
        end
        for i, self in pairs(children or {}) do
            self.Parent = object
        end
        for i,func in pairs(funcs or {}) do
            func(object)
        end
        return object
    end
    
    local function ts(object,tweenInfo,properties)
        if tweenInfo[2] and typeof(tweenInfo[2]) == 'string' then
            tweenInfo[2] = Enum.EasingStyle[ tweenInfo[2] ]
        end
        game:service('TweenService'):create(object, TweenInfo.new(unpack(tweenInfo)), properties):Play()
    end
    
    local function udim2(x1,x2,y1,y2)
        local t = tonumber
        return UDim2.new(t(x1), t(x2), t(y1), t(y2))
    end
    
    local function rgb(r,g,b) 
        return Color3.fromRGB(r,g,b)
    end
    
    local function fixInt(int) 
        return tonumber(string.format('%.02f', int)) 
    end
    
    local function round(exact, quantum)
        local quant, frac = math.modf(exact/quantum)
        return fixInt(quantum * (quant + (frac > 0.5 and 1 or 0)))
    end
    
    local function scale(unscaled, minAllowed, maxAllowed, min, max)
        return (maxAllowed - minAllowed) * (unscaled - min) / (max - min) + minAllowed
    end
    
    local function glow(frame, radius, step, color)
        local instances = {}
    
        local folder = instance('Folder', {
            Parent = frame,
            Name = 'glow'
        })
        
        local function newInstance(thick)
            local new = instance('Frame', {
                Parent = folder,
                BackgroundTransparency = 1,
                Size = udim2(1, 0, 1, 0)
            }, {
                (function()
                    local d, c = nil, frame:FindFirstChildWhichIsA('UICorner')
                    if c then
                        d = instance('UICorner', {
                            CornerRadius = c.CornerRadius
                        })
    
                        c:GetPropertyChangedSignal('CornerRadius'):Connect(function()
                            d.CornerRadius = c.CornerRadius
                        end)
                    end
                    return d
                end)(),
                instance('UIStroke', {
                    Transparency = 0.95,
                    Thickness = thick,
                    Color = typeof(color) == 'Color3' and color or Color3.new(0, 0, 0)
                })
            })
            
            table.insert(instances, new.UIStroke)
        end
    
        for a=1,radius,step do
            newInstance(a)
        end
    
        local function change(func)
            for a,v in next, instances do
                func(v)
            end
        end
    
        return {
            setColor = function(c)
                change(function(v)
                    ts(v, {0.3, 'Exponential'}, {
                        Color = c
                    })
                end)
            end,
            hide = function()
                change(function(v)
                    ts(v, {0.2, 'Exponential'}, {
                        Transparency = 1
                    })
                end)
            end,
            show = function()
                change(function(v)
                    ts(v, {0.2, 'Exponential'}, {
                        Transparency = 0.95
                    })
                end)
            end
        }
    end
    
    local mouse = game:service('Players').LocalPlayer:GetMouse()
    
    local function checkPos(obj)
        local x, y = mouse.X, mouse.Y
        local abs, abp = obj.AbsoluteSize, obj.AbsolutePosition
    
        if x > abp.X and x < (abp.X + abs.X) and y > abp.Y and y < (abp.Y + abs.Y) then
            return true
        end
        return nil
    end
    
    local function dragify(frame) 
        local connection, move, kill
        local function connect()
            connection = frame.InputBegan:Connect(function(inp) 
                pcall(function() 
                    if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then 
                        local mx, my = mouse.X, mouse.Y 
                        move = mouse.Move:Connect(function() 
                            local nmx, nmy = mouse.X, mouse.Y 
                            local dx, dy = nmx - mx, nmy - my 
                            frame.Position = frame.Position + UDim2.fromOffset(dx, dy)
                            mx, my = nmx, nmy 
                        end) 
                        kill = frame.InputEnded:Connect(function(inputType) 
                            if inputType.UserInputType == Enum.UserInputType.MouseButton1 then 
                                move:Disconnect() 
                                kill:Disconnect() 
                            end 
                        end) 
                    end 
                end) 
            end) 
        end
        connect()
        return {
            disconnect = function()
                connection:Disconnect()
            end,
            reconnect = connect,
            killConnection = function()
                move:Disconnect()
                kill:Disconnect()
            end
        }
    end
    
    local function getRel(object)
        return {
            X = (mouse.X - object.AbsolutePosition.X),
            Y = (mouse.Y - object.AbsolutePosition.Y)
        }
    end
    
    local function makeBetter(obj, maxSize)
        local drag = dragify(obj)
    
        local button = instance('TextButton', {
            Parent = obj,
            Size = udim2(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Text = '',
            Position = udim2(1, -10, 1, -10)
        })
    
        local holding = false
        button.MouseButton1Down:Connect(function()
            holding = true
            drag.disconnect()
    
            spawn(function()
                repeat
                    local sX, sY = (getRel(obj).X - obj.AbsoluteSize.X), (getRel(obj).Y - obj.AbsoluteSize.Y)
                    wait()
                    ts(obj, {0.5, 'Exponential'}, {
                        Size = udim2(0, (obj.AbsoluteSize.X + sX > maxSize.X and obj.AbsoluteSize.X + sX or maxSize.X), 0, (obj.AbsoluteSize.Y + sY > maxSize.Y and obj.AbsoluteSize.Y + sY or maxSize.Y))
                    })
                until not holding
            end)
        end)
    
        local function unhold()
            if holding then
                holding = false
                drag.reconnect()
            end
        end
    
        button.MouseButton1Up:Connect(unhold)
        mouse.Button1Up:Connect(unhold)
    end
    
    local function corner(r, r2)
        return instance('UICorner', {
            CornerRadius = UDim.new(r, r2)
        })
    end
    
    local uis = game:service('UserInputService')
    
    local function addBind(key, callback)
        local key2 = key
    
        uis.InputBegan:Connect(function(k, t)
            if t then
                return
            end
    
            pcall(function()
                if k.KeyCode == Enum.KeyCode[key2] then
                    callback()
                end
            end)
        end)
    
        return {
            setKey = function(s)
                key2 = s
            end
        }
    end        
    
    
    
    
    
    
    
    
    local create = {
        button = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty button name]'
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
            
            local buttonGlow
    
            local main = instance('Frame', {
                Parent = obj,
                Size = udim2(1, 0, 0, 28),
                BackgroundColor3 = rgb(60, 60, 60),
                Name = '!_button'
            }, {
                corner(0, 10),
                instance('ImageLabel', {
                    Size = udim2(0, 16, 0, 16),
                    Position = udim2(1, -22, 0.5, -8),
                    Image = 'rbxassetid://11243256070',
                    BackgroundTransparency = 1,
                    ImageColor3 = rgb(255, 255, 255)
                }),
                instance('TextButton', {
                    Size = udim2(1, -10, 1, 0),
                    Position = udim2(0, 10, 0, 0),
                    Font = 'Ubuntu',
                    RichText = true,
                    TextSize = 13,
                    TextColor3 = rgb(220, 220, 220),
                    Text = data.Text,
                    BackgroundColor3 = rgb(60, 60, 60),
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    TextXAlignment = 'Left'
                }, {corner(0, 10)}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            ts(self.Parent, {0.3, 'Exponential'}, {
                                BackgroundColor3 = rgb(80, 80, 80)
                            })
                            buttonGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            ts(self.Parent, {0.3, 'Exponential'}, {
                                BackgroundColor3 = rgb(60, 60, 60)
                            })
                            buttonGlow.hide()
                        end)
    
                        self.MouseButton1Down:Connect(function()
                            ts(self.Parent, {0.1, 'Exponential'}, {
                                BackgroundColor3 = rgb(150, 150, 150)
                            })
                            delay(0.1, function()
                                ts(self.Parent, {0.1, 'Exponential'}, {
                                    BackgroundColor3 = rgb(80, 80, 80)
                                })
                            end)
    
                            if data.Pcall then
                                pcall(data.Callback)
                            else
                                data.Callback()
                            end
                        end)
                    end
                })
            })
    
            buttonGlow = glow(main, 3, 1)
            buttonGlow.hide()
        end,
        toggle = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty toogle name]'
            data.State = typeof(data.State) == 'boolean' and data.State or false
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
    
            local toggleGlow
            local toggled = data.State
            local toggleBody
    
            local function toggleToggle(s)
                ts(toggleBody.toggle, {0.3, 'Exponential'}, {
                    Position = s and udim2(1, -14, 0.5, -7) or udim2(0, 0, 0.5, -7),
                    BackgroundColor3 = s and rgb(255, 255, 255) or rgb(150, 150, 150)
                })
            end
    
            local main = instance('Frame', {
                Parent = obj,
                Size = udim2(1, 0, 0, 26),
                BackgroundColor3 = rgb(50, 50, 50),
                Name = '!_toggle',
            }, {
                corner(0, 10),
                instance('Frame', {
                    Size = udim2(0, 20, 0, 10),
                    Position = udim2(1, -30, 0.5, -5),
                    BackgroundColor3 = rgb(30, 30, 30),
                    Name = 'toggleBody'
                }, {
                    corner(1, 0),
                    instance('Frame', {
                        Size = udim2(0, 14, 0, 14),
                        Position = toggled and udim2(1, -14, 0.5, -7) or udim2(0, 0, 0.5, -7),
                        Name = 'toggle',
                        BackgroundColor3 = toggled and rgb(255, 255, 255) or rgb(150, 150, 150)
                    }, {corner(1, 0)})
                }, {
                    function(self)
                        toggleBody = self
    
                        glow(toggleBody.toggle, 3, 1)
                    end
                }),
                instance('TextButton', {
                    Size = udim2(1, -10, 1, 0),
                    BackgroundTransparency = 1,
                    Position = udim2(0, 10, 0, 0),
                    Font = 'Ubuntu',
                    RichText = true,
                    Text = data.Text,
                    TextSize = 13,
                    TextColor3 = rgb(220, 220, 220),
                    TextXAlignment = 'Left'
                }, {}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            toggleGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            toggleGlow.hide()
                        end)
    
                        self.MouseButton1Down:Connect(function()
                            toggled = not toggled
    
                            toggleGlow.setColor(rgb(255, 255, 255))
    
                            delay(0.1, function()
                                toggleGlow.setColor(rgb(0, 0, 0))
                            end)
    
                            toggleToggle(toggled)
    
                            if data.Pcall then
                                pcall(function()
                                    data.Callback(toggled)
                                end)
                            else
                                data.Callback(toggled)
                            end
                        end)
                    end
                }),
            })
    
            toggleGlow = glow(main, 3, 1)
            toggleGlow.hide()
        end,
        keybind = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty keybind name]'
            data.Key = typeof(data.Key) == 'string' and Enum.KeyCode[data.Key] or nil
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
            data.NewCallback = typeof(data.NewCallback) == 'function' and data.NewCallback or function() end
    
            local tss = game:service('TextService')
            local uis = game:service('UserInputService')
    
            local keybindGlow, frameGlow
            local key = data.Key
            local keyStr = key and tostring(key):split('.')[3] or 'Unbinded'
            local listening = false
    
            uis.InputBegan:Connect(function(k, t)
                if t or listening then
                    return
                end
    
                if k.KeyCode == key then
                    if data.Pcall then
                        pcall(data.Callback)
                    else
                        data.Callback()
                    end
                end
            end)
    
            local function getSize(str)
                if not str then
                    keyStr = key and tostring(key):split('.')[3] or 'Unbinded'
                    return tss:GetTextSize(keyStr, 11, 'Ubuntu', Vector2.new(math.huge, math.huge)).X
                end
    
                return tss:GetTextSize(str, 11, 'Ubuntu', Vector2.new(math.huge, math.huge)).X
            end
    
            local function listen()
                local newKey = 'Unbinded'
                local canContinue = false
                listening = true
                
                local bind;bind = uis.InputBegan:Connect(function(k, t)
                    if k.UserInputType ~= Enum.UserInputType.MouseButton1 and k.UserInputType ~= Enum.UserInputType.MouseButton2 then
                        newKey = k.KeyCode
                        canContinue = true
                        bind:Disconnect()
                    else
                        canContinue = true
                        bind:Disconnect()
                    end
                end)
    
                repeat
                    wait()
                until canContinue
    
                listening = false
                return newKey
            end
    
            local main = instance('Frame', {
                Parent = obj,
                Size = udim2(1, 0, 0, 28),
                BackgroundColor3 = rgb(50, 50, 50),
                Name = '!_keybind',
            }, {
                corner(0, 10),
                instance('TextLabel', {
                    Size = udim2(0, getSize() + 10, 0, 18),
                    Position = udim2(1, -(getSize() + 14), 0.5, -9),
                    Font = 'Ubuntu',
                    TextSize = 11,
                    TextColor3 = rgb(200, 200, 200),
                    BackgroundColor3 = rgb(30, 30, 30),
                    Text = keyStr,
                    Name = 'key'
                }, {corner(0, 7)}),
                instance('TextButton', {
                    Position = udim2(0, 10, 0, 0),
                    Size = udim2(1, -10, 1, 0),
                    TextXAlignment = 'Left',
                    BackgroundTransparency = 1,
                    Text = data.Text,
                    Font = 'Ubuntu',
                    RichText = true,
                    TextColor3 = rgb(220, 220, 220),
                    TextSize = 13,
                }, {}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            keybindGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            keybindGlow.hide()
                        end)
    
                        local listening = false
                        self.MouseButton1Up:Connect(function()
                            if listening then
                                return
                            end
                            listening = true
                            frameGlow.show()
                            
                            self.Parent.key.Text = '...'
                            ts(self.Parent.key, {0.3, 'Exponential'}, {
                                Size = udim2(0, getSize('...') + 10, 0, 18),
                                Position = udim2(1, -(getSize('...') + 14), 0.5, -9)
                            })
    
                            local newKey = listen()
    
                            repeat
                                wait()
                            until newKey
    
                            listening = false
                            frameGlow.hide()
    
                            key = newKey
                            local new = newKey ~= 'Unbinded' and tostring(newKey):split('.')[3] or newKey
    
                            data.newCallback(new == 'Unbinded' and nil or new)
    
                            self.Parent.key.Text = new
                            ts(self.Parent.key, {0.3, 'Exponential'}, {
                                Size = udim2(0, getSize(new) + 10, 0, 18),
                                Position = udim2(1, -(getSize(new) + 14), 0.5, -9)
                            })                    
                        end)
                    end
                })
            })
    
            keybindGlow = glow(main, 3, 1)
            keybindGlow.hide()
    
            frameGlow = glow(main.key, 8, 1)
            frameGlow.setColor(rgb(97, 121, 255))
            frameGlow.hide()
        end,
        togglebind = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty togglebind name]'
            data.State = typeof(data.State) == 'boolean' and data.State or false
            data.Key = typeof(data.Key) == 'string' and Enum.KeyCode[data.Key] or nil
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
            data.NewCallback = typeof(data.NewCallback) == 'function' and data.NewCallback or function() end
    
            local tss = game:service('TextService')
            local uis = game:service('UserInputService')
    
            local keybindGlow, frameGlow
            local key = data.Key
            local keyStr = key and tostring(key):split('.')[3] or 'Unbinded'
            local listening = false
    
            local function getSize(str)
                if not str then
                    keyStr = key and tostring(key):split('.')[3] or 'Unbinded'
                    return tss:GetTextSize(keyStr, 11, 'Ubuntu', Vector2.new(math.huge, math.huge)).X
                end
    
                return tss:GetTextSize(str, 11, 'Ubuntu', Vector2.new(math.huge, math.huge)).X
            end
    
            local function listen()
                local newKey = 'Unbinded'
                local canContinue = false
                listening = true
                
                local bind;bind = uis.InputBegan:Connect(function(k, t)
                    if k.UserInputType ~= Enum.UserInputType.MouseButton1 and k.UserInputType ~= Enum.UserInputType.MouseButton2 then
                        newKey = k.KeyCode
                        canContinue = true
                        bind:Disconnect()
                    else
                        canContinue = true
                        bind:Disconnect()
                    end
                end)
    
                repeat
                    wait()
                until canContinue
    
                listening = false
                return newKey
            end
    
            local toggleGlow
            local toggled = data.State
            local toggleBody
            local mainGlow, frameGlow
    
            local function toggleToggle(s)
                ts(toggleBody.toggle, {0.3, 'Exponential'}, {
                    Position = s and udim2(1, -14, 0.5, -7) or udim2(0, 0, 0.5, -7),
                    BackgroundColor3 = s and rgb(255, 255, 255) or rgb(150, 150, 150)
                })
            end
    
            local function toggle()
                toggled = not toggled
    
                mainGlow.setColor(rgb(255, 255, 255))
    
                delay(0.1, function()
                    mainGlow.setColor(rgb(0, 0, 0))
                end)
    
                toggleToggle(toggled)
    
                if data.Pcall then
                    pcall(function()
                        data.Callback(toggled)
                    end)
                else
                    data.Callback(toggled)
                end
            end
    
            uis.InputBegan:Connect(function(k, t)
                if t or listening then
                    return
                end
    
                if k.KeyCode == key then
                    toggle()
                end
            end)
    
            local main = instance('Frame', {
                Name = '!_togglebind',
                Size = udim2(1, 0, 0, 28),
                BackgroundColor3 = rgb(50, 50, 50),
                Parent = obj
            }, {
                corner(0, 10),
                instance('Frame', {
                    Size = udim2(0, 20, 0, 10),
                    Position = udim2(1, -30, 0.5, -5),
                    BackgroundColor3 = rgb(30, 30, 30),
                    Name = 'toggleBody'
                }, {
                    corner(1, 0),
                    instance('Frame', {
                        Size = udim2(0, 14, 0, 14),
                        Position = toggled and udim2(1, -14, 0.5, -7) or udim2(0, 0, 0.5, -7),
                        Name = 'toggle',
                        BackgroundColor3 = toggled and rgb(255, 255, 255) or rgb(150, 150, 150)
                    }, {corner(1, 0)})
                }, {
                    function(self)
                        toggleBody = self
    
                        glow(toggleBody.toggle, 3, 1)
                    end
                }),
                instance('TextButton', {
                    RichText = true,
                    Text = data.Text,
                    Position = udim2(0, 10, 0, 0),
                    Size = udim2(1, -10, 1, 0),
                    TextXAlignment = 'Left',
                    BackgroundTransparency = 1,
                    TextColor3 = rgb(220, 220, 220),
                    Font = 'Ubuntu',
                    TextSize = 13
                }, {}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            mainGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            mainGlow.hide()
                        end)
    
                        self.MouseButton1Down:Connect(function()
                            toggle()
                        end)
                    end
                }),
                instance('TextButton', {
                    Size = udim2(0, getSize() + 10, 0, 18),
                    Position = udim2(1, -(getSize() + 48), 0.5, -9),
                    Font = 'Ubuntu',
                    TextSize = 11,
                    TextColor3 = rgb(200, 200, 200),
                    BackgroundColor3 = rgb(30, 30, 30),
                    Text = keyStr,
                    Name = 'key'
                }, {
                    corner(0, 7)
                }, {
                    function(self)
                        local listening = false
                        self.MouseButton1Up:Connect(function()
                            if listening then
                                return
                            end
                            listening = true
                            frameGlow.show()
                            
                            self.Text = '...'
                            ts(self, {0.3, 'Exponential'}, {
                                Size = udim2(0, getSize('...') + 10, 0, 18),
                                Position = udim2(1, -(getSize('...') + 48), 0.5, -9)
                            })
    
                            local newKey = listen()
    
                            repeat
                                wait()
                            until newKey
    
                            listening = false
                            frameGlow.hide()
    
                            key = newKey
                            local new = newKey ~= 'Unbinded' and tostring(newKey):split('.')[3] or newKey
    
                            data.NewCallback(new == 'Unbinded' and nil or new)
    
                            self.Text = new
                            ts(self, {0.3, 'Exponential'}, {
                                Size = udim2(0, getSize(new) + 10, 0, 18),
                                Position = udim2(1, -(getSize(new) + 48), 0.5, -9)
                            })                    
                        end)
                    end
                }),
            })
    
            mainGlow = glow(main, 3, 1)
            mainGlow.hide()
    
            frameGlow = glow(main.key, 8, 1)
            frameGlow.setColor(rgb(97, 121, 255))
            frameGlow.hide()
        end,
        textbox = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty textbox name]'
            data.Placeholder = typeof(data.Placeholder) == 'string' and data.Placeholder or 'Type here'
            data.NumberOnly = typeof(data.NumberOnly) == 'boolean' and data.NumberOnly or false
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
            data.FillFunction = typeof(data.FillFunction) == 'function' and data.FillFunction or function() return {} end
    
            if data.Clear == nil then
                data.Clear = true
            end
            
    
            local text = data.Placeholder
            local main, mainGlow, box, boxGlow;
            local tss = game:service('TextService')
    
            local function getSize(str)
                return tss:GetTextSize(str, 11, 'Ubuntu', Vector2.new(math.huge, math.huge)).X
            end
    
            local function extract(str)
                local n = {}
                for a in string.gmatch(str, '%d+') do
                    table.insert(n, a)
                end
                return table.concat(n)
            end
    
            local full = false
    
            local function toggle(s)
                full = not s
                main.ClipsDescendants = not s
                ts(main.button, {0.3, 'Exponential'}, {
                    Position = s and udim2(0, 10, 0, 0) or udim2(-1, 0, 0, 0)
                })
                ts(main.TextBox, {0.3, 'Exponential'}, {
                    Position = s and udim2(1, -(getSize(text) + 15), 0.5, -10) or udim2(0, 3, 0, 3),
                    Size = s and udim2(0, getSize(text) + 10, 0, 20) or udim2(1, -6, 1, -6),
                    TextSize = s and 11 or 13
                })
            end
    
    
            main = instance('Frame', {
                Parent = obj,
                BackgroundColor3 = rgb(51, 51, 51),
                Size = udim2(1, 0, 0, 30),
                Name = '!_textbox',
            }, {
                corner(0, 9),
                instance('TextButton', {
                    Position = udim2(0, 10, 0, 0),
                    Size = udim2(1, -10, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = 'Left',
                    Text = data.Text,
                    TextColor3 = rgb(220, 220, 220),
                    Font = 'Ubuntu',
                    TextSize = 13,
                    RichText = true,
                    Name = 'button'
                }, {}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            mainGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            mainGlow.hide()
                        end)
    
                        self.MouseButton1Down:Connect(function()
                            toggle(false)
                            boxGlow.show()
                            box:CaptureFocus()
                        end)
                    end
                }),
                instance('TextBox', {
                    Text = '',
                    PlaceholderText = data.Placeholder,
                    Size = udim2(0, getSize(data.Placeholder) + 10, 0, 20),
                    Position = udim2(1, -(getSize(data.Placeholder) + 15), 0.5, -10),
                    BackgroundColor3 = rgb(30, 30, 30),
                    PlaceholderColor3 = rgb(150, 150, 150),
                    TextColor3 = rgb(220, 220, 220),
                    TextSize = 11,
                    Font = 'Ubuntu',
                    ClearTextOnFocus = data.Clear
                }, {
                    corner(0, 6),
                    instance('TextLabel', {
                        Text = '',
                        TextColor3 = rgb(220, 220, 220),
                        TextTransparency = 1,
                        TextSize = 11,
                        Font = 'Ubuntu',
                        BackgroundTransparency = 1,
                        Name = 'autofill',
                        Size = udim2(0, 10, 1, 0),
                        TextXAlignment = 'Left'
                    })
                }, {
                    function(self)
                        local mouseOn
                        self.MouseEnter:Connect(function()
                            mouseOn = true
                            boxGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            mouseOn = false
                            boxGlow.hide()
                        end)
    
                        self.Focused:Connect(function()
                            boxGlow.setColor(rgb(97, 121, 255))
    
                            if mouseOn then
                                ts(box, {0.3, 'Exponential'}, {
                                    Position = udim2(1, -(getSize(data.Placeholder) + 15), 0.5, -10),
                                    Size = udim2(0, getSize(data.Placeholder) + 10, 0, 20)
                                })
                            end
                        end)
    
                        local AutoFind
    
                        self:GetPropertyChangedSignal('Text'):Connect(function()
                            if not full then
                                ts(box, {0.3, 'Exponential'}, {
                                    Position = udim2(1, -(getSize(self.Text:gsub(' ', '') ~= '' and self.Text or data.Placeholder) + 15), 0.5, -10),
                                    Size = udim2(0, getSize(self.Text:gsub(' ', '') ~= '' and self.Text or data.Placeholder) + 10, 0, 20)
                                })
                            end
    
                            local options = data.FillFunction()
    
                            if self.Text:gsub(' ', '') ~= '' and self:IsFocused() then
                                for a,v in next, options do
                                    if v:sub(1, #self.Text) == self.Text then
                                        ts(self.autofill, {0.3, 'Exponential'}, {
                                            TextTransparency = 0.7,
                                            Position = udim2(0.5, -math.round(self.TextBounds.X / 2), 0, 0)
                                        })
                                        self.autofill.Text = v
                                        AutoFind = v
                                        break
                                    else
                                        ts(self.autofill, {0.3, 'Exponential'}, {
                                            TextTransparency = 1
                                        })
                                        AutoFind = nil
                                    end
                                end
                            else
                                ts(self.autofill, {0.3, 'Exponential'}, {
                                    TextTransparency = 1
                                })
                                AutoFind = nil
                            end
    
                            if data.NumberOnly then
                                self.Text = extract(self.Text)
                            end
                        end)
    
                        self.FocusLost:Connect(function(EnterPressed)
                            boxGlow.setColor(rgb(0, 0, 0))
                            text = self.Text:gsub(' ', '') ~= '' and self.Text or data.Placeholder
                            toggle(true)
    
                            ts(self.autofill, {0.3, 'Exponential'}, {
                                TextTransparency = 1
                            })
    
                            if EnterPressed and AutoFind ~= nil then
                                self.Text = AutoFind
                            end
    
                            if data.Pcall then
                                pcall(function()
                                    data.Callback(self.Text)
                                end)
                            else
                                data.Callback(self.Text)
                            end
                        end)
                    end
                })
            })
    
            mainGlow = glow(main, 3, 1)
            mainGlow.hide()
    
            box = main.TextBox
            boxGlow = glow(main.TextBox, 5, 1)
            boxGlow.hide()
    
            return main
        end,
        dropdown = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty dropdown name]'
            data.Options = typeof(data.Options) == 'table' and data.Options or {}
            data.Default = typeof(data.Default) == 'string' and table.find(data.Options, data.Default) and data.Default or 'Unselected'
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
    
            local canShow = true
            local mainGlow, main, hidden = nil,nil,false
            local frameGlow
            local tts = game:service('TextService')
            local option = data.Default
    
            local function getSize(str)
                return tts:GetTextSize(str, 11, 'Ubuntu', Vector2.new(math.huge, math.huge)).X
            end
    
            local function toggle(s)
                if s then
                    canShow = false
                    mainGlow.hide()
                    for a,v in next, main:GetDescendants() do
                        pcall(function()
                            v.ZIndex = 10
                        end)
                    end
                else
                    canShow = true
                    for a,v in next, main:GetDescendants() do
                        pcall(function()
                            v.ZIndex = 1
                        end)
                    end
                end
    
                if s then frameGlow.show() else frameGlow.hide() end
    
                ts(main.body, {0.3, 'Exponential'}, {
                    Position = s and udim2(1, -160, 0.5, -10) or udim2(1, -(getSize(option) + 15), 0.5, -10),
                    Size = s and udim2(0, 155, 0, (26 * #data.Options) + 8) or udim2(0, getSize(option) + 10, 0, 20),
                    BackgroundColor3 = s and rgb(35, 35, 35) or rgb(30, 30, 30)
                })
    
                ts(main.TextButton, {0.3, 'Exponential'}, {
                    Size = s and udim2(1, -160, 1, 0) or udim2(1, -10, 1, 0)
                })
    
                main.body.container.Visible = s
                main.body.selected.Text = option
    
                ts(main.body.selected, {0.3, 'Exponential'}, {
                    TextTransparency = s and 1 or 0
                })
            end
    
            main = instance('Frame', {
                Parent = obj,
                Size = udim2(1, 0, 0, 28),
                BackgroundColor3 = rgb(50, 50, 50),
            }, {
                corner(0, 10),
                instance('Frame', {
                    Name = 'body',
                    Size = udim2(0, getSize(data.Default) + 10, 0, 20),
                    Position = udim2(1, -(getSize(data.Default) + 15), 0.5, -10),
                    BackgroundColor3 = rgb(30, 30, 30)
                }, {
                    corner(0, 6),
                    instance('TextLabel', {
                        Name = 'selected',
                        Size = udim2(1, 0, 1, 0),
                        Font = 'Ubuntu',
                        TextSize = 11,
                        TextColor3 = rgb(200, 200, 200),
                        BackgroundTransparency = 1,
                        Text = data.Default
                    }),
                    instance('Frame', {
                        Position = udim2(0, 4, 0, 4),
                        Size = udim2(1, -8, 1, -8),
                        BackgroundColor3 = rgb(30, 30, 30),
                        Name = 'container',
                        Visible = false
                    }, {
                        corner(0, 4),
                        instance('UIListLayout', { 
                            SortOrder = 'LayoutOrder',
                            Padding = UDim.new(0, 0)
                        })
                    })
                }),
                instance('TextButton', {
                    TextSize = 13, 
                    Font = 'Ubuntu',
                    TextColor3 = rgb(220, 220, 220),
                    TextXAlignment = 'Left',
                    Size = udim2(1, -10, 1, 0),
                    Position = udim2(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = data.Text
                }, {}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            if not canShow then
                                return
                            end
    
                            mainGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            if not canShow then
                                return
                            end
                            
                            mainGlow.hide()
                        end)
    
                        self.MouseButton1Down:Connect(function()
                            toggle(true)
                        end)
                    end
                })
            })
    
            local function addOptions()
                for a,v in next, data.Options do
                    local button = instance('TextButton', {
                        Parent = main.body.container,
                        Size = udim2(1, 0, 0, 26),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = rgb(55,55,55),
                        TextColor3 = rgb(220, 220, 220),
                        Text = v,
                        Font = 'Ubuntu',
                        TextSize = 11,
                        AutoButtonColor = false
                    }, {corner(0, 4)}, {
                        function(self)
                            self.MouseEnter:Connect(function()
                                ts(self, {0.3, 'Exponential'}, {
                                    BackgroundTransparency = 0
                                })
                            end)
    
                            self.MouseLeave:Connect(function()
                                ts(self, {0.3, 'Exponential'}, {
                                    BackgroundTransparency = 1
                                })
                            end)
    
                            self.MouseButton1Down:Connect(function()
                                option = v
    
                                if data.Pcall then
                                    pcall(function()
                                        data.Callback(v)
                                    end)
                                else
                                    data.Callback(v)
                                end
    
                                toggle(false)
                            end)
                        end
                    })
                end
            end
            addOptions()
    
            mainGlow = glow(main, 3, 1)
            mainGlow.hide()
    
            frameGlow = glow(main.body, 5, 1)
            frameGlow.hide()
    
            local d = {}
    
            function d:UpdateOptions(s)
                data.Options = s
    
                for a,v in next, main.body.container:GetChildren() do
                    if v:IsA('TextButton') then
                        v:Destroy()
                    end
                end
    
                addOptions()
            end
    
            return d
        end,
        slider = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty slider name]'
            data.Min = typeof(data.Min) == 'number' and data.Min or 0
            data.Max = typeof(data.Max) == 'number' and data.Max or 100
            data.Float = typeof(data.Float) == 'number' and data.Float or 1
            data.Value = typeof(data.Value) == 'number' and data.Value or data.Min
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
            if data.BlockMax == nil then data.BlockMax = true end
    
            local current = scale(data.Value, 0, 1, data.Min, data.Max)
    
            local mainGlow, frameGlow, main
            local function listen()
                frameGlow.show()
    
                local con;con = game:service('RunService').Stepped:Connect(function()
                    local newScale = scale(mouse.X, 0, 1, main.AbsolutePosition.X + 10, (main.AbsolutePosition.X + 10) + (main.AbsoluteSize.X - 20))
                    if newScale < 0 then newScale = 0 end if newScale > 1 then newScale = 1 end
                    if newScale < 0.02 then frameGlow.hide() else frameGlow.show() end
    
                    local intScale = scale(newScale, data.Min, data.Max, 0, 1)
                    intScale = round(intScale, data.Float)
                    local sizeScale = scale(intScale, 0, 1, data.Min, data.Max)
                    main.TextBox.Text = intScale
    
                    if data.Pcall then
                        pcall(function()
                            data.Callback(intScale)
                        end)
                    else
                        data.Callback(intScale)
                    end
    
                    ts(main.sliderBody.slider, {0.3, 'Exponential'}, {
                        Size = udim2(sizeScale, -2, 1, -2),
                        BackgroundTransparency = sizeScale < 0.02 and 1 or 0
                    })
                end)
    
                game:service('UserInputService').InputEnded:Connect(function(k)
                    if k.UserInputType == Enum.UserInputType.MouseButton1 then
                        con:Disconnect()
                        frameGlow.hide()
                    end
                end)
            end
    
            main = instance('Frame', {
                Parent = obj,
                Size = udim2(1, 0, 0, 45),
                BackgroundColor3 = rgb(52, 52, 52)
            }, {
                corner(0, 10),
                instance('TextButton', {
                    Position = udim2(0, 10, 0, 10),
                    Size = udim2(1, -10, 1, -10),
                    TextYAlignment = 'Top',
                    TextXAlignment = 'Left',
                    BackgroundTransparency = 1,
                    Font = 'Ubuntu',
                    Text = data.Text,
                    TextColor3 = rgb(220, 220, 220),
                    TextSize = 13,
                    RichText = true
                }, {}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            mainGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            mainGlow.hide()
                        end)
    
                        self.MouseButton1Down:Connect(function()
                            listen()
                        end)
                    end
                }),
                instance('TextBox', {
                    Size = udim2(0, 50, 0, 18),
                    Position = udim2(1, -55, 0, 5), 
                    BackgroundColor3 = rgb(30, 30, 30),
                    PlaceholderText = '0',
                    Text = data.Value,
                    TextColor3 = rgb(220, 220, 220),
                    Font = 'Ubuntu',
                    TextSize = 11,
                    ClipsDescendants = true
                }, {corner(0, 6)}, {
                    function(self)
                        self.FocusLost:Connect(function()
                            local t = tonumber(self.Text)
                            if not t then t = data.Min end
                            local newScale = scale(t, 0, 1, data.Min, data.Max)
                            if newScale > 1 then newScale = 1 end
                            if newScale < 0 then newScale = 0 end
    
                            local intScale = round(scale(newScale, data.Min, data.Max, 0, 1), data.Float)
                            self.Text = intScale
    
                            if data.Pcall then
                                pcall(function()
                                    data.Callback(intScale)
                                end)
                            else
                                data.Callback(intScale)
                            end
                            
                            ts(main.sliderBody.slider, {0.3, 'Exponential'}, {
                                Size = udim2(newScale, -2, 1, -2),
                                BackgroundTransparency = newScale < 0.02 and 1 or 0
                            })
                        end)
                    end
                }),
                instance('Frame', {
                    Position = udim2(0, 10, 1, -14),
                    Size = udim2(1, -20, 0, 6),
                    BackgroundColor3 = rgb(30, 30, 30),
                    Name = 'sliderBody'
                }, {
                    corner(1, 0),
                    instance('Frame', {
                        BackgroundColor3 = rgb(97, 121, 255),
                        Size = udim2(current, -2, 1, -2),
                        Position = udim2(0, 1, 0, 1),
                        Name = 'slider',
                    }, {corner(1, 0)})
                })
            })
    
            frameGlow = glow(main.sliderBody.slider, 4, 1)
            frameGlow.setColor(rgb(97, 121, 255))
            frameGlow.hide()
    
            mainGlow = glow(main, 3, 1)
            mainGlow.hide()
        end,
        textlabel = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty textlabel text]'
            data.Alignment = typeof(data.Alignment) == 'string' and data.Alignment or 'Center'
    
            local main = instance('Frame', {
                Size = udim2(1, 0, 0, 26),
                BackgroundTransparency = 1,
                Parent = obj
            }, {
                instance('TextLabel', {
                    RichText = true,
                    Text = data.Text,
                    Position = udim2(0, 10, 0, 0),
                    Size = udim2(1, -20, 1, 0),
                    TextXAlignment = data.Alignment,
                    Font = 'Ubuntu',
                    TextSize = 13, 
                    TextColor3 = rgb(220, 220, 220),
                    BackgroundTransparency = 1,
                })
            })
    
            local d = {}
            function d:SetText(str)
                main.TextLabel.Text = tostring(str)
            end
            
            return d
        end,
        colorpicker = function(obj, data, gui)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty colorpicker name]'
            data.Color = typeof(data.Color) == 'table' and Color3.fromRGB(data.Color[1], data.Color[2], data.Color[3]) or typeof(data.Color) == 'Color3' and data.Color or Color3.new(1, 1, 1)
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
    
            local h,s,v = data.Color:ToHSV()
            local mainGlow
            local colorFrame
            local main
    
            local listening = false
            local function startListening()
                if listening then
                    return
                end
                listening = true
    
                local listenFrame
                local dot, bar, box1
                
                local function stopListening()
                    ts(listenFrame, {0.4, 'Exponential'}, {
                        Position = udim2(0, listenFrame.AbsolutePosition.X, 1, 100)
                    })
    
                    delay(0.4, function()
                        listening = false
                        listenFrame:Destroy()
                    end)
                end
    
                local f = 1
    
                local csk = ColorSequenceKeypoint.new
                local function hsv(h1,s1,v1)
                    return Color3.fromHSV(h1, s1, v1)
                end
    
                local drag
    
                listenFrame = instance('Frame', {
                    Parent = gui,
                    Size = udim2(0, 0, 0, 220), --270
                    Position = udim2(0, (main.AbsolutePosition.X + main.AbsoluteSize.X), 0, main.AbsolutePosition.Y),
                    BackgroundColor3 = rgb(30, 30, 30),
                    ClipsDescendants = true
                }, {
                    corner(0, 10),
                    instance('TextLabel', {
                        RichText = true,
                        Name = 'title',
                        Position = udim2(0, 10, 0, 0),
                        Size = udim2(1, -10, 0, 33),
                        BackgroundTransparency = 1,
                        Text = ('%s<font color="rgb(100,100,100)"> • </font><font color="rgb(97,121,255)"><b>Color</b></font>'):format(data.Text),
                        Font = 'Ubuntu',
                        TextSize = 12,
                        TextColor3 = rgb(220, 220, 220),
                        TextXAlignment = 'Left',
                    }, {
                        instance('TextButton', {
                            Text = '<b>X</b>',
                            Font = 'Ubuntu',
                            TextSize = 13,
                            RichText = true,
                            AutoButtonColor = false,
                            BackgroundColor3 = rgb(255, 150, 150),
                            BackgroundTransparency = 0.9,
                            TextColor3 = rgb(255, 150, 150),
                            Position = udim2(1, -27, 0.5, -10),
                            Size = udim2(0, 20, 0, 20)
                        }, {corner(1, 0)}, {
                            function(self)
                                self.MouseEnter:Connect(function()
                                    ts(self, {0.2, 'Exponential'}, {
                                        BackgroundTransparency = 0.6
                                    })
                                end)
    
                                self.MouseLeave:Connect(function()
                                    ts(self, {0.2, 'Exponential'}, {
                                        BackgroundTransparency = 0.9
                                    })
                                end)
    
                                self.MouseButton1Down:Connect(function()
                                    stopListening()
    
                                    ts(self, {0.1, 'Exponential'}, {
                                        BackgroundTransparency = 0.2
                                    })
    
                                    delay(0.1, function()
                                        ts(self, {0.1, 'Exponential'}, {
                                            BackgroundTransparency = 0.6
                                        })
                                    end)
                                end)
                            end
                        })
                    }),
                    instance('Frame', {
                        Name = 'box1',
                        Position = udim2(0, 6, 0, 33),
                        Size = udim2(1, -12, 1, -70),
                        BackgroundColor3 = rgb(255, 255, 255),
                        BackgroundTransparency = 0.2
                    }, {
                        corner(0, 6),
                        instance('UIGradient', {
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                            })
                        })
                    }, {
                        function(self)
                            box1 = self
                        end
                    }),
                    instance('Frame', {
                        Name = 'box2',
                        Position = udim2(0, 6, 0, 33),
                        Size = udim2(1, -12, 1, -70),
                        BackgroundColor3 = rgb(255, 255, 255),
                        BackgroundTransparency = 0.2
                    }, {
                        corner(0, 6),
                        instance('UIGradient', {
                            Rotation = 90,
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, rgb(255, 255, 255)),
                                ColorSequenceKeypoint.new(1, rgb(0, 0, 0))
                            }),
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 1),
                                NumberSequenceKeypoint.new(1, 0)
                            })
                        }),
                        instance('UIStroke', {
                            Thickness = 1,
                            Color = rgb(15, 15, 15)
                        }),
                        instance('Frame', {
                            BackgroundColor3 = rgb(0, 0, 0),
                            Position = udim2(scale(scale(s, 0, 1, 0, 270), 1, 0, 0, 1), -3, scale(v, 0, 1, 0, 220), -3),
                            Size = udim2(0, 6, 0, 6)
                        }, {
                            corner(1, 0),
                            instance('Frame', {
                                BackgroundColor3 = rgb(255, 255, 255),
                                Position = udim2(0, 2, 0, 2),
                                Size = udim2(1, -4, 1, -4)
                            }, {corner(1, 0)})
                        }, {
                            function(self)
                                dot = self
                            end
                        }),
                        instance('TextButton', {
                            Size = udim2(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Text = '',
                        }, {}, {
                            function(self)
                                self.MouseButton1Down:Connect(function()
                                    local unlisten
                                    local con;con = game:service('RunService').Stepped:Connect(function()
                                        local apx,asx,apy,asy = self.AbsolutePosition.X, self.AbsoluteSize.X, self.AbsolutePosition.Y, self.AbsoluteSize.Y
                                        local sx = scale(mouse.X, 0, 1, apx, apx + asx)
                                        if sx > 1 then sx = 1 end; if sx < 0 then sx = 0 end
    
                                        local sy = scale(mouse.Y, 0, 1, apy, apy + asy)
                                        sy = scale(sy, 1, 0, 0, 1)
                                        if sy > 1 then sy = 1 end; if sy < 0 then sy = 0 end
    
                                        ts(colorFrame, {0.3, 'Exponential'}, {
                                            BackgroundColor3 = hsv(h, sx, sy)
                                        })
    
                                        ts(dot, {0.3, 'Exponential'}, {
                                            Position = udim2(sx, -3, scale(sy, 1, 0, 0, 1), -3)
                                        })
    
                                        s = sx
                                        v = sy
    
                                        if data.Pcall then
                                            pcall(function()
                                                data.Callback(hsv(h, sx, sy))
                                            end)
                                        else
                                            data.Callback(hsv(h, sx, sy))
                                        end
                                    end)
    
                                    unlisten = game:service('UserInputService').InputEnded:Connect(function(k)
                                        if k.UserInputType == Enum.UserInputType.MouseButton1 then
                                            con:Disconnect()
                                        end
                                    end)
                                end)
                            end
                        })
                    }),
                    instance('Frame', {
                        Position = udim2(0, 6, 1, -31),
                        Size = udim2(1, -12, 0, 25),
                        BackgroundColor3 = rgb(255, 255, 255)
                    }, {
                        corner(0, 6),
                        instance('UIStroke', {
                            Thickness = 1,
                            Color = rgb(15, 15, 15)
                        }),
                        instance('UIGradient', {
                            Color = ColorSequence.new({
                                csk(0.0, hsv(scale(36 * 0, 0, 1, 0, 360), 1, 1)),
                                csk(0.1, hsv(scale(36 * 1, 0, 1, 0, 360), 1, 1)),
                                csk(0.2, hsv(scale(36 * 2, 0, 1, 0, 360), 1, 1)),
                                csk(0.3, hsv(scale(36 * 3, 0, 1, 0, 360), 1, 1)),
                                csk(0.4, hsv(scale(36 * 4, 0, 1, 0, 360), 1, 1)),
                                csk(0.5, hsv(scale(36 * 5, 0, 1, 0, 360), 1, 1)),
                                csk(0.6, hsv(scale(36 * 6, 0, 1, 0, 360), 1, 1)),
                                csk(0.7, hsv(scale(36 * 7, 0, 1, 0, 360), 1, 1)),
                                csk(0.8, hsv(scale(36 * 8, 0, 1, 0, 360), 1, 1)),
                                csk(0.9, hsv(scale(36 * 9, 0, 1, 0, 360), 1, 1)),
                                csk(1.0, hsv(scale(36 * 10, 0, 1, 0, 360), 1, 1)),
                            })
                        }),
                        instance('Frame', {
                            Size = udim2(0, 6, 1, -6),
                            Position = udim2(scale(h, 0, 1, 0, 258), -3, 0, 3),
                            BackgroundColor3 = rgb(0, 0, 0)
                        }, {
                            corner(1, 0),
                            instance('Frame', {
                                Position = udim2(0, 2, 0, 2),
                                BackgroundColor3 = rgb(255, 255, 255),
                                Size = udim2(1, -4, 1, -4)
                            }, {corner(1, 0)})
                        }, {
                            function(self)
                                bar = self
                            end
                        }),
                        instance('TextButton', {
                            Size = udim2(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Text = ''
                        }, {}, {
                            function(self)
                                self.MouseButton1Down:Connect(function()
                                    local con;con = game:service('RunService').Stepped:Connect(function()
                                        local apx, asx = self.AbsolutePosition.X, self.AbsoluteSize.X
                                        local sx = scale(mouse.X, 0, 1, apx, apx + asx)
                                        if sx > 1 then sx = 1 end; if sx < 0 then sx = 0 end
    
                                        h = sx
    
                                        ts(bar, {0.3, 'Exponential'}, {
                                            Position = udim2(sx, -3, 0, 3)
                                        })
    
                                        ts(colorFrame, {0.3, 'Exponential'}, {
                                            BackgroundColor3 = hsv(h, s, v)
                                        })
    
                                        box1.UIGradient.Color = ColorSequence.new({
                                            ColorSequenceKeypoint.new(0, rgb(255, 255, 255)),
                                            ColorSequenceKeypoint.new(1, hsv(h, 1, 1))
                                        })
    
                                        if data.Pcall then
                                            pcall(function()
                                                data.Callback(hsv(h, s, v))
                                            end)
                                        else
                                            data.Callback(hsv(h, s, v))
                                        end
                                    end)
    
                                    game:service('UserInputService').InputEnded:Connect(function(k)
                                        if k.UserInputType == Enum.UserInputType.MouseButton1 then
                                            con:Disconnect()
                                        end
                                    end)    
                                end)
                            end
                        })
                    })
                })
    
                glow(listenFrame, 3, 1)
                drag = dragify(listenFrame)
    
                delay(0.3, function()
                    listenFrame.ClipsDescendants = false
                end)
    
                ts(listenFrame, {0.3, 'Exponential'}, {
                    Size = udim2(0, 270, 0, 220),
                    Position = udim2(0, (main.AbsolutePosition.X + main.AbsoluteSize.X + 30), 0, main.AbsolutePosition.Y),
                })
            end
    
            main = instance('Frame', {
                Parent = obj,
                Size = udim2(1, 0, 0, 30),
                BackgroundColor3 = rgb(53, 53, 53),
                Name = '!_colorpicker'
            }, {
                corner(0, 10),
                instance('Frame', {
                    Position = udim2(1, -45, 0, 5),
                    Size = udim2(0, 40, 1, -10),
                    BackgroundColor3 = data.Color,
                }, {
                    corner(0, 6),
                }, {
                    function(self)
                        colorFrame = self
    
                        local selfGlow = glow(self, 3, 1)
                        selfGlow.setColor(Color3.fromHSV(h, s, v - 0.2))
    
                        self:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
                            local H,S,V = self.BackgroundColor3:ToHSV()
                            selfGlow.setColor(Color3.fromHSV(H, S, V))
                        end)
                    end
                }),
                instance('TextButton', {
                    Position = udim2(0, 10, 0, 0),
                    Size = udim2(1, -10, 1, 0),
                    Text = data.Text,
                    BackgroundTransparency = 1,
                    RichText = true,
                    Font = 'Ubuntu',
                    TextSize = 13,
                    TextColor3 = rgb(220, 220, 220),
                    TextXAlignment = 'Left',
                }, {}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            mainGlow.show()
                        end)
    
                        self.MouseLeave:Connect(function()
                            mainGlow.hide()
                        end)
    
                        self.MouseButton1Down:Connect(function()
                            startListening()
                        end)
                    end
                })
            })
    
            mainGlow = glow(main, 3, 1)
            mainGlow.hide()
        end,
        locked = function(obj, data)
            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty locked name]'

            data.Text = typeof(data.Text) == 'string' and data.Text or '[empty button name]'
            data.Callback = typeof(data.Callback) == 'function' and data.Callback or function() end
                
            local main = instance('Frame', {
                Parent = obj,
                Size = udim2(1, 0, 0, 28),
                BackgroundColor3 = rgb(40, 40, 40),
                Name = '!_locked'
            }, {
                corner(0, 10),
                instance('ImageLabel', {
                    Size = udim2(0, 12, 0, 12),
                    Position = udim2(1, -20, 0.5, -6),
                    Image = 'rbxassetid://6114012068',
                    BackgroundTransparency = 1,
                    ImageColor3 = rgb(150, 150, 150)
                }),
                instance('TextButton', {
                    Size = udim2(1, -10, 1, 0),
                    Position = udim2(0, 10, 0, 0),
                    Font = 'Ubuntu',
                    RichText = true,
                    TextSize = 13,
                    TextColor3 = rgb(150, 150, 150),
                    Text = data.Text,
                    BackgroundColor3 = rgb(60, 60, 60),
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    TextXAlignment = 'Left'
                }, {corner(0, 10)}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            ts(self, {0.2, 'Exponential'}, {
                                TextTransparency = 1
                            })
                            delay(0.2, function()
                                self.Text = 'Premium only feature.'

                                ts(self, {0.2, 'Exponential'}, {
                                    TextTransparency = 0
                                })
                            end)
                        end)

                        self.MouseLeave:Connect(function()
                            ts(self, {0.2, 'Exponential'}, {
                                TextTransparency = 1
                            })
                            delay(0.2, function()
                                self.Text = data.Text

                                ts(self, {0.2, 'Exponential'}, {
                                    TextTransparency = 0
                                })
                            end)
                        end)
                    end
                })
            })
        end
    }
    
    
    
    
    
    
    
    
    
    local library = {}
    
    function library:New(data)
        pcall(function()
            game:service('CoreGui')['ui_v7']:Destroy()
        end)
    
        local lib = {}
    
        --LOCALS
        local selectedTab
        local lastTab
    
        local sgui = instance('ScreenGui', {
            Name = 'ui_v7'
        })
    
    
    
    
    
        local dCount = 0
        local function createDetachment(italic, name, detatchedStuff, rCallback1, rCallback2)
            dCount = dCount + 1
        
            local main = instance('Frame', {
                Name = 'detachment_' .. dCount,
                Size = udim2(0, 300, 0, 300),
                Position = udim2(0.5, -150, 0.5, -150),
                BackgroundColor3 = rgb(0, 0, 0),
                BackgroundTransparency = 0.5,
                Parent = sgui
            }, {
                corner(0, 12),
                instance('Frame', {
                    Position = udim2(0, 9, 0, 9),
                    Size = udim2(1, -18, 1, -18),
                    BackgroundTransparency = 1,
                    Name = 'blur'
                }),
                instance('Frame', {
                    Position = udim2(0, 6, 0, 30),
                    Size = udim2(1, -12, 1, -36),
                    BackgroundColor3 = rgb(0, 0, 0),
                    BackgroundTransparency = 0.5,
                    Name = 'body',
                    ClipsDescendants = true
                }, {
                    corner(0, 9),
                    instance('ScrollingFrame', {
                        Name = 'container',
                        Position = udim2(0, 8, 0, 8),
                        Size = udim2(1, -16, 1, -16),
                        BackgroundTransparency = 1,
                        ScrollBarThickness = 0,
                        BorderSizePixel = 0,
                        AutomaticCanvasSize = 'Y',
                        CanvasSize = udim2(0, 0, 0, 0),
                        ClipsDescendants = false
                    })
                }),
                instance('TextLabel', {
                    Position = udim2(0, 10, 0, 1),
                    Size = udim2(1, -10, 0, 29),
                    TextXAlignment = 'Left',
                    RichText = true,
                    Text = italic and ('<i>%s</i>'):format(name) or ('<b>%s</b>'):format(name),
                    TextColor3 = rgb(255, 255, 255),
                    Font = 'Ubuntu',
                    TextSize = 14,
                    BackgroundTransparency = 1,
                }, {
                    instance('TextButton', {
                        Size = udim2(0, 20, 0, 20),
                        Position = udim2(1, -30, 0.5, -10),
                        BackgroundTransparency = 1,
                        Text = '<b>X</b>',
                        Font = 'Ubuntu',
                        RichText = true,
                        TextSize = 12,
                        TextColor3 = rgb(200, 200, 200)
                    }, {}, {
                        function(self)
                            self.MouseEnter:Connect(function()
                                ts(self, {0.3, 'Exponential'}, {
                                    TextColor3 = rgb(255, 150, 150)
                                })
                            end)
    
                            self.MouseLeave:Connect(function()
                                ts(self, {0.3, 'Exponential'}, {
                                    TextColor3 = rgb(200, 200, 200)
                                })
                            end)
    
                            self.MouseButton1Down:Connect(function()
                                rCallback2()
                                
                                for a,v in next, self.Parent.Parent.body.container:GetChildren() do
                                    rCallback1(v)
                                end
                            end)
                        end
                    })
                })
            })
    
            makeBetter(main, {
                X = 200,
                Y = 150,
            })
    
            blurModule:BindFrame(main.blur, {
                Material = 'Glass',
                Color = rgb(255, 255, 255),
                Transparency = 0.999
            })
        
            return main 
        end
    
    
        if exploit == 'synapse' then
            syn.protect_gui(sgui)
        end
        
        sgui.Parent = game:service('CoreGui')
    
        local mainFrame = instance('Frame', {
            Parent = sgui,
            Size = udim2(0, 0, 0, 0),
            Position = udim2(0.5, 0, 0.5, 0),
            BackgroundColor3 = rgb(22, 22, 22),
        }, {
            corner(1, 0),
            instance('Frame', {
                Size = udim2(0, 0, 0, 0),
                Position = udim2(0.5, 0, 0.5, 0),
                BackgroundColor3 = rgb(145, 139, 255),
                BackgroundTransparency = 0.8,
                Name = 'back',
                ZIndex = 10,
            }, {
                corner(1, 0)
            }),
            instance('ImageLabel', {
                Name = 'logo',
                Position = udim2(0.5, 0, 0.5, 0),
                Size = udim2(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Image = 'rbxassetid://12133038644',
                ImageColor3 = rgb(145, 139, 255),
                ZIndex = 10,
            })
        })
    
        local mainGlow = glow(mainFrame, 5, 1)
        makeBetter(mainFrame, {X = 350, Y = 250})
    
        local oldX, oldY = 450, 380
        local function toggleBody(s)
            if not s then
                mainFrame.TextButton.Visible = false
                mainFrame.logo.Size = udim2(1, -10, 1, -10)
                mainFrame.logo.Position = udim2(0.5, -13, 0.5, -13)
                mainGlow.hide()
                oldX = mainFrame.Size.X.Offset
                oldY = mainFrame.Size.Y.Offset
                mainFrame.ClipsDescendants = true
                mainFrame.title.minimize.Text = '<b>+</b>'
            else
                delay(0.35, function()
                    mainFrame.TextButton.Visible = true
                    mainFrame.logo.Size = udim2(0, 0, 0, 0)
                    mainFrame.logo.Position = udim2(0.5, 0, 0.5, 0)
                    mainFrame.ClipsDescendants = false
                    mainFrame.title.minimize.Text = '<b>-</b>'
                    mainGlow.show()
                end)
            end
    
            ts(mainFrame.body, {0.3, 'Exponential'}, {
                Position = not s and udim2(2, 0, 1, 0) or udim2(0, 0, 0, 36),
                Size = not s and udim2(1, 0, 1, 0) or udim2(1, 0, 1, -36)
            })
            ts(mainFrame.title.close, {0.35, 'Exponential'}, {
                Position = not s and udim2(1, 0, 0, 0) or udim2(1, -30, 0.5, -12)
            })
            ts(mainFrame.title.minimize, {0.35, 'Exponential'}, {
                Position = not s and udim2(0.5, -12, 0.5, -12) or udim2(1, -60, 0.5, -12)
            })
            ts(mainFrame.title, {0.35, 'Exponential'}, {
                TextTransparency = not s and 1 or 0,
                Position = not s and udim2(0, 0, 0, 0) or udim2(0, 10, 0, 0),
                Size = not s and udim2(1, 0, 1, 0) or udim2(1, -10, 0, 36)
            })
            ts(mainFrame, {0.35, 'Exponential'}, {
                Size = not s and udim2(0, 36, 0, 36) or udim2(0, oldX, 0, oldY)
            })
            ts(mainFrame.UICorner, {not s and 1.5 or 0.35, 'Exponential'}, {
                CornerRadius = not s and UDim.new(1, 0) or UDim.new(0, 10)
            })
        end
    
        local savedPos, hidden, hideCooldown = nil, false, false
        local function hideUi(s)
            if hideCooldown then
                return
            end
            hideCooldown = true
            delay(0.7, function()
                hideCooldown = false
            end)
    
            hidden = s
    
            if s then
                savedPos = mainFrame.Position
    
                ts(mainFrame, {0.6, 'Bounce'}, {
                    Position = udim2(0, mainFrame.AbsolutePosition.X, 2, 0)
                })
            else
                ts(mainFrame, {0.6, 'Exponential'}, {
                    Position = savedPos
                })
            end
        end
    
        local showBind = addBind(UiConfig.ShowUiBind, function()
            if UiConfig.ClassicClose then
                hideUi(not hidden)

                return
            end
            
            if hidden then 
                hideUi(false)
            end
        end)
    
        spawn(function()
            while wait(0.5) do
                showBind.setKey(UiConfig.ShowUiBind)
            end
        end)
    
        ts(mainFrame, {0.8, 'Exponential'}, {
            Size = udim2(0, 150, 0, 150),
            Position = udim2(0.5, -75, 0.5, -75)
        })
    
        delay(0.35, function() --launch animation
            mainGlow.show()
    
            ts(mainFrame.logo, {0.5, 'Exponential'}, {
                Position = udim2(0.5, -50, 0.5, -50),
                Size = udim2(0, 100, 0, 100),
            })
    
            delay(0.12, function()
                ts(mainFrame.back, {0.4, 'Exponential'}, {
                    Position = udim2(0, 6, 0, 6),
                    Size = udim2(1, -12, 1, -12),
                })
            end)
    
            delay(2, function()
                ts(mainFrame.logo, {0.5, 'Exponential'}, {
                    ImageColor3 = rgb(255, 255, 255)
                })
        
                delay(1, function()
                    ts(mainFrame.logo, {0.3, 'Exponential'}, {
                        ImageTransparency = 1,
                        Size = udim2(0, 0, 0, 0),
                        Position = udim2(0.5, 0, 0.5, 0)
                    })
    
                    delay(0.25, function()
                        ts(mainFrame.back, {0.5, 'Exponential'}, {
                            BackgroundTransparency = 1
                        })
                        delay(0.51, function()
                            mainFrame.back:Destroy()
                        end)
                    end)
                end)
    
                ts(mainFrame.back, {0.4, 'Exponential'}, {
                    Position = udim2(0, 2, 0, 2),
                    Size = udim2(1, -4, 1, -4),
                    BackgroundTransparency = 0,
                    BackgroundColor3 = rgb(50, 50, 50)
                })
    
                ts(mainFrame.back.UICorner, {0.4, 'Exponential'}, {
                    CornerRadius = UDim.new(0, 8)
                })
    
                ts(mainFrame, {0.4, 'Exponential'}, {
                    Size = udim2(0, 450, 0, 380),
                    Position = udim2(0.5, -450/2, 0.5, -380/2)
                })
    
                ts(mainFrame.UICorner, {0.4, 'Exponential'}, {
                    CornerRadius = UDim.new(0, 10)
                })
            end)
        end)
    
        wait(2.6)
    
        local title = instance('TextLabel', {
            Parent = mainFrame,
            Name = 'title',
            Position = udim2(0, 10, 0, 0),
            Size = udim2(1, -10, 0, 36),
            BackgroundTransparency = 1,
            Font = 'Ubuntu',
            RichText = true,
            TextSize = 14,
            TextXAlignment = 'Left',
            Text = ('<b>%s  </b><font color="rgb(200,200,200)" size="12">|  <i>%s</i></font>'):format(data.Title, data.SubTitle or 'Universals'),
            TextColor3 = rgb(255, 255, 255),
        }, {
            instance('TextButton', {
                Position = udim2(1, -60, 0.5, -12),
                Size = udim2(0, 24, 0, 24),
                BackgroundTransparency = 0.8,
                BackgroundColor3 = rgb(255, 255, 150),
                TextColor3 = rgb(255, 255, 150),
                RichText = true,
                Text = '<b>-</b>',
                Font = 'Ubuntu',
                TextSize = 14,
                Name = 'minimize'
            }, {
                corner(1, 0)
            }, {
                function(self)
                    local toggled = true
    
                    self.MouseButton1Down:Connect(function()
                        toggled = not toggled
                        toggleBody(toggled)
                    end)
    
                    self.MouseEnter:Connect(function()
                        if not toggled then
                            ts(mainFrame.logo, {0.3, 'Exponential'}, {
                                ImageTransparency = 1
                            })
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundTransparency = 0.8,
                                TextTransparency = 0
                            })
                        end
                    end)
    
                    self.MouseLeave:Connect(function()
                        if not toggled then
                            ts(mainFrame.logo, {0.3, 'Exponential'}, {
                                ImageTransparency = 0
                            })
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundTransparency = 1,
                                TextTransparency = 1
                            })
                        end
                    end)
                end
            }),
            instance('TextButton', {
                Position = udim2(1, -30, 0.5, -12),
                Size = udim2(0, 24, 0, 24),
                Name = 'close',
                Text = '<b>X</b>',
                RichText = true,
                Font = 'Ubuntu',
                TextSize = 11,
                TextColor3 = rgb(255, 150, 150),
                BackgroundColor3 = rgb(255, 150, 150),
                BackgroundTransparency = 0.8
            }, {
                corner(1, 0)
            }, {
                function(self)
                    self.MouseButton1Down:Connect(function()
                        hideUi(true)
    
                        if UiConfig.CloseNotification then
                            local a;a = notify({
                                Title = 'Cappuccino',
                                Text = ('UI is hidden. Press %s to show'):format(UiConfig.ShowUiBind),
                                Options = {
                                    'Show UI',
                                    'Close',
                                },
                                Image = '11335634088',
                                Duration = 5,
                                Callback = function(s)
                                    if s == 'Show UI' then
                                        hideUi(false)
                                    else
                                        a:Close()
                                    end
                                end
                            })
                        end
                    end)
                end
            })
        })
    
        local body = instance('Frame', {
            Parent = mainFrame,
            Position = udim2(0, 0, 0, 36),
            Size = udim2(1, 0, 1, -36),
            BackgroundTransparency = 1,
            Name = 'body'
        }, {
            instance('Frame', {
                Name = 'tabs',
                Position = udim2(0, 10, 0, 0),
                Size = udim2(0, 120, 1, -10),
                BackgroundColor3 = rgb(35, 35, 35)
            }, {
                corner(0, 8),
                instance('Frame', {
                    Name = 'container',
                    Position = udim2(0, 6, 0, 6),
                    Size = udim2(1, -12, 1, -12),
                    BackgroundTransparency = 1,
                }, {
                    instance('UIListLayout', {
                        Padding = UDim.new(0, 6)
                    })
                })
            }, {
                function(self)
                    glow(self, 3, 1)
                end
            }),
            instance('Frame', {
                Name = 'container',
                Position = udim2(0, 140, 0, 0),
                Size = udim2(1, -150, 1, -10),
                BackgroundColor3 = rgb(30, 30, 30),
                ClipsDescendants = true
            }, {
                corner(0, 8)
            }, {
                function(self)
                    glow(self, 3, 1)
                end
            })
        })
    
        local tabCount = 0
    
        function lib:Tab(tabData)
            local tabLib = {}
            local tabWindow,tabButton
            local categories = {}
            
            tabCount = tabCount + 1
    
            local function reattach()
    
            end
    
            local tabDetached = false
            local function detachTab()
                if tabDetached then
                    return
                end
                tabDetached = true
    
                local det;det = createDetachment(false, tabData.Name, {}, function(v)
                    v.Parent = tabWindow
                    
                    if v:IsA('Frame') then
                        if v.Name == 'category' then
                            v.BackgroundTransparency = 0
                            v.BackgroundColor3 = rgb(42, 42, 42)
                        end
    
                        local oldSize = v.Size
                        v.Size = udim2(1, 0, 0, 0)
    
                        local newd = 0
                        delay(0.1, function()
                            newd = newd + 0.1
                            ts(v, {0.5, 'Exponential'}, {
                                Size = oldSize
                            })
                        end)
                    end
                end, function()
                    tabDetached = false
                    tabWindow.detachedStatus.Visible = false
                    tabWindow.detachedStatus.TextTransparency = 1
    
                    ts(det, {2, 'Exponential'}, {
                        Position = udim2(0, det.AbsolutePosition.X, 2, 0)
                    })
    
                    delay(0.3, function()
                        det:Destroy()
                    end)
                end)
    
                det.Position = udim2(0.5, -150, 1, 0)
    
                for a,v in next, tabWindow:GetChildren() do
                    if v.Name ~= 'detachedStatus' then
                        v.Parent = det.body.container
                        
                        if v:IsA('Frame') and v.Name == 'category' then
                            v.BackgroundTransparency = 0.95
                            v.BackgroundColor3 = rgb(255, 255, 255)
                        end
                    end
                end
    
                tabWindow.detachedStatus.Visible = true
                ts(tabWindow.detachedStatus, {0.3, 'Exponential'}, {
                    TextTransparency = 0
                })
    
                ts(det, {0.3, 'Exponential'}, {
                    Position = udim2(0.5, -150, 0.5, -150)
                })
            end
    
            --detachTab()
    
            tabButton = instance('Frame', {
                Parent = mainFrame.body.tabs.container,
                Size = udim2(1, 0, 0, 26),
                BackgroundColor3 = rgb(70, 70, 70),
                BackgroundTransparency = 1,
                Name = 'tab_' .. tabCount .. '_' .. tabData.Name
            }, {
                corner(0, 6),
                instance('ImageLabel', {
                    Name = 'icon',
                    Position = udim2(0, (tabData.Icon ~= nil and 3 or 0), 0.5, -10),
                    Size = udim2(0, (tabData.Icon ~= nil and 20 or 0), 0, 20),
                    BackgroundTransparency = 1,
                    Image = tabData.Icon,
                    ImageColor3 = rgb(150, 150, 150)
                }, {
                    instance('TextLabel', {
                        Position = udim2(0, (tabData.Icon ~= nil and 24 or 6), 0, 1),
                        Size = udim2(0, 30, 1, -2),
                        TextXAlignment = 'Left',
                        BackgroundTransparency = 1,
                        Font = 'Ubuntu',
                        TextSize = 11,
                        RichText = true,
                        Text = ('<b>%s</b>'):format(tabData.Name),
                        TextColor3 = rgb(150, 150, 150),
                    })
                }),
                instance('TextButton', {
                    Size = udim2(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = ''
                }),
                instance('ImageButton', {
                    Size = udim2(0, 16, 0, 14),
                    Position = udim2(1, -22, 0.5, -7),
                    Image = 'rbxassetid://12131634551',
                    ImageTransparency = 1,
                    Name = 'detach',
                    ImageColor3 = rgb(150, 150, 150),
                    BackgroundTransparency = 1,
                    BackgroundColor3 = rgb(0, 0, 0)
                }, {corner(0, 4)}, {
                    function(self)
                        self.MouseEnter:Connect(function()
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundTransparency = 0.5
                            })
                        end)
    
                        self.MouseLeave:Connect(function()
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundTransparency = 1
                            })
                        end)
    
                        self.MouseButton1Down:Connect(function()
                            detachTab()
                        end)
                    end
                })
            }, {
                function(self)
                    local buttonGlow = glow(self, 3, 1)
                    buttonGlow.hide()
    
                    self.MouseEnter:Connect(function()
                        ts(self, {0.3, 'Exponential'}, {
                            BackgroundTransparency = 0.6
                        })
    
                        ts(self.detach, {0.3, 'Exponential'}, {
                            ImageTransparency = 0
                        })
                    end)
    
                    self.MouseLeave:Connect(function()
                        if selectedTab ~= tabWindow then
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundTransparency = 1
                            })
    
                            ts(self.detach, {0.3, 'Exponential'}, {
                                ImageTransparency = 1
                            })
                        end
                    end)
    
                    self.TextButton.MouseButton1Down:Connect(function()
                        lastTab = selectedTab
    
                        if lastTab then
                            ts(lastTab, {0.3, 'Exponential'}, {
                                Position = udim2(-1, 0, 0, 8)
                            })
    
                            delay(0.3, function()
                                lastTab.Position = udim2(1, 0, 0, 8)
                            end)
                        end
    
                        selectedTab = tabWindow
    
                        spawn(function()
                            buttonGlow.show()
                            ts(self.icon, {0.3, 'Exponential'}, {
                                ImageColor3 = rgb(255, 255, 255)
                            })
                            ts(self.icon.TextLabel, {0.3, 'Exponential'}, {
                                TextColor3 = rgb(255, 255, 255)
                            })
    
                            repeat
                                wait()
                            until selectedTab ~= tabWindow
    
                            buttonGlow.hide()
    
                            ts(self, {0.3, 'Exponential'}, {
                                BackgroundTransparency = 1
                            })
                            ts(self.detach, {0.3, 'Exponential'}, {
                                ImageTransparency = 1
                            })
                            ts(self.icon, {0.3, 'Exponential'}, {
                                ImageColor3 = rgb(150, 150, 150)
                            })
                            ts(self.icon.TextLabel, {0.3, 'Exponential'}, {
                                TextColor3 = rgb(150, 150, 150)
                            })
                            buttonGlow.hide()
                        end)
    
                        delay(0.2, function()
                            ts(selectedTab, {0.3, 'Exponential'}, {
                                Position = udim2(0, 8, 0, 8)
                            })
                        end)
                    end)
                end
            })
    
            tabWindow = instance('ScrollingFrame', {
                Parent = body.container,
                Position = udim2(1, 0, 0, 8),
                Size = udim2(1, -16, 1, -16),
                ClipsDescendants = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 0,
                AutomaticCanvasSize = 'Y',
                CanvasSize = udim2(0, 0, 0, 0)
            }, {
                instance('UIListLayout', {
                    Padding = UDim.new(0, 6),
                    SortOrder = 'LayoutOrder',
                }),
                instance('TextLabel', {
                    Text = '<i>The tab has been detached\ninto a separate window.</i>',
                    RichText = true,
                    TextSize = 14,
                    Font = 'Ubuntu',
                    TextColor3 = rgb(200, 200, 200),
                    Size = udim2(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Visible = false,
                    Name = 'detachedStatus'
                })
            })
    
            function tabLib:Category(categoryData)
                local categoryLib = {}
                categoryData.Closed = typeof(categoryData.Closed) == 'boolean' and categoryData.Closed or true
    
                local sizeData = {
                    ['button'] = 30,
                    ['toggle'] = 26,
                }
                local realCategorySize = 30
                local categoryBody
                local toggleCategory, categoryToggled = nil,  not categoryData.Closed
    
                local categoryDetached = false
                local function detachCategory()
                    if categoryDetached then
                        return
                    end
                    categoryDetached = true
    
                    categoryBody.title.Text = ('<s><i>%s</i></s>'):format(categoryData.Name)
    
                    local det;det = createDetachment(true, categoryData.Name, {}, function(v)
                        v.Parent = categoryBody.container
                    end, function()
                        categoryDetached = false
    
                        categoryBody.title.Text = ('<i>%s</i>'):format(categoryData.Name)
    
                        ts(det, {1, 'Exponential'}, {
                            Position = udim2(0, det.AbsolutePosition.X, 2, 0)
                        })
    
                        delay(1, function()
                            det:Destroy()
                        end)
    
                        ts(categoryBody.detachStatus, {0.3, 'Exponential'}, {
                            TextTransparency = 1
                        })
    
                        delay(0.3, function()
                            categoryBody.detachStatus.Visible = false
                        end)
                    end)
    
                    for a,v in next, categoryBody.container:GetChildren() do
                        v.Parent = det.body.container
                    end
    
                    categoryBody.detachStatus.Visible = true
                    ts(categoryBody.detachStatus, {0.3, 'Exponential'}, {
                        TextTransparency = 0
                    })
    
                    det.Position = udim2(0.5, -150, 2, 0)
    
                    ts(det, {0.3, 'Exponential'}, {
                        Position = udim2(0.5, -150, 0.5, -150)
                    })
                end
    
                categoryBody = instance('Frame', {
                    Parent = tabWindow,
                    Size = udim2(1, 0, 0, 30),
                    BackgroundColor3 = rgb(40, 40, 40),
                    Name = 'category',
                    ClipsDescendants = categoryData.Closed and true or false
                }, {
                    corner(0, 10),
                    instance('TextButton', {
                        Size = udim2(1, -10, 0, 30),
                        BackgroundTransparency = 1,
                        Text = '<i>' .. categoryData.Name .. '</i>',
                        TextXAlignment = 'Left',
                        TextColor3 = rgb(200, 200, 200),
                        Position = udim2(0, 10, 0, 0),
                        Font = 'Ubuntu',
                        RichText = true,
                        TextSize = 12,
                        Name = 'title'
                    }, {
                        instance('ImageButton', {
                            Size = udim2(0, 16, 0, 14),
                            Position = udim2(1, -22, 0.5, -7),
                            Image = 'rbxassetid://12131634551',
                            ImageTransparency = 0,
                            Name = 'detach',
                            ImageColor3 = rgb(150, 150, 150),
                            BackgroundTransparency = 1,
                            BackgroundColor3 = rgb(0, 0, 0)
                        }, {corner(0, 4)}, {
                            function(self)
                                self.MouseEnter:Connect(function()
                                    ts(self, {0.3, 'Exponential'}, {
                                        BackgroundTransparency = 0.5
                                    })
                                end)
            
                                self.MouseLeave:Connect(function()
                                    ts(self, {0.3, 'Exponential'}, {
                                        BackgroundTransparency = 1
                                    })
                                end)
            
                                self.MouseButton1Down:Connect(function()
                                    detachCategory()
                                end)
                            end
                        })
                    }, {
                        function(self)
                            self.MouseButton1Down:Connect(function()
                                categoryToggled = not categoryToggled
                                toggleCategory(categoryToggled)
                            end)
                        end
                    }),
                    instance('TextLabel', {
                        Position = udim2(0, 0, 0, 30),
                        Size = udim2(1, 0, 1, -30),
                        TextTransparency = 1,
                        ClipsDescendants = true,
                        Visible = false,
                        Text = '<i>Category has been detached\ninto a separate window.</i>',
                        RichText = true,
                        Font = 'Ubuntu',
                        TextSize = 12,
                        Name = 'detachStatus',
                        TextColor3 = rgb(255, 255, 255),
                        BackgroundTransparency = 1
                    }),
                    instance('Frame', {
                        Name = 'container', 
                        Size = not categoryData.Closed and udim2(1, -12, 1, -36) or udim2(1, -12, 1, 0),
                        Position = not categoryData.Closed and udim2(0, 6, 0, 30) or udim2(0, 6, 1, 0),
                        BackgroundTransparency = 1,
                    }, {
                        instance('UIListLayout', {
                            Padding = UDim.new(0, 6),
                            SortOrder = 'LayoutOrder'
                        })
                    })
                })
    
                local categoryGlow = glow(categoryBody, 3, 1)
                categoryGlow.hide()
    
                toggleCategory = function(s)
                    ts(categoryBody, {0.3, 'Exponential'}, {
                        Size = s and udim2(1, 0, 0, realCategorySize) or udim2(1, 0, 0, 30)
                    })
    
                    categoryBody.ClipsDescendants = not s
    
                    ts(categoryBody.container, {0.3, 'Exponential'}, {
                        Size = s and udim2(1, -12, 1, -36) or udim2(1, -12, 1, 0),
                        Position = s and udim2(0, 6, 0, 30) or udim2(0, 6, 1, 0)
                    })
    
                    if s then categoryGlow.show() else categoryGlow.hide() end
                end
    
                if not categoryData.Closed then
                    categoryGlow.show()
                    categoryBody.Size = udim2(1, 0, 0, realCategorySize)
                end
    
                function categoryLib:Button(data)
                    realCategorySize = realCategorySize + (28 + 6)
                    create.button(categoryBody.container, data)
                end
    
                function categoryLib:Toggle(data)
                    realCategorySize = realCategorySize + (26 + 6)
                    create.toggle(categoryBody.container, data)
                end
    
                function categoryLib:Keybind(data)
                    realCategorySize = realCategorySize + (28 + 6)
                    create.keybind(categoryBody.container, data)
                end
    
                function categoryLib:ToggleBind(data)
                    realCategorySize = realCategorySize + (28 + 6)
                    create.togglebind(categoryBody.container, data)
                end
    
                function categoryLib:Textbox(data)
                    realCategorySize = realCategorySize + (30 + 6)
                    create.textbox(categoryBody.container, data)
                end
    
                function categoryLib:Dropdown(data)
                    realCategorySize = realCategorySize + (28 + 6)
                    return create.dropdown(categoryBody.container, data)
                end
    
                function categoryLib:Slider(data)
                    realCategorySize = realCategorySize + (45 + 6)
                    create.slider(categoryBody.container, data)
                end
    
                function categoryLib:Textlabel(data)
                    realCategorySize = realCategorySize + (26 + 6)
                    return create.textlabel(categoryBody.container, data)
                end
    
                function categoryLib:Colorpicker(data)
                    realCategorySize = realCategorySize + (30 + 6)
                    create.colorpicker(categoryBody.container, data, sgui)
                end

                function categoryLib:Locked(data)
                    realCategorySize = realCategorySize + (28 + 6)
                    create.locked(categoryBody.container, data)
                end
    
                return categoryLib
            end
    
            function tabLib:Button(data)
                create.button(tabWindow, data)
            end
    
            function tabLib:Toggle(data)
                create.toggle(tabWindow, data)
            end
    
            function tabLib:Keybind(data)
                create.keybind(tabWindow, data)
            end
    
            function tabLib:ToggleBind(data)
                create.togglebind(tabWindow, data)
            end
    
            function tabLib:Textbox(data)
                create.textbox(tabWindow, data)
            end
    
            function tabLib:Dropdown(data)
                return create.dropdown(tabWindow, data)
            end
    
            function tabLib:Slider(data)
                create.slider(tabWindow, data)
            end
    
            function tabLib:Textlabel(data)
                return create.textlabel(tabWindow, data)
            end
    
            function tabLib:Colorpicker(data)
                create.colorpicker(tabWindow, data, sgui)
            end

            function tabLib:Locked(data)
                create.locked(tabWindow, data)
            end
    
            return tabLib
        end
    
    
        return lib
    end
    
    
    _G.library = library
    --#endregion


    local lib = _G.library:New({
        Title = 'Cappuccino',
        SubTitle = Marketplace:GetProductInfo(game.PlaceId).Name
    })

    _G.library = nil


    --#region Game sources
    local GameData = {
        {{4483381587}, function() --literal baseplate
            local newTab = lib:Tab({
                Name = 'Hello there',
                Icon = 'rbxassetid://10716853380'
            })

            local data = {
                '<font color="rgb(255,150,150)"><b><i>What are you doing in the mystical baseplate?</i></b></font>',
                '<b>Fun facts about cappuccino:</b>',
                'Cappuccino was made in 2020 by boop',
                'At first it was called IronBlu',
                'Then, it became <font color="rgb(66, 135, 245)">BluhHub</font>',
                'And, at last - <font color="rgb(126, 66, 245)">Cappuccino</font>',
                '<font color="rgb(66, 135, 245)">BluhHub</font> completely destroyed IMS, because it was OP',
                'After which serphos attempted rewriting the entire game',
                'Thats where IMS 2 appeared on the horizon',
                'Then we did it again'
            }

            for a,v in next, data do
                newTab:Textlabel({
                    Text = v
                })
            end
        end},
        {{537413528}, function() --build a boat for treasure
            --locals
            local player = game:service('Players').LocalPlayer
            local rep = game:service('ReplicatedStorage')
            local remote = {}
            local func = {}
            local feature = {}
            local building = false

            --functions
            function func:getBuildTool()
                local build
                xpcall(function()
                    build = player.Character.BuildingTool
                end, function()
                    build = player.Backpack.BuildingTool
                end)
                return build
            end
            function func:getScalingTool()
                local scale
                xpcall(function()
                    scale = player.Character.ScalingTool
                end, function()
                    scale = player.Backpack.ScalingTool
                end)
                return scale
            end
            function func:getPropsTool()
                local prop
                xpcall(function()
                    prop = player.Character.PropertiesTool
                end, function()
                    prop = player.Backpack.PropertiesTool
                end)
                return prop
            end
            function func:getColorTool()
                local color
                xpcall(function()
                    color = player.Character.PaintingTool
                end, function()
                    color = player.Backpack.PaintingTool
                end)
                return color
            end
            function func:getBlockInt(block)
                return player.Data[block].Value
            end
            function func:convertToRad(rot)
                return CFrame.Angles(math.rad(rot.X), math.rad(rot.Y), math.rad(rot.Z))
            end
            function func:getBlocks(owner)
                local b = {}
                for a,v in next, workspace:GetChildren() do
                    if v:FindFirstChild('Tag') and v.Tag.Value == owner then
                        table.insert(b, v)
                    end
                end
                return b
            end
            function func:checkAllTools()
                local tCount = #player.Backpack:GetChildren()
                if tCount ~= 7 then
                    return false
                end
                return true
            end

            --remotes
            function remote:build(btp, rot, pos, anc, con)
                rot = CFrame.new(pos) * func:convertToRad(rot)
                func:getBuildTool().RF:InvokeServer(btp, func:getBlockInt(btp), con, rot, anc, 1, CFrame.new(pos))
            end
            function remote:resize(block, size, pos)
                func:getScalingTool().RF:InvokeServer(block, size, pos)
            end
            function remote:color(block, color)
                func:getColorTool().RF:InvokeServer({[1] = {[1] = block, [2] = color}})
            end
            function remote:update(block, ut)
                func:getPropsTool().SetPropertieRF:InvokeServer(ut, {[1] = block})
            end

            --hooks
            local resizeNext, newBlock
            workspace.ChildAdded:Connect(function(v)
                if building then
                    v:WaitForChild('Tag')

                    if v.Tag.Value == player.Name then
                        newBlock = true
                        if resizeNext then
                            remote:resize(v, resizeNext.size, CFrame.new(resizeNext.pos) * func:convertToRad(resizeNext.rot))
                            remote:color(v, resizeNext.color)
                            if resizeNext.collision == false then
                                remote:update(v, 'Collision')
                            end
                            for a=1,(resizeNext.trans or 0) do
                                remote:update(v, 'Transparency')
                            end
                            resizeNext = nil
                        end
                    end
                end
            end)

            --features
            function feature:giveAllTools()
                local wl = {'DeleteTool', 'BuildingTool'}
            
                for a,v in next, player.Character:GetChildren() do
                    if v:IsA('Tool') then
                        if not table.find(wl, v.Name) then
                            v:Destroy()
                        end
                    end
                end
                for a,v in next, player.Backpack:GetChildren() do
                    if not table.find(wl, v.Name) then
                        v:Destroy()
                    end
                end
                
                for a,v in next, game:service('ReplicatedStorage').BuildingParts:GetChildren() do
                    if v:IsA('Tool') then
                        local a = v:Clone()
                        a.Parent = player.Backpack
                    end
                end
            end
            
            function feature:removeObstacles()
            
            end

            --settings
            local settings = {
                autofarm = false,
                runLen = 22,
                noObstacles = false,
            }

            local function formatInt(int)
                local s = tostring(int)
                s = s:reverse()
                local c = 0
                s = s:gsub('.', function(x)
                    c = c + 1
                    if c >= 3 then
                        c = 0
                        return x .. ','
                    else
                        return x
                    end
                end)
                s = s:reverse()
                if s:sub(1, 1) == ',' then
                    s = s:sub(2, string.len(s))
                end
                return s
            end

            --#region Tabs
            local autofarm = lib:Tab({Name = 'Autofarm', Icon = 'rbxassetid://11033997173'})
            local player1 = lib:Tab({Name = 'Player', Icon = 'rbxassetid://10876020158'})
            local game1 = lib:Tab({Name = 'Game', Icon = 'rbxassetid://10905009435'})
            local clone = lib:Tab({Name = 'Clone boats', Icon = 'rbxassetid://11033341371'})
            --#endregion


            --#region Autofarm code
            getgenv().farming = false
            getgenv().time = 22
            
            local t = tick()
            
            local function measure()
                return tick() - t
            end
            
            local p = game:service('Players').LocalPlayer
            
            local function fixInt(int) 
                return tonumber(string.format('%.02f', int)) 
            end
            
            local function round(exact, quantum)
                local quant, frac = math.modf(exact/quantum)
                return fixInt(quantum * (quant + (frac > 0.5 and 1 or 0)))
            end
            
            local runs = 0
            p.CharacterAdded:Connect(function(v)
                runs = runs + 1
                v:WaitForChild('HumanoidRootPart')
                t = tick()
            end)
            
            local function scale(unscaled, minAllowed, maxAllowed, min, max)
                return (maxAllowed - minAllowed) * (unscaled - min) / (max - min) + minAllowed
            end
            
            local function setPos(p1, p2, p3)
                pcall(function()
                    p.Character.HumanoidRootPart.CFrame = CFrame.new(p1, p2, p3)
                end)
            end

            local farmClock = {0, 0, 0}
            
            game:service('RunService').Stepped:connect(function()
                if farming then        
                    workspace.Gravity = 0
            
                    if measure() > getgenv().time then
                        workspace.Gravity = 200
                        setPos(-56 + math.random(-10, 10), -360 + math.random(-5, 5), 9498 + math.random(-10, 10))
                        return
                    end
                    
                    setPos(-25, 50, scale(measure(), 0, 8800, 0, getgenv().time))
                else
                    workspace.Gravity = 200 
                    t = tick()
                end
            end)

            local status = autofarm:Textlabel({Text = 'Status: <font color="rgb(255,150,150)"><b>Waiting</b></font>'})
            local elapsed = autofarm:Textlabel({Text = 'Time elapsed: <font color="rgb(150,255,150)"><b>0</b></font>', Alignment = 'Left'})
            local completed = autofarm:Textlabel({Text = 'Runs completed: <font color="rgb(150,255,150)"><b>0</b></font>', Alignment = 'Left'})
            local earned = autofarm:Textlabel({Text = 'Money earned: <font color="rgb(255,255,150)"><b>0</b></font>', Alignment = 'Left'})

            local function getMoney()
                local m
                xpcall(function()
                    m = player.PlayerGui.GoldGui.Frame.Amount.Text
                end, function()
                    m = 'N/A'
                end)
                return m
            end

            local savedGold = getMoney()
            spawn(function()
                wait(3)
                while wait(1) do
                    if getgenv().farming then
                        farmClock[1] = farmClock[1] + 1
                        if farmClock[1] > 59 then
                            farmClock[1] = 0
                            farmClock[2] = farmClock[2] + 1
                            if farmClock[2] > 59 then
                                farmClock[2] = 0
                                farmClock[3] = farmClock[3] + 1
                            end
                        end
                        status:SetText('Status: <font color="rgb(150,255,150)"><b>Farming</b></font>')
                        elapsed:SetText(('Time elapsed: <font color="rgb(150,255,150)"><b>%s</b></font>:<font color="rgb(150,255,150)"><b>%s</b></font>:<font color="rgb(150,255,150)"><b>%s</b></font>'):format(
                            string.len(tostring(farmClock[3])) == 1 and '0' .. tostring(farmClock[3]) or farmClock[3],
                            string.len(tostring(farmClock[2])) == 1 and '0' .. tostring(farmClock[2]) or farmClock[2],
                            string.len(tostring(farmClock[1])) == 1 and '0' .. tostring(farmClock[1]) or farmClock[1]
                        ))
                        completed:SetText(('Runs completed: <font color="rgb(150,255,150)"><b>%s</b></font>'):format(tostring(runs)))
                        pcall(function()
                            earned:SetText(('Money earned: <font color="rgb(255,255,150)"><b>%s</b></font> credits'):format(formatInt(tonumber(getMoney() - tonumber(savedGold)))))
                        end)
                    else
                        farmClock = {0, 0, 0}
                        runs = 0
                        status:SetText('Status: <font color="rgb(255,150,150)"><b>Waiting</b></font>')
                        elapsed:SetText('Time elapsed: <font color="rgb(150,255,150)"><b>0</b></font>')
                        completed:SetText('Runs completed: <font color="rgb(150,255,150)"><b>0</b></font>')
                        earned:SetText('Money earned: <font color="rgb(255,255,150)"><b>0</b></font>')
                    end
                end
            end)

            local runData = {
                len = {0, 0, 0},
                comp = 0,
                money = 0
            }

            autofarm:Toggle({
                Text = 'Enabled',
                Callback = function(s)
                    if s then
                        player.Character.Humanoid:TakeDamage(math.huge)
                        savedGold = getMoney() ~= 'N/A' and getMoney() or 0
                    end
                    getgenv().farming = s
                end
            })

            autofarm:Slider({
                Text = 'Autofarm run length',
                Min = 9,
                Max = 30,
                Value = 22,
                Float = 1,
                Callback = function(v)
                    getgenv().time = v
                end
            })
            --#endregion

            --#region Player code
            local god = false
            spawn(function()
                while true do
                    wait()
                    if god then
                        pcall(function()
                            player.Character.WaterDetector:Destroy()
                        end)
                    end
                end
            end)

            player1:Toggle({
                Text = 'Godmode',
                Callback = function(s)
                    god = s 
                end
            })

            player1:Locked({Text = 'Give all tools'})
            --#endregion


            --#region Game code
            local remove = false

            LPH_NO_VIRTUALIZE(function()
                workspace.BoatStages.OtherStages.DescendantAdded:Connect(function(v)
                    wait(0.5)
                    if v:FindFirstChild('RockScript') then
                        if remove then
                            v:Destroy()
                        end
                    end
                end)

                game1:Toggle({
                    Text = 'Auto remove obstacles',
                    Callback = function(s)
                        if s then
                            for a,v in next, workspace.BoatStages.OtherStages:GetChildren() do
                                for a2,v2 in next, v:GetDescendants() do
                                    if v2:FindFirstChild('RockScript') then
                                        v2:Destroy()
                                    end
                                end
                            end
                        end
                        remove = s
                    end
                })
            end)()
            --#endregion

            --#region Clone boats
            if not CapIsFile('BOATS_copy.json') then
                CapWrite('BOATS_copy.json', HttpService:JSONEncode({}))
            end

            local CloneStatus = clone:Textlabel({
                Text = 'Status: <font color="rgb(150,255,150)"><b>Ready</b></font>',
            })
            local Copying = clone:Textlabel({
                Text = 'Copying: <font color="rgb(255,255,150)"><b>N/A</b></font>',
                Alignment = 'Left'
            })
            local Blocks = clone:Textlabel({
                Text = 'Copied blocks: <font color="rgb(150,255,150)"><b>0</b></font> / 0',
                Alignment = 'Left'
            })

            function feature:copyBuild(user)
                if not func:checkAllTools() then
                    feature:giveAllTools()
                end
                if not isfile('cappuccino-v7/BOATS_copy.json') then
                    writefile('cappuccino-v7/BOATS_copy.json', json.encode({}))
                end
            
                local realData = HttpService:JSONDecode(CapRead('BOATS_copy.json'))
                local data, blocks = {owner = user, zone = tostring(game:service('Players')[user].Team), copyData = {}}, func:getBlocks(user)
            
                for a,v in next, realData do
                    if v.owner == user then
                        table.remove(realData, a)
                    end
                end
            
                for a,v in next, blocks do
                    local b = v.PPart
                    local tr = b.Transparency
                    table.insert(data.copyData, {
                        ['b1'] = v.Name,
                        ['s1'] = {b.Size.X, b.Size.Y, b.Size.Z},
                        ['p1'] = {b.Position.X, b.Position.Y, b.Position.Z},
                        ['r1'] = {b.Rotation.X, b.Rotation.Y, b.Rotation.Z},
                        ['a1'] = b.Anchored,
                        ['c1'] = {b.Color.R, b.Color.G, b.Color.B},
                        ['c2'] = b.CanCollide,
                        ['t1'] = (tr == 0 and 0 or tr == 0.25 and 1 or tr == 0.5 and 2 or tr == 0.75 and 3 or tr == 1 and 4)
                    })
                end
            
                table.insert(realData, data)
                writefile('cappuccino-v7/BOATS_copy.json', HttpService:JSONEncode(realData))
            end
            
            function feature:build(user)
                if building then
                    return
                end
                building = true

                CloneStatus:SetText('Status: <font color="rgb(255,255,150)"><b>Working</b></font>')
            
                local copy = HttpService:JSONDecode(readfile('cappuccino-v7/BOATS_copy.json'))
                
                local copyData, team
                for a,v in next, copy do
                    if v.owner == user then
                        team = v.zone
                        copyData = v.copyData
                    end
                end
            
                for a,v in next, copyData do
                    resizeNext = {
                        size = Vector3.new(v.s1[1], v.s1[2], v.s1[3]), 
                        pos = Vector3.new(v.p1[1], v.p1[2], v.p1[3]),
                        rot = Vector3.new(v.r1[1], v.r1[2], v.r1[3]),
                        color = Color3.new(v.c1[1], v.c1[2], v.c1[3]),
                        collision = v.c2,
                        trans = v.t1
                    }

                    Copying:SetText(('Copying: <font color="rgb(255,255,150)"><b>%s</b></font> | pos: <b>%s, %s, %s</b>'):format(v.b1, math.floor(v.p1[1]), math.floor(v.p1[2]), math.floor(v.p1[3])))
                    Blocks:SetText(('Copied blocks: <font color="rgb(150,255,150)"><b>%s</b></font> / %s'):format(tostring(a), tostring(#copyData)))
            
                    remote:build(v.b1, Vector3.new(v.r1[1], v.r1[2], v.r1[3]), Vector3.new(v.p1[1], v.p1[2], v.p1[3]), true, nil)
            
                    local t = tick()

                    repeat
                        wait()
                        if tick() - t > 2 then
                            resizeNext = nil
                        end
                    until resizeNext == nil
                end

                CloneStatus:SetText('Status: <font color="rgb(150,255,150)"><b>Ready</b></font>')
                Copying:SetText('Copying: <font color="rgb(255,255,150)"><b>N/A</b></font>')
                Blocks:SetText('Copied blocks: <font color="rgb(150,255,150)"><b>0</b></font> / 0')
            
                building = false
            end

            local textHolder = ''
            local tb, tb2 = HttpService:JSONDecode(CapRead('BOATS_copy.json')), {}
            local saveFile = ''
            local newTb = {}
            local dropdown
            local function upd()
                newTb = {}
                for a,v in next, tb do
                    table.insert(newTb, v.owner)
                end
                if #newTb == 0 then
                    newTb = {'Empty'}
                end
            end

            local function refresh()
                dropdown:UpdateOptions(newTb)
            end

            spawn(function()
                while wait(1) do
                    upd()
                end
            end)

            clone:Textbox({
                Text = 'Username',
                Placeholder = 'nust be full username',
                Clear = false,
                Callback = function(v)
                    textHolder = v
                end,
                FillFunction = function()
                    local t = {}
                    for a,v in next, game:service('Players'):GetPlayers() do
                        table.insert(t, v.Name)
                    end
                    return t
                end
            })

            clone:Button({
                Text = 'Save boat',
                Callback = function()
                    local gp = false
                    for a,v in next, game:service('Players'):GetPlayers() do if v.Name == textHolder then gp = true break end end
                    if not gp then
                        return
                    end
        
                    feature:copyBuild(textHolder)
        
                    tb = HttpService:JSONDecode(CapRead('BOATS_copy.json'))
                    upd()
                end
            })

            clone:Button({
                Text = 'Refresh save files',
                Callback = refresh
            })

            dropdown = clone:Dropdown({
                Text = 'Choose a save file',
                Options = newTb,
                Callback = function(o)
                    saveFile = o
                end
            })

            delay(2.4, function()
                refresh()
            end)

            clone:Button({
                Text = 'Load!',
                Callback = function()
                    local cc = false
                    for a,v in next, tb do
                        if v.owner == saveFile then
                            if tostring(player.Team) == v.zone then
                                cc = true
                            else
                                notify({
                                    Title = ('You must be on the same team as the saved file (%s)!'):format(v.zone),
                                    Duration = 10,
                                })
                            end
                            break
                        end
                    end
                    if not cc then
                        return
                    end
        
                    feature:build(saveFile)
                end
            })

            --#endregion
        end},
        {{6168898345}, function() --bulwark 2.2.1.4.56.2
            local FakeLocalPlayer = game:GetService("Players"):FindFirstChild("LocalPlayer") -- BEST PATCH EVER OMG GREAT JOB PATCHING US!!!
            if FakeLocalPlayer then FakeLocalPlayer.Name = "_" end
            ENABLE_PLAYER_DATA = false

            --#region Settings 
            local Config = {
                -- Kill aura
                KillAura = false,
                ParryCheck = true,
                PositionDelay = true,
                TpAura = false,
                MaxDistance = 14,
                TpMaxDistance = 70,
                CustomDelay = 0.1,
                AutomatedDecrease = 0.1,

                DelayMethod = "Automated",

                -- Auto parry
                AutoParry = false,
                HitableCheck = true,
                FacingTarget = true,

                Chance = 100,
                ParryChance = 0,
                RiposteChance = 100,

                ParryMax = 150,
                ParryMin = 0,

                RiposteMax = 60,
                RiposteMin = 0,

                UnParryMax = 120,
                UnParryMin = 30,

                CooldownBlockMax = 30,
                CooldownBlockyMin = 5,

                RiposteDistance = 7,
                ParryDistance = 9.5,
                ParryTrigger = "Release",

                -- Auto feint
                AutoFeint = false,
                FeintHitableCheck = true,
                FeintFacingTarget = true,
                FeintChance = 100,

                FeintMax = 200,
                FeintMin = 100,

                FeintHoldMax = 130,
                FeintHoldMin = 60,

                FeintCooldownMax = 300,
                FeintCooldownMin = 200,

                FeintDistance = 11,

                -- Auto punch
                AutoPunch = false,
                PunchHitableCheck = true,
                PunchFacingTarget = true,
                PunchChance = 100,

                PunchMax = 100,
                PunchMin = 2,

                PunchHoldMax = 100,
                PunchHoldMin = 20,

                PunchCooldownMax = 200,
                PunchCooldownMin = 50,

                PunchDistance = 6.5,

                -- Auto kick
                AutoKick = false,
                KickHitableCheck = true,
                KickChance = 100,
                KickMax = 100,
                KickMin = 50,
                KickHoldMax = 100,
                KickHoldMin = 20,
                KickDistance = 4,

                -- Auto teleport
                Autoteleport = false,
                TeleportOffset = 6,

                Collision = true,

                -- Flight
                Flight = false,
                FlightSpeed = 7.5,
                FlightdMethod = "Down",
                FlightdMoveMethod = "Normal",

                -- Speed hack
                SpeedHack = false,
                Speed = 4.5,
                SpeedMethod = "Normal",

                -- Bypass config
                StopDuration = 0.4,
                StopCooldownDuration = 0.8,
                TpCooldownDuration = 0.6,

                -- Always features
                AlwaysParry = false,
                AlwaysHitHead = false,
                CancelAttack = false,
                
                -- Spam play sound
                PlaySound = false,
                PlayDelay = 0.2,

                -- Misc
                HideNameTag = false,

                AutoEnterDuel = false,
                AutoEnterTeamFight = false,

                NoSwingSound = false,
                CollectCornucopia = false,
                AutoReset = false,

                StaminaDecrease = false,
                DecreaseProcent = 100,

                -- Break duels
                Break = false,
                BreakConfirmed = false,
                AlreadyBroke = false,
            }
            --#endregion


            --#region Tables 
            local PlayerData = {}
            local BlockingStates = { "Parrying", "Riposte" }
            local AttackingStates = { "Release", }
            --#endregion


            --#region Yields 
            local GameComponents = Workspace:WaitForChild("gameComponents", 9e9)
            local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 9e9)
            local ToServer = RemoteEvents:WaitForChild("ToServer", 9e9)
            local TeamFightQueueBoard = GameComponents:WaitForChild("TeamFightQueueBoard", 9e9)
            local DuelQueueBoard = GameComponents:WaitForChild("DuelQueueBoard", 9e9)
            --#endregion


            --#region Remotes 
            local Hit = ToServer:WaitForChild("Hit", 9e9)
            local Kick = ToServer:WaitForChild("Kick", 9e9)
            local Punch = ToServer:WaitForChild("Punch", 9e9)
            local ChangeStance = ToServer:WaitForChild("ChangeStance", 9e9)
            local Sound = ToServer:WaitForChild("Sound", 9e9)
            local Reset = ToServer:WaitForChild("Reset", 9e9)
            --#endregion
    
            --#region Functions 
            local function SaveConfig()
                local ConfigTable = {}
    
                for Name, Value in pairs(Config) do
                    if type(Value) == "boolean" then
                        continue
                    end
    
                    ConfigTable[Name] = Value
                end
    
                local Json = HttpService:JSONEncode(ConfigTable)
                CapWrite("bulwark_config.json", Json)
            end
            local function EnterQueue()
                if LocalPlayer.Team ~= Teams.Spectators then
                    return
                end
    
                if Config.AutoEnterDuel then
                    local FoundYou = DuelQueueBoard.SurfaceGui.ScrollingFrame:FindFirstChild(LocalPlayer.Name)
                    if not FoundYou then
                        fireclickdetector(DuelQueueBoard.ClickDetector, 0)
                    end
                end
    
                if Config.AutoEnterTeamFight then
                    local FoundYou = TeamFightQueueBoard.SurfaceGui.ScrollingFrame:FindFirstChild(LocalPlayer.Name)
                    if not FoundYou then
                        fireclickdetector(TeamFightQueueBoard.ClickDetector, 0)
                    end
                end
            end
            local function HideNameTag(Character)
                if Character then Character:WaitForChild("Head") Character.Head:WaitForChild("NamePlate") end
    
                local LocalCharacter = Character or LocalPlayer.Character
                if
                    not LocalCharacter
                    or (Character and not Config.HideNameTag)
                then
                    return
                end
    
                local Head = LocalCharacter:FindFirstChild("Head")
                local NamePlate = Head and Head:FindFirstChild("NamePlate")
                if not Head or not NamePlate or not NamePlate:FindFirstChild("NameFrame") then return end
                NamePlate.NameFrame:Destroy()
            end
            local function AutoReset(Character)
                if not Config.AutoReset then 
                    return
    
                end
    
                if Character then Character:WaitForChild("Humanoid") end
    
                local Humanoid = Character:FindFirstChild("Humanoid")
                if
                    not Humanoid 
                    or LocalPlayer.Team == Teams.Spectators
                then
                    return
                end
    
                repeat
                    task.wait(0.1)
    
                    Humanoid.Health = 0
                until Humanoid.Parent == nil
            end
            local function CollectCornucopia(Child)
                task.wait(0.5)
    
                local CornucopiaFind = Child or Workspace:FindFirstChild("Cornucopia")
                if not CornucopiaFind then
                    return
                end
                
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local Root = Character:WaitForChild("HumanoidRootPart")
    
                notify({text = 'Collected Cornucopia', duration = 4})
    
                firetouchinterest(Root, CornucopiaFind.Cornucopia, 0)
                firetouchinterest(Root, CornucopiaFind.Cornucopia, 1)
            end
            local function CharacterAdded(Character, UserId)
                task.wait(0.1)
    
                local ToolsFound = {}
                local Tool = Character:FindFirstChildWhichIsA("Tool")
                if Tool then
                    local Stance = Tool:WaitForChild("Stance", 5)
                    if Stance then
                        ToolsFound[Tool] = Tool
                        PlayerData[UserId].Stance = Stance.Value
                        PlayerData[UserId].StanceTick = tick()
    
                        Stance.Changed:Connect(function()
                            PlayerData[UserId].StanceTick = tick()
                            PlayerData[UserId].Stance = Stance.Value
                        end)
                    end
                end
    
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    PlayerData[UserId].Root = HumanoidRootPart
                end
                local Humanoid = Character:FindFirstChild("Humanoid")
                if Humanoid then
                    PlayerData[UserId].Humanoid = Humanoid
                end
                PlayerData[UserId].Character = Character
    
                Character.ChildRemoved:Connect(function(Child)
                    if not Child:IsA("Tool") then
                        if Child.Name == "HumanoidRootPart" then
                            PlayerData[UserId].Root = nil
                        elseif Child.Name == "Humanoid" then
                            PlayerData[UserId].Humanoid = nil
                        end
                    
                        return
                    end
    
                    PlayerData[UserId].Stance = "Idle"
                    PlayerData[UserId].StanceTick = tick()
                end)
                Character.ChildAdded:Connect(function(Child)
                    if
                        not Child:IsA("Tool")
                        or Child == ToolsFound
                    then
                        if Child.Name == "HumanoidRootPart" then
                            PlayerData[UserId].Root = Child
                        elseif Child.Name == "Humanoid" then
                            PlayerData[UserId].Humanoid = Child
                        end
    
                        return
                    end
    
                    local Stance = Child:WaitForChild("Stance", 5)
                    if Stance then
                        ToolsFound[Child] = Child
                        PlayerData[UserId].Stance = Stance.Value
                        PlayerData[UserId].StanceTick = tick()
                        
                        Stance.Changed:Connect(function()
                            PlayerData[UserId].StanceTick = tick()
                            PlayerData[UserId].Stance = Stance.Value
                        end)
                    end
                end)
            end
            local function OnPlayerAdded(Player)
                PlayerData[Player.UserId] = {
                    Instance = Player,
                    Name = Player.Name,
    
                    Root = nil,
                    Humanoid = nil,
                    Character = nil,
    
                    Stance = "Idle",
                    StanceTick = tick(),
    
                    Positions = {},
                    PPosition = nil,
    
                    PvP = false,
                }
    
                PlayerData[Player.UserId].PvP = Player:GetAttribute("PVP")
                Player.AttributeChanged:Connect(function(attributeName)
                    PlayerData[Player.UserId].PvP = Player:GetAttribute("PVP")
                end)
                if Player.Character then
                    CharacterAdded(Player.Character, Player.UserId)
                end
                Player.CharacterAdded:Connect(function(Character)
                    PlayerData[Player.UserId].Stance = "Idle"
                    PlayerData[Player.UserId].StanceTick = tick()
    
                    CharacterAdded(Character, Player.UserId)
                end)
                Player.CharacterRemoving:Connect(function()
                    if not PlayerData[Player.UserId] then
                        return
                    end
                    PlayerData[Player.UserId].Root = nil
                    PlayerData[Player.UserId].Humanoid = nil
                    PlayerData[Player.UserId].Character = nil
                end)
            end
            local function OnPlayerRemoving(Player)
                PlayerData[Player.UserId] = nil
            end
            local function OnWorkspaceChildAdded(Child)
                if
                    Child.Name ~= "Cornucopia"
                    or not Config.CollectCornucopia
                then
                    return
                end
    
                CollectCornucopia(Child)
            end
            --#endregion


            --#region Signals
            for Index, Player in pairs(Players:GetPlayers()) do
                OnPlayerAdded(Player)
            end

            LocalPlayer:GetPropertyChangedSignal("Team"):Connect(EnterQueue)
            LocalPlayer.CharacterAdded:Connect(HideNameTag)
            LocalPlayer.CharacterAdded:Connect(AutoReset)
            Players.PlayerAdded:Connect(OnPlayerAdded)
            Players.PlayerRemoving:Connect(OnPlayerRemoving)
            workspace.ChildAdded:Connect(OnWorkspaceChildAdded)
            --#endregion


            --#region Main position desync 
            task.spawn(function()
                while true do task.wait(0.003)
                    for UserId, Table in pairs(PlayerData) do
                        if
                            not Table.Character
                            or not Table.Root
                        then
                            continue
                        end
    
                        local Tick = math.floor(tick() * 100) / 100
                        if not Table.Positions[Tick] then
                            Table.Positions[Tick] = Table.Root.Position
                        end
    
                        local Ping = math.floor(game.Stats.PerformanceStats.Ping:GetValue() / 600 *  100) / 100
                        local WantedPing = math.floor(tick() * 100) / 100
                        local FoundPos = PlayerData[Table.Instance.UserId].Positions[WantedPing - Ping]
    
                        if FoundPos then
                            Table.PPosition = FoundPos
                        end
                    end
                end
            end)
            --#endregion


            --#region Meta 
            local GetRawMetatable = getrawmetatable(game)
            local OldNameCall = GetRawMetatable.__namecall

            setreadonly(GetRawMetatable, false)

            GetRawMetatable.__namecall = newcclosure(function(self, ...)
                local Arguments = { ... }
                local Method = getnamecallmethod()

                if Method == "FireServer" then
                    if
                        Config.NoSwingSound
                        and tostring(self) == "Sound"
                    then
                        return wait(math.huge)
                    end

                    if
                        Config.StaminaDecrease
                        and tostring(self) == "Stamina"
                    then
                        Arguments[1] = (100 - Config.DecreaseProcent) / 100 * Arguments[1]
                    end

                    if
                        Config.AlwaysHitHead
                        and tostring(self) == "Hit"
                        and tostring(Arguments[2]) ~= "Head"
                    then
                        local Success, Output = pcall(function()
                            return Arguments[3].Parent.Head 
                        end)

                        Arguments[2] = Success and Output or Arguments[2]
                    end

                    if
                        Config.CancelAttack
                        and tostring(self) == "Hit"
                    then
                        local Value = "null"
                        
                        task.spawn(function()
                            local Tool = Arguments[3].Parent:FindFirstChildWhichIsA("Tool")
                            if Tool then
                                Value = Tool.Stance.Value
                            end
                        end)

                        if
                            Value == "Riposte"
                            or Value == "Parrying"
                        then
                            return nil
                        end
                    end
                end

                return OldNameCall(self, unpack(Arguments))
            end)

            setreadonly(GetRawMetatable, true)
            --#endregion


            --#region Config setup 
            if CapIsFile("bulwark_config.json") then
                for Name, Value in pairs(HttpService:JSONDecode(CapRead("bulwark_config.json"))) do
                    if type(Value) == "boolean" then
                        continue
                    end
    
                    Config[Name] = Value
                end
            else
                SaveConfig()
            end
            --#endregion


            --#region Part setup 
            local WhereOhWhere = Instance.new("Part")
            do
                WhereOhWhere.Anchored = true
                WhereOhWhere.CanCollide = false
                WhereOhWhere.Transparency = 0.9
                WhereOhWhere.CanQuery = false
                WhereOhWhere.Color = Color3.fromRGB(165, 165, 165)
                WhereOhWhere.Massless = true
                WhereOhWhere.CollisionGroupId = -1
                WhereOhWhere.Material = Enum.Material.Neon
                WhereOhWhere.Size = Vector3.new(2, 2, 2)
                WhereOhWhere.CanTouch = false
                WhereOhWhere.CastShadow = false
                WhereOhWhere.Shape = Enum.PartType.Ball
            end
            --#endregion


            --#region Tabs 
            local Rage = lib:Tab({
                Name = 'Rage',
                Icon = 'rbxassetid://11391513362'
            })
            local Legit = lib:Tab({
                Name = 'Legit',
                Icon = 'rbxassetid://11391513345'
            })
            local Player = lib:Tab({
                Name = 'Player',
                Icon = 'rbxassetid://10876020158'
            })
            local Miscellaneous = lib:Tab({
                Name = 'Miscellaneous',
                Icon = 'rbxassetid://10872983349'
            })
            --#endregion


            --#region Kill aura
            Rage:Locked({Text = 'Kill aura'})
            --#endregion


            --#region Auto teleport
            local AutoTeleport = Rage:Category({
                Name = 'Auto teleport'
            })

            AutoTeleport:Toggle({
                Text = 'Enable',
                State = Config.Autoteleport,
                Callback = function(BoolState)
                    Config.Autoteleport = BoolState

                    task.spawn(function()
                        while Config.Autoteleport do 
                            task.wait()
    
                            for Index, Player in pairs(Players:GetPlayers()) do
                                if
                                    not Config.Autoteleport
                                    or Player == LocalPlayer
                                    or not LocalPlayer.Character
                                    or not Player.Character
                                    or not Player:GetAttribute("PVP")
                                    or not LocalPlayer:GetAttribute("PVP")
                                    or (LocalPlayer.Team.Name ~= "Spectators" and LocalPlayer.Team == Player.Team)
                                then
                                    continue
                                end
    
                                local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                local TargetRoot = Player.Character:FindFirstChild("HumanoidRootPart")
                                local Humanoid = Player.Character:FindFirstChild("Humanoid")
    
                                if
                                    not Root
                                    or not TargetRoot
                                    or not Humanoid
                                    or Humanoid.Health <= 0
                                then
                                    continue
                                end
    
                                local StartedTick = tick()
                                repeat task.wait()
                                    Root.CFrame = TargetRoot.CFrame + Vector3.new(0, Config.TeleportOffset, 0)
                                until Humanoid.Health <= 0
                                or tick() - StartedTick > 8
                                or not Player:GetAttribute("PVP")
                                or not Player.Character
                                or not TargetRoot.Parent
                            end
                        end
                    end)
                end
            })
            AutoTeleport:Slider({
                Text = 'Vertical offset',
                Max = 10,
                Min = -10,
                Float = 1,
                Value = Config.TeleportOffset,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.TeleportOffset = NumberState
                    SaveConfig()
                end
            })
            --#endregion


            --#region Non folder
            Rage:Locked({Text = 'Always parry'})

            Rage:Locked({Text = 'Always hit head'})

            Rage:Locked({Text = 'Cancel attack if hit is parried/riposted'})
            --#endregion


            --#region Auto block
            local AutoParry = Legit:Category({
                Name = 'Auto block'
            })

            local errorNotified = false
            local ignoreNotif = false

            AutoParry:ToggleBind({
                Text = 'Enable',
                Key = 'World0',
                Hold = false,
                State = Config.AutoParry,
                Callback = function(BoolState)
                    Config.AutoParry = BoolState
                
                    task.spawn(function()
                        while Config.AutoParry do
                            task.wait(0.01)

                            
                            if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
                                continue
                            end

                            for Index, Table in pairs(PlayerData) do
                                xpcall(function()
                                    if
                                        Table.Stance ~= Config.ParryTrigger
                                        and Table.Stance ~= "Release"
                                    then
                                        return
                                    end

                                    if
                                        Table.Instance == LocalPlayer
                                        or not Config.AutoParry
                                        or not LocalPlayer:FindFirstChild("Backpack") or LocalPlayer.Backpack:FindFirstChild("Tool")
                                        or (Config.HitableCheck and (not Table.Instance:GetAttribute("PVP") or not LocalPlayer:GetAttribute("PVP")or (LocalPlayer.Team ~= Teams.Spectators and LocalPlayer.Team == Table.Instance.Team)))
                                    then
                                        return
                                    end

                                    local Player = Table.Instance
                                    local Character = Player.Character
                                    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                                    local YourRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    local Humanoid = Character and Character:FindFirstChild("Humanoid")

                                    if not Character or not Root or not Humanoid or not YourRoot then return end
                                    if Humanoid.Health <= 0 then return end

                                    local Tool = Character:FindFirstChildWhichIsA("Tool")
                                    if not Tool then return end

                                    local Distance = (workspace.CurrentCamera.Focus.p - Root.Position).Magnitude
                                    local Unit = (Root.Position - workspace.CurrentCamera.Focus.p ).Unit
                                    local YourLookVector = YourRoot.CFrame.LookVector
                                    local Random = math.random(1, Config.ParryChance + Config.RiposteChance)
                                    local Which = Random < Config.ParryChance

                                    if
                                        Config.FacingTarget
                                        and Unit:Dot(YourLookVector) < 0
                                    then
                                        return
                                    end
                                    if Distance > (Which and Config.ParryDistance or Config.RiposteDistance) then
                                        if Distance > (not Which and Config.ParryDistance or Config.RiposteDistance) then
                                            return
                                        else
                                            Which = not Which and Config.ParryDistance or Config.RiposteDistance
                                        end
                                    end

                                    if math.random(1, 100) > Config.Chance then
                                        repeat task.wait()
                                        until Table.Stance ~= "Release"
                                        
                                        return
                                    end

                                    local ParryWait = math.random((Which and Config.ParryMin or Config.RiposteMin), (Which and Config.ParryMax or Config.RiposteMax)) / 1000
                                    repeat task.wait()
                                    until tick() - Table.StanceTick > ParryWait

                                    if Which then
                                        mouse2press()

                                        repeat task.wait()
                                        until (Table.Stance ~= Config.ParryTrigger and Table.Stance ~= "Release")
                                        or (workspace.CurrentCamera.Focus.p - Root.Position).Magnitude > Config.ParryDistance
                                        
                                        task.wait(math.random(Config.UnParryMin, Config.UnParryMax) / 1000)

                                        mouse2release()
                                    else
                                        keypress(0x52)

                                        repeat task.wait()
                                        until Table.Stance ~= "RiposteChance"
                                        and Table.Stance ~= "Riposte"
                                        
                                        task.wait(math.random(Config.UnParryMin, Config.UnParryMax) / 1000)

                                        keyrelease(0x52)

                                        task.wait(math.random(Config.CooldownBlockyMin, Config.CooldownBlockMax) / 1000)
                                    end
                                end, function(Error : string)
                                    if not errorNotified then
                                        errorNotified = true

                                        delay(15, function()
                                            errorNotified = false
                                        end)

                                        notify({
                                            Title = Error,
                                            Duration = 15,
                                            Options = {
                                                "Don't show this again",
                                                'Close'
                                            },
                                            CloseOnCallback = true,
                                            Callback = function(s)
                                                if s == "Don't show this again" then
                                                    ignoreNotif = true
                                                end
                                            end
                                        })
                                    end
                                end)
                            end
                        end
                    end)
                end,
            })
            AutoParry:Toggle({
                Text = 'Hitable Check',
                State = Config.AlwaysHitHead,
                Callback = function(BoolState)
                    Config.HitableCheck = BoolState
                end
            })
            AutoParry:Toggle({
                Text = 'Facing the target',
                State = Config.FacingTarget,
                Callback = function(BoolState)
                    Config.FacingTarget = BoolState
                end
            })
            AutoParry:Slider({
                Text = 'Chance',
                Max = 100,
                Min = 0,
                Float = 1,
                Value = Config.Chance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.Chance = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Parry chance',
                Max = 100,
                Min = 0,
                Float = 1,
                Value = Config.ParryChance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.ParryChance = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Riposte chance',
                Max = 100,
                Min = 0,
                Float = 1,
                Value = Config.RiposteChance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.RiposteChance = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Max parry reaction delay',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.ParryMax,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.ParryMax = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Min parry reaction delay',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.ParryMin,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.ParryMin = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Max riposte reaction delay',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.RiposteMax,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.RiposteMax = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Min riposte reaction delay',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.RiposteMin,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.RiposteMin = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Max cooldown time',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.CooldownBlockMax,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.CooldownBlockMax = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Min cooldown time',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.CooldownBlockyMin,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.CooldownBlockyMin = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Max parry distance',
                Max = 20,
                Min = 1,
                Float = 1,
                Value = Config.ParryDistance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.ParryDistance = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Slider({
                Text = 'Max riposte distance',
                Max = 20,
                Min = 1,
                Float = 1,
                Value = Config.RiposteDistance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.RiposteDistance = NumberState
                    SaveConfig()
                end
            })
            AutoParry:Dropdown({
                Text = 'Trigger',
                Options = {
                    'Release',
                    'Windup'
                },
                Default = Config.ParryTrigger,
                Callback = function(StringOption)
                    Config.ParryTrigger = StringOption
                    SaveConfig()
                end
            })
            --#endregion



            --#region Auto feint
            local AutoFeint = Legit:Category({
                Name = 'Auto feint'
            })

            AutoFeint:ToggleBind({
                Text = 'Enable',
                Key = 'World0',
                Hold = false,
                State = Config.AutoFeint,
                Callback = function(BoolState)
                    Config.AutoFeint = BoolState
                
                    task.spawn(function()
                        while Config.AutoFeint do
                            task.wait(0.01)
    
                            if PlayerData[LocalPlayer.UserId].Stance ~= "Windup" then
                                continue
                            end
    
                            for Index, Table in pairs(PlayerData) do
                                xpcall(function()
                                    if
                                        Table.Stance ~= "Parrying"
                                        and Table.Stance ~= "Riposte"
                                        and Table.Stance ~= "Release"
                                    then
                                        return
                                    end
    
                                    if
                                        Table.Instance == LocalPlayer
                                        or not Config.AutoFeint
                                        or not LocalPlayer:FindFirstChild("Backpack") or LocalPlayer.Backpack:FindFirstChild("Tool")
                                        or (Config.FeintHitableCheck and (not Table.Instance:GetAttribute("PVP") or not LocalPlayer:GetAttribute("PVP")or (LocalPlayer.Team ~= Teams.Spectators and LocalPlayer.Team == Table.Instance.Team)))
                                    then
                                        return
                                    end
    
                                    local Player = Table.Instance
                                    local Character = Player.Character
                                    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                                    local YourRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    local Humanoid = Character and Character:FindFirstChild("Humanoid")
                                    if not Character or not Root or not Humanoid or not YourRoot then return end
                                    if Humanoid.Health <= 0 then return end
    
                                    local Tool = Character:FindFirstChildWhichIsA("Tool")
                                    if not Tool then return end
    
                                    local Distance = (workspace.CurrentCamera.Focus.p - Root.Position).Magnitude
                                    local Unit = (Root.Position - workspace.CurrentCamera.Focus.p).Unit
                                    local YourLookVector = YourRoot.CFrame.LookVector
                                    if Distance > Config.FeintDistance then return end
    
                                    if
                                        Config.FeintFacingTarget
                                        and Unit:Dot(YourLookVector) < 0
                                    then
                                        return
                                    end
    
                                    if math.random(1, 100) > Config.FeintChance then
                                        repeat task.wait()
                                        until Table.Stance ~= "Parrying"
                                        and Table.Stance ~= "Riposte"
                                        and Table.Stance ~= "Release"
                                        
                                        return
                                    end
    
    
                                    local ParryWait = math.random(Config.FeintMin, Config.FeintMax) / 1000
                                    repeat task.wait()
                                    until tick() - Table.StanceTick > ParryWait
    
                                    keypress(0x51)
                                    
                                    task.wait(math.random(Config.FeintHoldMin, Config.FeintHoldMax) / 1000)
    
                                    keyrelease(0x51)
    
                                    task.wait(math.random(Config.FeintCooldownMin, Config.FeintCooldownMax) / 1000)
                                end, function(Error : string)
                                    notify({text = Error, duration = 15})
                                end)
                            end
                        end
                    end)
                end,
            })
            AutoFeint:Toggle({
                Text = 'Hitable Check',
                State = Config.FeintHitableCheck,
                Callback = function(BoolState)
                    Config.FeintHitableCheck = BoolState
                    SaveConfig()
                end
            })
            AutoFeint:Toggle({
                Text = 'Facing the target',
                State = Config.FeintFacingTarget,
                Callback = function(BoolState)
                    Config.FeintFacingTarget = BoolState
                    SaveConfig()
                end
            })
            AutoFeint:Slider({
                Text = 'Chance',
                Max = 100,
                Min = 0,
                Float = 1,
                Value = Config.FeintChance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.FeintChance = NumberState
                    SaveConfig()
                end
            })
            AutoFeint:Slider({
                Text = 'Max reaction delay',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.FeintMax,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.FeintMax = NumberState
                    SaveConfig()
                end
            })
            AutoFeint:Slider({
                Text = 'Min reaction delay',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.FeintMin,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.FeintMin = NumberState
                    SaveConfig()
                end
            })
            AutoFeint:Slider({
                Text = 'Max hold duration',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.FeintHoldMax,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.FeintHoldMax = NumberState
                    SaveConfig()
                end
            })
            AutoFeint:Slider({
                Text = 'Min hold duration',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.FeintHoldMin,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.FeintHoldMin = NumberState
                    SaveConfig()
                end
            })
            AutoFeint:Slider({
                Text = 'Max cooldown time',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.FeintCooldownMax,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.FeintCooldownMax = NumberState
                    SaveConfig()
                end
            })
            AutoFeint:Slider({
                Text = 'Min cooldown time',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.FeintCooldownMin,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.FeintCooldownMin = NumberState
                    SaveConfig()
                end
            })
            AutoFeint:Slider({
                Text = 'Max distance',
                Max = 20,
                Min = 0,
                Float = 0.1,
                Value = Config.FeintDistance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.FeintDistance = NumberState
                    SaveConfig()
                end
            })
            --#endregion


            --#region Auto punch
            local AutoPunch = Legit:Category({
                Name = 'Auto punch'
            })

            AutoPunch:ToggleBind({
                Text = 'Enable',
                Key = 'World0',
                Hold = false,
                State = Config.AutoPunch,
                Callback = function(BoolState)
                    Config.AutoPunch = BoolState
                
                
                    task.spawn(function()
                        while Config.AutoPunch do
                            task.wait(0.01)

                            if PlayerData[LocalPlayer.UserId].Stance ~= "Idle" then
                                continue
                            end

                            for Index, Table in pairs(PlayerData) do
                                xpcall(function()
                                    if
                                        Table.Stance ~= "Parrying"
                                    then
                                        return
                                    end

                                    if
                                        Table.Instance == LocalPlayer
                                        or not Config.AutoPunch
                                        or not LocalPlayer:FindFirstChild("Backpack") or LocalPlayer.Backpack:FindFirstChild("Tool")
                                        or (Config.PunchHitableCheck and (not Table.Instance:GetAttribute("PVP") or not LocalPlayer:GetAttribute("PVP")or (LocalPlayer.Team ~= Teams.Spectators and LocalPlayer.Team == Table.Instance.Team)))
                                    then
                                        return
                                    end

                                    local Player = Table.Instance
                                    local Character = Player.Character
                                    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                                    local YourRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    local Humanoid = Character and Character:FindFirstChild("Humanoid")
                                    if not Character or not Root or not Humanoid or not YourRoot then return end
                                    if Humanoid.Health <= 0 then return end

                                    local Tool = Character:FindFirstChildWhichIsA("Tool")
                                    if not Tool then return end

                                    local Distance = (workspace.CurrentCamera.Focus.p - Root.Position).Magnitude
                                    local Unit = (Root.Position - workspace.CurrentCamera.Focus.p).Unit
                                    local YourLookVector = YourRoot.CFrame.LookVector

                                    
                                    if
                                        Config.PunchFacingTarget
                                        and Unit:Dot(YourLookVector) < 0
                                    then
                                        return
                                    end
                                    if Distance > Config.PunchDistance then return end

                                    if math.random(1, 100) > Config.PunchChance then
                                        repeat task.wait()
                                        until Table.Stance ~= "Parrying"
                                        
                                        return
                                    end

                                    local ParryWait = math.random(Config.PunchMin, Config.PunchMax) / 1000
                                    repeat task.wait()
                                    until tick() - Table.StanceTick > ParryWait

                                    keypress(0x45)
                                    
                                    task.wait(math.random(Config.PunchHoldMin, Config.PunchHoldMax) / 1000)

                                    keyrelease(0x45)
                                end, function(Error : string)
                                    notify({text = Error, duration = 15})
                                end)
                            end
                        end
                    end)
                end,
            })
            AutoPunch:Toggle({
                Text = 'Hitable Check',
                State = Config.PunchHitableCheck,
                Callback = function(BoolState)
                    Config.PunchHitableCheck = BoolState
                    SaveConfig()
                end
            })
            AutoPunch:Toggle({
                Text = 'Facing the target',
                State = Config.PunchFacingTarget,
                Callback = function(BoolState)
                    Config.PunchFacingTarget = BoolState
                    SaveConfig()
                end
            })
            AutoPunch:Slider({
                Text = 'Chance',
                Max = 100,
                Min = 0,
                Float = 1,
                Value = Config.PunchChance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.PunchChance = NumberState
                    SaveConfig()
                end
            })
            AutoPunch:Slider({
                Text = 'Max reaction delay',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.PunchMax,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.PunchMax = NumberState
                    SaveConfig()
                end
            })
            AutoPunch:Slider({
                Text = 'Min reaction delay',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.PunchMin,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.PunchMin = NumberState
                    SaveConfig()
                end
            })
            AutoPunch:Slider({
                Text = 'Max key hold duration',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.PunchHoldMax,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.PunchHoldMax = NumberState
                    SaveConfig()
                end
            })
            AutoPunch:Slider({
                Text = 'Min key hold duration',
                Max = 1000,
                Min = 0,
                Float = 1,
                Value = Config.PunchHoldMin,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.PunchHoldMin = NumberState
                    SaveConfig()
                end
            })
            AutoPunch:Slider({
                Text = 'Max distance',
                Max = 20,
                Min = 0,
                Float = 0.1,
                Value = Config.PunchDistance,
                BlockMax = true, 
                Callback = function(NumberState)
                    Config.PunchDistance = NumberState
                    SaveConfig()
                end
            })
            --#endregion


            --#region Auto kick
            --[[
                local AutoKick = Legit:Category({
                    Name = 'Auto kick'
                })

                AutoKick:ToggleBind({
                    Text = 'Enable',
                    Key = 'World0',
                    Hold = false,
                    State = Config.AutoKick,
                    Callback = function(BoolState)
                        Config.AutoKick = BoolState
                    
                    
                        task.spawn(function()
                            while Config.AutoKick do
                                task.wait(0.01)

                                if PlayerData[LocalPlayer.UserId].Stance ~= "Idle" then
                                    continue
                                end

                                for Index, Table in pairs(PlayerData) do
                                xpcall(function()
                                        if
                                            Table.Stance == "Parrying"
                                            or Table.Stance == "Riposte"
                                        then
                                            return
                                        end

                                        if
                                            Table.Instance == LocalPlayer
                                            or not Config.AutoKick
                                            or not LocalPlayer:FindFirstChild("Backpack") or LocalPlayer.Backpack:FindFirstChild("Tool")
                                            or (Config.PunchHitableCheck and (not Table.Instance:GetAttribute("PVP") or not LocalPlayer:GetAttribute("PVP") or (LocalPlayer.Team ~= Teams.Spectators and LocalPlayer.Team == Table.Instance.Team)))
                                        then
                                            return
                                        end

                                        local Player = Table.Instance
                                        local Character = Player.Character
                                        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                                        local YourRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                        local Humanoid = Character and Character:FindFirstChild("Humanoid")
                                        if not Character or not Root or not Humanoid or not YourRoot then return end
                                        if Humanoid.Health <= 0 then return end
                                    
                                        local Distance = (workspace.CurrentCamera.Focus.p - Root.Position).Magnitude
                                        local Unit = (Root.Position - workspace.CurrentCamera.Focus.p).Unit
                                        local YourLookVector = YourRoot.CFrame.LookVector

                                        if
                                            Config.KickFacingTarget
                                            and Unit:Dot(YourLookVector) < 0
                                        then
                                            return
                                        end

                                        if Distance > Config.KickDistance then return end

                                        if math.random(1, 100) > Config.KickChance then
                                            repeat task.wait()
                                            until Table.Stance ~= "Idle"
                                            
                                            return
                                        end

                                        local KickWait = math.random(Config.KickMin, Config.KickMax) / 1000
                                        repeat task.wait()
                                        until tick() - Table.StanceTick > KickWait

                                        keypress(0x46)
                                        
                                        task.wait(math.random(Config.KickHoldMin, Config.KickHoldMax) / 1000)

                                        keyrelease(0x46)

                                        task.wait(math.random(Config.PunchCooldownMin, Config.PunchCooldownMax) / 1000)
                                    end, function(Error : string)
                                        notify({text = Error, duration = 15})
                                end)
                                end
                            end
                        end)
                    end,
                })
                AutoKick:Toggle({
                    Text = 'Hitable Check',
                    State = Config.KickHitableCheck,
                    Callback = function(BoolState)
                        Config.KickHitableCheck = BoolState
                        SaveConfig()
                    end
                })
                AutoKick:Toggle({
                    Text = 'Facing the target',
                    State = Config.KickFacingTarget,
                    Callback = function(BoolState)
                        Config.KickFacingTarget = BoolState
                        SaveConfig()
                    end
                })
                AutoKick:Slider({
                    Text = 'Chance',
                    Max = 100,
                    Min = 0,
                    Float = 1,
                    Value = Config.KickChance,
                    BlockMax = true, 
                    Callback = function(NumberState)
                        Config.KickChance = NumberState
                        SaveConfig()
                    end
                })
                AutoKick:Slider({
                    Text = 'Max reaction delay',
                    Max = 1000,
                    Min = 0,
                    Float = 1,
                    Value = Config.KickMax,
                    BlockMax = true, 
                    Callback = function(NumberState)
                        Config.KickMax = NumberState
                        SaveConfig()
                    end
                })
                AutoKick:Slider({
                    Text = 'Min reaction delay',
                    Max = 1000,
                    Min = 0,
                    Float = 1,
                    Value = Config.KickMin,
                    BlockMax = true, 
                    Callback = function(NumberState)
                        Config.KickMin = NumberState
                        SaveConfig()
                    end
                })
                AutoKick:Slider({
                    Text = 'Max key hold duration',
                    Max = 1000,
                    Min = 0,
                    Float = 1,
                    Value = Config.KickHoldMax,
                    BlockMax = true, 
                    Callback = function(NumberState)
                        Config.KickHoldMax = NumberState
                        SaveConfig()
                    end
                })
                AutoKick:Slider({
                    Text = 'Min key hold duration',
                    Max = 1000,
                    Min = 0,
                    Float = 1,
                    Value = Config.KickHoldMin,
                    BlockMax = true, 
                    Callback = function(NumberState)
                        Config.KickHoldMin = NumberState
                        SaveConfig()
                    end
                })
                AutoKick:Slider({
                    Text = 'Max cooldown',
                    Max = 1000,
                    Min = 0,
                    Float = 1,
                    Value = Config.PunchCooldownMax,
                    BlockMax = true, 
                    Callback = function(NumberState)
                        Config.PunchCooldownMax = NumberState
                        SaveConfig()
                    end
                })
                AutoKick:Slider({
                    Text = 'Min cooldown',
                    Max = 1000,
                    Min = 0,
                    Float = 1,
                    Value = Config.PunchCooldownMin,
                    BlockMax = true, 
                    Callback = function(NumberState)
                        Config.PunchCooldownMin = NumberState
                        SaveConfig()
                    end
                })
                AutoKick:Slider({
                    Text = 'Max distance',
                    Max = 20,
                    Min = 0,
                    Float = 0.1,
                    Value = Config.PunchDistance,
                    BlockMax = true, 
                    Callback = function(NumberState)
                        Config.PunchDistance = NumberState
                        SaveConfig()
                    end
                })
            ]]
            --#endregion


            --#region Flight 
            Player:Locked({Text = 'Flight'})
            --#endregion


            --#region Speed hack 
            local SpeedHack = Player:Category({
                Name = 'Speed hack'
            })
            
            SpeedHack:ToggleBind({
                Text = 'Enable',
                Key = 'World0',
                Hold = false,
                State = Config.SpeedHack,
                Callback = function(BoolValue)
                    Config.SpeedHack = BoolValue
                
                
                    task.spawn(function()
                        local Last = tick()
                        local Ignore = false
                        local TpIgnore = false
                        
                        WhereOhWhere.CFrame = CFrame.new(0, -1000, 0)

                        while Config.SpeedHack do
                            task.wait()

                            if
                                not LocalPlayer.Character
                                or Config.Flight
                                or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                or IsTyping
                            then
                                if Config.SpeedMethod == "Silent tp" then
                                    WhereOhWhere.Parent = nil
                                end

                                continue
                            end

                            -- Ik i can make this so much cleaner but i'm fucking lazy so i'll do it later (aka never)
                            local Offset = Vector3.new(0, 0, 0)
                            local Speed = Config.Speed / 50

                            if Config.SpeedMethod == "Tp" then
                                Speed = Speed * 20
                            end

                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                Offset = Offset + Vector3.new(0, 0, -Speed)
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                Offset = Offset + Vector3.new(0, 0, Speed)
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                Offset = Offset + Vector3.new(-Speed, 0, 0)
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                Offset = Offset + Vector3.new(Speed, 0, 0)
                            end

                            if Offset == Vector3.new(0, 0, 0) then
                                Last = tick()

                                if Config.SpeedMethod == "Silent tp" then
                                    pcall(function()
                                        WhereOhWhere.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                                    end)
                                end

                                continue
                            end

                            if Config.SpeedMethod == "Silent tp" then
                                if not WhereOhWhere.Parent then
                                    WhereOhWhere.Parent = CurrentCamera
                                end
                                if not Ignore then
                                    -- [[ NOT AVAIBLE ON THE OPEN SOURCE VERSION ]] --
                                end

                                if tick() - Last > 0.6 and not Ignore then
                                    Ignore = true
                                    
                                    task.delay(0.2, function()
                                        pcall(function()
                                            WhereOhWhere.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                                        end)

                                        Last = tick()
                                        Ignore = false
                                    end)
                                end
                            end

                            local Angle
                            
                            if Config.SpeedMethod == "Tp" then 
                                if TpIgnore then
                                    continue
                                end

                                TpIgnore = true

                                task.delay(Config.TpCooldownDuration, function()
                                    TpIgnore = false
                                end)
                            end

                            local Params = RaycastParams.new()
                            Params.FilterDescendantsInstances = {LocalPlayer.Character}
                            Params.FilterType = Enum.RaycastFilterType.Blacklist

                            Angle = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(CurrentCamera.CFrame.LookVector.X, 0, CurrentCamera.CFrame.LookVector.Z)) * CFrame.new(Offset.x, Offset.y, Offset.z)

                            local Offset = (Angle.p - LocalPlayer.Character.HumanoidRootPart.Position)
                            local Result = Config.Collision and workspace:Raycast(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Offset, Params) or false                            

                            if Result then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Result.Position)
                            else
                                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Offset
                            end

                            if Config.SpeedMethod == "Stop" and tick() - Last > Config.StopDuration then 
                                task.wait(Config.StopCooldownDuration)

                                Last = tick()
                            end
                        end
                    end)
                end,
            })
            SpeedHack:Slider({
                Text = 'Speed',
                Max = 100,
                Min = 0,
                Float = 0.2,
                Value = Config.Speed,
                BlockMax = false, 
                Callback = function(NumberState)
                    Config.Speed = NumberState
                    SaveConfig()
                end
            })
            SpeedHack:Dropdown({
                Text = 'Move method',
                Options = {
                    'Normal',
                    'Silent tp',
                    'Stop',
                    'Tp',
                },
                Default = Config.SpeedMethod,
                Callback = function(StringOption)
                    Config.SpeedMethod = StringOption
                    SaveConfig()

                    WhereOhWhere.Parent = Config.SpeedMethod == "Silent tp" and CurrentCamera or nil
                end
            })
            --#endregion


            --#region Idk 
            Player:Toggle({
                Text = 'Collision detection',
                State = Config.Collision,
                Callback = function(BoolState)
                    Config.Collision = BoolState
                end
            })
            --#endregion


            --#region Debug
            local DebugCategory = Player:Category({
                Name = 'Debug'
            })

            DebugCategory:Slider({
                Text = 'Stop duration',
                Max = 2,
                Min = 0,
                Float = 0.1,
                Value = Config.StopDuration,
                BlockMax = false, 
                Callback = function(NumberState)
                    Config.StopDuration = NumberState
                    SaveConfig()
                end
            })
            DebugCategory:Slider({
                Text = 'Stop cooldown',
                Max = 2,
                Min = 0,
                Float = 0.1,
                Value = Config.StopCooldownDuration,
                BlockMax = false, 
                Callback = function(NumberState)
                    Config.StopCooldownDuration = NumberState
                    SaveConfig()
                end
            })
            DebugCategory:Slider({
                Text = 'Tp cooldown',
                Max = 2,
                Min = 0,
                Float = 0.1,
                Value = Config.TpCooldownDuration,
                BlockMax = false, 
                Callback = function(NumberState)
                    Config.TpCooldownDuration = NumberState
                    SaveConfig()
                end
            })
            --#endregion


            --#region Spam play sound 
            local PlaySound = Miscellaneous:Category({
                Name = 'Spam play sound'
            })

            PlaySound:Toggle({
                Text = 'Enable',
                State = Config.PlaySound,
                Callback = function(BoolState)
                    Config.PlaySound = BoolState
                    

                    task.spawn(function()
                        while Config.PlaySound do
                            task.wait(Config.PlayDelay)
                            if not LocalPlayer.Character then
                                continue
                            end
    
                            local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                            if not Tool then continue end 
                            for Index, SoundInstance in pairs(Tool.BodyAttach:GetChildren()) do
                                if not SoundInstance:IsA("Sound") then
                                    continue
                                end
    
                                Sound:FireServer(SoundInstance)
                            end
                        end
                    end)
                end
            })
            PlaySound:Slider({
                Text = 'Play delay',
                Max = 1,
                Min = 0.01,
                Float = 0.01,
                Value = Config.PlayDelay,
                BlockMax = false, 
                Callback = function(NumberState)
                    Config.PlayDelay = NumberState
                    SaveConfig()
                end
            })
            --#endregion


            --#region Spam play sound 
            local Stamina = Miscellaneous:Category({
                Name = 'Stamina decrease'
            })

            Stamina:Toggle({
                Text = 'Enable',
                State = Config.StaminaDecrease,
                Callback = function(BoolState)
                    Config.StaminaDecrease = BoolState
                end
            })
            Stamina:Slider({
                Text = 'Decrease procent',
                Max = 100,
                Min = 0,
                Float = 1,
                Value = Config.DecreaseProcent,
                BlockMax = false, 
                Callback = function(NumberState)
                    Config.DecreaseProcent = NumberState
                    SaveConfig()
                end
            })
            --#endregion
        end},
        {{6097258548}, function() --iron man simulator 2
            -- [[ NOT AVAIBLE ON THE OPEN SOURCE VERSION ]] --
        end},
        {{2768379856, 9240353587, 9240295147, 6704458668, 2898101897}, function() --3008
            -- Services
            local Players = game:GetService("Players")
            local Lighting = game:GetService("Lighting")
            local UserInputService = game:GetService("UserInputService")
            local ReplicatedFirst = game:GetService("ReplicatedFirst")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local RunService = game:GetService("RunService")
            local HttpService = game:GetService("HttpService")
            local CoreGui = game:GetService("CoreGui")

            -- Tables
            local Remote = {}
            local Function = {}

            local EatableNames = {}
            local ModelNames = {}

            local EatableInstances = {}
            local ModelInstances = {}

            local Densitys = {
                ["BloodNight_Atmosphere"] = 0.6209999918937683,
                ["FoggyDay_Atmosphere"] = 0.675000011920929
            }
            local BlacklistedEatable = {
                "Glass Shard",
            }

            -- Values
            local ActionRemote = nil
            local EventRemote = nil
            local DefaultFogEnd = Lighting.FogEnd
            local DefaultFogStart = Lighting.FogStart

            -- Instances
            local CurrentCamera = workspace.CurrentCamera

            local LocalPlayer = Players.LocalPlayer
            local PlayerScripts =  LocalPlayer.PlayerScripts
            local PlayerGui = LocalPlayer.PlayerGui

            local ClientModule = PlayerScripts:WaitForChild("ClientModule", 5)

            local GameObjects = workspace:WaitForChild("GameObjects", 5)

            local Physical = GameObjects:WaitForChild("Physical", 5)

            local Map = Physical:WaitForChild("Map", 5)
            local Employees = Physical:WaitForChild("Employees", 5)

            local Floor = Map:WaitForChild("Floor", 5)

            local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
            local Modules = ReplicatedStorage:WaitForChild("Modules", 10)
            local ServerSettings = ReplicatedStorage:WaitForChild("ServerSettings", 10)
            local TimeLeft = ReplicatedStorage:FindFirstChild("TimeLeft", true)

            local _EDIBLE = Modules:FindFirstChild("_EDIBLE", true) -- To lazy
            local Default = ServerSettings:FindFirstChild("Default", true)

            -- Functions
            do -- EatableNames
                for _, ModuleScript in pairs(_EDIBLE:GetDescendants()) do
                    if not ModuleScript:IsA("ModuleScript") then
                        continue
                    end
                    
                    EatableNames[ModuleScript.Name] = ModuleScript.Name
                end
            end
            do -- ModelNames
                for _, Model in pairs(Default:GetChildren()) do
                    if not Model:IsA("Model") then
                        continue
                    end
                    
                    ModelNames[Model.Name] = Model.Name
                end
            end
            do -- Fix NoFog
                Lighting.ChildAdded:Connect(function(child)
                    if not child:IsA("Atmosphere") then
                        return
                    end
                    if Lighting.FogStart < 50 then
                        return
                    end

                    child.Density = 0
                end)
            end
            do -- ActionRemote and EventRemote
                local function OnCharacterAdded(Character)
                    local System = Character:WaitForChild("System", 10)
                    if System then
                        local Action = System:WaitForChild("Action", 5) 
                        local Event = System:WaitForChild("Event", 5) 
                        if Action and Event then
                            EventRemote = Event
                            ActionRemote = Action
                        else
                            EventRemote = nil
                            ActionRemote = nil
                        end
                    else
                        EventRemote = nil
                        ActionRemote = nil
                    end
                end

                if LocalPlayer.Character then
                    OnCharacterAdded(LocalPlayer.Character)
                end

                LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
            end
            do -- Remote
                function Remote:Pickup(Model)
                    if not Model or not ActionRemote or not ActionRemote.Parent then return end

                    ActionRemote:InvokeServer("Pickup", {
                        ["Model"] = Model
                    })
                end
                function Remote:Drop(EndCFrame, CameraCFrame, ThrowPower)
                    if not ActionRemote or not ActionRemote.Parent then return end

                    ActionRemote:InvokeServer("Drop", {
                        ["EndCFrame"] = EndCFrame or CurrentCamera.CFrame, -- If you didn't give a end cframe it'll use your camera cframe.
                        ["CameraCFrame"] = CameraCFrame or Vector3.new(0, 0, 0),
                        ["ThrowPower"] = ThrowPower or 0
                    })
                end
                function Remote:Shove(Employee)
                    if not Employee or not ActionRemote or not ActionRemote.Parent then return end

                    local Humanoid = Employee:FindFirstChild("Enemy") or Employee:FindFirstChildWhichIsA("Humanoid") 
                    if not Humanoid then
                        return
                    end

                    ActionRemote:InvokeServer("ShoveEmployee", {
                        ["Humanoid"] = Humanoid
                    })
                end
                function Remote:Store(ItemName)
                    if not ItemName or not ActionRemote or not ActionRemote.Parent then return end

                    ActionRemote:InvokeServer("Store", {
                        ["Model"] = ItemName
                    })
                end
                function Remote:DropAllItems(ItemName)
                    if not ActionRemote or not ActionRemote.Parent then return end
                    task.spawn(function()
                        ActionRemote:InvokeServer("Inventory_DropAll", {
                            ["Tool"] = ItemName
                        })
                    end)
                end
                function Remote:Consume(ItemName)
                    if not ActionRemote or not ActionRemote.Parent then return end

                    ActionRemote:InvokeServer("Inventory_Consume", {
                        ["Tool"] = ItemName
                    })
                end
                function Remote:SetAfk(Value)
                    if Value == nil then return end
                    
                    Remotes.Communication:FireServer("ToggleAFK", {
                        ["Data"] = Value
                    })
                end
            end
            do -- Function
                local PickupConnection = nil
                local TeleportRequests = {}
                local BusyWithRequests = false
                local SubjectPart = Instance.new("Part")
                do
                    SubjectPart.Name = "Subject"
                    SubjectPart.Parent = workspace.CurrentCamera
                    SubjectPart.Anchored = true
                    SubjectPart.CanCollide = false
                    SubjectPart.Size = Vector3.zero
                    SubjectPart.Transparency = 1
                end
                function Function:SetInstantPickup(Value)
                    if PickupConnection then
                        PickupConnection:Disconnect()
                    end

                    PickupConnection = nil

                    if Value then
                        local HoldValue = ClientModule.PickupSystem.System.HoldValue
                        PickupConnection = HoldValue.Changed:Connect(function()
                            if HoldValue.Value > 0 then
                                require(ClientModule.PickupSystem.System).InputSheet.MainInteract.Complete(Enum.PlaybackState.Completed)
                            end
                        end)
                    end
                end
                function Function:SetThirdPerson(Value)
                    if Value then
                        LocalPlayer.CameraMode = Enum.CameraMode.Classic
                        LocalPlayer.CameraMaxZoomDistance = 100000
                        LocalPlayer.CameraMinZoomDistance = 5
                        LocalPlayer.CameraMinZoomDistance = 0
                    else
                        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
                    end
                end
                function Function:GetItemStats(ItemName)
                    local Find = _EDIBLE:FindFirstChild(ItemName, true)
                    if Find then
                        return require(Find).Properties.RegenStats
                    end
                end
                function Function:GetEmployees(MaxDistance, HasPartsCheck)
                    local Table = {}
                    for _, Employee in ipairs(Employees:GetChildren()) do
                        if HasPartsCheck and not Employee:FindFirstChild("HumanoidRootPart") then
                            continue
                        end

                        if MaxDistance and not LocalPlayer:DistanceFromCharacter(Employee:GetModelCFrame().p) then
                            continue
                        end

                        table.insert(Table, Employee)
                    end

                    return Table
                end
                function Function:FindObject(Name) -- Note this is kinda heavy so don't use this to spam
                    local Find = Floor:FindFirstChild(Name, true)
                    return Find and (not Find:IsA("Model") and Find.Parent or Find) or nil
                end
                function Function:RunInventory() -- Kinda heavy on fps so don't repeat it fast (Fix the fps if you want to)
                    if not LocalPlayer.Character then 
                        return
                    end
                    local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if not Humanoid then 
                        return
                    end

                    local ChildrenOfBackpack = LocalPlayer.Backpack:GetChildren()
                    do
                        local HighestHealth = {nil, 0}
                        local HighestHunger = {nil, 0}
                        local HighestEnergy = {nil, 0}
                        
                        local AlreadyFound = {}

                        for _, Tool in pairs(ChildrenOfBackpack) do
                            local Stat = AlreadyFound[Tool.Name] or Function:GetItemStats(Tool.Name)
                            if not Stat then continue end
                            AlreadyFound[Tool.Name] = Stat
                            -- Health
                            if
                                Stat.Health
                                and Stat.Health > HighestHealth[2]
                            then
                                HighestHealth = {Tool, Stat.Health}
                            end

                            -- Hunger
                            if
                                Stat.Hunger
                                and Stat.Hunger > HighestHunger[2]
                            then
                                HighestHunger = {Tool, Stat.Hunger}
                            end

                            -- Energy
                            if
                                Stat.Energy
                                and Stat.Energy > HighestEnergy[2]
                            then
                                HighestEnergy = {Tool, Stat.Energy}
                            end
                        end
                        
                        if HighestHealth[1] and Humanoid.Health < 100 - HighestHealth[2] then
                            Remote:Consume(HighestHealth[1].Name)
                        end

                        if HighestHunger[1] and Humanoid:GetAttribute("Hunger") < 100 - HighestHunger[2] then
                            Remote:Consume(HighestHunger[1].Name)
                        end
                        
                        if HighestEnergy[1] and Humanoid:GetAttribute("Energy") < 100 - HighestEnergy[2] then
                            Remote:Consume(HighestEnergy[1].Name)
                        end
                    end
                end
                function Function:IsAEatableObject(Object)
                    if not Object:IsA("Model") then
                        return false
                    end
                    if not EatableNames[Object.Name] then
                        return false
                    end
                    
                    return true
                end
                function Function:IsAModelObject(Object)
                    if not Object:IsA("Model") then
                        return false
                    end
                    if not ModelNames[Object.Name] then
                        return false
                    end
                    
                    return true
                end
                function Function:GetTimeLeft()
                    local Time = TimeLeft.Value
                    local Min = math.floor(Time / 60)
                    local Sec = Min == 0 and Time or Time - (60 * Min)

                    return {Min, Sec}
                end
                function Function:GetCurrentTime() -- Function:GetCurrentTime()[1] is the current time and [2] is the time that it's gonna be
                    return Lighting.ClockTime == 0 and {"Night", "Day"} or {"Day", "Night"}
                end
                function Function:IsBackpackFull()
                    local MaxInventorySpace = LocalPlayer:GetAttribute("MaxInventorySpace")
                    local Tools = #LocalPlayer.Backpack:GetChildren()
                    Tools += LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool") and 1 or 0
                    return Tools >= MaxInventorySpace and true or false
                end
                function Function:ChangeNameTagDistance(Number)
                    for _, Player in pairs(game.Players:GetPlayers()) do
                        if not Player.Character then 
                            continue
                        end
                        local Head = Player.Character:FindFirstChild("Head")
                        local Nametag = Head and Head:FindFirstChild("Nametag") or nil
                        if not Head or not Nametag then
                            continue
                        end

                        Nametag.MaxDistance = Number
                    end
                end
                function Function:GoThroughRequests()
                    BusyWithRequests = true

                    repeat
                        if
                            table.getn(TeleportRequests) == 0
                            or not LocalPlayer.Character
                        then
                            break
                        end

                        local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                        if not Root or not Humanoid then break end
                        
                        local WasCFrame = Root.CFrame
                        local WasSubject = workspace.CurrentCamera.CameraSubject
                        
                        local Request = TeleportRequests[1]
                        local Object = Request.OBJECT
                        local Goal = Request.GOAL

                        local StartedTick = tick()
                        local RemoteTick = 0

                        local GoalCFrame
                        local ObjectCFrame = Object:FindFirstChild("Main") and Object.Main.CFrame or Object:GetModelCFrame()
                        local Offset = Vector3.new(0, -10, 0)

                        SubjectPart.CFrame = workspace.CurrentCamera.Focus
                        workspace.CurrentCamera.CameraSubject = SubjectPart
                        Humanoid.PlatformStand = true

                        repeat 
                            Root.CFrame = ObjectCFrame + Offset
                            Root.Velocity = Vector3.zero

                            task.spawn(function()
                                if tick() - RemoteTick > 0.2 then
                                    RemoteTick = tick()
                                    Remote:Pickup(Object)
                                end
                            end)

                            task.wait()
                        until Object:GetAttribute("Busy") or tick() - StartedTick > 5

                        RemoteTick = 0
                        StartedTick = tick()

                        repeat
                            GoalCFrame = typeof(Goal) == "CFrame" and Goal or Goal.CFrame

                            Root.CFrame = GoalCFrame + Offset
                            Root.Velocity = Vector3.zero

                            task.spawn(function()
                                if tick() - RemoteTick > 0.2 then
                                    RemoteTick = tick()
                                    Remote:Drop(GoalCFrame, GoalCFrame, 0)
                                end
                            end)
                            
                            task.wait()
                        until not Object:GetAttribute("Busy") or tick() - StartedTick > 5

                        Root.CFrame = WasCFrame
                        workspace.CurrentCamera.CameraSubject = WasSubject
                        Humanoid.PlatformStand = false
                        
                        table.remove(TeleportRequests, 1)

                        task.wait(0.02)
                    until table.getn(TeleportRequests) == 0 

                    BusyWithRequests = false
                end
                function Function:TeleportObject(Object, GoalCFrameOrInstance)
                    local TablePosition = table.getn(TeleportRequests) + 1

                    table.insert(TeleportRequests, {
                        OBJECT = Object,
                        GOAL = GoalCFrameOrInstance
                    })

                    if not BusyWithRequests then
                        Function:GoThroughRequests()
                    end

                    repeat task.wait() until not TeleportRequests[TablePosition] or TeleportRequests[TablePosition].OBJECT ~= Object or table.getn(TeleportRequests) == 0 
                end
            end
            do -- EatableInstances
                for _, Object in pairs(Physical:GetDescendants()) do
                    if not Function:IsAEatableObject(Object) then
                        continue
                    end
                    
                    EatableInstances[Object] = Object
                end

                Physical.DescendantAdded:Connect(function(Object)
                    task.wait(0.5)
                    if not Function:IsAEatableObject(Object) then
                        return
                    end
                    
                    EatableInstances[Object] = Object
                end)
                Physical.DescendantRemoving:Connect(function(Object)
                    if not EatableInstances[Object] then
                        return
                    end
                    
                    EatableInstances[Object] = nil
                end)
            end
            do -- ModelInstances
                for _, Object in pairs(Floor:GetDescendants()) do
                    if
                        not Function:IsAModelObject(Object)
                        or Function:IsAEatableObject(Object) 
                    then
                        continue
                    end
                    
                    ModelInstances[Object] = Object
                end

                Floor.DescendantAdded:Connect(function(Object)
                    task.wait(0.5)
                    if
                        not Function:IsAModelObject(Object)
                        or Function:IsAEatableObject(Object) 
                    then
                        return
                    end
                    
                    ModelInstances[Object] = Object
                end)
                Floor.DescendantRemoving:Connect(function(Object)
                    if
                        not Function:IsAModelObject(Object)
                        or Function:IsAEatableObject(Object) 
                    then
                        return
                    end
                    
                    ModelInstances[Object] = nil
                end)
            end

            local player = lib:Tab({
                Name = 'Player',
                Icon = 'rbxassetid://10876020158'
            })

            local flight = player:Category({
                Name = 'Flight'
            })

            local Flight = false
            local FlightSpeed = 10

            flight:ToggleBind({Text = 'Enable', Key = "B", State = Flight, Callback = function(s)
                Flight = s
                
                task.spawn(function()
                    while Flight do
                        task.wait()
                        --debug.profilebegin("FLIGHT")
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local Offset = Vector3.new(0, 0, 0)
                            local Speed = FlightSpeed / 10
                            -- For some reason the reapeated if IsKeyDown is better then pairs
                            if UserInputService:GetFocusedTextBox() == nil then
                                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                    Offset += Vector3.new(0, 0, -Speed)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                    Offset += Vector3.new(0, 0, Speed)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                    Offset += Vector3.new(-Speed, 0, 0)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                    Offset += Vector3.new(Speed, 0, 0)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                                    Offset += Vector3.new(0, -Speed, 0)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                                    Offset += Vector3.new(0, Speed, 0)
                                end
                            end
    
                            local Angle = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(CurrentCamera.CFrame.LookVector.X, 0, CurrentCamera.CFrame.LookVector.Z)) * CFrame.new(Offset)
                            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + (Angle.p - LocalPlayer.Character.HumanoidRootPart.Position)
                            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            workspace.Gravity = 0
                        end
    
                        if not Flight then workspace.Gravity = 196.2 end
    
                        --debug.profileend("FLIGHT")
                    end
                end)
    
                workspace.Gravity = 196.2
            end})

            flight:Slider({Text = 'Flight speed', Min = 0, Max = 100, Float = 1, Value = FlightSpeed, Callback = function(v)
                FlightSpeed = v
            end})

            local movement = player:Category({
                Name = 'Character'
            })

            local infjump = false
            local uis = game:service('UserInputService')
            uis.InputBegan:Connect(function(k, t)
                if k.KeyCode == Enum.KeyCode.Space and infjump then
                    LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(LocalPlayer.Character.PrimaryPart.Velocity.x, LocalPlayer.Character.Humanoid.JumpPower, LocalPlayer.Character.PrimaryPart.Velocity.z)
                end
            end)

            local nofdmg = false
            local function UpdateFD()
                if not LocalPlayer.Character then
                    return
                end
        
                local FallDamage = LocalPlayer.Character:FindFirstChild("FallDamage")
                if not FallDamage then
                    return
                end
        
                FallDamage.Disabled = nofdmg 
            end

            movement:Toggle({Text = 'Infinite jump', State = false, Callback = function(s)
                infjump = s
            end})
    
            movement:Toggle({Text = 'No fall damage', State = false, Callback = function(s)
                nofdmg = s
                UpdateFD()
            end})

            movement:Slider({Text = 'Jump Power', Min = 40, Max = 200, Float = 1, Value = 40, Callback = function(v)
                if not LocalPlayer.Character then
                    return
                end
                local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if not Humanoid then return end
                Humanoid.JumpPower = v
            end})
    
            local ReturnByDeath = false
            local AutoRespawn = false
            LocalPlayer.CharacterRemoving:Connect(function(Character)
                if not ReturnByDeath then
                    return
                end
    
                local OldPosition = Character.Head.Position
    
                LocalPlayer.CharacterAdded:Wait()
                LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    
                repeat task.wait() until LocalPlayer.Character.HumanoidRootPart.Anchored
                repeat task.wait()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(OldPosition) + Vector3.new(0, 0.8, 0)
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                until not LocalPlayer.Character.HumanoidRootPart.Anchored
            end)

            local DeathMusic = PlayerGui:WaitForChild("DeathScreen"):WaitForChild("DeathMusic")
            DeathMusic:GetPropertyChangedSignal("Playing"):Connect(function()
                if not AutoRespawn or not DeathMusic.Playing then
                    return
                end
    
                for i=1, 5 do
                    EventRemote:FireServer("Respawn")
    
                    task.wait(0.1)
                end
                DeathMusic.Playing = false
            end)

            LocalPlayer.CharacterAdded:Connect(function(Character)
                Character:WaitForChild("FallDamage")
                UpdateFD()
    
                for Name, Value in pairs(MovementStates) do
                    updateMove(Name, Value)
                end
            end)

            player:Toggle({Text = 'Return by death', State = false, Callback = function(s)
                ReturnByDeath = s
            end})
    
            player:Toggle({Text = 'Auto respawn', State = AutoRespawn, Callback = function(s)
                AutoRespawn = s
            end})
    
            player:Toggle({Text = 'Third person', State = false, Callback = function(s)
                Function:SetThirdPerson(s)
            end})

            local infenergy, infhunger, manipulation  = false, false, 'Regen'
            spawn(function()
                while wait(.1) do
                    if infenergy or infhunger then
                        -- [[ NOT AVAIBLE ON THE OPEN SOURCE VERSION ]] --
                    end
                end
            end)

            local manipulate = player:Category({
                Name = 'Manipulation'
            })

            manipulate:Locked({Text = 'Manipulate hunger'})
            manipulate:Locked({Text = 'Manipulate energy'})
            manipulate:Locked({Text = 'Manipulation method'})

            local items = lib:Tab({
                Name = 'Items',
                Icon = 'rbxassetid://10905010746'
            })

            items:Toggle({Text = 'Instant pickup', State = false, Callback = function(toggle)
                Function:SetInstantPickup(toggle)
            end})

            local cniCF = nil

            game:service('RunService').Stepped:connect(function()
                if cniCF ~= nil then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, cniCF)
                end
            end)

            local banAura = false
            local aura = false

            spawn(function()
                while wait() do
                    for a,v in next, EatableInstances do
                        if aura and not banAura then
                            if v.PrimaryPart then
                                if (v.PrimaryPart.CFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 7 then
                                    Remote:Store(v) 
                                end
                            end
                        end
                    end
                end
            end)
            local autouse = false

            items:Toggle({Text = 'Auto consume items', State = false, Callback = function(s)
                autouse = s
                if s then
                    spawn(function()
                        while wait(1) do
                            if not autouse then
                                break
                            end
                            Function:RunInventory()
                        end
                    end)
                end
            end})
            items:Button({Text = 'Drop all items', Callback = function()
                for _, Tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    Remote:DropAllItems(Tool.Name)
                end
            end})

            local annoyer = items:Category({
                Name = 'Annoyer'
            })
            local annoyTarget = nil
            local annoy = false

            annoyer:Textbox({Text = "Target's name", Clear = false, Placeholder = 'player name', Callback = function(String)
                annoyTarget = Players:FindFirstChild(String) or nil
                print(annoyTarget)
    
            end, fillFunction = function()
                local Table = {}
                for Index, Player in pairs(Players:GetPlayers()) do
                    table.insert(Table, Player.Name)
                end
                return Table
            end})
            annoyer:Toggle({Text = 'Annoy target', State = annoy, Callback = function(s)
                annoy = s
                task.spawn(function()
                    if
                        not annoyTarget
                        or not annoyTarget.Character
                        or not annoyTarget.Character:FindFirstChild("HumanoidRootPart")
                    then
                        return
                    end
    
                    local TargetPart = annoyTarget.Character.HumanoidRootPart
    
                    while annoy do
                        for _, Prop in pairs(ModelInstances) do
                            if
                                not annoy
                                or not TargetPart
                                or not TargetPart.Parent
                            then
                                break
                            end
    
                            Function:TeleportObject(Prop,  TargetPart)
                        end
    
                        task.wait(0.5)
                    end
                end)
            end})

            local nuker = items:Category({
                Name = 'Object nuker'
            })
            local removeNearby = false
            local maxDistance = 50
            local nukerHighlight = instance('Highlight', {
                FillColor = rgb(255, 255, 255),
                FillTransparency = 0.3,
                Enabled = true,
                Name = 'cap_Target_Highlight'
            })

            nuker:Locked({Text = 'Nuke nearby objects'})
            nuker:Locked({Text = 'Max nuke range'})

            local collect = items:Category({
                Name = 'Collect'
            })
            local TargetItem = "All"
            local IgnoreNearby = false
            local CustomNames = EatableNames
            table.insert(CustomNames, "All")
            collect:Locked({Text = 'Collect aura'})
            collect:Locked({Text = 'Collect specific item'})
            collect:Locked({Text = 'Ignore nearby items'})
            collect:Locked({Text = 'Collect nearby items'})

            local prop = items:Category({
                Name = 'Object'
            })

            local ItemSelected = ""
            local Blacklisted = {}
            local EnableBlacklist = true

            prop:Textbox({Placeholder = "Object name here", Text = "Object name", Clear = false, Callback = function(String)
                ItemSelected = String
            end})

            prop:Button({Text = 'Bring object', Callback = function()
                if banAura then return end
                banAura = true
    
                for _, Prop in pairs(ModelInstances) do
                    if (Prop.Name:lower():find(ItemSelected:lower()) and (not EnableBlacklist or not Blacklisted[Prop])) then
                        Function:TeleportObject(Prop,  workspace.CurrentCamera.Focus * CFrame.new(0, 0, -7))
                        
                        Blacklisted[Prop] = Prop
    
                        break
                    end
                end
    
                banAura = false
            end})
            prop:Toggle({Text = 'Ignore already bringed object', State = EnableBlacklist, Callback = function(s)
                EnableBlacklist = s
            end})

            local lighting = lib:Tab({
                Name = 'Lighting',
                Icon = 'rbxassetid://10948271461'
            })

            lighting:Toggle({Text = 'No fog', Callback = function(s)
                if s then
                    Lighting.FogEnd = 9e9
                    Lighting.FogStart = 9e9
                    local Atmosphere = Lighting:FindFirstAncestorWhichIsA("Atmosphere")
                    if not Atmosphere then
                        return
                    end
    
                    Atmosphere.Density = 0
                else
                    Lighting.FogEnd = DefaultFogEnd
                    Lighting.FogStart = DefaultFogStart
                    local Atmosphere = Lighting:FindFirstAncestorWhichIsA("Atmosphere")
                    if not Atmosphere or Atmosphere.Density > 0 then
                        return
                    end
    
                    Atmosphere.Density = Densitys[Atmosphere.Name] or 0.6
                end
            end})

            lighting:Toggle({Text = 'No future lighting', Callback = function(s)
                sethiddenproperty(game.Lighting, 'Technology', s and 'ShadowMap' or 'Future')
            end})

            local game1 = lib:Tab({
                Name = 'Game',
                Icon = 'rbxassetid://10905009435'
            })

            local clock = game1:Textlabel({Text = 'Time until next cycle: <font color="rgb(255,255,150)"><b>0</b></font>'})

            TimeLeft.Changed:Connect(function()
                local time = Function:GetTimeLeft()
    
                if string.len(time[2]) == 1 then
                    time[2] = '0' .. time[2]
                end
    
                pcall(function()
                    clock:SetText(('Time until next cycle: <font color="rgb(255,255,150)"><b>%s</b></font>:<font color="rgb(255,255,150)"><b>%s</b></font>'):format(
                        time[1],
                        time[2]
                    ))
                end)
            end)

            local highlights = {}
            local eESP = false
            spawn(function()
                while wait(1) do
                    for a,v in next, workspace.GameObjects.Physical.Employees:GetChildren() do
                        if v:FindFirstChild('HumanoidRootPart') then
                            if not v:FindFirstChild('cap_Highlight') then
                                local a = instance('Highlight', {
                                    FillColor = rgb(255, 0, 0),
                                    FillTransparency = 0.3,
                                    Enabled = eESP,
                                    Parent = v,
                                    Name = 'cap_Highlight'
                                })
                                table.insert(highlights, a)
                            end
                        else
                            if v:FindFirstChild('cap_Highlight') then
                                v:FindFirstChild('cap_Highlight'):Destroy()
                            end
                        end
                    end
                end
            end)

            game1:Toggle({Text = 'Employee ESP', State = false, Callback = function(s)
                eESP = s
                for a,v in next, highlights do
                    v.Enabled = s
                end
            end})
    
            local ShoveAura = false
            game1:Locked({Text = 'Shove aura'})
        end},
        {{5890606049}, function() --iron man battlegrounds
            local main = lib:Tab({
                Name = 'IMBG'
            })

            main:Textlabel({Text = '<font color="rgb(150,150,150) size=20"><i>Iron Man Battlegrounds\nhas not been added yet.</i></font>'})
        end}
    }


    for a,v in next, GameData do
        if table.find(v[1], game.PlaceId) then
            v[2]()
        end
    end


    --#endregion


    --#region Connections
    UserInputService.InputEnded:Connect(OnInputEnded)

    if ENABLE_PLAYER_DATA then
        Connection:Create("PlayerAdded", Players.PlayerAdded, PlayerMeta.OnPlayerAdded)
        Connection:Create("PlayerRemoving", Players.PlayerRemoving, PlayerMeta.OnPlayerRemoving)

        for Index, Player in pairs(Players:GetPlayers()) do
            PlayerMeta.OnPlayerAdded(Player)
        end
    end
    --#endregion


    --#region Universal stuff
    local setting = lib:Tab({
        Name = 'Settings',
        Icon = 'rbxassetid://10879117556'
    })

    setting:Textbox({
        Text = 'Send us a message',
        Placeholder = 'message',
        Callback = function(s)
            syn.request({
                Url = 'https://canary.discord.com/api/webhooks/1067179676004515880/TswQYp36sUXJePs_9VWxj-yeKRo5ZgCJBmqNzKZF2fy_Ukxx21KpYol7ZkuVjymYl8wR', -- hi, should work so have fun :) - doggo
                Method = 'POST',
                Headers = {['content-type'] = 'application/json'},
                Body = HttpService:JSONEncode({content = ("[%s]: %s"):format(LocalName, s)})
            })

            local a;a = notify({
                Title = 'Cappuccino',
                Text = ('Message sent successfully. Content: %s'):format(s),
                Duration = 5,
                Image = '11335634088'
            })
        end
    })

    local rev = setting:Category({
        Name = 'Review'
    })

    local revData = {
        Stars = 5,
        Comment = 'None'
    }

    rev:Slider({Text = 'Rate cappuccino (0 - 10)', Min = 0, Max = 10, Value = 5, Float = 0.5, Callback = function(s)
        revData.Stars = s
    end})

    rev:Textbox({Text = 'Comment (optional)', Placeholder = 'None', Callback = function(s)
        revData.Comment = s
    end})

    rev:Button({Text = 'Send review', Callback = function()
        syn.request({
            Url = 'https://canary.discord.com/api/webhooks/1072907657888940166/9_KymSqkyQkPAri1AtEVOecZoIwbLiEiBfQQN9SjXkshkhUv6rJ-T-ENhHgQap3k5h3R', -- also hi :) - doggo
            Method = 'POST',
            Headers = {['content-type'] = 'application/json'},
            Body = game:GetService('HttpService'):JSONEncode({
                content = ('Rating: `%s/10`\nComment: `%s`\nUser: `%s`'):format(revData.Stars, revData.Comment, lgVarsTbl['DiscordUsername'])
            })
        })
    end})

    setting:Toggle({
        Text = 'Show UI close notification',
        State = UiConfig.CloseNotification,
        Callback = function(s)
            UiConfig.CloseNotification = s
            CapSaveUiConfig()
        end
    })

    setting:Toggle({
        Text = 'Classic close',
        State = UiConfig.ClassicClose,
        Callback = function(s)
            UiConfig.ClassicClose = s
            CapSaveUiConfig()
        end
    })

    local cursor = Drawing.new('Circle')
    cursor.Radius = 5
    cursor.Filled = false
    cursor.NumSides = 12
    cursor.Thickness = 2
    cursor.Color = Color3.fromRGB(97, 113, 255)
    cursor.Visible = UiConfig.ShowMouseCursor

    local mouse = Players.LocalPlayer:GetMouse()

    RunService.Stepped:Connect(function()
        cursor.Position = Vector2.new(mouse.X, mouse.Y + 37)
    end)

    setting:Toggle({
        Text = 'Show mouse cursor',
        State = UiConfig.ShowMouseCursor,
        Callback = function(s)
            UiConfig.ShowMouseCursor = s
            cursor.Visible = s
            CapSaveUiConfig()
        end
    })

    setting:Keybind({
        Text = 'Show UI keybind',
        Key = (UiConfig.ShowUiBind ~= 'Unbinded' and UiConfig.ShowUiBind or nil),
        Callback = function()

        end,
        newCallback = function(s)
            UiConfig.ShowUiBind = s
            CapSaveUiConfig()
        end
    })
    --#endregion

    --#region Welcome
    notify({
        Title = 'Cappuccino',
        Text = 'Welcome back, ' .. lgVarsTbl['DiscordUsername'],
        Image = '11335634088',
        Duration = 5,
    })
    --#endregion

    --#region ESP
    if not isfolder('cappuccino-v7/universals') then
        makefolder('cappuccino-v7/universals')
    end

    local gdCopy = {
        esp = {
            useCustomPattern = false,
            customPattern = '$user | $hp | $dist',
            rendering = true,
            enabled = false,
            rr = 60,
            spacing = 14,
            color = {1, 1, 1},
            box = {
                enabled = false,
                filled = false,
                thickness = 3,
                anchorPoint = {'UpperTorso', 'HumanoidRootPart'},
                transparency = 0.5,
                bar = {
                    enabled = false,
                    transparency = 0.5,
                    thickness = 4
                }
            },
            showDead = false,
            maxDistance = 500,
            infDistance = false,
            name = { 
                enabled = false,
                method = 'username', --displayname
                transparency = 1
            },
            health = {
                enabled = false,
                showMax = true,
                method = 'max',
                transparency = 1
            },
            distance = {
                enabled = false,
                unit = 'studs',
                transparency = 1
            },
            tracer = {
                enabled = false,
                from = 'bottom',
                thickness = 1,
                transparency = 0.5
            },
            team = {
                teamColor = false,
                teamCheck = false,
            },
            raycast = {
                enabled = false,
            }
        },
        glow = {
            enabled = false,
            fill = {
                color = {1, 0.5, 0.5},
                transparency = 0.5
            },
            outline = {
                color = {1, 0.5, 0.5},
                transparency = 0.1
            },
            showDead = false,
            alwaysOnTop = true,
            hpColor = false,
            team = {
                teamColor = false,
                teamCheck = false
            }
        },
        aimbot = {
            Enabled = false,
            EnableKeybind = "E",
            AlwaysEnabled = false,
            MouseMove = false,

            ShowFov = false,
            FovSize = 120,
            FovNumSides = 12,
            FovColor = {1, 1, 1},

            Hitbox = "Head",
            MaxDistance = 1000,

            TeamCheck = false,
            VisibleCheck = false,
            ForceFieldCheck = true,

            Pixel = 1,
            RefreshRate = 0,
        },
        expander = {
            enabled = false,
            color = {1, 1, 1},
            teamCheck = false,
            size = 2,
            useCustomSize = false,
            customSize = {2, 2, 2},
            material = 'ForceField',
            transparency = 0.5
        },
        crosshair = {
            enabled = false,
            width = 8,
            height = 8,
            thickness = 2,
            gap = 6,
            position = 'center',
            tShape = false,
            dot = {
                size = 2,
                enabled = false,
                color = {1, 1, 1},
                outline = {
                    enabled = false,
                    color = {0, 0, 0}
                },
                filled = false
            },
            filled = true,
            border = false,
            fillColor = {1, 1, 1},
            borderColor = {0, 0, 0},
            outlineThickness = 1,
        },
        version = '1.6'
    }

    local json = {
        encode = function(body)
            return HttpService:JSONEncode(body)
        end,
        decode = function(body)
            return HttpService:JSONDecode(body)
        end
    }
    
    local FileFormat = ('universals/%s.json'):format(game.PlaceId)
    local mouse = Players.LocalPlayer:GetMouse()

    if not CapIsFile(FileFormat) then
        CapWrite(FileFormat, json.encode(gdCopy))
    else
        if json.decode(CapRead(FileFormat)).version ~= '1.6' then
            CapWrite(FileFormat, json.encode(gdCopy))
        end
    end

    _G.gd = json.decode(CapRead(FileFormat))

    local universals = lib:Tab({
        Name = 'Universal',
        Icon = 'rbxassetid://10874946046'
    })

    local esp = universals:Category({
        Name = 'ESP'
    })

    local glow = universals:Category({
        Name = 'Glow'
    })

    local aimbot = universals:Category({
        Name = 'Aimbot'
    })

    local expander = universals:Category({
        Name = 'Hitbox expander'
    })

    local crosshair = universals:Category({
        Name = 'Crosshair'
    })

    local movement = universals:Category({
        Name = 'Movement'
    })

    movement:Textlabel({Text = 'Movement coming soon.'})

    spawn(function()
        while wait(1) do
            CapWrite(FileFormat, json.encode(_G.gd))
        end
    end)

    LPH_NO_VIRTUALIZE(function()
        local function draw(obj, props)
            local new = Drawing.new(obj)
            for a,v in next, props or {} do
                new[a] = v
            end
            return new
        end
        
        
        
        local function createCrosshair(startData)
            local data = startData
        
            local cParts = {
                up = draw('Square', {Thickness = 1.2}),
                left = draw('Square', {Thickness = 1.2}),
                right = draw('Square', {Thickness = 1.2}),
                down = draw('Square', {Thickness = 1.2}),
                dot = draw('Circle', {Thickness = 1.2, NumSides = 36}),
        
                upOut = draw('Square', {Thickness = 1.2}),
                leftOut = draw('Square', {Thickness = 1.2}),
                rightOut = draw('Square', {Thickness = 1.2}),
                downOut = draw('Square', {Thickness = 1.2}),
                dotOut = draw('Circle', {Thickness= 1.2, NumSides = 36})
            }
        
            local function getAnchorPoint()
                if data.position == 'center' then
                    return Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
                elseif data.position == 'cursor' then
                    local mouse = game:GetService('Players').LocalPlayer:GetMouse()
                    return Vector2.new(mouse.X, mouse.Y + 37)
                end
            end
        
            game:GetService('RunService').Stepped:Connect(function()
                local ap = getAnchorPoint()
                
                local fc = Color3.new(data.fillColor[1], data.fillColor[2], data.fillColor[3])
                local dc = Color3.new(data.dot.color[1], data.dot.color[2], data.dot.color[3])
                local bc = Color3.new(data.borderColor[1], data.borderColor[2], data.borderColor[3])
                local dbc = Color3.new(data.dot.outline.color[1], data.dot.outline.color[2], data.dot.outline.color[3])
        
                cParts.up.Position = Vector2.new(ap.X - (data.thickness / 2), ap.Y - (data.height + data.gap))
                cParts.up.Size = Vector2.new(data.thickness, data.height)
                cParts.up.Visible = (not data.tShape and data.enabled or false)
                cParts.up.Filled = data.filled
                cParts.up.Color = fc
        
                cParts.upOut.Position = cParts.up.Position - Vector2.new(data.outlineThickness, data.outlineThickness)
                cParts.upOut.Size = cParts.up.Size + Vector2.new(data.outlineThickness, data.outlineThickness)
                cParts.upOut.Visible = (cParts.up.Visible and data.border or false)
                cParts.upOut.Color = bc
        
                cParts.left.Position = Vector2.new(ap.X - (data.width + data.gap), ap.Y - (data.thickness / 2))
                cParts.left.Size = Vector2.new(data.width, data.thickness)
                cParts.left.Visible = data.enabled
                cParts.left.Filled = data.filled
                cParts.left.Color = fc
        
                cParts.leftOut.Position = cParts.left.Position - Vector2.new(data.outlineThickness, data.outlineThickness)
                cParts.leftOut.Size = cParts.left.Size + Vector2.new(data.outlineThickness, data.outlineThickness)
                cParts.leftOut.Visible = data.border
                cParts.leftOut.Color = bc
        
                cParts.right.Position = Vector2.new(ap.X + data.gap, ap.Y - (data.thickness / 2))
                cParts.right.Size = Vector2.new(data.width, data.thickness)
                cParts.right.Visible = data.enabled
                cParts.right.Filled = data.filled
                cParts.right.Color = fc
        
                cParts.rightOut.Position = cParts.right.Position - Vector2.new(data.outlineThickness, data.outlineThickness)
                cParts.rightOut.Size = cParts.right.Size + Vector2.new(data.outlineThickness, data.outlineThickness)
                cParts.rightOut.Visible = data.border
                cParts.rightOut.Color = bc
        
                cParts.down.Position = Vector2.new(ap.X - (data.thickness / 2), ap.Y + data.gap)
                cParts.down.Size = Vector2.new(data.thickness, data.height)
                cParts.down.Visible = data.enabled
                cParts.down.Filled = data.filled
                cParts.down.Color = fc
        
                cParts.downOut.Position = cParts.down.Position - Vector2.new(data.outlineThickness, data.outlineThickness)
                cParts.downOut.Size = cParts.down.Size + Vector2.new(data.outlineThickness, data.outlineThickness)
                cParts.downOut.Visible = data.border
                cParts.downOut.Color = bc
        
                cParts.dot.Position = Vector2.new(ap.X, ap.Y)
                cParts.dot.Radius = data.dot.size
                cParts.dot.Visible = data.dot.enabled
                cParts.dot.Filled = data.dot.filled
                cParts.dot.Color = dc
        
                cParts.dotOut.Position = cParts.dot.Position
                cParts.dotOut.Radius = cParts.dot.Radius + data.outlineThickness
                cParts.dotOut.Visible = data.dot.outline.enabled
                cParts.dotOut.Color = dbc
            end)
        
            local d = {}
        
            function d:Update(newData)
                data = newData
            end
        
            return d
        end
        
        
        
        
        local crosshairInstance = createCrosshair(_G.gd.crosshair)

        spawn(function()
            while wait(0.1) do
                crosshairInstance:Update(_G.gd.crosshair)
            end
        end)

        crosshair:Toggle({Text = 'Enabled', State = _G.gd.crosshair.enabled, Callback = function(s)
            _G.gd.crosshair.enabled = s
        end})

        crosshair:Toggle({Text = 'T shape', State = _G.gd.crosshair.tShape, Callback = function(s)
            _G.gd.crosshair.tShape = s
        end})

        crosshair:Colorpicker({Text = 'Color', Default = Color3.new(_G.gd.crosshair.fillColor[1], _G.gd.crosshair.fillColor[2], _G.gd.crosshair.fillColor[3]), Callback = function(s)
            _G.gd.crosshair.fillColor = {s.R, s.G, s.B}
        end})

        crosshair:Slider({Text = 'Width', Min = 2, Max = 50, Float = 1, Value = _G.gd.crosshair.width, Callback = function(s)
            _G.gd.crosshair.width = s
        end})

        crosshair:Slider({Text = 'Height', Min = 2, Max = 50, Float = 1, Value = _G.gd.crosshair.height, Callback = function(s)
            _G.gd.crosshair.height = s
        end})

        crosshair:Slider({Text = 'Thickness', Min = 1, Max = 10, Float = 1, Value = _G.gd.crosshair.thickness, Callback = function(s)
            _G.gd.crosshair.thickness = s
        end})

        crosshair:Slider({Text = 'Gap', Min = 0, Max = 24, Float = 1, Value = _G.gd.crosshair.gap, Callback = function(s)
            _G.gd.crosshair.gap = s
        end})

        crosshair:Dropdown({Text = 'Position', Options = {'center', 'cursor'}, Default = _G.gd.crosshair.position, Callback = function(s)
            _G.gd.crosshair.position = s
        end})


        crosshair:Textlabel({Text = '<i>Dot</i>'})

        crosshair:Toggle({Text = 'Enabled', State = _G.gd.crosshair.dot.enabled, Callback = function(s)
            _G.gd.crosshair.dot.enabled = s
        end})

        crosshair:Slider({Text = 'Size', Min = 1, Max = 20, Float = 1, Value = _G.gd.crosshair.dot.size, Callback = function(s)
            _G.gd.crosshair.dot.size = s
        end})

        crosshair:Colorpicker({Text = 'Color', Default = Color3.new(_G.gd.crosshair.dot.color[1], _G.gd.crosshair.dot.color[2], _G.gd.crosshair.dot.color[3]), Callback = function(s)
            _G.gd.crosshair.dot.color = {s.R, s.G, s.B}
        end})

        crosshair:Toggle({Text = 'Filled', State = _G.gd.crosshair.dot.filled, Callback = function(s)
            _G.gd.crosshair.dot.filled = s
        end})

        crosshair:Textlabel({Text = '<i>Dot border</i>'})

        crosshair:Toggle({Text = 'Enabled', State = _G.gd.crosshair.dot.outline.enabled, Callback = function(s)
            _G.gd.crosshair.dot.outline.enabled = s
        end})

        crosshair:Colorpicker({Text = 'Color', Default = Color3.new(_G.gd.crosshair.dot.outline.color[1], _G.gd.crosshair.dot.outline.color[2], _G.gd.crosshair.dot.outline.color[3]), Callback = function(s)
            _G.gd.crosshair.dot.outline.color = {s.R, s.G, s.B}
        end})

        crosshair:Textlabel({Text = '<i>Border</i>'})

        crosshair:Toggle({Text = 'Enabled', State = _G.gd.crosshair.border, Callback = function(s)
            _G.gd.crosshair.border = s
        end})

        crosshair:Slider({Text = 'Thickness', Min = 1, Max = 6, Float = 1, Default = _G.gd.crosshair.outlineThickness, Callback = function(s)
            _G.gd.crosshair.outlineThickness = s
        end})

        crosshair:Colorpicker({Text = 'Color', Default = Color3.new(_G.gd.crosshair.borderColor[1], _G.gd.crosshair.borderColor[2], _G.gd.crosshair.borderColor[3]), Callback = function(s)
            _G.gd.crosshair.borderColor = {s.R, s.G, s.B}
        end})
    end)()

    LPH_NO_VIRTUALIZE(function()
        print('aimbot initianting')

        -- [[ NOT AVAIBLE ON THE OPEN SOURCE VERSION ]] --
    end)()
    LPH_NO_VIRTUALIZE(function()
        print('esp initianting')
        local camera = workspace.CurrentCamera
    
        local percent, scale, draw, delta, mag, vPort, getSize, raycast
    
        do --FUNCTIONS
            percent = function(a,b)
                return (((a * 100) / b) < 100 and (a * 100) / b or 100)
            end
            
            scale = function(unscaled, minAllowed, maxAllowed, min, max) 
                return (maxAllowed - minAllowed) * (unscaled - min) / (max - min) + minAllowed
            end
            
            draw = function(obj, props)
                local new = Drawing.new(obj)
                for a,v in next, props or {} do
                    new[a] = v
                end
                return new
            end
            
            delta = function(func, rr)
                rr = (1000 / rr) * 0.001
                local acc = 0
                game:GetService("RunService").Heartbeat:Connect(function(Delta)
                    acc = acc + Delta
                    if acc >= rr then
                        acc = acc - rr
                        func()
                    end
                end)
                return {
                    r = function(int)
                        rr = (1000/int) * 0.001
                    end
                }
            end
            
            mag = function(n1, n2, v)
                if not v then
                    if n1 > n2 then
                        return math.abs(n1) - math.abs(n2)
                    else
                        return math.abs(n2) - math.abs(n1)
                    end
                else
                    return (n1 - n2).magnitude
                end
            end
            
            vPort = function(pos)
                if typeof(pos) == 'CFrame' then
                    pos = pos.Position
                end
            
                local a,a2 = camera:WorldToViewportPoint(pos)
                if a2 then
                    return Vector2.new(a.X, a.Y)
                end
                return false
            end
            
            getSize = function(body)
                local pos = {}
            
                for a,v in next, body:GetChildren() do
                    if v:IsA('Part') or v:IsA('MeshPart') then
                        table.insert(pos, v.CFrame.Position)
                    elseif v:IsA('Accessory') then
                        table.insert(pos, v.Handle.CFrame.Position)
                    end
                end
            
                local X,Y = 0,0
                local lX,lY = math.huge,math.huge
            
                local pPoints = {}
            
                for a,v in next, pos do
                    local vPos = vPort(v)
                    if vPos then
                        table.insert(pPoints, vPos)
                    end
                end
            
                for a,v in next, pPoints do
                    if v.X > X then X = v.X end if v.X < lX then lX = v.X end  if v.Y > Y then Y = v.Y end if v.Y < lY then lY = v.Y end
                end
            
                return {mag(X, lX), mag(Y, lY)}
            end
    
            raycast = function(a, b)
                return true
            end
        end
        
        local queue = {}
        
        local upd;upd = delta(function()
            for a,v in next, queue do
                v.func()
            end
            upd.r(_G.gd.esp.rr)
        end, _G.gd.esp.rr)
        
        local function addEsp(v)
            local n = v.Name
            print('added',n)
        
            local esp = {
                box = draw('Square', {
                    Visible = _G.gd.esp.box.enabled,
                    Color = Color3.new(_G.gd.esp.color[1], _G.gd.esp.color[2], _G.gd.esp.color[3]),
                    Thickness = _G.gd.esp.box.thickness
                }),
                tracer = draw('Line', {
                    Thickness = 3,
                    Color = Color3.new(_G.gd.esp.color[1], _G.gd.esp.color[2], _G.gd.esp.color[3]),
                    Visible = false
                }),
                barBack = draw('Square', {
                    Color = Color3.fromRGB(120, 255, 120),
                    Thickness = 1.5
                }),
                barFront = draw('Square', {
                    Color = Color3.fromRGB(120, 255, 120),
                    Thickness = 1.5,
                    Filled = true
                }),
                name = draw('Text', {
                    Text = '',
                    Visible = _G.gd.esp.name.enabled,
                    Size = 16,
                    Outline = true
                }),
                health = draw('Text', {
                    Text = '',
                    Visible = _G.gd.esp.health.enabled,
                    Size = 16,
                    Outline = true
                }),
                distance = draw('Text', {
                    Text = '',
                    Visible = _G.gd.esp.distance.enabled,
                    Size = 16,
                    Outline = true
                }),
                all = draw('Text', {
                    Text = '',
                    Visible = _G.gd.esp.useCustomPattern,
                    Size = 16,
                    Outline = true
                })
            }
        
            local function off()
                for a,v in next, esp do
                    v.Visible = false
                end
            end
        
            local function queueRefresh()
                if not _G.gd.esp.rendering then
                    return
                elseif not _G.gd.esp.enabled then
                    off()
                    return
                end
        
                if not game:service('Players'):FindFirstChild(n) then
                    for a,v in next, esp do
                        v:Remove()
                    end
                    for a,v in next, queue do
                        if v.id == n then
                            table.remove(queue, a)
                        end 
                    end
                end
        
        
                local c = v.Character

                if not c then
                    return off()
                end
                
                if not c:FindFirstChild('HumanoidRootPart') then
                    return off()
                end

                local player = Players.LocalPlayer
        
                if c and c:FindFirstChild('HumanoidRootPart') then
    
                    local d,a = pcall(function()
                    
                        if 
                        
                        _G.gd.esp.enabled and
                        vPort(c.HumanoidRootPart.CFrame.Position) and 
                        c:FindFirstChildWhichIsA('Humanoid') and
                        _G.gd.esp.team.teamCheck and tostring(player.Team) ~= tostring(v.Team) and true or not _G.gd.esp.team.teamCheck and true or false and
                        raycast(camera.CFrame.Position, c.HumanoidRootPart.CFrame.Position)
                        
                        then

                            local magnitude = (player.Character.HumanoidRootPart.Position - c.HumanoidRootPart.Position).Magnitude

                            if magnitude > (not _G.gd.esp.infDistance and _G.gd.esp.maxDistance or math.huge) then
                                return off()
                            end

                            if not _G.gd.esp.showDead then
                                if c.Humanoid.Health <= 0 then
                                    return off()
                                end
                            end
            
                            --locating anchor point 
                            local p, a
                            if _G.gd.esp.box.anchorPoint == 'UpperTorso' then
                                a = pcall(function()
                                    p = vPort(c.UpperTorso.CFrame.Position)
                                end)
                            else
                                a = pcall(function()
                                    p = vPort(c[_G.gd.esp.box.anchorPoint[2]].CFrame.Position)
                                end)
                            end
            
                            if not a then
                                pcall(function()
                                    p = vPort(c.HumanoidRootPart.CFrame.Position)
                                end)
                            end
            
                            local p2 = {
                                ['000'] = function()
                                    return {
                                        Vector2.new(0, 0),
                                        Vector2.new(0, 0),
                                        Vector2.new(0, 0)
                                    }
                                end,
                                ['100'] = function(a, b)
                                    return {
                                        Vector2.new(a.X - b[1].TextBounds.X / 2, a.Y - _G.gd.esp.spacing),
                                        Vector2.new(0, 0),
                                        Vector2.new(0, 0)
                                    }
                                end,
                                ['110'] = function(a, b)
                                    return {
                                        Vector2.new(a.X - b[1].TextBounds.X / 2, a.Y - _G.gd.esp.spacing * 2),
                                        Vector2.new(a.X - b[2].TextBounds.X / 2, a.Y - _G.gd.esp.spacing),
                                        Vector2.new(0, 0)
                                    }
                                end,
                                ['111'] = function(a, b)
                                    return {
                                        Vector2.new(a.X - b[1].TextBounds.X / 2, a.Y - _G.gd.esp.spacing * 2),
                                        Vector2.new(a.X - b[2].TextBounds.X / 2, a.Y - _G.gd.esp.spacing),
                                        Vector2.new(a.X - b[3].TextBounds.X / 2, a.Y)
                                    }
                                end,
                                ['101'] = function(a, b)
                                    return {
                                        Vector2.new(a.X - b[1].TextBounds.X / 2, a.Y - _G.gd.esp.spacing * 2),
                                        Vector2.new(0, 0),
                                        Vector2.new(a.X - b[3].TextBounds.X / 2, a.Y - _G.gd.esp.spacing)
                                    }
                                end,
                                ['011'] = function(a, b)
                                    return {
                                        Vector2.new(0, 0),
                                        Vector2.new(a.X - b[2].TextBounds.X / 2, a.Y - _G.gd.esp.spacing * 2),
                                        Vector2.new(a.X - b[3].TextBounds.X / 2, a.Y - _G.gd.esp.spacing)
                                    }
                                end,
                                ['010'] = function(a, b)
                                    return {
                                        Vector2.new(0, 0),
                                        Vector2.new(a.X - b[2].TextBounds.X / 2, a.Y - _G.gd.esp.spacing),
                                        Vector2.new(0, 0)
                                    }
                                end,
                                ['001'] = function(a, b)
                                    return {
                                        Vector2.new(0, 0),
                                        Vector2.new(0, 0),
                                        Vector2.new(a.X - b[3].TextBounds.X / 2, a.Y - _G.gd.esp.spacing)
                                    }
                                end
                            }
    
                            local function grabColor()
                                local color
                                if _G.gd.esp.team.teamColor then
                                    color = typeof(v.TeamColor) == 'BrickColor' and v.TeamColor.Color or v.TeamColor
                                else
                                    color = Color3.new(_G.gd.esp.color[1], _G.gd.esp.color[2], _G.gd.esp.color[3])
                                end
                                return color
                            end
            
                            local p3 = table.concat({(_G.gd.esp.name.enabled and 1 or 0), (_G.gd.esp.health.enabled and 1 or 0), (_G.gd.esp.distance.enabled and 1 or 0)}) 
                            local p4 = p2[p3](p, {esp.name, esp.health, esp.distance})

                            if not _G.gd.esp.useCustomPattern then
                                esp.all.Visible = false
                                esp.name.Text = (_G.gd.esp.name.method == 'username' and v.Name or v.DisplayName)

                                esp.health.Text = 
                                _G.gd.esp.health.method ~= 'percent' and
                                math.floor(c.Humanoid.Health) .. (_G.gd.esp.health.showMax and (' / %s'):format(math.floor(c.Humanoid.MaxHealth)) or '')
                                or math.floor(percent(c.Humanoid.Health, c.Humanoid.MaxHealth)) .. '%'

                                local dist = mag(player.Character.HumanoidRootPart.Position, c.HumanoidRootPart.Position, true)
            
                                esp.distance.Text = 
                                _G.gd.esp.distance.unit == 'studs' and
                                math.floor(dist) .. ' std' or
                                math.floor(dist / (25 / 7)) .. ' m'

                                if _G.gd.esp.name.enabled then
                                    esp.name.Visible = true
                                    esp.name.Position = p4[1]
                                    esp.name.Color = grabColor()
                                    esp.name.Transparency = _G.gd.esp.name.transparency
                                else
                                    esp.name.Visible = false
                                end
                
                                if _G.gd.esp.health.enabled then
                                    esp.health.Visible = true
                                    esp.health.Position = p4[2]
                                    esp.health.Color = grabColor()
                                    
                                    esp.health.Transparency = _G.gd.esp.health.transparency
                                else
                                    esp.health.Visible = false
                                end
                
                                if _G.gd.esp.distance.enabled then
                                    esp.distance.Visible = true
                                    esp.distance.Position = p4[3]
                                    esp.distance.Color = grabColor()
    
                                    esp.distance.Transparency = _G.gd.esp.health.transparency
                                else
                                    esp.distance.Visible = false
                                end
                            else
                                esp.name.Visible = false
                                esp.health.Visible = false
                                esp.distance.Visible = false

                                esp.all.Visible = true
                                esp.all.Position = Vector2.new(p.X - esp.all.TextBounds.X / 2, p.Y - esp.all.TextBounds.Y / 2)
                                esp.all.Color = grabColor()
                                
                                local f = _G.gd.esp.customPattern

                                f = f:gsub('$user', v.Name)
                                f = f:gsub('$dp', v.DisplayName)
                                f = f:gsub('$n', '\n')
                                f = f:gsub('$hp', c.Humanoid.Health)
                                f = f:gsub('$maxhp', c.Humanoid.MaxHealth)
                                f = f:gsub('$dist', round(mag(player.Character.HumanoidRootPart.Position, c.HumanoidRootPart.Position, true), 1))
                                f = f:gsub('$m', round(mag(player.Character.HumanoidRootPart.Position, c.HumanoidRootPart.Position, true) / (25 / 7), 1))

                                esp.all.Text = f
                            end
            
                            if _G.gd.esp.box.enabled then
                                local size = getSize(c)
            
                                esp.box.Size = Vector2.new(size[1], size[2])
                                esp.box.Visible = true
                                esp.box.Thickness = _G.gd.esp.box.thickness
                                esp.box.Filled = _G.gd.esp.box.filled
                                esp.box.Color = grabColor()
                                esp.box.Transparency = _G.gd.esp.box.transparency
            
                                esp.box.Position = Vector2.new(p.X - (size[1] / 2), p.Y - (size[2] / 2))
            
                                if _G.gd.esp.box.bar.enabled then
                                    esp.barBack.Visible = true
                                    esp.barFront.Visible = true
                                    esp.barBack.Transparency = _G.gd.esp.box.bar.transparency
                                    esp.barFront.Transparency = _G.gd.esp.box.bar.transparency
                                    esp.barBack.Size = Vector2.new(esp.box.Thickness + _G.gd.esp.box.bar.thickness, esp.box.Size.Y)
                                    esp.barBack.Position = Vector2.new(esp.box.Position.X - (esp.box.Thickness + (_G.gd.esp.box.bar.thickness + 4)), esp.box.Position.Y)
                                    local s = esp.box.Size.Y
                                    s = scale(c.Humanoid.Health, 0, 1, 0, c.Humanoid.MaxHealth)
                                    s = scale(s, 0, esp.box.Size.Y, 0, 1)
                                    esp.barFront.Size = Vector2.new(esp.box.Thickness + _G.gd.esp.box.bar.thickness, s)
                                    esp.barFront.Position = Vector2.new(esp.barBack.Position.X, esp.barBack.Position.Y + esp.barBack.Size.Y - esp.barFront.Size.Y)
                                else
                                    esp.barBack.Visible = false
                                    esp.barFront.Visible = false
                                end
                            else
                                esp.box.Visible = false
                            end
        
            
                            if _G.gd.esp.tracer.enabled then
                                esp.tracer.Visible = true
                                esp.tracer.Color = grabColor()
                                esp.tracer.Thickness = _G.gd.esp.tracer.thickness
                                
                                esp.tracer.From = 
                                _G.gd.esp.tracer.from == 'bottom' and
                                Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y - 100)
                                or _G.gd.esp.tracer.from == 'mouse' and
                                Vector2.new(mouse.X, mouse.Y)
                                or _G.gd.esp.tracer.from == 'top' and
                                Vector2.new(camera.ViewportSize.X / 2, 100)
            
            
                                esp.tracer.To = 
                                not _G.gd.esp.box.enabled and Vector2.new(p.X, p.Y - 10) or
                                Vector2.new(p.X, esp.box.Position.Y + esp.box.Size.Y)
            
                                esp.tracer.Transparency = _G.gd.esp.tracer.transparency
                            else
                                esp.tracer.Visible = false
                            end
                        else
                            off()
                        end
    
                    end)
        
                    if not d then
                        off()
                    end
                end
            end
        
            table.insert(queue, {func = queueRefresh, id = n})
        end
        
        --addEsp(game.Players.xBlumz)
        
        for a,v in next, Players:GetPlayers() do
            if v ~= Players.LocalPlayer then
                addEsp(v)
            end
        end
        
        Players.PlayerAdded:Connect(function(v)
            addEsp(v)
        end)
    end)()

    --#region Aimbot 
    aimbot:ToggleBind({
        Text = 'Enabled',
        Key = _G.gd.esp.key,
        State = _G.gd.esp.enabled,
        Callback = function(s)
            _G.gd.aimbot.Enabled = s
        end,
    })

    aimbot:Keybind({
        Text = 'Hold keybind',
        Key = _G.gd.aimbot.EnableKeybind,
        Callback = function() end,
        newCallback = function(Key)
            _G.gd.aimbot.EnableKeybind = Key
        end,
    })

    aimbot:Toggle({
        Text = 'Always hold',
        State = _G.gd.aimbot.AlwaysEnabled,
        Callback = function(s)
            _G.gd.aimbot.AlwaysEnabled = s
        end
    })

    aimbot:Toggle({
        Text = 'Enable on mouse move',
        State = _G.gd.aimbot.MouseMove,
        Callback = function(s)
            _G.gd.aimbot.MouseMove = s
        end
    })

    aimbot:Slider({
        Text = 'Pixels',
        Min = 1,
        Max = 50,
        Value = _G.gd.aimbot.Pixel,
        Float = 0.5,
        Callback = function(s)
            _G.gd.aimbot.Pixel = s
        end
    })

    aimbot:Slider({
        Text = 'Refresh rate',
        Min = 0,
        Max = 100,
        Value = _G.gd.aimbot.RefreshRate,
        Float = 1,
        Callback = function(s)
            _G.gd.aimbot.RefreshRate = s
        end
    })

    aimbot:Textlabel({Text = '<b><i>Fov</i></b>'})

    local fovCircle = Drawing.new('Circle')
    local mouse = LocalPlayer:GetMouse()

    fovCircle.NumSides = _G.gd.aimbot.FovNumSides
    fovCircle.Color = Color3.new(_G.gd.aimbot.FovColor[1], _G.gd.aimbot.FovColor[2], _G.gd.aimbot.FovColor[3])
    fovCircle.Radius = _G.gd.aimbot.FovSize
    fovCircle.Visible = _G.gd.aimbot.ShowFov
    fovCircle.Thickness = 1.5

    mouse.Move:Connect(function()
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + 37)
    end)

    aimbot:Toggle({
        Text = 'Show fov',
        State = _G.gd.aimbot.ShowFov,
        Callback = function(s)
            _G.gd.aimbot.ShowFov = s
            fovCircle.Visible = s
        end
    })

    aimbot:Slider({
        Text = 'Fov circle num sides',
        Min = 3,
        Max = 36,
        Float = 1,
        Value = _G.gd.aimbot.FovNumSides,
        Callback = function(v)
            _G.gd.aimbot.FovNumSides = v
            fovCircle.NumSides = v
        end
    })

    aimbot:Colorpicker({
        Text = 'Fov color',
        Color = Color3.new(_G.gd.aimbot.FovColor[1], _G.gd.aimbot.FovColor[2], _G.gd.aimbot.FovColor[3]),
        Callback = function(c)
            _G.gd.aimbot.FovColor = {c.R, c.G, c.B}
            fovCircle.Color = Color3.new(_G.gd.aimbot.FovColor[1], _G.gd.aimbot.FovColor[2], _G.gd.aimbot.FovColor[3])
        end
    })

    aimbot:Slider({
        Text = 'Fov size',
        Min = 0,
        Max = 500,
        Value = _G.gd.aimbot.FovSize,
        Float = 0.5,
        Callback = function(s)
            _G.gd.aimbot.FovSize = s
            fovCircle.Radius = s
        end
    })

    aimbot:Textlabel({Text = '<b><i>Checks</i></b>'})

    aimbot:Dropdown({
        Text = 'Hitbox',
        Options = {
            'Head',
            'Torso',
            'Closest',
        },
        Default = _G.gd.aimbot.Hitbox,
        Callback = function(s)
            _G.gd.aimbot.Hitbox = s
        end
    })

    aimbot:Slider({
        Text = 'Max distance',
        Min = 0,
        Max = 10000,
        Value = _G.gd.aimbot.MaxDistance,
        Float = 1,
        Callback = function(s)
        _G.gd.aimbot.MaxDistance = s
        end
    })

    aimbot:Toggle({
        Text = 'Team check',
        State = _G.gd.aimbot.TeamCheck,
        Callback = function(s)
            _G.gd.aimbot.TeamCheck = s
        end
    })

    aimbot:Toggle({
        Text = 'Visible check',
        State = _G.gd.aimbot.VisibleCheck,
        Callback = function(s)
            _G.gd.aimbot.VisibleCheck = s
        end
    })

    aimbot:Toggle({
        Text = 'ForceField check',
        State = _G.gd.aimbot.ForceFieldCheck,
        Callback = function(s)
            _G.gd.aimbot.ForceFieldCheck = s
        end
    })

    
    --#endregion

    esp:ToggleBind({Text = 'Enabled', Key = _G.gd.esp.key, State = _G.gd.esp.enabled, Callback = function(s)
        _G.gd.esp.enabled = s
    end, NewCallback = function(s)
        if s ~= 'Unbinded' then
            _G.gd.esp.key = s
        else
            _G.gd.esp.key = nil
        end
    end})

    esp:Toggle({Text = 'ESP rendering', State = _G.gd.esp.rendering, Callback = function(s)
        _G.gd.esp.rendering = s
    end})

    esp:Slider({Text = 'Refresh rate', Min = 10, Max = 240, Value = _G.gd.esp.rr, Float = 1, Callback = function(s)
        _G.gd.esp.rr = s
    end})

    esp:Slider({Text = 'Spacing px', Min = 8, Max = 26, Float = 1, Value = _G.gd.esp.spacing, Callback = function(s)
        _G.gd.esp.spacing = s
    end})

    esp:Colorpicker({Text = 'Color', Color = Color3.new(_G.gd.esp.color[1], _G.gd.esp.color[2], _G.gd.esp.color[3]), Callback = function(c)
        _G.gd.esp.color = {c.R, c.G, c.B}
    end})

    esp:Toggle({Text = 'Use custom text pattern', State = _G.gd.esp.useCustomPattern, Callback = function(s)
        _G.gd.esp.useCustomPattern = s
    end})

    esp:Textbox({Text = 'Custom text pattern', Placeholder = _G.gd.esp.customPattern, Callback = function(s)
        _G.gd.esp.customPattern = s
    end})

    esp:Toggle({Text = 'Show dead people', State = _G.gd.esp.showDead, Callback = function(s)
        _G.gd.esp.showDead = s
    end})

    esp:Slider({Text = 'Render distance', Min = 10, Max = 10000, Float = 1, deg = ' studs', Value = _G.gd.esp.maxDistance, Callback = function(s)
        _G.gd.esp.maxDistance = s
    end})

    esp:Toggle({Text = 'Infinite render distance', State = _G.gd.esp.infDistance, Callback = function(s)
        _G.gd.esp.infDistance = s
    end})

    esp:Slider({Text = 'Text transparency', Value = _G.gd.esp.name.transparency, Min = 0, Max = 1, Float = 0.1, Callback = function(v)
        _G.gd.esp.name.transparency = v
        _G.gd.esp.health.transparency = v
        _G.gd.esp.distance.transparency = v
    end})

    esp:Textlabel({Text = '<b><i>Boxes</i></b>'})

    esp:Toggle({Text = 'Enabled', State = _G.gd.esp.box.enabled, Callback = function(s)
        _G.gd.esp.box.enabled = s
    end})

    esp:Slider({Text = 'Thickness', Min = 0.1, Max = 5, Float = 0.1, Value = _G.gd.esp.box.thickness, Callback = function(s)
        _G.gd.esp.box.thickness = s
    end})

    esp:Toggle({Text = 'Filled', State = _G.gd.esp.box.filled, Callback = function(s)
        _G.gd.esp.filled = s
    end})

    esp:Slider({Text = 'Transparency', Min = 0, Max = 1, Float = 0.1, Value = _G.gd.esp.box.transparency, Callback = function(s)
        _G.gd.esp.box.transparency = s
    end})

    esp:Textlabel({Text = '<b><i>Health bar</i></b>'})

    esp:Toggle({Text = 'Enabled', State = _G.gd.esp.box.bar.enabled, Callback = function(s)
        _G.gd.esp.box.bar.enabled = s
    end})

    esp:Slider({Text = 'Transparency', Min = 0, Max = 1, Value = _G.gd.esp.box.bar.transparency, Float = 0.1, Callback = function(s)
        _G.gd.esp.box.bar.transparency = s
    end})
    
    esp:Slider({Text = 'Thickness', Min = 2, Max = 20, Float = 1, deg = ' px', Value = _G.gd.esp.box.bar.thickness, Callback = function(s)
        _G.gd.esp.box.bar.thickness = s
    end})

    esp:Textlabel({Text = '<b><i>Text data</i></b>'})

    esp:Toggle({Text = 'Show name', State = _G.gd.esp.name.enabled, Callback = function(s)
        _G.gd.esp.name.enabled = s
    end})

    esp:Toggle({Text = 'Show health', State = _G.gd.esp.health.enabled, Callback = function(s)
        _G.gd.esp.health.enabled = s
    end})

    esp:Toggle({Text = 'Show distance', State = _G.gd.esp.distance.enabled, Callback = function(s)
        _G.gd.esp.distance.enabled = s
    end})

    esp:Dropdown({Text = 'Name method', Options = {'username', 'displayname'}, Default = _G.gd.esp.name.method, Callback = function(s)
        _G.gd.esp.name.method = s
    end})

    esp:Toggle({Text = 'Show Max health', State = _G.gd.esp.health.showMax, Callback = function(s)
        _G.gd.esp.health.showMax = s
    end})

    esp:Dropdown({Text = 'Health method', Options = {'max', 'percent'}, Default = _G.gd.esp.health.method, Callback = function(s)
        _G.gd.esp.health.method = s
    end})

    esp:Dropdown({Text = 'Distance unit', Options = {'studs', 'meters'}, Default = _G.gd.esp.distance.unit, Callback = function(s)
        _G.gd.esp.distance.unit = s
    end})

    esp:Textlabel({Text = '<b><i>Tracers</i></b>'})

    esp:Toggle({Text = 'Enabled', State = _G.gd.esp.tracer.enabled, Callback = function(s)
        _G.gd.esp.tracer.enabled = s
    end})

    esp:Dropdown({Text = 'Origin', Options = {'bottom', 'mouse', 'top'}, Default = _G.gd.esp.tracer.from, Callback = function(s)
        _G.gd.esp.tracer.from = s
    end})

    esp:Slider({Text = 'Thickness', Min = 1, Max = 6, Float = 0.1, Value = _G.gd.esp.tracer.thickness, Callback = function(s)
        _G.gd.esp.tracer.thickness = s
    end})

    esp:Slider({Text = 'Transparency', Min = 0, Max = 1, Float = 0.1, Value = _G.gd.esp.tracer.transparency, Callback = function(s)
        _G.gd.esp.tracer.transparency = s
    end})

    esp:Textlabel({Text = '<b><i>Team</i></b>'})

    esp:Toggle({Text = 'Team check', State = _G.gd.esp.team.teamCheck, Callback = function(s)
        _G.gd.esp.team.teamCheck = s
    end})

    esp:Toggle({Text = 'Team Color', State = _G.gd.esp.team.teamColor, Callback = function(s)
        _G.gd.esp.team.teamColor = s
    end})
    --#endregion

    --#region Glow
    LPH_NO_VIRTUALIZE(function() --GLOW NO VIRTUALIZATION
        local objects = {}
        local count = 0
        local object = {
            add = function(model)
                if model:FindFirstChild('cap_highlight') then
                    return
                elseif count >= 36 then
                    return
                end
    
                local newId = math.random(1, 999999)
    
                local newObject = instance('Highlight', {
                    Name = 'cap_highlight',
                    Parent = model
                })
    
                newObject.AncestryChanged:Connect(function()
                    if not newObject:IsDescendantOf(game) then
                        for a,v in next, objects do
                            if v.id == newId then
                                table.remove(v, a)
                            end
                        end
                        count = count - 1
                    end
                end)
    
                count = count + 1
                table.insert(objects, {
                    obj = newObject,
                    id = newId
                })
    
                return newObject
            end,
            remove = function(model)
                if not model:FindFirstChild('cap_highlight') then
                    return
                end
    
                model['cap_highlight']:Destroy()
                count = count - 1
            end
        }
    
        local rrTable = {}
    
        local function addGlow(p)
            local name, v, currentObject = p.Name, p.Character, nil
            currentObject = object.add(v)
    
            p.CharacterAdded:Connect(function(v2)
                currentObject = object.add(v2)
            end)
    
            local data = {
                refresh = function()
                    if _G.gd.glow.enabled then
                        currentObject.Enabled = true
    
                        currentObject.FillColor = Color3.new(_G.gd.glow.fill.color[1], _G.gd.glow.fill.color[2], _G.gd.glow.fill.color[3])
                        currentObject.FillTransparency = _G.gd.glow.fill.transparency
    
                        currentObject.OutlineColor = Color3.new(_G.gd.glow.outline.color[1], _G.gd.glow.outline.color[2], _G.gd.glow.outline.color[3])
                        currentObject.OutlineTransparency = _G.gd.glow.outline.transparency
    
                        currentObject.DepthMode = (_G.gd.glow.alwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded)
                    else
                        currentObject.Enabled = false
                    end
                end,
                player = name
            }
    
            table.insert(rrTable, data)
        end
    
        game:service('RunService').Stepped:Connect(function()
            for a,v in next, rrTable do
                v.refresh()
                if not table.find(game:service('Players'):GetPlayers(), v.player) then
                    table.remove(v, a)
                end
            end
        end)
    
        for a,v in next, game:service('Players'):GetPlayers() do
            if v ~= game:service('Players').LocalPlayer then
                addGlow(v)
            end
        end
    
        game:service('Players').PlayerAdded:Connect(function(v)
            repeat
                wait()
            until v.Character ~= nil
    
            addGlow(v)
        end)
    end)()

    glow:ToggleBind({Text = 'Enabled', State = _G.gd.glow.enabled, Key = _G.gd.glow.toggle, Callback = function(s)
        _G.gd.glow.enabled = s
    end, NewCallback = function(k)
        if k ~= 'Unbinded' then
            _G.gd.glow.toggle = k
        else
            _G.gd.glow.toggle = nil
        end
    end})

    glow:Toggle({Text = 'Always on top', State = _G.gd.glow.alwaysOnTop, Callback = function(s)
        _G.gd.glow.alwaysOnTop = s
    end})

    glow:Textlabel({Text = '<b><i>Fill</i></b>'})

    glow:Colorpicker({Text = 'Color', Color = Color3.new(_G.gd.glow.fill.color[1], _G.gd.glow.fill.color[2], _G.gd.glow.fill.color[3]), Callback = function(c)
        _G.gd.glow.fill.color = {c.R, c.G, c.B}
    end})
    glow:Slider({Text = 'Transparency', Value = _G.gd.glow.fill.transparency, Min = 0, Max = 1, Float = 0.05, Callback = function(v)
        _G.gd.glow.fill.transparency = v
    end})

    glow:Textlabel({Text = '<b><i>Outline</i></b>'})

    glow:Colorpicker({Text = 'Color', Color = Color3.new(_G.gd.glow.outline.color[1], _G.gd.glow.outline.color[2], _G.gd.glow.outline.color[3]), Callback = function(c)
        _G.gd.glow.outline.color = {c.R, c.G, c.B}
    end})
    glow:Slider({Text = 'Transparency', Value = _G.gd.glow.outline.transparency, Min = 0, Max = 1, Float = 0.05, Callback = function(v)
        _G.gd.glow.outline.transparency = v
    end})

    LPH_NO_VIRTUALIZE(function() --hitbox expander
        local queue = {}

        game:service('RunService').Stepped:Connect(function()
            for a,v in next, queue do
                if Players:FindFirstChild(v.name) then
                    v.update()
                else
                    table.remove(queue, a)
                end
            end
        end)

        local function addExpander(plr)
            local function updateBox()
                local c = plr.Character
                local hum = c.HumanoidRootPart
                local sta = Vector3.new(2, 2.1, 2)

                if _G.gd.expander.enabled then
                    hum.Material = _G.gd.expander.material
                    hum.CanCollide = false
                    hum.Transparency = _G.gd.expander.transparency
                    hum.Color = Color3.new(_G.gd.expander.color[1], _G.gd.expander.color[2], _G.gd.expander.color[3])

                    local function sizeCheck()
                        if not _G.gd.expander.useCustomSize then
                            hum.Size = Vector3.new(_G.gd.expander.size, _G.gd.expander.size, _G.gd.expander.size)
                        else
                            hum.Size = Vector3.new(_G.gd.expander.customSize[1], _G.gd.expander.customSize[2], _G.gd.expander.customSize[3])
                        end
                    end

                    if not _G.gd.expander.teamCheck then
                        sizeCheck()
                    else
                        if plr.Team == LocalPlayer.Team then
                            hum.Size = sta
                            hum.Tracers = 1
                        else
                            sizeCheck()
                        end
                    end
                else
                    hum.Size = sta
                    hum.CanCollide = true
                    hum.Transparency = 1
                end
            end

            table.insert(queue, {
                name = plr.Name,
                update = updateBox
            })
        end

        for a,v in next, Players:GetChildren() do
            if v ~= LocalPlayer then
                addExpander(v)
            end
        end

        game:GetService('Players').PlayerAdded:Connect(function(v)
            print('adding expander:',v.Name)
            addExpander(v)
        end)
    end)()

    expander:ToggleBind({Text = 'Enabled', State = _G.gd.expander.enabled, Key = _G.gd.expander.key, Callback = function(s)
        _G.gd.expander.enabled = s
    end, NewCallback = function(s)
        if s ~= 'Unbinded' then
            _G.gd.expander.key = s
        else
            _G.gd.expander.key = nil
        end
    end})

    expander:Slider({Text = 'Size', Min = 2, Max = 20, Float = 0.1, Value = _G.gd.expander.size, Callback = function(s)
        _G.gd.expander.size = s
    end})

    expander:Colorpicker({Text = 'Color', Color = Color3.new(_G.gd.expander.color[1], _G.gd.expander.color[2], _G.gd.expander.color[3]), Callback = function(s)
        _G.gd.expander.color = {s.R, s.G, s.B}
    end})
    
    expander:Dropdown({Text = 'Material', Options = {'ForceField', 'Neon'}, Default = _G.gd.expander.material, Callback = function(v)
        _G.gd.expander.material = v
    end})

    expander:Slider({Text = 'Transparency', Min = 0, Max = 1, Float = 0.05, Value = _G.gd.expander.transparency, Callback = function(v)
        _G.gd.expander.transparency = v
    end})

    expander:Textlabel({Text = '<b><i>Custom size</i></b>'})

    expander:Toggle({Text = 'Use custom size', State = _G.gd.expander.useCustomSize, Callback = function(s)
        _G.gd.expander.useCustomSize = s
    end})

    expander:Slider({Text = 'Size X', Min = 2, Max = 20, Float = 0.1, Value = _G.gd.expander.customSize[1], Callback = function(s)
        _G.gd.expander.customSize[1] = s
    end})

    expander:Slider({Text = 'Size Y', Min = 2, Max = 20, Float = 0.1, Value = _G.gd.expander.customSize[2], Callback = function(s)
        _G.gd.expander.customSize[2] = s
    end})

    expander:Slider({Text = 'Size Z', Min = 2, Max = 20, Float = 0.1, Value = _G.gd.expander.customSize[3], Callback = function(s)
        _G.gd.expander.customSize[3] = s
    end})

    expander:Textlabel({Text = '<b><i>Team</i></b>'})

    expander:Toggle({Text = 'Team check', State = _G.gd.expander.teamCheck, Callback = function(s)
        _G.gd.expander.teamCheck = s
    end})
    --#endregion

    --#region Info
    local info = lib:Tab({
        Name = 'Account',
        Icon = 'rbxassetid://11312139188'
    })

    local function formatInt(int)
        local s = tostring(int)
        s = s:reverse()
        local c = 0
        s = s:gsub('.', function(x)
            c = c + 1
            if c >= 3 then
                c = 0
                return x .. ','
            else
                return x
            end
        end)
        s = s:reverse()
        if s:sub(1, 1) == ',' then
            s = s:sub(2, string.len(s))
        end
        return s
    end

    local AccountData = {
        ('Username: <font color="rgb(97,133,255)"><b>%s</b></font>'):format(Players.LocalPlayer.DisplayName .. ' (unknown)'),
        ('Hours remaining: <font color="rgb(97,133,255)"><b>%s</b></font>'):format(lgVarsTbl['hoursRemaining']),
        ('Expiration date: <font color="rgb(97,133,255)"><b>%s</b></font>'):format(lgVarsTbl['expirationDateTime']),
        ('Exploit: %s'):format(exploit == 'synapse' and
            'Synapse <font color="rgb(255,150,0)"><b>X</b></font>' or
            '<b>KRNL</b> / <i>Script<font color="rgb(66,155,251)">-</font>Ware</i>'
        ),
        ('Total executions: <font color="rgb(97,133,255)"><b>%s</b></font>'):format(
            formatInt(UiConfig.TotalExecutions or 0)
        )
    }

    info:Textlabel({
        Text = ('Cappuccino v7.0.7.2 <font color="rgb(255,255,150)"><b><i>linkvertise</i></b></font>')
    })

    for a,v in next, AccountData do
        info:Textlabel({
            Text = v,
            Alignment = 'Left',
        })
    end
    --#endregion
end, function(x)
   ErrorMessage(x)
end)
