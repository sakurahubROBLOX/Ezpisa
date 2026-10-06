local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ApplyThirdPerson = nil
local ResetThirdPerson = nil
local RefreshThirdPersonConnection = nil
local UpdateKillTargetInfo = nil
local KillTargetAllows = nil
local CollectEnemyPlayers = nil
local LastEnemyKey = ""
local InstallWalkSpeedBypass = nil
local UpdateWeaponHighlight = nil
local ApplyHandsPosition = nil
local GetEquippedWeapon = nil
local MovementDebugLabel = nil
local MoveDebugText = "..."
local ApplyAirStuck = nil
local ReleaseAirStuck = nil
local ModelChangerOptions = {"Reset"}
local RefreshModelChangerOptions = nil
local ApplyModelChanger = nil
local RestoreOriginalModel = nil
local PushKillFeed = nil
local PushKillFeedIfDead = nil
local CameraPitchLock = false
local ESPColorMap = {
    Pink = Color3.fromRGB(255, 105, 180),
    Lime = Color3.fromRGB(180, 230, 30),
    Cyan = Color3.fromRGB(55, 177, 218),
    Purple = Color3.fromRGB(204, 72, 180),
    Orange = Color3.fromRGB(255, 150, 50),
    White = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(220, 60, 60),
    Green = Color3.fromRGB(60, 220, 90),
    Blue = Color3.fromRGB(60, 120, 255),
    Yellow = Color3.fromRGB(255, 220, 60)
}

local ESPColorNames = {"Pink", "Lime", "Cyan", "Purple", "Orange", "White", "Red", "Green", "Blue", "Yellow"}

local Icons = {
    Sakura = "rbxassetid://79478214327919",
    Sparkles = "rbxassetid://105634041692696",
    Flame = "rbxassetid://125012650497883",
    Crosshair = "rbxassetid://83752373575368",
    Rotate3D = "rbxassetid://97818595741565",
    Zap = "rbxassetid://109718589733073",
    Eye = "rbxassetid://127234874352422",
    Activity = "rbxassetid://137527339160230",
    Target = "rbxassetid://121091323240554",
    Shield = "rbxassetid://106509993556171",
    Swords = "rbxassetid://99199363807265",
    Wrench = "rbxassetid://85345725497834",
    User = "rbxassetid://114567720540659",
    Settings = "rbxassetid://106205298246017",
    Palette = "rbxassetid://127369887384101",
    Volume = "rbxassetid://129861259578431"
}

local HitSoundMap = {
    ["Skeet"] = "rbxassetid://83717596220569",
    ["Neverlose"] = "rbxassetid://139452805868562",
    ["Bell"] = "rbxassetid://96481309571950",
    ["Bubble"] = "rbxassetid://104824514322839",
    ["Rust"] = "rbxassetid://1255040462"
}

local State = {
    MenuOpen = true,
    ESP = {
        Enabled = false,
        Box = false,
        BoxFilled = false,
        Skeleton = false,
        Nickname = false,
        Chams = false,
        SelfChams = false,
        TeamCheck = true,
        BoxColor = Color3.fromRGB(255, 105, 180),
        ChamsColor = Color3.fromRGB(255, 90, 175),
        CharmPlayers = false,
        CharmColor = Color3.fromRGB(55, 177, 218),
        CharmTransparency = 0.4,
        CharmDistance = 50,
        Arrows = false,
        ArrowColor = Color3.fromRGB(255, 255, 255),
        PlayerColors = {}
    },
    AntiAim = {
        Enabled = false,
        Mode = "jitter",
        SpinSpeed = 720,
        JitterAngle = 65,
        PitchAngle = 89,
        CameraPitch = true
    },
    Ragebot = {
        Enabled = false,
        TeamCheck = true,
        WallCheck = true,
        ShootWall = false,
        AutoWall = false,
        ShootWallLimit = 16,
        Hitbox = "Head",
        FireDelay = 0.04
    },
    SilentAim = {
        Enabled = false,
        ShowFOV = true,
        FOV = 120,
        TeamCheck = true,
        WallCheck = true,
        ShootWall = false,
        AutoWall = false,
        ShootWallLimit = 16,
        Hitbox = "Head"
    },
    Weapons = {
        NoRecoil = false,
        NoSpread = false,
        RapidFire = false,
        FireRate = 0.02,
        BulletTracers = false,
        TracerTime = 1.2,
        WeaponGlow = false,
        WeaponGlowFill = Color3.fromRGB(255, 105, 180),
        WeaponGlowOutline = Color3.fromRGB(180, 230, 30),
        WeaponChamsMode = "Highlight",
        WeaponGlassTransparency = 0.4,
        WeaponMetalReflectance = 1.0,
        HandsEnabled = false,
        HandsX = 0.2,
        HandsY = -0.155,
        HandsZ = 0.075,
        HitSound = false,
        HitSoundPreset = "Skeet",
        HitSoundVolume = 2.0
    },
    Skins = {
        WeaponSkinsEnabled = false,
        SelectedSkinIndex = 1,
        KnifeEnabled = false,
        KnifeModel = "Karambit",
        GlovesEnabled = false,
        GloveModel = "Sports Gloves"
    },
    KillAll = {
        Enabled = false,
        Hitbox = "Head",
        Delay = 0.09,
        ThroughWalls = true
    },
    Misc = {
        BunnyHop = false,
        BhopSpeed = 18,
        BhopStrafe = false,
        BhopStrafeRate = 14,
        JumpPower = 58,
        SpeedHack = false,
        SpeedValue = 34,
        SpeedBypass = false,
        SpeedInstant = true,
        ThirdPerson = false,
        ThirdPersonDist = 12,
        HideViewmodel = true,
        AntiFlash = false,
        AntiSmoke = false,
        AirStuck = false,
        FogEnabled = false,
        FogStart = 20,
        FogEnd = 420,
        FogColor = Color3.fromRGB(196, 206, 218),
        SkyEnabled = false,
        Skybox = "Default",
        SkyColor = Color3.fromRGB(255, 255, 255),
        SkyBrightness = 1.5,
        ModelChanger = false,
        ModelTarget = "Reset"
    },
    KillTarget = {
        Enabled = false,
        OnlySelected = true,
        MaxKills = 0,
        Selected = {},
        Kills = 0,
        LimitReached = false
    }
}

local World = (function()
    local Packs = {
        Default = {
            "rbxasset://textures/sky/sky512_bk.tex",
            "rbxasset://textures/sky/sky512_dn.tex",
            "rbxasset://textures/sky/sky512_ft.tex",
            "rbxasset://textures/sky/sky512_lf.tex",
            "rbxasset://textures/sky/sky512_rt.tex",
            "rbxasset://textures/sky/sky512_up.tex"
        },
        Storm = {
            "rbxassetid://10258337305",
            "rbxassetid://10258337305",
            "rbxassetid://10258337305",
            "rbxassetid://10258337305",
            "rbxassetid://10258337305",
            "rbxassetid://10258337305"
        },
        Flat = {
            "rbxassetid://10799413050",
            "rbxassetid://10799413050",
            "rbxassetid://10799413050",
            "rbxassetid://10799413050",
            "rbxassetid://10799413050",
            "rbxassetid://10799413050"
        },
        Azure = {
            "rbxassetid://225469345",
            "rbxassetid://225469349",
            "rbxassetid://225469359",
            "rbxassetid://225469364",
            "rbxassetid://225469372",
            "rbxassetid://225469380"
        },
        Void = {"", "", "", "", "", ""}
    }

    local Names = {"Default", "Storm", "Flat", "Azure", "Void"}
    local Faces = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}

    local OrigFog = nil
    local OrigLighting = nil
    local OrigSky = nil

    local function SaveFogOrig()
        if OrigFog then
            return
        end
        pcall(function()
            OrigFog = {
                Start = Lighting.FogStart,
                End = Lighting.FogEnd,
                Color = Lighting.FogColor
            }
        end)
    end

    local function SaveLightingOrig()
        if OrigLighting then
            return
        end
        pcall(function()
            OrigLighting = {
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                Brightness = Lighting.Brightness,
                ColorShiftTop = Lighting.ColorShift_Top,
                ColorShiftBottom = Lighting.ColorShift_Bottom,
                GlobalShadows = Lighting.GlobalShadows
            }
        end)
    end

    local function SaveSkyOrig()
        if OrigSky then
            return
        end
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then
            OrigSky = {}
            return
        end
        local saved = {}
        for _, face in ipairs(Faces) do
            pcall(function()
                saved[face] = sky[face]
            end)
        end
        OrigSky = saved
    end

    local function RestoreLighting()
        if not Lighting or not OrigLighting then
            return
        end
        pcall(function()
            Lighting.Ambient = OrigLighting.Ambient
            Lighting.OutdoorAmbient = OrigLighting.OutdoorAmbient
            Lighting.Brightness = OrigLighting.Brightness
            Lighting.ColorShift_Top = OrigLighting.ColorShiftTop
            Lighting.ColorShift_Bottom = OrigLighting.ColorShiftBottom
            Lighting.GlobalShadows = OrigLighting.GlobalShadows
        end)
    end

    local function GetSkyObject()
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Parent = Lighting
        end
        return sky
    end

    local function ApplyFog()
        if not Lighting then
            return
        end
        SaveFogOrig()
        pcall(function()
            if State.Misc.FogEnabled then
                Lighting.FogStart = State.Misc.FogStart
                Lighting.FogEnd = State.Misc.FogEnd
                Lighting.FogColor = State.Misc.FogColor
            elseif OrigFog then
                Lighting.FogStart = OrigFog.Start
                Lighting.FogEnd = OrigFog.End
                Lighting.FogColor = OrigFog.Color
            end
        end)
    end

    local function ApplySky()
        if not Lighting then
            return
        end
        SaveLightingOrig()
        SaveSkyOrig()

        if not State.Misc.SkyEnabled then
            RestoreLighting()
            pcall(function()
                local sky = Lighting:FindFirstChildOfClass("Sky")
                if sky and OrigSky then
                    for _, face in ipairs(Faces) do
                        if OrigSky[face] ~= nil then
                            sky[face] = OrigSky[face]
                        end
                    end
                    sky.Parent = Lighting
                end
            end)
            return
        end

        local sky = GetSkyObject()
        local pack = Packs[State.Misc.Skybox] or Packs.Default
        for i, face in ipairs(Faces) do
            pcall(function()
                sky[face] = pack[i]
            end)
        end
        pcall(function()
            sky.CelestialBodiesShown = (State.Misc.Skybox == "Default")
        end)

        local col = State.Misc.SkyColor
        SaveLightingOrig()
        pcall(function()
            Lighting.Ambient = col
            Lighting.OutdoorAmbient = col
            Lighting.ColorShift_Top = col
            Lighting.ColorShift_Bottom = col
            Lighting.Brightness = State.Misc.SkyBrightness
        end)

        local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
        if not atmo then
            atmo = Instance.new("Atmosphere")
            atmo.Parent = Lighting
        end
        pcall(function()
            atmo.Color = col
            atmo.Decay = col
            atmo.Density = 0.42
            atmo.Glare = 0
            atmo.Haze = 2.4
            atmo.Offset = 0
            atmo.Height = 200
        end)

        pcall(function()
            local holder = sky.Parent
            sky.Parent = nil
            sky.Parent = holder or Lighting
        end)
    end

    local function Reset()
        State.Misc.FogEnabled = false
        State.Misc.SkyEnabled = false
        ApplyFog()
        ApplySky()
    end

    task.spawn(function()
        while true do
            task.wait(1)
            if State.Misc.FogEnabled then
                pcall(ApplyFog)
            end
            if State.Misc.SkyEnabled then
                pcall(ApplySky)
            end
        end
    end)

    return {
        Names = Names,
        Packs = Packs,
        Faces = Faces,
        ApplyFog = ApplyFog,
        ApplySky = ApplySky,
        Reset = Reset
    }
end)()

pcall(function()
    RunService:UnbindFromRenderStep("SakuraAntiAimStep")
end)

local GuiParent = (gethui and gethui()) or CoreGui

local OldGui = GuiParent:FindFirstChild("sakura_for_gays_ui")
if OldGui then
    OldGui:Destroy()
end

local OldChams = GuiParent:FindFirstChild("sakura_for_gays_chams")
if OldChams then
    OldChams:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "sakura_for_gays_ui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
pcall(function()
    ScreenGui.Parent = GuiParent
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")
end

local ChamsFolder = Instance.new("Folder")
ChamsFolder.Name = "sakura_for_gays_chams"
pcall(function()
    ChamsFolder.Parent = GuiParent
end)
if not ChamsFolder.Parent then
    ChamsFolder.Parent = ScreenGui
end

local KillFeedFrame = Instance.new("Frame")
KillFeedFrame.Name = "sakura_kill_feed"
KillFeedFrame.AnchorPoint = Vector2.new(1, 0)
KillFeedFrame.Position = UDim2.new(1, -16, 0, 44)
KillFeedFrame.Size = UDim2.new(0, 260, 0, 220)
KillFeedFrame.BackgroundTransparency = 1
KillFeedFrame.BorderSizePixel = 0
KillFeedFrame.ZIndex = 40
KillFeedFrame.Parent = ScreenGui

local KillFeedLayout = Instance.new("UIListLayout")
KillFeedLayout.FillDirection = Enum.FillDirection.Vertical
KillFeedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
KillFeedLayout.VerticalAlignment = Enum.VerticalAlignment.Top
KillFeedLayout.Padding = UDim.new(0, 4)
KillFeedLayout.SortOrder = Enum.SortOrder.LayoutOrder
KillFeedLayout.Parent = KillFeedFrame

local KillFeedCounter = 0

PushKillFeed = function(text, accentColor)
    pcall(function()
        KillFeedCounter = KillFeedCounter + 1
        local row = Instance.new("TextLabel")
        row.Size = UDim2.new(0, 250, 0, 22)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        row.BackgroundTransparency = 0.15
        row.BorderSizePixel = 0
        row.Font = Enum.Font.Code
        row.TextSize = 13
        row.TextColor3 = Color3.fromRGB(240, 240, 240)
        row.TextXAlignment = Enum.TextXAlignment.Right
        row.Text = "  " .. tostring(text) .. "  "
        row.LayoutOrder = KillFeedCounter
        row.ZIndex = 41
        row.Parent = KillFeedFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 3)
        corner.Parent = row

        local stroke = Instance.new("UIStroke")
        stroke.Color = accentColor or Color3.fromRGB(180, 230, 30)
        stroke.Thickness = 1
        stroke.Transparency = 0.35
        stroke.Parent = row

        task.delay(3.2, function()
            pcall(function()
                row:Destroy()
            end)
        end)
    end)
end

PushKillFeedIfDead = function(charModel, throughWall)
    if not charModel then
        return
    end
    local hum = charModel:FindFirstChildOfClass("Humanoid")
    if not hum then
        return
    end
    local startHealth = hum.Health
    task.delay(0.35, function()
        pcall(function()
            if hum and hum.Parent and startHealth > 0 and hum.Health <= 0 then
                if throughWall then
                    PushKillFeed(charModel.Name .. "   [WALLBANG]", Color3.fromRGB(255, 190, 60))
                else
                    PushKillFeed(charModel.Name .. "   [KILLED]", Color3.fromRGB(255, 105, 180))
                end
            end
        end)
    end)
end

local ESPCanvas = Instance.new("Frame")
ESPCanvas.Name = "ESPCanvas"
ESPCanvas.Size = UDim2.new(1, 0, 1, 0)
ESPCanvas.BackgroundTransparency = 1
ESPCanvas.BorderSizePixel = 0
ESPCanvas.ZIndex = 1
ESPCanvas.Parent = ScreenGui

local FOVCircleFrame = Instance.new("Frame")
FOVCircleFrame.Name = "FOVCircle"
FOVCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircleFrame.Size = UDim2.new(0, 240, 0, 240)
FOVCircleFrame.BackgroundTransparency = 1
FOVCircleFrame.Visible = false
FOVCircleFrame.ZIndex = 2
FOVCircleFrame.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircleFrame

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1.2
FOVStroke.Color = Color3.fromRGB(255, 105, 180)
FOVStroke.Transparency = 0.15
FOVStroke.Parent = FOVCircleFrame

local function CreateSkeetGradient(parent)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 2)
    bar.Position = UDim2.new(0, 0, 0, 0)
    bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bar.BorderSizePixel = 0
    bar.ZIndex = parent.ZIndex + 2
    bar.Parent = parent

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(55, 177, 218)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(204, 72, 180)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(180, 230, 30))
    })
    grad.Parent = bar
    return bar
end

local function ApplySkeetBorder(frame)
    frame.BorderSizePixel = 0
    local outerStroke = Instance.new("UIStroke")
    outerStroke.Thickness = 1
    outerStroke.Color = Color3.fromRGB(45, 45, 45)
    outerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    outerStroke.Parent = frame
end

local WatermarkOuter = Instance.new("Frame")
WatermarkOuter.Name = "Watermark"
WatermarkOuter.AnchorPoint = Vector2.new(1, 0)
WatermarkOuter.Position = UDim2.new(1, -14, 0, 14)
WatermarkOuter.Size = UDim2.new(0, 310, 0, 26)
WatermarkOuter.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
WatermarkOuter.ZIndex = 50
WatermarkOuter.Parent = ScreenGui
ApplySkeetBorder(WatermarkOuter)
CreateSkeetGradient(WatermarkOuter)

local WatermarkIcon = Instance.new("ImageLabel")
WatermarkIcon.Size = UDim2.new(0, 14, 0, 14)
WatermarkIcon.Position = UDim2.new(0, 8, 0.5, -6)
WatermarkIcon.BackgroundTransparency = 1
WatermarkIcon.Image = Icons.Sakura
WatermarkIcon.ImageColor3 = Color3.fromRGB(255, 105, 180)
WatermarkIcon.ZIndex = 51
WatermarkIcon.Parent = WatermarkOuter

local WatermarkLabel = Instance.new("TextLabel")
WatermarkLabel.Size = UDim2.new(1, -30, 1, -2)
WatermarkLabel.Position = UDim2.new(0, 26, 0, 2)
WatermarkLabel.BackgroundTransparency = 1
WatermarkLabel.Font = Enum.Font.Code
WatermarkLabel.TextSize = 12
WatermarkLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
WatermarkLabel.Text = "sakura.for.gays | " .. LP.Name .. " | 60 FPS"
WatermarkLabel.ZIndex = 51
WatermarkLabel.Parent = WatermarkOuter

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "MobileToggleBtn"
ToggleButton.Size = UDim2.new(0, 145, 0, 32)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -16)
ToggleButton.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
ToggleButton.Font = Enum.Font.Code
ToggleButton.TextSize = 12
ToggleButton.TextColor3 = Color3.fromRGB(235, 235, 235)
ToggleButton.Text = "   sakura.for.gays"
ToggleButton.AutoButtonColor = false
ToggleButton.ZIndex = 60
ToggleButton.Parent = ScreenGui
ApplySkeetBorder(ToggleButton)
CreateSkeetGradient(ToggleButton)

local ToggleBtnIcon = Instance.new("ImageLabel")
ToggleBtnIcon.Size = UDim2.new(0, 14, 0, 14)
ToggleBtnIcon.Position = UDim2.new(0, 8, 0.5, -6)
ToggleBtnIcon.BackgroundTransparency = 1
ToggleBtnIcon.Image = Icons.Sakura
ToggleBtnIcon.ImageColor3 = Color3.fromRGB(255, 105, 180)
ToggleBtnIcon.ZIndex = 61
ToggleBtnIcon.Parent = ToggleButton

local function MakeDraggable(dragHandle, targetFrame, onClickCallback)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    local moved = false

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if not moved and onClickCallback then
                        onClickCallback()
                    end
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                moved = true
            end
            targetFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local MainWindow = Instance.new("Frame")
MainWindow.Name = "SkeetMainWindow"
MainWindow.Size = UDim2.new(0, 620, 0, 420)
MainWindow.Position = UDim2.new(0.5, -310, 0.5, -210)
MainWindow.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainWindow.ZIndex = 20
MainWindow.Parent = ScreenGui
ApplySkeetBorder(MainWindow)

local InnerBorder = Instance.new("Frame")
InnerBorder.Size = UDim2.new(1, -6, 1, -6)
InnerBorder.Position = UDim2.new(0, 3, 0, 3)
InnerBorder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InnerBorder.ZIndex = 21
InnerBorder.Parent = MainWindow
ApplySkeetBorder(InnerBorder)
CreateSkeetGradient(InnerBorder)

local TopDragBar = Instance.new("Frame")
TopDragBar.Size = UDim2.new(1, 0, 0, 26)
TopDragBar.Position = UDim2.new(0, 0, 0, 2)
TopDragBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TopDragBar.BorderSizePixel = 0
TopDragBar.ZIndex = 22
TopDragBar.Parent = InnerBorder

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Size = UDim2.new(0, 14, 0, 14)
TitleIcon.Position = UDim2.new(0, 8, 0.5, -7)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Image = Icons.Sparkles
TitleIcon.ImageColor3 = Color3.fromRGB(180, 230, 30)
TitleIcon.ZIndex = 23
TitleIcon.Parent = TopDragBar

local WindowTitle = Instance.new("TextLabel")
WindowTitle.Size = UDim2.new(1, -30, 1, 0)
WindowTitle.Position = UDim2.new(0, 26, 0, 0)
WindowTitle.BackgroundTransparency = 1
WindowTitle.Font = Enum.Font.Code
WindowTitle.TextSize = 13
WindowTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
WindowTitle.TextXAlignment = Enum.TextXAlignment.Left
WindowTitle.Text = "sakura.for.gays [bloxstrike]"
WindowTitle.ZIndex = 23
WindowTitle.Parent = TopDragBar

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 0, 28)
HeaderLine.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 23
HeaderLine.Parent = InnerBorder

local Sidebar = Instance.new("Frame")
Sidebar.Name = "LeftTabs"
Sidebar.Size = UDim2.new(0, 140, 1, -29)
Sidebar.Position = UDim2.new(0, 0, 0, 29)
Sidebar.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 22
Sidebar.Parent = InnerBorder

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 1, 1, -29)
SidebarDivider.Position = UDim2.new(0, 140, 0, 29)
SidebarDivider.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
SidebarDivider.BorderSizePixel = 0
SidebarDivider.ZIndex = 23
SidebarDivider.Parent = InnerBorder

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 2)
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 4)
SidebarPadding.PaddingRight = UDim.new(0, 4)
SidebarPadding.Parent = Sidebar

local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -141, 1, -29)
PagesContainer.Position = UDim2.new(0, 141, 0, 29)
PagesContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PagesContainer.BorderSizePixel = 0
PagesContainer.ZIndex = 22
PagesContainer.Parent = InnerBorder

MakeDraggable(TopDragBar, MainWindow, nil)
MakeDraggable(ToggleButton, ToggleButton, function()
    State.MenuOpen = not State.MenuOpen
    MainWindow.Visible = State.MenuOpen
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and (input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert) then
        State.MenuOpen = not State.MenuOpen
        MainWindow.Visible = State.MenuOpen
    end
end)

local TabsData = {}

local function CreateTab(tabName, iconId, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.ZIndex = 24
    btn.Parent = Sidebar

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 2, 1, -8)
    indicator.Position = UDim2.new(0, 0, 0, 4)
    indicator.BackgroundColor3 = Color3.fromRGB(180, 230, 30)
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 25
    indicator.Parent = btn

    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0, 15, 0, 15)
    iconImg.Position = UDim2.new(0, 10, 0.5, -7)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = iconId
    iconImg.ImageColor3 = Color3.fromRGB(130, 130, 130)
    iconImg.ZIndex = 25
    iconImg.Parent = btn

    local btnText = Instance.new("TextLabel")
    btnText.Size = UDim2.new(1, -32, 1, 0)
    btnText.Position = UDim2.new(0, 30, 0, 0)
    btnText.BackgroundTransparency = 1
    btnText.Font = Enum.Font.Code
    btnText.TextSize = 12
    btnText.TextColor3 = Color3.fromRGB(130, 130, 130)
    btnText.TextXAlignment = Enum.TextXAlignment.Left
    btnText.Text = tabName
    btnText.ZIndex = 25
    btnText.Parent = btn

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ZIndex = 23
    page.Parent = PagesContainer

    local leftCol = Instance.new("ScrollingFrame")
    leftCol.Size = UDim2.new(0.5, -14, 1, -20)
    leftCol.Position = UDim2.new(0, 10, 0, 10)
    leftCol.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
    leftCol.ScrollBarThickness = 2
    leftCol.ScrollBarImageColor3 = Color3.fromRGB(180, 230, 30)
    leftCol.CanvasSize = UDim2.new(0, 0, 0, 0)
    leftCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
    leftCol.ZIndex = 24
    leftCol.Parent = page
    ApplySkeetBorder(leftCol)

    local leftLayout = Instance.new("UIListLayout")
    leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    leftLayout.Padding = UDim.new(0, 8)
    leftLayout.Parent = leftCol

    local leftPad = Instance.new("UIPadding")
    leftPad.PaddingTop = UDim.new(0, 10)
    leftPad.PaddingBottom = UDim.new(0, 10)
    leftPad.PaddingLeft = UDim.new(0, 10)
    leftPad.PaddingRight = UDim.new(0, 10)
    leftPad.Parent = leftCol

    local rightCol = Instance.new("ScrollingFrame")
    rightCol.Size = UDim2.new(0.5, -14, 1, -20)
    rightCol.Position = UDim2.new(0.5, 4, 0, 10)
    rightCol.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
    rightCol.ScrollBarThickness = 2
    rightCol.ScrollBarImageColor3 = Color3.fromRGB(180, 230, 30)
    rightCol.CanvasSize = UDim2.new(0, 0, 0, 0)
    rightCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
    rightCol.ZIndex = 24
    rightCol.Parent = page
    ApplySkeetBorder(rightCol)

    local rightLayout = Instance.new("UIListLayout")
    rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rightLayout.Padding = UDim.new(0, 8)
    rightLayout.Parent = rightCol

    local rightPad = Instance.new("UIPadding")
    rightPad.PaddingTop = UDim.new(0, 10)
    rightPad.PaddingBottom = UDim.new(0, 10)
    rightPad.PaddingLeft = UDim.new(0, 10)
    rightPad.PaddingRight = UDim.new(0, 10)
    rightPad.Parent = rightCol

    local tabObj = {
        Button = btn,
        Label = btnText,
        Icon = iconImg,
        Indicator = indicator,
        Page = page,
        Left = leftCol,
        Right = rightCol
    }
    table.insert(TabsData, tabObj)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(TabsData) do
            t.Page.Visible = false
            t.Indicator.Visible = false
            t.Button.BackgroundTransparency = 1
            t.Label.TextColor3 = Color3.fromRGB(130, 130, 130)
            t.Icon.ImageColor3 = Color3.fromRGB(130, 130, 130)
        end
        page.Visible = true
        indicator.Visible = true
        btn.BackgroundTransparency = 0
        btnText.TextColor3 = Color3.fromRGB(240, 240, 240)
        iconImg.ImageColor3 = Color3.fromRGB(180, 230, 30)
    end)

    return tabObj
end

local function AddSectionTitle(parent, titleText, iconId, order)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 18)
    holder.BackgroundTransparency = 1
    holder.LayoutOrder = order
    holder.ZIndex = 25
    holder.Parent = parent

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 13, 0, 13)
    icon.Position = UDim2.new(0, 0, 0.5, -6)
    icon.BackgroundTransparency = 1
    icon.Image = iconId or Icons.Target
    icon.ImageColor3 = Color3.fromRGB(180, 230, 30)
    icon.ZIndex = 26
    icon.Parent = holder

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -18, 1, 0)
    lbl.Position = UDim2.new(0, 18, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(180, 230, 30)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = titleText
    lbl.ZIndex = 26
    lbl.Parent = holder
end

local function AddToggle(parent, text, defaultVal, order, callback)
    local container = Instance.new("TextButton")
    container.Size = UDim2.new(1, 0, 0, 20)
    container.BackgroundTransparency = 1
    container.Text = ""
    container.AutoButtonColor = false
    container.LayoutOrder = order
    container.ZIndex = 25
    container.Parent = parent

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 12, 0, 12)
    box.Position = UDim2.new(0, 0, 0.5, -6)
    box.BackgroundColor3 = defaultVal and Color3.fromRGB(156, 202, 43) or Color3.fromRGB(30, 30, 30)
    box.ZIndex = 26
    box.Parent = container
    ApplySkeetBorder(box)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Code
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(215, 215, 215)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.ZIndex = 26
    label.Parent = container

    local state = defaultVal
    container.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(156, 202, 43) or Color3.fromRGB(30, 30, 30)
        if callback then
            callback(state)
        end
    end)
end

local function AddSlider(parent, text, minVal, maxVal, defaultVal, decimals, order, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 34)
    holder.BackgroundTransparency = 1
    holder.LayoutOrder = order
    holder.ZIndex = 25
    holder.Parent = parent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 14)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Code
    title.TextSize = 12
    title.TextColor3 = Color3.fromRGB(210, 210, 210)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = text .. ": " .. tostring(defaultVal)
    title.ZIndex = 26
    title.Parent = holder

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, 0, 0, 12)
    barBg.Position = UDim2.new(0, 0, 0, 18)
    barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    barBg.ZIndex = 26
    barBg.Parent = holder
    ApplySkeetBorder(barBg)

    local fill = Instance.new("Frame")
    local initRatio = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(initRatio, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(156, 202, 43)
    fill.BorderSizePixel = 0
    fill.ZIndex = 27
    fill.Parent = barBg

    local sliding = false

    local function updateFromInput(inputPos)
        local relX = math.clamp((inputPos.X - barBg.AbsolutePosition.X) / math.max(barBg.AbsoluteSize.X, 1), 0, 1)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        local raw = minVal + (maxVal - minVal) * relX
        local mult = 10 ^ (decimals or 0)
        local val = math.floor(raw * mult + 0.5) / mult
        title.Text = text .. ": " .. tostring(val)
        if callback then
            callback(val)
        end
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateFromInput(input.Position)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    sliding = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input.Position)
        end
    end)
end

local function AddSelector(parent, text, options, defaultOpt, order, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 38)
    holder.BackgroundTransparency = 1
    holder.LayoutOrder = order
    holder.ZIndex = 25
    holder.Parent = parent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 14)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Code
    title.TextSize = 12
    title.TextColor3 = Color3.fromRGB(210, 210, 210)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = text
    title.ZIndex = 26
    title.Parent = holder

    local cycleBtn = Instance.new("TextButton")
    cycleBtn.Size = UDim2.new(1, 0, 0, 20)
    cycleBtn.Position = UDim2.new(0, 0, 0, 16)
    cycleBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    cycleBtn.Font = Enum.Font.Code
    cycleBtn.TextSize = 12
    cycleBtn.TextColor3 = Color3.fromRGB(156, 202, 43)
    cycleBtn.Text = "< " .. tostring(defaultOpt) .. " >"
    cycleBtn.AutoButtonColor = false
    cycleBtn.ZIndex = 26
    cycleBtn.Parent = holder
    ApplySkeetBorder(cycleBtn)

    local idx = table.find(options, defaultOpt) or 1
    cycleBtn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then
            idx = 1
        end
        local chosen = options[idx]
        cycleBtn.Text = "< " .. tostring(chosen) .. " >"
        if callback then
            callback(chosen)
        end
    end)
end

local function AddInfoLabel(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(180, 230, 30)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    lbl.LayoutOrder = order
    lbl.ZIndex = 26
    lbl.Parent = parent
    return lbl
end

local function AddButton(parent, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(156, 202, 43)
    btn.Text = text
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.ZIndex = 26
    btn.Parent = parent
    ApplySkeetBorder(btn)
    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    return btn
end

local TabRage = CreateTab("RAGE", Icons.Flame, 1)
local TabSilent = CreateTab("SILENT AIM", Icons.Crosshair, 2)
local TabAntiAim = CreateTab("ANTIAIM", Icons.Rotate3D, 3)
local TabWeapons = CreateTab("WEAPONS", Icons.Zap, 4)
local TabESP = CreateTab("VISUALS", Icons.Eye, 5)
local TabSkins = CreateTab("SKINS", Icons.Palette, 6)
local TabMisc = CreateTab("MISC", Icons.Activity, 7)
local TabKillTarget = CreateTab("KILL TARGET", Icons.Swords, 8)

TabsData[1].Page.Visible = true
TabsData[1].Indicator.Visible = true
TabsData[1].Button.BackgroundTransparency = 0
TabsData[1].Label.TextColor3 = Color3.fromRGB(240, 240, 240)
TabsData[1].Icon.ImageColor3 = Color3.fromRGB(180, 230, 30)

local CachedLocalChar = nil

local function GetLocalCharacter()
    if LP.Character and LP.Character.Parent then
        CachedLocalChar = LP.Character
        return LP.Character
    end
    if CachedLocalChar and CachedLocalChar.Parent then
        return CachedLocalChar
    end
    local charsFolder = Workspace:FindFirstChild("Characters")
    if charsFolder then
        local t = charsFolder:FindFirstChild("Terrorists")
        local ct = charsFolder:FindFirstChild("Counter-Terrorists")
        local found = (t and t:FindFirstChild(LP.Name)) or (ct and ct:FindFirstChild(LP.Name)) or charsFolder:FindFirstChild(LP.Name)
        if found and found:IsA("Model") then
            CachedLocalChar = found
            return found
        end
    end
    return nil
end

local LastHitSoundTick = 0
local HitSoundInstance = Instance.new("Sound")
HitSoundInstance.Name = "SakuraHitSound"
HitSoundInstance.Parent = SoundService

local function PlayHitSound()
    if not State.Weapons.HitSound then
        return
    end
    local now = tick()
    if now - LastHitSoundTick < 0.04 then
        return
    end
    LastHitSoundTick = now
    pcall(function()
        HitSoundInstance.SoundId = HitSoundMap[State.Weapons.HitSoundPreset] or HitSoundMap["Skeet"]
        HitSoundInstance.Volume = State.Weapons.HitSoundVolume
        HitSoundInstance:Play()
    end)
end

AddSectionTitle(TabRage.Left, "KILL ALL", Icons.Swords, 1)
AddToggle(TabRage.Left, "Kill All (Through Walls)", State.KillAll.Enabled, 2, function(v)
    State.KillAll.Enabled = v
end)
AddSelector(TabRage.Left, "Kill All Hitbox", {"Head", "UpperTorso", "HumanoidRootPart"}, State.KillAll.Hitbox, 3, function(v)
    State.KillAll.Hitbox = v
end)
AddSlider(TabRage.Left, "Kill All Delay", 0.03, 0.5, State.KillAll.Delay, 2, 4, function(v)
    State.KillAll.Delay = v
end)

AddSectionTitle(TabRage.Left, "RAGEBOT MAIN", Icons.Flame, 5)
AddToggle(TabRage.Left, "Ragebot Enabled", State.Ragebot.Enabled, 6, function(v)
    State.Ragebot.Enabled = v
end)
AddToggle(TabRage.Left, "Team Check", State.Ragebot.TeamCheck, 7, function(v)
    State.Ragebot.TeamCheck = v
end)
AddToggle(TabRage.Left, "Wall Check", State.Ragebot.WallCheck, 8, function(v)
    State.Ragebot.WallCheck = v
end)

AddSectionTitle(TabRage.Right, "RAGEBOT SETTINGS", Icons.Target, 1)
AddSelector(TabRage.Right, "Target Hitbox", {"Head", "UpperTorso", "HumanoidRootPart"}, State.Ragebot.Hitbox, 2, function(v)
    State.Ragebot.Hitbox = v
end)
AddToggle(TabRage.Right, "Auto Wall", State.Ragebot.AutoWall, 3, function(v)
    State.Ragebot.AutoWall = v
end)
AddToggle(TabRage.Right, "Shoot Wall", State.Ragebot.ShootWall, 4, function(v)
    State.Ragebot.ShootWall = v
end)
AddSlider(TabRage.Right, "Shoot Wall Thickness", 2, 100, State.Ragebot.ShootWallLimit, 0, 5, function(v)
    State.Ragebot.ShootWallLimit = v
end)
AddSlider(TabRage.Right, "Fire Delay", 0.01, 0.25, State.Ragebot.FireDelay, 2, 6, function(v)
    State.Ragebot.FireDelay = v
end)

AddSectionTitle(TabSilent.Left, "SILENT AIM", Icons.Crosshair, 1)
AddToggle(TabSilent.Left, "Silent Aim Enabled", State.SilentAim.Enabled, 2, function(v)
    State.SilentAim.Enabled = v
end)
AddToggle(TabSilent.Left, "Team Check", State.SilentAim.TeamCheck, 3, function(v)
    State.SilentAim.TeamCheck = v
end)
AddToggle(TabSilent.Left, "Wall Check", State.SilentAim.WallCheck, 4, function(v)
    State.SilentAim.WallCheck = v
end)

AddSectionTitle(TabSilent.Right, "FOV SETTINGS", Icons.Target, 1)
AddToggle(TabSilent.Right, "Show FOV Circle", State.SilentAim.ShowFOV, 2, function(v)
    State.SilentAim.ShowFOV = v
end)
AddSlider(TabSilent.Right, "FOV Radius", 20, 400, State.SilentAim.FOV, 0, 3, function(v)
    State.SilentAim.FOV = v
end)
AddSelector(TabSilent.Right, "Silent Hitbox", {"Head", "UpperTorso", "HumanoidRootPart"}, State.SilentAim.Hitbox, 4, function(v)
    State.SilentAim.Hitbox = v
end)
AddToggle(TabSilent.Right, "Auto Wall", State.SilentAim.AutoWall, 5, function(v)
    State.SilentAim.AutoWall = v
end)
AddToggle(TabSilent.Right, "Shoot Wall", State.SilentAim.ShootWall, 6, function(v)
    State.SilentAim.ShootWall = v
end)
AddSlider(TabSilent.Right, "Shoot Wall Thickness", 2, 100, State.SilentAim.ShootWallLimit, 0, 7, function(v)
    State.SilentAim.ShootWallLimit = v
end)

AddSectionTitle(TabAntiAim.Left, "ANTIAIM MAIN", Icons.Rotate3D, 1)
AddToggle(TabAntiAim.Left, "AntiAim Enabled", State.AntiAim.Enabled, 2, function(v)
    State.AntiAim.Enabled = v
    if not v then
        local myChar = GetLocalCharacter()
        if myChar then
            local hum = myChar:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = true
            end
        end
    end
end)
AddSelector(TabAntiAim.Left, "AntiAim Mode", {
    "jitter",
    "spin",
    "backwares",
    "jitter-backwares",
    "goodluck",
    "backwares-jitter-down",
    "backwares-jitter-up",
    "backwares-down",
    "backwares-up",
    "jitter-down",
    "jitter-up",
    "down-up",
    "spin-down"
}, State.AntiAim.Mode, 3, function(v)
    State.AntiAim.Mode = v
end)
AddInfoLabel(TabAntiAim.Left, "goodluck: left=-90 right=90 fwd=180 back=0", 4)
AddInfoLabel(TabAntiAim.Left, "down/up modes use Pitch Angle", 5)

AddSectionTitle(TabAntiAim.Right, "ANTIAIM VALUES", Icons.Settings, 1)
AddSlider(TabAntiAim.Right, "Spin Speed", 180, 2160, State.AntiAim.SpinSpeed, 0, 2, function(v)
    State.AntiAim.SpinSpeed = v
end)
AddSlider(TabAntiAim.Right, "Jitter Angle", 15, 135, State.AntiAim.JitterAngle, 0, 3, function(v)
    State.AntiAim.JitterAngle = v
end)
AddSlider(TabAntiAim.Right, "Pitch Angle", 10, 89, State.AntiAim.PitchAngle, 0, 4, function(v)
    State.AntiAim.PitchAngle = v
end)
AddToggle(TabAntiAim.Right, "Camera Pitch", State.AntiAim.CameraPitch, 8, function(v)
    State.AntiAim.CameraPitch = v
end)
AddInfoLabel(TabAntiAim.Right, "pitch: body via PostSimulation", 9)
MovementDebugLabel = AddInfoLabel(TabAntiAim.Right, "status: ...", 6)

AddSectionTitle(TabWeapons.Left, "WEAPON MODS", Icons.Wrench, 1)
AddToggle(TabWeapons.Left, "No Recoil", State.Weapons.NoRecoil, 2, function(v)
    State.Weapons.NoRecoil = v
end)
AddToggle(TabWeapons.Left, "No Spread", State.Weapons.NoSpread, 3, function(v)
    State.Weapons.NoSpread = v
end)
AddToggle(TabWeapons.Left, "Rapid Fire", State.Weapons.RapidFire, 4, function(v)
    State.Weapons.RapidFire = v
end)
AddSlider(TabWeapons.Left, "Rapid Fire Delay", 0.01, 0.15, State.Weapons.FireRate, 2, 5, function(v)
    State.Weapons.FireRate = v
end)

AddSectionTitle(TabWeapons.Right, "TRACERS & HITSOUND", Icons.Volume, 1)
AddToggle(TabWeapons.Right, "Tracer Bullet", State.Weapons.BulletTracers, 2, function(v)
    State.Weapons.BulletTracers = v
end)
AddSlider(TabWeapons.Right, "Tracer Time", 0.3, 5.0, State.Weapons.TracerTime, 1, 3, function(v)
    State.Weapons.TracerTime = v
end)
AddToggle(TabWeapons.Right, "HitSound Enabled", State.Weapons.HitSound, 4, function(v)
    State.Weapons.HitSound = v
    if v then
        PlayHitSound()
    end
end)
AddSelector(TabWeapons.Right, "HitSound Type", {"Skeet", "Neverlose", "Bell", "Bubble", "Rust"}, State.Weapons.HitSoundPreset, 5, function(v)
    State.Weapons.HitSoundPreset = v
    if State.Weapons.HitSound then
        PlayHitSound()
    end
end)
AddSlider(TabWeapons.Right, "HitSound Volume", 0.2, 5.0, State.Weapons.HitSoundVolume, 1, 6, function(v)
    State.Weapons.HitSoundVolume = v
end)

AddSectionTitle(TabWeapons.Right, "WEAPON GLOW", Icons.Sparkles, 7)
AddToggle(TabWeapons.Right, "Weapon Highlight (Glow)", State.Weapons.WeaponGlow, 8, function(v)
    State.Weapons.WeaponGlow = v
    UpdateWeaponHighlight()
end)
AddSelector(TabWeapons.Right, "Glow Fill Color", {"Pink", "Lime", "Cyan", "Purple", "Orange", "White"}, "Pink", 9, function(v)
    local map = {
        Pink = Color3.fromRGB(255, 105, 180),
        Lime = Color3.fromRGB(180, 230, 30),
        Cyan = Color3.fromRGB(55, 177, 218),
        Purple = Color3.fromRGB(204, 72, 180),
        Orange = Color3.fromRGB(255, 150, 50),
        White = Color3.fromRGB(255, 255, 255)
    }
    State.Weapons.WeaponGlowFill = map[v] or map.Pink
    UpdateWeaponHighlight()
end)
AddSelector(TabWeapons.Right, "Glow Outline Color", {"Lime", "Pink", "Cyan", "Purple", "Orange", "White"}, "Lime", 10, function(v)
    local map = {
        Pink = Color3.fromRGB(255, 105, 180),
        Lime = Color3.fromRGB(180, 230, 30),
        Cyan = Color3.fromRGB(55, 177, 218),
        Purple = Color3.fromRGB(204, 72, 180),
        Orange = Color3.fromRGB(255, 150, 50),
        White = Color3.fromRGB(255, 255, 255)
    }
    State.Weapons.WeaponGlowOutline = map[v] or map.Lime
    UpdateWeaponHighlight()
end)
AddSelector(TabWeapons.Right, "Glow Mode", {"Highlight", "Glass", "ForceField", "Metal", "Neon"}, "Highlight", 11, function(v)
    State.Weapons.WeaponChamsMode = v
    UpdateWeaponHighlight()
end)
AddSlider(TabWeapons.Right, "Glass Transparency", 0, 1, State.Weapons.WeaponGlassTransparency, 2, 12, function(v)
    State.Weapons.WeaponGlassTransparency = v
    UpdateWeaponHighlight()
end)
AddSlider(TabWeapons.Right, "Metal Reflectance", 0, 1, State.Weapons.WeaponMetalReflectance, 2, 13, function(v)
    State.Weapons.WeaponMetalReflectance = v
    UpdateWeaponHighlight()
end)

AddSectionTitle(TabWeapons.Right, "CUSTOM HANDS POSITION", Icons.Wrench, 14)
AddToggle(TabWeapons.Right, "Custom Hands", State.Weapons.HandsEnabled, 15, function(v)
    State.Weapons.HandsEnabled = v
    if v then
        ApplyHandsPosition()
    end
end)
AddSlider(TabWeapons.Right, "Hands X", -1, 1, State.Weapons.HandsX, 3, 16, function(v)
    State.Weapons.HandsX = v
    if State.Weapons.HandsEnabled then
        ApplyHandsPosition()
    end
end)
AddSlider(TabWeapons.Right, "Hands Y", -1, 1, State.Weapons.HandsY, 3, 17, function(v)
    State.Weapons.HandsY = v
    if State.Weapons.HandsEnabled then
        ApplyHandsPosition()
    end
end)
AddSlider(TabWeapons.Right, "Hands Z", -1, 1, State.Weapons.HandsZ, 3, 18, function(v)
    State.Weapons.HandsZ = v
    if State.Weapons.HandsEnabled then
        ApplyHandsPosition()
    end
end)
AddInfoLabel(TabWeapons.Right, "writes Stats.Default in camera vm", 19)

AddSectionTitle(TabESP.Left, "PLAYER ESP", Icons.Eye, 1)
AddToggle(TabESP.Left, "ESP Master", State.ESP.Enabled, 2, function(v)
    State.ESP.Enabled = v
end)
AddToggle(TabESP.Left, "ESP Box", State.ESP.Box, 3, function(v)
    State.ESP.Box = v
end)
AddToggle(TabESP.Left, "Box Filled", State.ESP.BoxFilled, 4, function(v)
    State.ESP.BoxFilled = v
end)
AddToggle(TabESP.Left, "ESP Skeleton", State.ESP.Skeleton, 5, function(v)
    State.ESP.Skeleton = v
end)
AddToggle(TabESP.Left, "ESP Nickname", State.ESP.Nickname, 6, function(v)
    State.ESP.Nickname = v
end)

AddSectionTitle(TabESP.Right, "CHAMS & SHELL", Icons.Shield, 1)
AddToggle(TabESP.Right, "Charms (Enemy Shell)", State.ESP.Chams, 2, function(v)
    State.ESP.Chams = v
end)
AddToggle(TabESP.Right, "Self Chams (My Shell)", State.ESP.SelfChams, 3, function(v)
    State.ESP.SelfChams = v
end)
AddToggle(TabESP.Right, "Team Check", State.ESP.TeamCheck, 4, function(v)
    State.ESP.TeamCheck = v
end)

AddSectionTitle(TabESP.Right, "WEAPON CHARMS", Icons.Sparkles, 5)
AddToggle(TabESP.Right, "Weapon Charms", State.Weapons.WeaponGlow, 6, function(v)
    State.Weapons.WeaponGlow = v
    UpdateWeaponHighlight()
end)
AddSelector(TabESP.Right, "Charms Mode", {"Highlight", "Glass", "ForceField", "Metal", "Neon"}, "Highlight", 7, function(v)
    State.Weapons.WeaponChamsMode = v
    UpdateWeaponHighlight()
end)
AddSelector(TabESP.Right, "Charms Color", {"Pink", "Lime", "Cyan", "Purple", "Orange", "White"}, "Pink", 8, function(v)
    local map = {
        Pink = Color3.fromRGB(255, 105, 180),
        Lime = Color3.fromRGB(180, 230, 30),
        Cyan = Color3.fromRGB(55, 177, 218),
        Purple = Color3.fromRGB(204, 72, 180),
        Orange = Color3.fromRGB(255, 150, 50),
        White = Color3.fromRGB(255, 255, 255)
    }
    State.Weapons.WeaponGlowFill = map[v] or map.Pink
    UpdateWeaponHighlight()
end)
AddSelector(TabESP.Right, "Charms Outline", {"Lime", "Pink", "Cyan", "Purple", "Orange", "White"}, "Lime", 9, function(v)
    local map = {
        Pink = Color3.fromRGB(255, 105, 180),
        Lime = Color3.fromRGB(180, 230, 30),
        Cyan = Color3.fromRGB(55, 177, 218),
        Purple = Color3.fromRGB(204, 72, 180),
        Orange = Color3.fromRGB(255, 150, 50),
        White = Color3.fromRGB(255, 255, 255)
    }
    State.Weapons.WeaponGlowOutline = map[v] or map.Lime
    UpdateWeaponHighlight()
end)
AddSlider(TabESP.Right, "Glass Transparency", 0, 1, State.Weapons.WeaponGlassTransparency, 2, 10, function(v)
    State.Weapons.WeaponGlassTransparency = v
    UpdateWeaponHighlight()
end)
AddSlider(TabESP.Right, "Metal Reflectance", 0, 1, State.Weapons.WeaponMetalReflectance, 2, 11, function(v)
    State.Weapons.WeaponMetalReflectance = v
    UpdateWeaponHighlight()
end)

local ESPColorRows = {}
local LastESPColorKey = ""

local function BuildESPColorRows()
    for _, row in pairs(ESPColorRows) do
        if row and row.Parent then
            row:Destroy()
        end
    end
    ESPColorRows = {}
    local names = CollectEnemyPlayers()
    for i, name in ipairs(names) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 20)
        btn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        btn.Font = Enum.Font.Code
        btn.TextSize = 11
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "  " .. name .. ": Pink"
        btn.AutoButtonColor = false
        btn.LayoutOrder = 200 + i
        btn.ZIndex = 26
        btn.Parent = TabESP.Right
        ApplySkeetBorder(btn)
        btn.MouseButton1Click:Connect(function()
            local cur = State.ESP.PlayerColors[name]
            local curName = "Pink"
            for n, c in pairs(ESPColorMap) do
                if c == cur then
                    curName = n
                    break
                end
            end
            local idx = table.find(ESPColorNames, curName) or 1
            local nextName = ESPColorNames[(idx % #ESPColorNames) + 1]
            State.ESP.PlayerColors[name] = ESPColorMap[nextName]
            btn.Text = "  " .. name .. ": " .. nextName
        end)
        ESPColorRows[name] = btn
    end
end

task.defer(function()
    pcall(BuildESPColorRows)
end)

task.spawn(function()
    while true do
        task.wait(1.5)
        pcall(function()
            local names = CollectEnemyPlayers()
            local key = table.concat(names, ",")
            if key ~= LastESPColorKey then
                LastESPColorKey = key
                BuildESPColorRows()
            end
        end)
    end
end)

AddSectionTitle(TabESP.Right, "CHARM PLAYERS", Icons.Shield, 12)
AddToggle(TabESP.Right, "Charm Players", State.ESP.CharmPlayers, 13, function(v)
    State.ESP.CharmPlayers = v
end)
AddSelector(TabESP.Right, "Charm Color", ESPColorNames, "Cyan", 14, function(v)
    State.ESP.CharmColor = ESPColorMap[v] or ESPColorMap.Cyan
end)
AddSlider(TabESP.Right, "Charm Transparency", 0, 1, State.ESP.CharmTransparency, 2, 15, function(v)
    State.ESP.CharmTransparency = v
end)
AddSlider(TabESP.Right, "Charm Distance", 10, 500, State.ESP.CharmDistance, 0, 16, function(v)
    State.ESP.CharmDistance = v
end)
AddInfoLabel(TabESP.Right, "forcefield material on model", 17)

AddSectionTitle(TabESP.Right, "OFFSCREEN ARROWS", Icons.Target, 18)
AddToggle(TabESP.Right, "Offscreen Arrows", State.ESP.Arrows, 19, function(v)
    State.ESP.Arrows = v
end)
AddSelector(TabESP.Right, "Arrow Color", ESPColorNames, "White", 20, function(v)
    State.ESP.ArrowColor = ESPColorMap[v] or ESPColorMap.White
end)
AddInfoLabel(TabESP.Right, "arrow points to offscreen enemy", 21)

AddSectionTitle(TabESP.Right, "ESP COLORS", Icons.Palette, 22)
AddSelector(TabESP.Right, "ESP Box Color", ESPColorNames, "Pink", 23, function(v)
    State.ESP.BoxColor = ESPColorMap[v] or ESPColorMap.Pink
end)
AddSelector(TabESP.Right, "Chams Color", ESPColorNames, "Pink", 24, function(v)
    State.ESP.ChamsColor = ESPColorMap[v] or ESPColorMap.Pink
end)
AddInfoLabel(TabESP.Right, "per player colors below", 25)

local KnifeModelsList = {"Karambit", "Butterfly Knife", "M9 Bayonet", "Skeleton Knife", "Stiletto Knife", "Flip Knife", "Gut Knife"}
local GloveModelsList = {"Sports Gloves", "Driver Gloves", "Operator Gloves", "Hand Wraps"}

AddSectionTitle(TabSkins.Left, "KNIFE & WEAPON SKINS", Icons.Swords, 1)
AddToggle(TabSkins.Left, "Enable Weapon Skins", State.Skins.WeaponSkinsEnabled, 2, function(v)
    State.Skins.WeaponSkinsEnabled = v
end)
AddSlider(TabSkins.Left, "Skin Variant Index", 1, 12, State.Skins.SelectedSkinIndex, 0, 3, function(v)
    State.Skins.SelectedSkinIndex = v
end)
AddToggle(TabSkins.Left, "Enable Knife Changer", State.Skins.KnifeEnabled, 4, function(v)
    State.Skins.KnifeEnabled = v
end)
AddSelector(TabSkins.Left, "Knife Model", KnifeModelsList, State.Skins.KnifeModel, 5, function(v)
    State.Skins.KnifeModel = v
end)

AddSectionTitle(TabSkins.Right, "GLOVE CHANGER", Icons.Palette, 1)
AddToggle(TabSkins.Right, "Enable Gloves Changer", State.Skins.GlovesEnabled, 2, function(v)
    State.Skins.GlovesEnabled = v
end)
AddSelector(TabSkins.Right, "Glove Model", GloveModelsList, State.Skins.GloveModel, 3, function(v)
    State.Skins.GloveModel = v
end)

AddSectionTitle(TabMisc.Left, "MOVEMENT & WORLD", Icons.Activity, 1)
AddToggle(TabMisc.Left, "BunnyHop", State.Misc.BunnyHop, 2, function(v)
    State.Misc.BunnyHop = v
end)
AddSlider(TabMisc.Left, "Bhop Speed", 5, 30, State.Misc.BhopSpeed, 0, 3, function(v)
    State.Misc.BhopSpeed = v
end)
AddToggle(TabMisc.Left, "Auto Strafe", State.Misc.BhopStrafe, 4, function(v)
    State.Misc.BhopStrafe = v
end)
AddSlider(TabMisc.Left, "Strafe Rate", 1, 60, State.Misc.BhopStrafeRate, 0, 5, function(v)
    State.Misc.BhopStrafeRate = v
end)
AddToggle(TabMisc.Left, "Speed Hack", State.Misc.SpeedHack, 7, function(v)
    State.Misc.SpeedHack = v
    if not v then
        pcall(function()
            local myChar = GetLocalCharacter()
            local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end)
    end
end)
AddSlider(TabMisc.Left, "Speed Value", 16, 120, State.Misc.SpeedValue, 0, 8, function(v)
    State.Misc.SpeedValue = v
end)
AddToggle(TabMisc.Left, "Instant Accel", State.Misc.SpeedInstant, 9, function(v)
    State.Misc.SpeedInstant = v
end)
AddToggle(TabMisc.Left, "Speed Bypass (Hide WS)", State.Misc.SpeedBypass, 10, function(v)
    State.Misc.SpeedBypass = v
    if v then
        InstallWalkSpeedBypass()
    end
end)
AddInfoLabel(TabMisc.Left, "off by default: metatable hook", 11)
AddSlider(TabMisc.Left, "Jump Power", 30, 130, State.Misc.JumpPower, 0, 12, function(v)
    State.Misc.JumpPower = v
end)
AddSectionTitle(TabMisc.Left, "AIR STUCK", Icons.Sparkles, 1)
AddToggle(TabMisc.Left, "Air Stuck", State.Misc.AirStuck, 2, function(v)
    State.Misc.AirStuck = v
    if v then
        if ApplyAirStuck then
            pcall(ApplyAirStuck)
        end
    else
        if ReleaseAirStuck then
            pcall(ReleaseAirStuck)
        end
    end
end)
AddInfoLabel(TabMisc.Left, "jump then toggle = freeze in air", 3)

AddSectionTitle(TabMisc.Left, "MODEL CHANGER", Icons.User, 4)
AddToggle(TabMisc.Left, "Model Changer", State.Misc.ModelChanger, 5, function(v)
    State.Misc.ModelChanger = v
    if v then
        if RefreshModelChangerOptions then
            RefreshModelChangerOptions()
        end
        if ApplyModelChanger then
            pcall(ApplyModelChanger)
        end
    else
        if RestoreOriginalModel then
            pcall(RestoreOriginalModel)
        end
    end
end)
AddSelector(TabMisc.Left, "Model", ModelChangerOptions, State.Misc.ModelTarget, 6, function(v)
    State.Misc.ModelTarget = v
    if State.Misc.ModelChanger and ApplyModelChanger then
        pcall(ApplyModelChanger)
    end
end)
AddButton(TabMisc.Left, "REFRESH LIST", 7, function()
    if RefreshModelChangerOptions then
        RefreshModelChangerOptions()
    end
end)
AddButton(TabMisc.Left, "RESET MODEL", 8, function()
    State.Misc.ModelTarget = "Reset"
    if RestoreOriginalModel then
        pcall(RestoreOriginalModel)
    end
end)

AddToggle(TabMisc.Left, "Anti Flashbang", State.Misc.AntiFlash, 4, function(v)
    State.Misc.AntiFlash = v
end)
AddToggle(TabMisc.Left, "Anti Smoke", State.Misc.AntiSmoke, 5, function(v)
    State.Misc.AntiSmoke = v
end)

AddSectionTitle(TabMisc.Right, "CAMERA", Icons.User, 1)
AddToggle(TabMisc.Right, "Third Person", State.Misc.ThirdPerson, 2, function(v)
    State.Misc.ThirdPerson = v
    if v then
        if RefreshThirdPersonConnection then
            RefreshThirdPersonConnection()
        end
        if ApplyThirdPerson then
            ApplyThirdPerson()
        end
    else
        if ResetThirdPerson then
            ResetThirdPerson()
        end
    end
end)
AddToggle(TabMisc.Right, "Hide Arms (Viewmodel)", State.Misc.HideViewmodel, 4, function(v)
    State.Misc.HideViewmodel = v
    if State.Misc.ThirdPerson then
        if ApplyThirdPerson then
            ApplyThirdPerson()
        end
    end
end)
AddSlider(TabMisc.Right, "Third Person Dist", 5, 40, State.Misc.ThirdPersonDist, 0, 3, function(v)
    State.Misc.ThirdPersonDist = v
    if State.Misc.ThirdPerson and ApplyThirdPerson then
        ApplyThirdPerson()
    end
end)

AddSectionTitle(TabMisc.Right, "FOG", Icons.Volume, 6)
AddToggle(TabMisc.Right, "Fog", State.Misc.FogEnabled, 7, function(v)
    State.Misc.FogEnabled = v
    World.ApplyFog()
end)
AddSlider(TabMisc.Right, "Fog Start", 0, 2000, State.Misc.FogStart, 0, 8, function(v)
    State.Misc.FogStart = v
    World.ApplyFog()
end)
AddSlider(TabMisc.Right, "Fog End", 0, 5000, State.Misc.FogEnd, 0, 9, function(v)
    State.Misc.FogEnd = v
    World.ApplyFog()
end)
AddSelector(TabMisc.Right, "Fog Color", ESPColorNames, "White", 10, function(v)
    State.Misc.FogColor = ESPColorMap[v] or ESPColorMap.White
    World.ApplyFog()
end)

AddSectionTitle(TabMisc.Right, "CHANGE SKY", Icons.Palette, 11)
AddToggle(TabMisc.Right, "Change Sky", State.Misc.SkyEnabled, 12, function(v)
    State.Misc.SkyEnabled = v
    World.ApplySky()
end)
AddSelector(TabMisc.Right, "Skybox", World.Names, State.Misc.Skybox, 13, function(v)
    State.Misc.Skybox = v
    World.ApplySky()
end)
AddSelector(TabMisc.Right, "Sky Color", ESPColorNames, "White", 14, function(v)
    State.Misc.SkyColor = ESPColorMap[v] or ESPColorMap.White
    World.ApplySky()
end)
AddSlider(TabMisc.Right, "Sky Brightness", 0, 5, State.Misc.SkyBrightness, 2, 15, function(v)
    State.Misc.SkyBrightness = v
    World.ApplySky()
end)
AddButton(TabMisc.Right, "RESET SKY AND FOG", 16, function()
    World.Reset()
end)

local KillTargetInfoLabel = nil

AddSectionTitle(TabKillTarget.Left, "KILL TARGET", Icons.Swords, 1)
AddToggle(TabKillTarget.Left, "Kill Target Enabled", State.KillTarget.Enabled, 2, function(v)
    State.KillTarget.Enabled = v
    UpdateKillTargetInfo()
end)
AddToggle(TabKillTarget.Left, "Only Selected Players", State.KillTarget.OnlySelected, 3, function(v)
    State.KillTarget.OnlySelected = v
    UpdateKillTargetInfo()
end)
AddSlider(TabKillTarget.Left, "Max Kills", 0, 20, State.KillTarget.MaxKills, 0, 4, function(v)
    State.KillTarget.MaxKills = v
    State.KillTarget.LimitReached = false
    UpdateKillTargetInfo()
end)
AddButton(TabKillTarget.Left, "Reset Kills", 5, function()
    State.KillTarget.Kills = 0
    State.KillTarget.LimitReached = false
    UpdateKillTargetInfo()
end)

AddSectionTitle(TabKillTarget.Right, "ENEMY PLAYERS", Icons.User, 1)
KillTargetInfoLabel = AddInfoLabel(TabKillTarget.Right, "Kills: 0 | Selected: 0", 2)
AddButton(TabKillTarget.Right, "Select All Enemies", 3, function()
    for _, name in ipairs(CollectEnemyPlayers()) do
        State.KillTarget.Selected[name] = true
    end
    LastEnemyKey = ""
end)
AddButton(TabKillTarget.Right, "Clear Selection", 4, function()
    State.KillTarget.Selected = {}
    LastEnemyKey = ""
end)

local SkinsRoot = nil
pcall(function()
    SkinsRoot = ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("Skins")
end)

local BaseKnives = {["CT Knife"] = true, ["T Knife"] = true, ["Knife"] = true}

local function GetPickedSkinFolder(weaponFolder)
    if not weaponFolder then
        return nil
    end
    local children = weaponFolder:GetChildren()
    if #children == 0 then
        return nil
    end
    table.sort(children, function(a, b)
        return a.Name < b.Name
    end)
    local idx = ((State.Skins.SelectedSkinIndex - 1) % #children) + 1
    return children[idx]
end

local function InitSkinHooks()
    pcall(function()
        local skinsLibMod = ReplicatedStorage:FindFirstChild("Database")
            and ReplicatedStorage.Database:FindFirstChild("Components")
            and ReplicatedStorage.Database.Components:FindFirstChild("Libraries")
            and ReplicatedStorage.Database.Components.Libraries:FindFirstChild("Skins")

        local vmMod = ReplicatedStorage:FindFirstChild("Classes")
            and ReplicatedStorage.Classes:FindFirstChild("WeaponComponent")
            and ReplicatedStorage.Classes.WeaponComponent:FindFirstChild("Classes")
            and ReplicatedStorage.Classes.WeaponComponent.Classes:FindFirstChild("Viewmodel")

        if skinsLibMod then
            local skOk, Sk = pcall(require, skinsLibMod)
            if skOk and type(Sk) == "table" and not Sk._sakuraHooked then
                Sk._sakuraHooked = true
                if type(Sk.GetCameraModel) == "function" then
                    local origGCM = Sk.GetCameraModel
                    Sk.GetCameraModel = function(w, sk, ...)
                        if State.Skins.KnifeEnabled and w and BaseKnives[w] then
                            local targetKnife = State.Skins.KnifeModel
                            local kf = SkinsRoot and SkinsRoot:FindFirstChild(targetKnife)
                            local picked = GetPickedSkinFolder(kf)
                            local skinName = (picked and picked.Name) or "Vanilla"
                            local ok, res = pcall(origGCM, targetKnife, skinName, ...)
                            if ok and res then
                                return res
                            end
                        end
                        return origGCM(w, sk, ...)
                    end
                end

                if type(Sk.GetCharacterModel) == "function" then
                    local origGChM = Sk.GetCharacterModel
                    Sk.GetCharacterModel = function(w, sk, ...)
                        if State.Skins.KnifeEnabled and w and BaseKnives[w] then
                            local targetKnife = State.Skins.KnifeModel
                            local kf = SkinsRoot and SkinsRoot:FindFirstChild(targetKnife)
                            local picked = GetPickedSkinFolder(kf)
                            local skinName = (picked and picked.Name) or "Vanilla"
                            local ok, res = pcall(origGChM, targetKnife, skinName, ...)
                            if ok and res then
                                return res
                            end
                        end
                        return origGChM(w, sk, ...)
                    end
                end

                if type(Sk.GetGloves) == "function" then
                    local origGG = Sk.GetGloves
                    Sk.GetGloves = function(g, sk, ...)
                        if State.Skins.GlovesEnabled then
                            local gModel = State.Skins.GloveModel
                            local gf = SkinsRoot and SkinsRoot:FindFirstChild(gModel)
                            local picked = GetPickedSkinFolder(gf)
                            local skinName = (picked and picked.Name) or "Default"
                            local ok, res = pcall(origGG, gModel, skinName, ...)
                            if ok and res then
                                return res
                            end
                        end
                        return origGG(g, sk, ...)
                    end
                end
            end
        end

        if vmMod then
            local vmOk, Vm = pcall(require, vmMod)
            if vmOk and type(Vm) == "table" and type(Vm.new) == "function" and not Vm._sakuraHooked then
                Vm._sakuraHooked = true
                local origNew = Vm.new
                Vm.new = function(vc, w, sk, ...)
                    if State.Skins.KnifeEnabled and w and BaseKnives[w] then
                        local targetKnife = State.Skins.KnifeModel
                        local kf = SkinsRoot and SkinsRoot:FindFirstChild(targetKnife)
                        local picked = GetPickedSkinFolder(kf)
                        local skinName = (picked and picked.Name) or "Vanilla"
                        local ok, res = pcall(origNew, vc, targetKnife, skinName, ...)
                        if ok and res then
                            return res
                        end
                    end
                    return origNew(vc, w, sk, ...)
                end
            end
        end
    end)
end

InitSkinHooks()

local function ApplyCameraSkinsAndGloves()
    if not Camera then
        return
    end
    if not SkinsRoot then
        pcall(function()
            SkinsRoot = ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("Skins")
        end)
        if not SkinsRoot then
            return
        end
    end

    if State.Skins.WeaponSkinsEnabled or State.Skins.KnifeEnabled then
        for _, child in ipairs(Camera:GetChildren()) do
            if child:IsA("Model") and not child.Name:match("Arms") and child.Name ~= "Viewmodel" and child.Name ~= "ViewmodelLight" then
                local lookupName = child.Name
                if BaseKnives[lookupName] and State.Skins.KnifeEnabled then
                    lookupName = State.Skins.KnifeModel
                end
                local wFolder = SkinsRoot:FindFirstChild(lookupName)
                local skinFolder = GetPickedSkinFolder(wFolder)
                local camFolder = skinFolder and skinFolder:FindFirstChild("Camera")
                local wearFolder = camFolder and (camFolder:FindFirstChild("Factory New") or camFolder:GetChildren()[1])
                if wearFolder then
                    for _, sa in ipairs(wearFolder:GetChildren()) do
                        if sa:IsA("SurfaceAppearance") then
                            local targetPart = child:FindFirstChild(sa.Name, true)
                            if targetPart and (targetPart:IsA("BasePart") or targetPart:IsA("MeshPart")) then
                                local tag = skinFolder.Name .. "_" .. sa.Name
                                if targetPart:GetAttribute("SakuraSkinApplied") ~= tag then
                                    for _, old in ipairs(targetPart:GetChildren()) do
                                        if old:IsA("SurfaceAppearance") then
                                            old:Destroy()
                                        end
                                    end
                                    sa:Clone().Parent = targetPart
                                    targetPart:SetAttribute("SakuraSkinApplied", tag)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if State.Skins.GlovesEnabled then
        for _, child in ipairs(Camera:GetChildren()) do
            if child:IsA("Model") and (child.Name:match("Arms") or child:FindFirstChild("Right Arm")) then
                local la = child:FindFirstChild("Left Arm")
                local ra = child:FindFirstChild("Right Arm")
                local lg = la and la:FindFirstChild("Glove")
                local rg = ra and ra:FindFirstChild("Glove")
                if lg and rg then
                    local gFolder = SkinsRoot:FindFirstChild(State.Skins.GloveModel)
                    local skinFolder = GetPickedSkinFolder(gFolder)
                    local camFolder = skinFolder and skinFolder:FindFirstChild("Camera")
                    local wearFolder = camFolder and (camFolder:FindFirstChild("Factory New") or camFolder:GetChildren()[1])
                    if wearFolder then
                        local tag = State.Skins.GloveModel .. "_" .. skinFolder.Name
                        if lg:GetAttribute("SakuraGloveTag") ~= tag then
                            for _, old in ipairs(lg:GetChildren()) do
                                if old:IsA("SurfaceAppearance") then old:Destroy() end
                            end
                            for _, old in ipairs(rg:GetChildren()) do
                                if old:IsA("SurfaceAppearance") then old:Destroy() end
                            end
                            for _, sa in ipairs(wearFolder:GetChildren()) do
                                if sa:IsA("SurfaceAppearance") then
                                    sa:Clone().Parent = lg
                                    sa:Clone().Parent = rg
                                end
                            end
                            lg:SetAttribute("SakuraGloveTag", tag)
                        end
                    end
                end
            end
        end
    end
end

local function HasVestDetails(char)
    if not char then
        return nil
    end
    local armor = char:FindFirstChild("CharacterArmor")
    if armor then
        return armor:FindFirstChild("VestDetails") ~= nil
    end
    return nil
end

local function IsTeammate(char)
    if not char then
        return false
    end
    local myChar = GetLocalCharacter()
    if char == myChar or char.Name == LP.Name then
        return true
    end
    local targetPlayer = Players:GetPlayerFromCharacter(char) or Players:FindFirstChild(char.Name)
    if targetPlayer and targetPlayer == LP then
        return true
    end
    if targetPlayer and LP.Team and targetPlayer.Team and LP.Team == targetPlayer.Team then
        return true
    end
    if myChar then
        if myChar.Parent and char.Parent and myChar.Parent == char.Parent and char.Parent.Name ~= "Characters" and char.Parent ~= Workspace then
            return true
        end
        local myVest = HasVestDetails(myChar)
        local theirVest = HasVestDetails(char)
        if myVest ~= nil and theirVest ~= nil then
            return myVest == theirVest
        end
    end
    return false
end

local function IsEnemyPlayerObject(plr)
    if not plr or plr == LP then
        return false
    end
    if LP.Team and plr.Team and LP.Team == plr.Team then
        return false
    end
    local myChar = GetLocalCharacter()
    local theirChar = plr.Character
    if myChar and theirChar and myChar.Parent and theirChar.Parent and myChar.Parent == theirChar.Parent and myChar.Parent.Name ~= "Characters" and myChar.Parent ~= Workspace then
        return false
    end
    if myChar and theirChar then
        local myVest = HasVestDetails(myChar)
        local theirVest = HasVestDetails(theirChar)
        if myVest ~= nil and theirVest ~= nil then
            return myVest ~= theirVest
        end
    end
    return true
end

local KillTargetRows = {}

CollectEnemyPlayers = function()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if IsEnemyPlayerObject(plr) then
            table.insert(names, plr.Name)
        end
    end
    table.sort(names)
    return names
end

local function CountKillTargetSelection()
    local count = 0
    for _, v in pairs(State.KillTarget.Selected) do
        if v then
            count = count + 1
        end
    end
    return count
end

UpdateKillTargetInfo = function()
    if not KillTargetInfoLabel then
        return
    end
    local maxText = ""
    if State.KillTarget.MaxKills > 0 then
        maxText = " / " .. tostring(State.KillTarget.MaxKills)
    end
    local status = ""
    if State.KillTarget.LimitReached then
        status = "  |  LIMIT REACHED"
    elseif State.KillTarget.Enabled and State.KillTarget.OnlySelected and CountKillTargetSelection() == 0 then
        status = "  |  NO TARGETS SELECTED"
    end
    KillTargetInfoLabel.Text = "Kills: " .. tostring(State.KillTarget.Kills) .. maxText .. "  |  Selected: " .. tostring(CountKillTargetSelection()) .. status
end

local function RefreshKillTargetRows()
    for name, row in pairs(KillTargetRows) do
        if row and row.Parent then
            local on = State.KillTarget.Selected[name] == true
            row.BackgroundColor3 = on and Color3.fromRGB(48, 58, 26) or Color3.fromRGB(24, 24, 24)
            row.TextColor3 = on and Color3.fromRGB(180, 230, 30) or Color3.fromRGB(200, 200, 200)
            row.Text = (on and "  [x] " or "  [ ] ") .. name
        end
    end
    UpdateKillTargetInfo()
end

local function CreateKillTargetRow(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 20)
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = "  [ ] " .. name
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.ZIndex = 26
    btn.Parent = TabKillTarget.Right
    ApplySkeetBorder(btn)
    btn.MouseButton1Click:Connect(function()
        State.KillTarget.Selected[name] = not (State.KillTarget.Selected[name] == true)
        RefreshKillTargetRows()
    end)
    return btn
end

local function OnEnemyKilled(char)
    if not State.KillTarget.Enabled or not char then
        return
    end
    if State.KillTarget.OnlySelected and State.KillTarget.Selected[char.Name] ~= true then
        return
    end
    State.KillTarget.Kills = State.KillTarget.Kills + 1
    if State.KillTarget.MaxKills > 0 and State.KillTarget.Kills >= State.KillTarget.MaxKills then
        State.KillTarget.LimitReached = true
    end
    UpdateKillTargetInfo()
end

KillTargetAllows = function(char)
    if not State.KillTarget.Enabled or not char then
        return true
    end
    if State.KillTarget.LimitReached then
        return false
    end
    if not State.KillTarget.OnlySelected then
        return true
    end
    if CountKillTargetSelection() == 0 then
        return true
    end
    return State.KillTarget.Selected[char.Name] == true
end

local PrevRoundAlive = nil
local function IsCharacterAlive(char)
    if not char or not char.Parent then
        return false
    end
    if char:GetAttribute("Dead") == true or char:GetAttribute("Invincible") == true then
        return false
    end
    local hpAttr = char:GetAttribute("Health")
    if hpAttr ~= nil and hpAttr <= 0 then
        return false
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then
        return false
    end
    return (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")) ~= nil
end

local CachedCharacterList = {}

local PrevRoundAttr = nil

local function CheckNewRound()
    local roundAttr = nil
    pcall(function()
        roundAttr = LP:GetAttribute("Round") or LP:GetAttribute("RoundNumber") or Workspace:GetAttribute("Round") or Workspace:GetAttribute("RoundState")
    end)
    local alive = 0
    for _, char in ipairs(CachedCharacterList) do
        if IsCharacterAlive(char) then
            alive = alive + 1
        end
    end
    local newRound = false
    if PrevRoundAttr ~= nil and roundAttr ~= nil and roundAttr ~= PrevRoundAttr then
        newRound = true
    end
    if PrevRoundAlive ~= nil and PrevRoundAlive <= 1 and alive >= 3 then
        newRound = true
    end
    PrevRoundAttr = roundAttr
    PrevRoundAlive = alive
    if newRound then
        State.KillTarget.Kills = 0
        State.KillTarget.LimitReached = false
        UpdateKillTargetInfo()
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            local names = CollectEnemyPlayers()
            local key = table.concat(names, ",")
            if key ~= LastEnemyKey then
                LastEnemyKey = key
                for _, row in pairs(KillTargetRows) do
                    if row and row.Parent then
                        row:Destroy()
                    end
                end
                KillTargetRows = {}
                for i, name in ipairs(names) do
                    KillTargetRows[name] = CreateKillTargetRow(name, 10 + i)
                end
            end
            RefreshKillTargetRows()
            CheckNewRound()
        end)
    end
end)

local WallCheckCache = {}

local function GetEnemyHitParts()
    local list = {}
    for _, char in ipairs(CachedCharacterList) do
        if IsCharacterAlive(char) and not IsTeammate(char) then
            local part = char:FindFirstChild(State.KillAll.Hitbox)
                or char:FindFirstChild("Head")
                or char:FindFirstChild("UpperTorso")
                or char:FindFirstChild("HumanoidRootPart")
            if part then
                local hum = char:FindFirstChildOfClass("Humanoid")
                table.insert(list, {Part = part, Humanoid = hum})
            end
        end
    end
    return list
end

local function RefreshCharacterCache()
    WallCheckCache = {}
    local list = {}
    local seen = {}
    local myChar = GetLocalCharacter()
    local charsFolder = Workspace:FindFirstChild("Characters")
    if charsFolder then
        for _, folderOrChar in ipairs(charsFolder:GetChildren()) do
            if folderOrChar:IsA("Model") then
                if folderOrChar ~= myChar and folderOrChar.Name ~= LP.Name and (folderOrChar:FindFirstChild("Head") or folderOrChar:FindFirstChild("HumanoidRootPart")) then
                    seen[folderOrChar] = true
                    table.insert(list, folderOrChar)
                else
                    for _, sub in ipairs(folderOrChar:GetChildren()) do
                        if sub:IsA("Model") and not seen[sub] and sub ~= myChar and sub.Name ~= LP.Name then
                            if sub:FindFirstChild("Head") or sub:FindFirstChild("HumanoidRootPart") then
                                seen[sub] = true
                                table.insert(list, sub)
                            end
                        end
                    end
                end
            elseif folderOrChar:IsA("Folder") then
                for _, sub in ipairs(folderOrChar:GetChildren()) do
                    if sub:IsA("Model") and not seen[sub] and sub ~= myChar and sub.Name ~= LP.Name then
                        if sub:FindFirstChild("Head") or sub:FindFirstChild("HumanoidRootPart") then
                            seen[sub] = true
                            table.insert(list, sub)
                        end
                    end
                end
            end
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and not seen[plr.Character] then
            seen[plr.Character] = true
            table.insert(list, plr.Character)
        end
    end
    CachedCharacterList = list
end

local VisRayParams = RaycastParams.new()
VisRayParams.FilterType = Enum.RaycastFilterType.Exclude
VisRayParams.IgnoreWater = true

local function IsPartVisible(targetPart, charModel)
    if not targetPart or not Camera then
        return false
    end
    local ignore = {Camera}
    local myChar = GetLocalCharacter()
    if myChar then
        table.insert(ignore, myChar)
    end
    VisRayParams.FilterDescendantsInstances = ignore
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local result = Workspace:Raycast(origin, direction, VisRayParams)
    if not result then
        return true
    end
    if charModel and result.Instance:IsDescendantOf(charModel) then
        return true
    end
    return false
end

local ActiveTracerCount = 0

local function SpawnBulletTracer(startPos, endPos)
    if not State.Weapons.BulletTracers then
        return
    end
    if ActiveTracerCount >= 12 then
        return
    end
    if not startPos or not endPos then
        return
    end
    local dist = (endPos - startPos).Magnitude
    if dist < 0.5 then
        return
    end

    ActiveTracerCount = ActiveTracerCount + 1
    local duration = State.Weapons.TracerTime
    local beam = Instance.new("Part")
    beam.Name = "SakuraBulletTracer"
    beam.Anchored = true
    beam.CanCollide = false
    beam.CanQuery = false
    beam.CanTouch = false
    beam.CastShadow = false
    beam.Material = Enum.Material.Neon
    beam.Color = Color3.fromRGB(255, 105, 180)
    beam.Size = Vector3.new(0.09, 0.09, dist)
    beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -dist * 0.5)
    beam.Parent = Workspace

    task.spawn(function()
        local t0 = tick()
        while tick() - t0 < duration do
            local alpha = (tick() - t0) / duration
            if beam and beam.Parent then
                beam.Transparency = alpha
            else
                break
            end
            task.wait(0.03)
        end
        if beam and beam.Parent then
            beam:Destroy()
        end
        ActiveTracerCount = math.max(0, ActiveTracerCount - 1)
    end)
end

local R15Bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

local R6Bones = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"}
}

local ESPObjects = {}
local CachedHealth = {}

local SelfHighlight = Instance.new("Highlight")
SelfHighlight.Name = "SakuraSelfHighlight"
SelfHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
SelfHighlight.FillColor = Color3.fromRGB(55, 177, 218)
SelfHighlight.OutlineColor = Color3.fromRGB(255, 105, 180)
SelfHighlight.FillTransparency = 0.35
SelfHighlight.OutlineTransparency = 0.05
SelfHighlight.Enabled = false
SelfHighlight.Parent = ChamsFolder

local function UpdateSelfChams()
    local myChar = GetLocalCharacter()
    if State.ESP.SelfChams and myChar and IsCharacterAlive(myChar) then
        SelfHighlight.Adornee = myChar
        SelfHighlight.Enabled = true
    else
        SelfHighlight.Enabled = false
        SelfHighlight.Adornee = nil
    end
end

local function GetPlayerColor(char)
    local plr = Players:GetPlayerFromCharacter(char)
    local name = plr and plr.Name or (char and char.Name)
    if name and State.ESP.PlayerColors[name] then
        return State.ESP.PlayerColors[name]
    end
    return State.ESP.BoxColor
end

local CharmPlayersBackup = {}

local function RestoreCharmPlayers(char)
    local backup = CharmPlayersBackup[char]
    if not backup then
        return
    end
    for part, d in pairs(backup) do
        if part and part.Parent then
            pcall(function()
                part.Material = d.M
                part.Transparency = d.T
                part.Color = d.C
                part.Reflectance = d.R
            end)
        end
    end
    CharmPlayersBackup[char] = nil
end

local function ApplyCharmPlayers(char)
    if CharmPlayersBackup[char] then
        return
    end
    local parts = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    local backup = {}
    for _, part in ipairs(parts) do
        backup[part] = {
            M = part.Material,
            T = part.Transparency,
            C = part.Color,
            R = part.Reflectance
        }
    end
    CharmPlayersBackup[char] = backup
    for _, part in ipairs(parts) do
        pcall(function()
            part.Material = Enum.Material.ForceField
            part.Color = State.ESP.CharmColor
            part.Transparency = State.ESP.CharmTransparency
            part.Reflectance = 0
        end)
    end
end

local function UpdateCharmPlayers()
    if not State.ESP.CharmPlayers or not State.ESP.Enabled then
        for char, _ in pairs(CharmPlayersBackup) do
            RestoreCharmPlayers(char)
        end
        return
    end
    local myChar = GetLocalCharacter()
    for _, char in ipairs(CachedCharacterList) do
        if IsCharacterAlive(char) and char ~= myChar then
            local teammate = State.ESP.TeamCheck and IsTeammate(char)
            local hrp = char:FindFirstChild("HumanoidRootPart")
                or char:FindFirstChild("Torso")
                or char:FindFirstChild("UpperTorso")
            local dist = math.huge
            if hrp and Camera then
                dist = (hrp.Position - Camera.CFrame.Position).Magnitude
            end
            if not teammate and dist <= State.ESP.CharmDistance then
                ApplyCharmPlayers(char)
            else
                RestoreCharmPlayers(char)
            end
        else
            RestoreCharmPlayers(char)
        end
    end
    for char, _ in pairs(CharmPlayersBackup) do
        if not char or not char.Parent then
            RestoreCharmPlayers(char)
        end
    end
end

local WeaponChamsPool = {}

local function ClearWeaponChams()
    for _, h in ipairs(WeaponChamsPool) do
        if h and h.Parent then
            pcall(function()
                h:Destroy()
            end)
        end
    end
    WeaponChamsPool = {}
end


local function IsWeaponModelName(n)
    local low = n:lower()
    if low:find("arms") or low:find("viewmodellight") or low:find("camera") then
        return false
    end
    return true
end

local function GetHeldWeaponModels()
    local found = {}
    local seen = {}

    local function add(inst)
        if inst and not seen[inst] then
            seen[inst] = true
            table.insert(found, inst)
        end
    end

    local weapon = GetEquippedWeapon()
    if type(weapon) == "table" then
        for _, field in ipairs({"ViewModel", "Viewmodel", "Model", "CameraModel", "WorldModel"}) do
            local ok, v = pcall(function()
                return weapon[field]
            end)
            if ok and typeof(v) == "Instance" and (v:IsA("Model") or v:IsA("BasePart")) and v.Parent then
                add(v)
            end
        end
        local wName = nil
        pcall(function()
            wName = weapon.Name or weapon.WeaponName or weapon.ClassName
        end)
        if type(wName) == "string" and wName ~= "" and Camera then
            local direct = Camera:FindFirstChild(wName, true)
            if direct then
                add(direct)
            end
            for _, child in ipairs(Camera:GetDescendants()) do
                if child:IsA("Model") and IsWeaponModelName(child.Name) and child.Name:lower():find(wName:lower(), 1, true) then
                    add(child)
                end
            end
        end
    end

    if Camera then
        for _, child in ipairs(Camera:GetDescendants()) do
            if child:IsA("Model") and IsWeaponModelName(child.Name) then
                add(child)
            elseif child:IsA("BasePart") and child.Parent == Camera and IsWeaponModelName(child.Name) then
                add(child)
            end
        end
    end

    local myChar = GetLocalCharacter()
    if myChar then
        for _, child in ipairs(myChar:GetChildren()) do
            if child:IsA("Tool") then
                add(child)
            end
        end
    end

    return found
end

UpdateWeaponHighlight = function()
    ClearWeaponChams()

    if not State.Weapons.WeaponGlow then
        return
    end

    local models = GetHeldWeaponModels()
    if #models == 0 then
        return
    end

    local mode = State.Weapons.WeaponChamsMode
    local col = State.Weapons.WeaponGlowFill
    local outline = State.Weapons.WeaponGlowOutline
    local seen = {}

    for _, model in ipairs(models) do
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "Hitbox" and part.Name ~= "HumanoidRootPart" then
                if part.Name ~= "ViewmodelLight"
                    and not part:FindFirstAncestor("ViewmodelLight") then
                    seen[part] = true
                    pcall(function()
                        if mode == "Highlight" then
                            local h = part:FindFirstChild("WeaponChamsHighlight")
                            if not h then
                                h = Instance.new("Highlight")
                                h.Name = "WeaponChamsHighlight"
                                h.Adornee = part
                                h.Parent = part
                                h.FillTransparency = 0
                                h.OutlineTransparency = 0
                                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                table.insert(WeaponChamsPool, h)
                            end
                            h.FillColor = col
                            h.OutlineColor = outline
                            h.Enabled = true
                        else
                            local h = part:FindFirstChild("WeaponChamsHighlight")
                            if h then
                                h:Destroy()
                            end

                            if mode ~= "Neon" then
                                for _, v in ipairs(part:GetChildren()) do
                                    if v:IsA("SurfaceAppearance") or v:IsA("Texture") or v:IsA("Decal") then
                                        v:Destroy()
                                    end
                                end
                            end

                            if mode == "Glass" then
                                part.Material = Enum.Material.Glass
                                part.Color = col
                                part.Transparency = State.Weapons.WeaponGlassTransparency
                            elseif mode == "ForceField" then
                                part.Material = Enum.Material.ForceField
                                part.Color = col
                                part.Transparency = 0
                            elseif mode == "Metal" then
                                part.Material = Enum.Material.Metal
                                part.Color = col
                                part.Reflectance = State.Weapons.WeaponMetalReflectance
                                part.Transparency = 0
                            elseif mode == "Neon" then
                                part.Material = Enum.Material.Neon
                                part.Color = col
                                part.Transparency = 0
                                for _, v in ipairs(part:GetChildren()) do
                                    if v:IsA("SurfaceAppearance") or v:IsA("Texture") or v:IsA("Decal") then
                                        v:Destroy()
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end

    for i = #WeaponChamsPool, 1, -1 do
        local h = WeaponChamsPool[i]
        if not h or not h.Parent or not seen[h.Adornee] then
            if h then
                pcall(function()
                    h:Destroy()
                end)
            end
            table.remove(WeaponChamsPool, i)
        end
    end
end

ApplyHandsPosition = function()
    if not State.Weapons.HandsEnabled then
        return
    end
    if not Camera then
        return
    end
    local offset = Vector3.new(State.Weapons.HandsX, State.Weapons.HandsY, State.Weapons.HandsZ)
    for _, child in ipairs(Camera:GetChildren()) do
        if child:IsA("Model") then
            local stats = child:FindFirstChild("Stats")
            if stats then
                local def = stats:FindFirstChild("Default")
                if def and def:IsA("Vector3Value") then
                    pcall(function()
                        def.Value = offset
                    end)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.12)
        if State.Weapons.HandsEnabled then
            pcall(ApplyHandsPosition)
        end
    end
end)

pcall(function()
    if Camera then
        Camera.ChildAdded:Connect(function()
            task.wait(0.15)
            if State.Weapons.WeaponGlow then
                UpdateWeaponHighlight()
            end
            if State.Weapons.HandsEnabled then
                ApplyHandsPosition()
            end
        end)
    end
end)

local function CreateESPObject(char)
    if ESPObjects[char] then
        return ESPObjects[char]
    end

    local holder = Instance.new("Folder")
    holder.Name = char.Name
    holder.Parent = ESPCanvas

    local boxFrame = Instance.new("Frame")
    boxFrame.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    boxFrame.BackgroundTransparency = 1
    boxFrame.BorderSizePixel = 0
    boxFrame.Visible = false
    boxFrame.ZIndex = 5
    boxFrame.Parent = holder

    local boxOutline = Instance.new("UIStroke")
    boxOutline.Thickness = 1.5
    boxOutline.Color = Color3.fromRGB(255, 105, 180)
    boxOutline.Parent = boxFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.AnchorPoint = Vector2.new(0.5, 1)
    nameLabel.Size = UDim2.new(0, 160, 0, 14)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.Code
    nameLabel.TextSize = 12
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.2
    nameLabel.Text = char.Name
    nameLabel.Visible = false
    nameLabel.ZIndex = 6
    nameLabel.Parent = holder

    local boneLines = {}
    for i = 1, 14 do
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BorderSizePixel = 0
        line.Visible = false
        line.ZIndex = 4
        line.Parent = holder
        boneLines[i] = line
    end

    local arrowHolder = Instance.new("Frame")
    arrowHolder.Name = "SakuraArrow"
    arrowHolder.BackgroundTransparency = 1
    arrowHolder.Size = UDim2.new(0, 26, 0, 26)
    arrowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    arrowHolder.Visible = false
    arrowHolder.ZIndex = 8
    arrowHolder.Parent = holder

    local arrowParts = {}
    local arrowSteps = 11
    local arrowSize = 30
    local arrowStep = arrowSize / arrowSteps
    for i = 0, arrowSteps - 1 do
        local t = i / (arrowSteps - 1)
        local seg = Instance.new("Frame")
        seg.Name = "SakuraArrowSeg"
        seg.BorderSizePixel = 0
        seg.BackgroundColor3 = Color3.fromRGB(148, 148, 148)
        seg.BackgroundTransparency = 0.08 + 0.87 * t
        seg.Size = UDim2.new(0, math.max(2, math.floor(arrowSize * (0.12 + 0.88 * t) + 0.5)), 0, arrowStep + 1.5)
        seg.AnchorPoint = Vector2.new(0.5, 0.5)
        seg.Position = UDim2.new(0.5, 0, 0.5, -arrowSize * 0.5 + arrowStep * (i + 0.5))
        seg.ZIndex = 9
        seg.Parent = arrowHolder
        table.insert(arrowParts, seg)
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "SakuraChams"
    highlight.Adornee = char
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 90, 175)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.35
    highlight.OutlineTransparency = 0.05
    highlight.Enabled = false
    highlight.Parent = ChamsFolder

    local data = {
        Holder = holder,
        Box = boxFrame,
        BoxStroke = boxOutline,
        Name = nameLabel,
        BoneLines = boneLines,
        Highlight = highlight,
        Arrow = arrowHolder,
        ArrowParts = arrowParts
    }
    ESPObjects[char] = data
    return data
end

local function RemoveESPObject(char)
    local data = ESPObjects[char]
    if data then
        if data.Holder then
            data.Holder:Destroy()
        end
        if data.Highlight then
            data.Highlight:Destroy()
        end
        if data.Arrow then
            data.Arrow:Destroy()
        end
        ESPObjects[char] = nil
        RestoreCharmPlayers(char)
    end
    CachedHealth[char] = nil
end

local function DrawLineFrame(lineFrame, p1, p2)
    local diff = p2 - p1
    local dist = diff.Magnitude
    if dist < 1 then
        lineFrame.Visible = false
        return
    end
    local mid = (p1 + p2) * 0.5
    local angle = math.deg(math.atan2(diff.Y, diff.X))
    lineFrame.Position = UDim2.new(0, mid.X, 0, mid.Y)
    lineFrame.Size = UDim2.new(0, dist, 0, 1.5)
    lineFrame.Rotation = angle
    lineFrame.Visible = true
end

local function GetWallThickness(targetPart, charModel)
    if not Camera or not targetPart then
        return math.huge
    end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local totalDist = direction.Magnitude
    if totalDist < 0.1 then
        return 0
    end
    local dir = direction.Unit
    local ignore = {Camera}
    local myChar = GetLocalCharacter()
    if myChar then
        table.insert(ignore, myChar)
    end
    if charModel then
        table.insert(ignore, charModel)
    end
    VisRayParams.FilterDescendantsInstances = ignore

    local firstHit = Workspace:Raycast(origin, dir * totalDist, VisRayParams)
    if not firstHit then
        return 0
    end
    if charModel and firstHit.Instance:IsDescendantOf(charModel) then
        return 0
    end
    local remaining = totalDist - firstHit.Distance
    if remaining <= 0.15 then
        return remaining
    end
    local secondHit = Workspace:Raycast(firstHit.Position + dir * 0.15, dir * (remaining - 0.15), VisRayParams)
    if not secondHit then
        return remaining
    end
    if charModel and secondHit.Instance:IsDescendantOf(charModel) then
        return remaining
    end
    return totalDist
end

local function PassesWallCheck(cfg, targetPart, charModel, cacheKey)
    local function compute()
        if cfg.AutoWall then
            return GetWallThickness(targetPart, charModel) <= cfg.ShootWallLimit
        end
        if cfg.ShootWall then
            return GetWallThickness(targetPart, charModel) <= cfg.ShootWallLimit
        end
        if not cfg.WallCheck then
            return true
        end
        return IsPartVisible(targetPart, charModel)
    end

    if cacheKey then
        local entry = WallCheckCache[cacheKey]
        if entry and (tick() - entry.t) < 0.12 then
            return entry.v
        end
        local result = compute()
        WallCheckCache[cacheKey] = {t = tick(), v = result}
        return result
    end

    return compute()
end

local CurrentRageTarget = nil
local CurrentSilentTarget = nil

local function UpdateTargets()
    CurrentRageTarget = nil
    CurrentSilentTarget = nil

    if not Camera then
        return
    end

    local screenCenter = Camera.ViewportSize * 0.5
    local bestRageDist = math.huge
    local bestSilentDist = State.SilentAim.FOV

    for _, char in ipairs(CachedCharacterList) do
        if IsCharacterAlive(char) then
            if State.Ragebot.Enabled then
                local passTeam = not State.Ragebot.TeamCheck or not IsTeammate(char)
                if passTeam and KillTargetAllows(char) then
                    local part = char:FindFirstChild(State.Ragebot.Hitbox) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if part then
                        local passWall = PassesWallCheck(State.Ragebot, part, char, "rage_" .. char.Name)
                        if passWall then
                            local worldDist = (Camera.CFrame.Position - part.Position).Magnitude
                            if worldDist < bestRageDist then
                                bestRageDist = worldDist
                                CurrentRageTarget = part
                            end
                        end
                    end
                end
            end

            if State.SilentAim.Enabled then
                local passTeam = not State.SilentAim.TeamCheck or not IsTeammate(char)
                if passTeam and KillTargetAllows(char) then
                    local part = char:FindFirstChild(State.SilentAim.Hitbox) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if part then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen and screenPos.Z > 0 then
                            local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            if dist2D <= bestSilentDist or State.SilentAim.AutoWall then
                                local passWall = PassesWallCheck(State.SilentAim, part, char, "silent_" .. char.Name)
                                if passWall then
                                    bestSilentDist = dist2D
                                    CurrentSilentTarget = part
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local InventoryControllerRef = nil
pcall(function()
    local icMod = ReplicatedStorage:FindFirstChild("Controllers") and ReplicatedStorage.Controllers:FindFirstChild("InventoryController")
    if icMod then
        InventoryControllerRef = require(icMod)
    end
end)

local GetCurrentEquippedFunc = nil
local ShootTablePatched = false

local KillAllTargetPart = nil
local KillAllTargetHumanoid = nil
local KillAllTargetChar = nil
local KillAllTargetName = nil

local function PatchShootWeaponTable(shootWeaponTbl)
    if not shootWeaponTbl or type(shootWeaponTbl) ~= "table" or shootWeaponTbl._sakuraPatched then
        return
    end
    local origSend = rawget(shootWeaponTbl, "Send")
    if type(origSend) ~= "function" then
        return
    end
    shootWeaponTbl._sakuraPatched = true
    ShootTablePatched = true

    pcall(function()
        if setreadonly then
            setreadonly(shootWeaponTbl, false)
        end
        shootWeaponTbl.Send = function(...)
            local args = {...}
            local activeTarget = nil
            if State.Ragebot.Enabled and CurrentRageTarget and CurrentRageTarget.Parent then
                activeTarget = CurrentRageTarget
            elseif State.SilentAim.Enabled and CurrentSilentTarget and CurrentSilentTarget.Parent then
                activeTarget = CurrentSilentTarget
            end

            if args[1] and type(args[1]) == "table" and type(args[1].Bullets) == "table" then
                for _, bullet in pairs(args[1].Bullets) do
                    if type(bullet) == "table" and type(bullet.Hits) == "table" then
                        if State.KillAll.Enabled and KillAllTargetPart and KillAllTargetPart.Parent then
                            local hits = bullet.Hits
                            local firstHit = nil
                            if type(hits) == "table" then
                                for _, hd in pairs(hits) do
                                    if type(hd) == "table" then
                                        firstHit = hd
                                        break
                                    end
                                end
                            end
                            if not firstHit then
                                firstHit = {}
                                if type(hits) ~= "table" then
                                    hits = {}
                                    bullet.Hits = hits
                                end
                                table.insert(hits, firstHit)
                            end
                            firstHit.Instance = KillAllTargetPart
                            firstHit.Position = KillAllTargetPart.Position
                            if KillAllTargetHumanoid then
                                firstHit.Humanoid = KillAllTargetHumanoid
                            end
                            local throughWall = false
                            pcall(function()
                                throughWall = GetWallThickness(KillAllTargetPart, KillAllTargetChar) > 0.05
                            end)
                            local startPos = KillAllTargetPart.Position
                            if Camera then
                                startPos = Camera.CFrame.Position + (Camera.CFrame.LookVector * 1.5) - Vector3.new(0, 0.25, 0)
                            end
                            SpawnBulletTracer(startPos, KillAllTargetPart.Position)
                            PlayHitSound()
                            PushKillFeedIfDead(KillAllTargetChar, throughWall)
                        else
                            for _, hitData in pairs(bullet.Hits) do
                                if type(hitData) == "table" then
                                    if activeTarget then
                                        hitData.Instance = activeTarget
                                        hitData.Position = activeTarget.Position
                                        local aaChar = activeTarget:FindFirstAncestorOfClass("Model")
                                        local aaThrough = false
                                        pcall(function()
                                            aaThrough = GetWallThickness(activeTarget, aaChar) > 0.05
                                        end)
                                        PushKillFeedIfDead(aaChar, aaThrough)
                                    end
                                    if Camera and hitData.Position then
                                        local startOrigin = Camera.CFrame.Position + (Camera.CFrame.LookVector * 1.5) - Vector3.new(0, 0.25, 0)
                                        SpawnBulletTracer(startOrigin, hitData.Position)
                                    end
                                    if activeTarget then
                                        PlayHitSound()
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return origSend(unpack(args))
        end
    end)
end

local function PatchWeaponInstance(weaponObj)
    if not weaponObj or type(weaponObj) ~= "table" then
        return
    end

    pcall(function()
        if setreadonly then
            setreadonly(weaponObj, false)
        end

        if rawget(weaponObj, "FireRate") and not weaponObj._origFireRate then
            weaponObj._origFireRate = weaponObj.FireRate
        end
        if weaponObj._origFireRate then
            if State.Weapons.RapidFire then
                weaponObj.FireRate = math.max(State.Weapons.FireRate, 0.01)
            else
                weaponObj.FireRate = weaponObj._origFireRate
            end
        end

        if not weaponObj._sakuraMethodsPatched then
            weaponObj._sakuraMethodsPatched = true

            if type(weaponObj.setWeaponRecoil) == "function" then
                local origRec = weaponObj.setWeaponRecoil
                weaponObj.setWeaponRecoil = function(...)
                    if State.Weapons.NoRecoil then
                        return
                    end
                    return origRec(...)
                end
            end

            if type(weaponObj.weaponKick) == "function" then
                local origKick = weaponObj.weaponKick
                weaponObj.weaponKick = function(...)
                    if State.Weapons.NoRecoil then
                        return
                    end
                    return origKick(...)
                end
            end

            if type(weaponObj.getTrueSpread) == "function" then
                local origSpread = weaponObj.getTrueSpread
                weaponObj.getTrueSpread = function(...)
                    if State.Weapons.NoSpread then
                        return 0
                    end
                    return origSpread(...)
                end
            end

            if type(weaponObj.shoot) == "function" and type(debug) == "table" and debug.getupvalues then
                pcall(function()
                    for _, uv in pairs(debug.getupvalues(weaponObj.shoot)) do
                        if type(uv) == "table" and rawget(uv, "Inventory") and type(uv.Inventory) == "table" and rawget(uv.Inventory, "ShootWeapon") then
                            PatchShootWeaponTable(uv.Inventory.ShootWeapon)
                            break
                        end
                    end
                end)
            end
        end
    end)
end

local function InitialOneTimeGCScan()
    if type(getgc) ~= "function" then
        return
    end
    pcall(function()
        for _, obj in next, getgc(true) do
            if type(obj) == "table" then
                if rawget(obj, "shoot") and type(obj.shoot) == "function" then
                    PatchWeaponInstance(obj)
                end
                if rawget(obj, "getCurrentEquipped") and type(obj.getCurrentEquipped) == "function" then
                    GetCurrentEquippedFunc = obj.getCurrentEquipped
                end
            end
        end
    end)
end

task.spawn(function()
    task.wait(0.5)
    InitialOneTimeGCScan()
end)

GetEquippedWeapon = function()
    if InventoryControllerRef and InventoryControllerRef.peekCurrentEquippedForMovement then
        local ok, w = pcall(function()
            return InventoryControllerRef.peekCurrentEquippedForMovement()
        end)
        if ok and w then
            return w
        end
    end
    if GetCurrentEquippedFunc and type(debug) == "table" and debug.getupvalue then
        local ok, res = pcall(function()
            return debug.getupvalue(GetCurrentEquippedFunc, 1).CurrentEquipped
        end)
        if ok and res then
            return res
        end
    end
    return nil
end

local function HideObject(obj)
    pcall(function()
        if obj:IsA("GuiObject") then
            obj.Visible = false
        elseif obj:IsA("BasePart") then
            obj.Transparency = 1
            obj.CanCollide = false
            obj.CanQuery = false
            obj.CanTouch = false
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") or obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("PointLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            obj.Enabled = false
        elseif obj:IsA("ColorCorrectionEffect") or obj:IsA("BlurEffect") then
            obj.Enabled = false
        end
    end)
end

local function CleanFlashAndSmoke()
    if State.Misc.AntiFlash then
        pcall(function()
            local pgui = LP:FindFirstChild("PlayerGui")
            local mainGui = pgui and pgui:FindFirstChild("MainGui")
            if mainGui then
                for _, child in ipairs(mainGui:GetDescendants()) do
                    local n = child.Name:lower()
                    if n:find("flash") or n:find("blind") then
                        HideObject(child)
                    end
                end
            end
            for _, eff in ipairs(Lighting:GetDescendants()) do
                local n = eff.Name:lower()
                if n:find("flash") or n:find("blind") then
                    HideObject(eff)
                end
            end
            if Camera then
                for _, eff in ipairs(Camera:GetDescendants()) do
                    local n = eff.Name:lower()
                    if n:find("flash") or n:find("blind") then
                        HideObject(eff)
                    end
                end
            end
        end)
    end

    if State.Misc.AntiSmoke then
        pcall(function()
            for _, folderName in ipairs({"Debris", "Effects", "FX"}) do
                local f = Workspace:FindFirstChild(folderName)
                if f then
                    for _, obj in ipairs(f:GetChildren()) do
                        local n = obj.Name:lower()
                        if n:find("smoke") or n:find("voxel") or n:find("gas") then
                            HideObject(obj)
                            for _, sub in ipairs(obj:GetChildren()) do
                                HideObject(sub)
                            end
                        end
                    end
                end
            end
            for _, obj in ipairs(Workspace:GetChildren()) do
                local n = obj.Name:lower()
                if n:find("smokezone") or n:find("voxelsmoke") or n:find("smoke_zone") then
                    HideObject(obj)
                    for _, sub in ipairs(obj:GetChildren()) do
                        HideObject(sub)
                    end
                end
            end
        end)
    end
end

task.spawn(function()
    while true do
        task.wait(0.45)
        pcall(RefreshCharacterCache)
        pcall(UpdateSelfChams)
        pcall(UpdateWeaponHighlight)
        pcall(ApplyCameraSkinsAndGloves)
        local currentWep = GetEquippedWeapon()
        if currentWep then
            PatchWeaponInstance(currentWep)
        end
        if State.Misc.AntiFlash or State.Misc.AntiSmoke then
            CleanFlashAndSmoke()
        end
    end
end)

local function FireWeaponOnce()
    local myChar = GetLocalCharacter()
    if not myChar or not IsCharacterAlive(myChar) then
        return
    end
    pcall(function()
        local weapon = GetEquippedWeapon()
        if weapon then
            PatchWeaponInstance(weapon)
        end
        if weapon and weapon.shoot then
            if (weapon.IsEquipped == nil or weapon.IsEquipped == true) and (weapon.Rounds == nil or weapon.Rounds > 0) then
                weapon:shoot()
            end
        elseif type(mouse1click) == "function" then
            mouse1click()
        elseif VirtualInputManager then
            local vp = Camera and Camera.ViewportSize or Vector2.new(800, 600)
            VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 0)
        end
    end)
end

task.spawn(function()
    while true do
        local waitDelay = State.Weapons.RapidFire and math.min(State.Ragebot.FireDelay, State.Weapons.FireRate) or State.Ragebot.FireDelay
        task.wait(math.max(waitDelay, 0.04))
        if State.Ragebot.Enabled and CurrentRageTarget and CurrentRageTarget.Parent then
            local myChar = GetLocalCharacter()
            if myChar and IsCharacterAlive(myChar) then
                pcall(function()
                    if not ShootTablePatched and Camera then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, CurrentRageTarget.Position)
                    end
                    FireWeaponOnce()
                end)
            end
        end
    end
end)

local KillAllIndex = 0

task.spawn(function()
    while true do
        task.wait(math.max(State.KillAll.Delay, 0.04))
        if State.KillAll.Enabled then
            local myChar = GetLocalCharacter()
            if myChar and IsCharacterAlive(myChar) then
                local enemies = GetEnemyHitParts()
                if #enemies > 0 then
                    KillAllIndex = (KillAllIndex % #enemies) + 1
                    local entry = enemies[KillAllIndex]
                    local charModel = entry.Part and entry.Part:FindFirstAncestorOfClass("Model")
                    local plrName = charModel and charModel.Name or nil
                    KillAllTargetPart = entry.Part
                    KillAllTargetHumanoid = entry.Humanoid
                    KillAllTargetChar = charModel
                    KillAllTargetName = plrName
                    pcall(function()
                        if Camera then
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, entry.Part.Position)
                        end
                        FireWeaponOnce()
                    end)
                    task.wait(0.02)
                    if KillAllTargetPart == entry.Part then
                        KillAllTargetPart = nil
                    end
                else
                    KillAllTargetPart = nil
                end
            else
                KillAllTargetPart = nil
            end
        else
            KillAllTargetPart = nil
            KillAllIndex = 0
        end
    end
end)

local function GetMoveDirection()
    if not Camera then
        return Vector3.zero
    end
    local dir = Vector3.zero
    local look = Camera.CFrame.LookVector
    local right = Camera.CFrame.RightVector
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + look end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - look end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - right end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + right end
    local flat = Vector3.new(dir.X, 0, dir.Z)
    if flat.Magnitude > 0.01 then
        return flat.Unit
    end
    local myChar = GetLocalCharacter()
    if myChar then
        local hum = myChar:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0.01 then
            return Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit
        end
    end
    return Vector3.zero
end

local JitterFlip = false
local SpinAngle = 0
local CurrentAntiAimYaw = 0

local function IsHumanoidUsable(hum)
    if not hum then
        return false
    end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Dead
        or st == Enum.HumanoidStateType.Seated
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.PlatformStanding
        or st == Enum.HumanoidStateType.FallingDown
        or st == Enum.HumanoidStateType.GettingUp
        or st == Enum.HumanoidStateType.Tripped
        or st == Enum.HumanoidStateType.Climbing
        or st == Enum.HumanoidStateType.Swimming then
        return false
    end
    return true
end

local GroundRayParams = RaycastParams.new()
GroundRayParams.FilterType = Enum.RaycastFilterType.Exclude
GroundRayParams.IgnoreWater = true

local function IsOnGround(char, hrp)
    if not char or not hrp then
        return false
    end
    GroundRayParams.FilterDescendantsInstances = {char, Camera}
    local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, -4.5, 0), GroundRayParams)
    return hit ~= nil
end

local AntiAimModeDefs = {
    ["jitter"] = { Yaw = "jitter", Pitch = "none" },
    ["spin"] = { Yaw = "spin", Pitch = "none" },
    ["backwares"] = { Yaw = "back", Pitch = "none" },
    ["jitter-backwares"] = { Yaw = "backjitter", Pitch = "none" },
    ["goodluck"] = { Yaw = "goodluck", Pitch = "none" },
    ["backwares-jitter-down"] = { Yaw = "backjitter", Pitch = "down" },
    ["backwares-jitter-up"] = { Yaw = "backjitter", Pitch = "up" },
    ["backwares-down"] = { Yaw = "back", Pitch = "down" },
    ["backwares-up"] = { Yaw = "back", Pitch = "up" },
    ["jitter-down"] = { Yaw = "jitter", Pitch = "down" },
    ["jitter-up"] = { Yaw = "jitter", Pitch = "up" },
    ["down-up"] = { Yaw = "back", Pitch = "downup" },
    ["spin-down"] = { Yaw = "spin", Pitch = "down" }
}

local function GetAntiAimModeDef()
    return AntiAimModeDefs[State.AntiAim.Mode] or AntiAimModeDefs["jitter"]
end

local function GetAntiAimPitchDeg(hum, char, hrp)
    if not IsHumanoidUsable(hum) then
        return 0
    end
    local pitchType = GetAntiAimModeDef().Pitch
    if pitchType == "none" then
        return 0
    end

    local wantDown = false
    if pitchType == "down" then
        wantDown = true
    elseif pitchType == "up" then
        wantDown = false
    elseif pitchType == "downup" then
        wantDown = JitterFlip
    else
        return 0
    end

    local magnitude = State.AntiAim.PitchAngle
    if IsOnGround(char, hrp) and magnitude > 35 then
        magnitude = 35
    end
    if wantDown then
        return -magnitude
    end
    return magnitude
end

local function SetAntiAimCFrame(hrp, hum, char)
    if not hrp then
        return
    end
    local pitch = GetAntiAimPitchDeg(hum, char, hrp)
    if pitch == 0 then
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, CurrentAntiAimYaw, 0)
        return
    end

    local hipHeight = 3
    if hum and hum.HipHeight and hum.HipHeight > 0.5 then
        hipHeight = hum.HipHeight
    end
    GroundRayParams.FilterDescendantsInstances = {char, Camera}
    local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, -14, 0), GroundRayParams)
    if hit then
        local d = hrp.Position.Y - hit.Position.Y
        if d > 0.5 and d < 14 then
            hipHeight = d
        end
    end

    hrp.CFrame = CFrame.new(hrp.Position - Vector3.new(0, hipHeight, 0))
        * CFrame.Angles(0, CurrentAntiAimYaw, 0)
        * CFrame.Angles(math.rad(pitch), 0, 0)
        * CFrame.new(0, hipHeight, 0)
end

local function ApplyAntiAimToCharacter(dt)
    if not State.AntiAim.Enabled or not Camera then
        return
    end
    local myChar = GetLocalCharacter()
    if not myChar then
        return
    end
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not hrp then
        return
    end

    pcall(function()
        UserSettings():GetService("UserGameSettings").RotationType = Enum.RotationType.MovementRelative
    end)

    if hum then
        hum.AutoRotate = false
    end

    local look = Camera.CFrame.LookVector
    local baseYaw = math.atan2(-look.X, -look.Z)
    local offsetDeg = 0
    JitterFlip = not JitterFlip

    local modeDef = GetAntiAimModeDef()
    local yawType = modeDef.Yaw
    if yawType == "spin" then
        SpinAngle = (SpinAngle + dt * State.AntiAim.SpinSpeed) % 360
        offsetDeg = SpinAngle
    elseif yawType == "back" then
        offsetDeg = 180
    elseif yawType == "jitter" then
        offsetDeg = JitterFlip and State.AntiAim.JitterAngle or -State.AntiAim.JitterAngle
    elseif yawType == "backjitter" then
        offsetDeg = 180 + (JitterFlip and State.AntiAim.JitterAngle or -State.AntiAim.JitterAngle)
    elseif yawType == "goodluck" then
        local md = GetMoveDirection()
        if md.Magnitude > 0.01 then
            local look = Camera.CFrame.LookVector
            local right = Camera.CFrame.RightVector
            local fwd = Vector3.new(look.X, 0, look.Z)
            local rgt = Vector3.new(right.X, 0, right.Z)
            if fwd.Magnitude > 0.001 then
                fwd = fwd.Unit
            end
            if rgt.Magnitude > 0.001 then
                rgt = rgt.Unit
            end
            local dotF = md.X * fwd.X + md.Z * fwd.Z
            local dotR = md.X * rgt.X + md.Z * rgt.Z
            if dotR < -0.4 then
                offsetDeg = -90
            elseif dotR > 0.4 then
                offsetDeg = 90
            elseif dotF > 0.4 then
                offsetDeg = 180
            else
                offsetDeg = 0
            end
        else
            offsetDeg = 180
        end
    end

    CurrentAntiAimYaw = baseYaw + math.rad(offsetDeg)
    SetAntiAimCFrame(hrp, hum, myChar)
end

local function GetCurrentPitchDeg()
    local myChar = GetLocalCharacter()
    if not myChar then
        return 0
    end
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then
        return 0
    end
    return GetAntiAimPitchDeg(hum, myChar, hrp)
end

local function ApplyCameraPitchCFrame(cf)
    if not cf then
        return cf
    end
    local deg = GetCurrentPitchDeg()
    if deg == 0 then
        return cf
    end
    local lv = cf.LookVector
    local flat = Vector3.new(lv.X, 0, lv.Z)
    if flat.Magnitude < 0.001 then
        flat = Vector3.new(0, 0, -1)
    end
    flat = flat.Unit
    local yaw = math.atan2(-flat.X, -flat.Z)
    return CFrame.new(cf.Position) * CFrame.Angles(math.rad(deg), yaw, 0)
end

local function ForceCameraPitch()
    if not Camera or CameraPitchLock then
        return
    end
    if not State.AntiAim.Enabled or not State.AntiAim.CameraPitch then
        return
    end
    local newCF = ApplyCameraPitchCFrame(Camera.CFrame)
    if not newCF or newCF == Camera.CFrame then
        return
    end
    CameraPitchLock = true
    pcall(function()
        Camera.CFrame = newCF
    end)
    CameraPitchLock = false
end

pcall(function()
    if Camera then
        Camera:GetPropertyChangedSignal("CFrame"):Connect(function()
            if State.AntiAim.Enabled and State.AntiAim.CameraPitch then
                ForceCameraPitch()
            end
        end)
    end
end)

pcall(function()
    RunService:BindToRenderStep("SakuraAntiAimStep", Enum.RenderPriority.Last.Value + 50, function(dt)
        ApplyAntiAimToCharacter(dt)
        ForceCameraPitch()
    end)
end)

pcall(function()
    RunService.PostSimulation:Connect(function()
        if State.AntiAim.Enabled then
            local myChar = GetLocalCharacter()
            if myChar then
                local hrp = myChar:FindFirstChild("HumanoidRootPart")
                local hum = myChar:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    SetAntiAimCFrame(hrp, hum, myChar)
                end
            end
            ForceCameraPitch()
        end
    end)
end)

local BhopRayParams = RaycastParams.new()
BhopRayParams.FilterType = Enum.RaycastFilterType.Exclude
BhopRayParams.IgnoreWater = true

local LastBhopJump = 0
local WalkSpeedBypassInstalled = false

InstallWalkSpeedBypass = function()
    if WalkSpeedBypassInstalled then
        return true
    end
    local ok = pcall(function()
        if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then
            return false
        end
        local mt = getrawmetatable(game)
        if not mt then
            return false
        end
        local oldindex = rawget(mt, "__index")
        if type(oldindex) ~= "function" then
            return false
        end
        setreadonly(mt, false)
        local replacement
        if type(newcclosure) == "function" then
            replacement = newcclosure(function(self, key)
                if key == "WalkSpeed" and State.Misc.SpeedHack and State.Misc.SpeedBypass then
                    local okc, isHum = pcall(function()
                        return typeof(self) == "Instance" and self:IsA("Humanoid")
                    end)
                    if okc and isHum then
                        return 16
                    end
                end
                return oldindex(self, key)
            end)
        else
            replacement = function(self, key)
                if key == "WalkSpeed" and State.Misc.SpeedHack and State.Misc.SpeedBypass then
                    local okc, isHum = pcall(function()
                        return typeof(self) == "Instance" and self:IsA("Humanoid")
                    end)
                    if okc and isHum then
                        return 16
                    end
                end
                return oldindex(self, key)
            end
        end
        mt.__index = replacement
        return true
    end)
    if ok then
        WalkSpeedBypassInstalled = true
    end
    return ok
end

local function IsCharacterGrounded(char, hrp, hum)
    if hum and hum.FloorMaterial ~= nil and hum.FloorMaterial ~= Enum.Material.Air then
        return true
    end
    if not hrp then
        return false
    end
    BhopRayParams.FilterDescendantsInstances = {char, Camera}
    for _, dist in ipairs({3.5, 6.0, 10.0, 16.0}) do
        local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, -dist, 0), BhopRayParams)
        if hit then
            return true
        end
    end
    return false
end

local function ForceJump(hum, hrp)
    if not hum then
        return
    end
    pcall(function()
        hum.Sit = false
    end)
    pcall(function()
        hum.PlatformStand = false
    end)
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end)
    pcall(function()
        hum.UseJumpPower = true
        hum.JumpPower = State.Misc.JumpPower
    end)
    hum.Jump = true
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    if hrp then
        local vel = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, State.Misc.JumpPower, vel.Z)
    end
end

local function ApplyBunnyHop()
    local myChar = GetLocalCharacter()
    if not myChar then
        return
    end
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then
        return
    end

    local wantsBhop = UserInputService:IsKeyDown(Enum.KeyCode.Space)
        or (UserInputService.TouchEnabled and GetMoveDirection().Magnitude > 0.1)
    if not wantsBhop then
        return
    end

    pcall(function()
        hum.Sit = false
    end)
    pcall(function()
        hum.PlatformStand = false
    end)

    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        BhopRayParams.FilterDescendantsInstances = {myChar}
        local groundHit = Workspace:Raycast(hrp.Position, Vector3.new(0, -4, 0), BhopRayParams)
        if groundHit then
            pcall(function()
                hum.UseJumpPower = true
                hum.JumpPower = State.Misc.JumpPower
            end)
            hum.Jump = true
        end
    end

    local moveDir = GetMoveDirection()
    if moveDir.Magnitude > 0 then
        local targetSpeed = math.clamp(State.Misc.BhopSpeed, 5, 30)
        local dir = moveDir * targetSpeed
        local vel = hrp.AssemblyLinearVelocity
        local nx = vel.X + (dir.X - vel.X) * 0.2
        local nz = vel.Z + (dir.Z - vel.Z) * 0.2
        hrp.AssemblyLinearVelocity = Vector3.new(nx, vel.Y, nz)
    end

    if State.Misc.BhopStrafe then
        local grounded = false
        pcall(function()
            BhopRayParams.FilterDescendantsInstances = {myChar}
            grounded = Workspace:Raycast(hrp.Position, Vector3.new(0, -4, 0), BhopRayParams) ~= nil
        end)
        if not grounded then
            local vel = hrp.AssemblyLinearVelocity
            local flat = Vector3.new(vel.X, 0, vel.Z)
            local speed = flat.Magnitude
            if speed > 0.6 then
                local wish = nil
                local md = GetMoveDirection()
                if md.Magnitude > 0.1 then
                    wish = Vector3.new(md.X, 0, md.Z).Unit
                else
                    wish = flat.Unit
                end
                local curYaw = math.atan2(flat.X, flat.Z)
                local wishYaw = math.atan2(wish.X, wish.Z)
                local delta = wishYaw - curYaw
                delta = (delta + math.pi) % (2 * math.pi) - math.pi
                local maxStep = math.rad(math.clamp(State.Misc.BhopStrafeRate, 1, 60))
                if delta > maxStep then
                    delta = maxStep
                elseif delta < -maxStep then
                    delta = -maxStep
                end
                local newYaw = curYaw + delta
                hrp.AssemblyLinearVelocity = Vector3.new(math.sin(newYaw) * speed, vel.Y, math.cos(newYaw) * speed)
            end
        end
    end
end

local function ApplySpeedHack()
    if State.Misc.SpeedBypass then
        InstallWalkSpeedBypass()
    end
    local myChar = GetLocalCharacter()
    if not myChar then
        return
    end
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then
        return
    end

    hum.WalkSpeed = State.Misc.SpeedValue

    local moveDir = GetMoveDirection()
    if moveDir.Magnitude <= 0.01 then
        local md = hum.MoveDirection
        if md and md.Magnitude > 0.01 then
            moveDir = Vector3.new(md.X, 0, md.Z).Unit
        end
    end

    if moveDir.Magnitude > 0.01 then
        local vel = hrp.AssemblyLinearVelocity
        local targetX = moveDir.X * State.Misc.SpeedValue
        local targetZ = moveDir.Z * State.Misc.SpeedValue
        if State.Misc.SpeedInstant then
            hrp.AssemblyLinearVelocity = Vector3.new(targetX, vel.Y, targetZ)
        else
            local nx = vel.X + (targetX - vel.X) * 0.55
            local nz = vel.Z + (targetZ - vel.Z) * 0.55
            hrp.AssemblyLinearVelocity = Vector3.new(nx, vel.Y, nz)
        end
    end
end

ApplyAirStuck = function()
    local myChar = GetLocalCharacter()
    if not myChar then
        return
    end
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then
        return
    end
    pcall(function()
        hum.PlatformStand = true
        hum.AutoRotate = false
        hum.Sit = false
    end)
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    pcall(function()
        if hum:GetState() ~= Enum.HumanoidStateType.PlatformStanding then
            hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
        end
    end)
end

ReleaseAirStuck = function()
    local myChar = GetLocalCharacter()
    if not myChar then
        return
    end
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not hum then
        return
    end
    pcall(function()
        hum.PlatformStand = false
        hum.AutoRotate = true
    end)
end

ModelChangerOptions = {"Reset"}

local OriginalModelRef = nil
local OriginalModelParent = nil
local CurrentModelClone = nil

RefreshModelChangerOptions = function()
    local names = {"Reset"}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            table.insert(names, plr.Name)
        end
    end
    table.sort(names, function(a, b)
        if a == "Reset" then return true end
        if b == "Reset" then return false end
        return a < b
    end)
    for i = #ModelChangerOptions, 1, -1 do
        ModelChangerOptions[i] = nil
    end
    for i, n in ipairs(names) do
        ModelChangerOptions[i] = n
    end
end

RefreshModelChangerOptions()

RestoreOriginalModel = function()
    if CurrentModelClone then
        pcall(function()
            CurrentModelClone:Destroy()
        end)
        CurrentModelClone = nil
    end
    if OriginalModelRef and OriginalModelRef.Parent == nil then
        pcall(function()
            OriginalModelRef.Parent = OriginalModelParent
        end)
    end
    if OriginalModelRef and OriginalModelRef.Parent then
        pcall(function()
            LP.Character = OriginalModelRef
            local hum = OriginalModelRef:FindFirstChildOfClass("Humanoid")
            if hum then
                Camera.CameraSubject = hum
            end
        end)
    end
    OriginalModelRef = nil
    OriginalModelParent = nil
end

ApplyModelChanger = function()
    local targetName = State.Misc.ModelTarget
    if targetName == "" or targetName == "Reset" then
        RestoreOriginalModel()
        return
    end

    local myChar = GetLocalCharacter()
    if not myChar or not myChar.Parent then
        return
    end
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    local targetChar = nil
    local targetPlr = Players:FindFirstChild(targetName)
    if targetPlr then
        targetChar = targetPlr.Character
    end
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        targetChar = Workspace:FindFirstChild(targetName, true)
    end
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        return
    end
    if CurrentModelClone and CurrentModelClone:GetAttribute("SakuraSource") == targetName then
        return
    end

    if not OriginalModelRef then
        OriginalModelRef = myChar
        OriginalModelParent = myChar.Parent
    end

    if CurrentModelClone then
        pcall(function()
            CurrentModelClone:Destroy()
        end)
        CurrentModelClone = nil
    end

    local clone = targetChar:Clone()
    clone.Name = LP.Name
    clone:SetAttribute("SakuraSource", targetName)
    CurrentModelClone = clone

    for _, obj in ipairs(clone:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function()
                obj.Anchored = false
                obj.CanCollide = true
            end)
        elseif obj:IsA("Script") or obj:IsA("LocalScript") then
            pcall(function()
                obj:Destroy()
            end)
        end
    end

    pcall(function()
        clone:PivotTo(hrp.CFrame)
    end)
    clone.Parent = Workspace

    pcall(function()
        LP.Character = clone
    end)
    pcall(function()
        local hum = clone:FindFirstChildOfClass("Humanoid")
        if hum then
            Camera.CameraSubject = hum
        end
    end)
    PushKillFeed("model: " .. targetName, Color3.fromRGB(255, 105, 180))
end

task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if State.Misc.ModelChanger then
                if CurrentModelClone and CurrentModelClone.Parent == nil then
                    CurrentModelClone = nil
                end
                if OriginalModelRef and OriginalModelRef.Parent == nil then
                    OriginalModelRef = nil
                    OriginalModelParent = nil
                end
                RefreshModelChangerOptions()
                ApplyModelChanger()
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if State.Misc.AirStuck then
        pcall(ApplyAirStuck)
    end

    if State.AntiAim.Enabled then
        local myChar = GetLocalCharacter()
        if myChar then
            local hrp = myChar:FindFirstChild("HumanoidRootPart")
            local hum = myChar:FindFirstChildOfClass("Humanoid")
            if hrp and hum and IsHumanoidUsable(hum) then
                SetAntiAimCFrame(hrp, hum, myChar)
            end
        end
    end

    if not State.Misc.AirStuck then
        if State.Misc.BunnyHop then
            pcall(ApplyBunnyHop)
        end

        if State.Misc.SpeedHack then
            pcall(ApplySpeedHack)
        end
    elseif State.Misc.SpeedBypass then
        InstallWalkSpeedBypass()
    end

    pcall(function()
        local myChar = GetLocalCharacter()
        if not myChar then
            MoveDebugText = "no character"
            return
        end
        local hrp = myChar:FindFirstChild("HumanoidRootPart")
        local hum = myChar:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then
            MoveDebugText = "no hrp/hum"
            return
        end
        local st = tostring(hum:GetState()):gsub("Enum.HumanoidStateType.", "")
        local g = IsCharacterGrounded(myChar, hrp, hum)
        local pitchVal = 0
        if State.AntiAim.Enabled then
            pitchVal = GetAntiAimPitchDeg(hum, myChar, hrp)
        end
        MoveDebugText = "state: " .. st
            .. " | ground: " .. tostring(g)
            .. " | pitch: " .. tostring(math.floor(pitchVal + 0.5))
            .. " | mode: " .. tostring(State.AntiAim.Mode) .. "/" .. tostring(GetAntiAimModeDef().Pitch)
            .. " | ws: " .. tostring(math.floor(hum.WalkSpeed + 0.5))
    end)
end)

local ThirdPersonRenderConn = nil
local LastTransparencyFix = 0

local function HideViewmodelParts()
    if not State.Misc.HideViewmodel then
        return
    end
    if not Camera then
        return
    end
    for _, obj in ipairs(Camera:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function()
                obj.LocalTransparencyModifier = 1
            end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function()
                obj.Transparency = 1
            end)
        end
    end
end

local function ShowViewmodelParts()
    if not Camera then
        return
    end
    for _, obj in ipairs(Camera:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function()
                obj.LocalTransparencyModifier = 0
            end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function()
                obj.Transparency = 0
            end)
        end
    end
end

local function FixLocalCharacterVisibility()
    local myChar = GetLocalCharacter()
    if not myChar then
        return
    end
    for _, obj in ipairs(myChar:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function()
                obj.LocalTransparencyModifier = 0
                if obj.Transparency >= 1 then
                    obj.Transparency = 0
                end
            end)
        elseif obj:IsA("Decal") then
            pcall(function()
                obj.Transparency = 0
            end)
        end
    end
end

pcall(function()
    if Camera then
        Camera.DescendantAdded:Connect(function()
            if not State.Misc.ThirdPerson then
                return
            end
            task.defer(function()
                if State.Misc.ThirdPerson then
                    HideViewmodelParts()
                end
            end)
        end)
    end
end)

ApplyThirdPerson = function()
    pcall(function()
        Camera = Workspace.CurrentCamera
        if not Camera then
            return
        end
        local myChar = GetLocalCharacter()
        local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if hum then
            Camera.CameraSubject = hum
            hum.CameraOffset = Vector3.zero
        end
        Camera.CameraType = Enum.CameraType.Custom
        LP.CameraMode = Enum.CameraMode.Classic
        LP.CameraMinZoomDistance = State.Misc.ThirdPersonDist
        LP.CameraMaxZoomDistance = State.Misc.ThirdPersonDist
        FixLocalCharacterVisibility()
        HideViewmodelParts()
    end)
end

ResetThirdPerson = function()
    pcall(function()
        Camera = Workspace.CurrentCamera
        if not Camera then
            return
        end
        local myChar = GetLocalCharacter()
        local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        LP.CameraMode = Enum.CameraMode.LockFirstPerson
        LP.CameraMinZoomDistance = 0.5
        LP.CameraMaxZoomDistance = 0.5
        if hum then
            Camera.CameraSubject = hum
        end
        ShowViewmodelParts()
    end)
end

RefreshThirdPersonConnection = function()
    if ThirdPersonRenderConn then
        ThirdPersonRenderConn:Disconnect()
        ThirdPersonRenderConn = nil
    end
    ThirdPersonRenderConn = RunService.RenderStepped:Connect(function()
        if State.Misc.ThirdPerson then
            ApplyThirdPerson()
        end
    end)
end

pcall(function()
    RunService:UnbindFromRenderStep("SakuraThirdPerson")
    RunService:BindToRenderStep("SakuraThirdPerson", Enum.RenderPriority.Last.Value + 100, function()
        if State.Misc.ThirdPerson then
            ApplyThirdPerson()
        end
    end)
end)

pcall(function()
    if Camera then
        Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
            if State.Misc.ThirdPerson then
                ApplyThirdPerson()
            end
        end)
        Camera:GetPropertyChangedSignal("CameraType"):Connect(function()
            if State.Misc.ThirdPerson then
                ApplyThirdPerson()
            end
        end)
        LP:GetPropertyChangedSignal("CameraMode"):Connect(function()
            if State.Misc.ThirdPerson then
                ApplyThirdPerson()
            end
        end)
    end
end)

RefreshThirdPersonConnection()

LP.CharacterAdded:Connect(function()
    task.wait(0.7)
    if State.Misc.ThirdPerson then
        RefreshThirdPersonConnection()
        ApplyThirdPerson()
    end
end)

local FPSFrames = 0
local FPSLastTick = tick()
local CurrentFPS = 60
local LastTargetTick = 0

RunService.RenderStepped:Connect(function(dt)
    Camera = Workspace.CurrentCamera
    FPSFrames = FPSFrames + 1
    local now = tick()
    if now - FPSLastTick >= 0.5 then
        CurrentFPS = math.floor(FPSFrames / (now - FPSLastTick) + 0.5)
        FPSFrames = 0
        FPSLastTick = now
        WatermarkLabel.Text = "sakura.for.gays | " .. LP.Name .. " | " .. tostring(CurrentFPS) .. " FPS"
    end

    if State.Misc.ThirdPerson and ApplyThirdPerson then
        ApplyThirdPerson()
    end

    FOVCircleFrame.Visible = State.SilentAim.Enabled and State.SilentAim.ShowFOV
    if FOVCircleFrame.Visible then
        local d = State.SilentAim.FOV * 2
        FOVCircleFrame.Size = UDim2.new(0, d, 0, d)
    end

    if MovementDebugLabel then
        MovementDebugLabel.Text = MoveDebugText
    end

    if now - LastTargetTick >= 0.033 then
        LastTargetTick = now
        UpdateTargets()
    end

    local activeChars = {}

    for _, char in ipairs(CachedCharacterList) do
        activeChars[char] = true
        local esp = CreateESPObject(char)
        local alive = IsCharacterAlive(char)
        local teammate = IsTeammate(char)

        local curHp = char:GetAttribute("Health")
        if curHp ~= nil then
            local prevHp = CachedHealth[char]
            if prevHp ~= nil and curHp < prevHp and not teammate and Camera then
                PlayHitSound()
                local headOrRoot = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if headOrRoot and not ShootTablePatched then
                    local startOrigin = Camera.CFrame.Position + (Camera.CFrame.LookVector * 1.5) - Vector3.new(0, 0.25, 0)
                    SpawnBulletTracer(startOrigin, headOrRoot.Position)
                end
                if prevHp > 0 and curHp <= 0 then
                    OnEnemyKilled(char)
                end
            end
            CachedHealth[char] = curHp
        end

        local filteredOut = State.ESP.TeamCheck and teammate

        if not alive or filteredOut or not State.ESP.Enabled then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Highlight.Enabled = false
            esp.Arrow.Visible = false
            for _, l in ipairs(esp.BoneLines) do
                l.Visible = false
            end
        else
            local plrColor = GetPlayerColor(char)
            esp.Highlight.Adornee = char
            esp.Highlight.Enabled = State.ESP.Chams
            esp.Highlight.FillColor = State.ESP.ChamsColor
            esp.Highlight.OutlineColor = plrColor
            esp.Box.BackgroundColor3 = plrColor
            esp.BoxStroke.Color = plrColor
            esp.Name.TextColor3 = plrColor
            for _, l in ipairs(esp.BoneLines) do
                l.BackgroundColor3 = plrColor
            end
            local arrowColor = State.ESP.ArrowColor
            local arrowCount = #esp.ArrowParts
            for ai = 1, arrowCount do
                local at = (ai - 1) / math.max(1, arrowCount - 1)
                local ag = 0.58 + 0.42 * at
                esp.ArrowParts[ai].BackgroundColor3 = Color3.new(arrowColor.R * ag, arrowColor.G * ag, arrowColor.B * ag)
                esp.ArrowParts[ai].BackgroundTransparency = 0.08 + 0.87 * at
            end

            local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            local head = char:FindFirstChild("Head")

            if hrp and head and Camera then
                local topWorld = head.Position + Vector3.new(0, 0.65, 0)
                local bottomWorld = hrp.Position - Vector3.new(0, 2.85, 0)
                local topScreen, topVis = Camera:WorldToViewportPoint(topWorld)
                local botScreen, botVis = Camera:WorldToViewportPoint(bottomWorld)

                if (topVis or botVis) and topScreen.Z > 0 and botScreen.Z > 0 then
                    local boxHeight = math.abs(botScreen.Y - topScreen.Y)
                    local boxWidth = boxHeight * 0.62
                    local centerX = (topScreen.X + botScreen.X) * 0.5
                    local topY = math.min(topScreen.Y, botScreen.Y)

                    if State.ESP.Box or State.ESP.BoxFilled then
                        esp.Box.Position = UDim2.new(0, centerX - boxWidth * 0.5, 0, topY)
                        esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                        esp.Box.BackgroundTransparency = State.ESP.BoxFilled and 0.65 or 1
                        esp.BoxStroke.Enabled = State.ESP.Box
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end

                    if State.ESP.Nickname then
                        local plr = Players:GetPlayerFromCharacter(char)
                        esp.Name.Text = (plr and plr.DisplayName) or char.Name
                        esp.Name.Position = UDim2.new(0, centerX, 0, topY - 2)
                        esp.Name.Visible = true
                    else
                        esp.Name.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.Name.Visible = false
                end

                if State.ESP.Skeleton then
                    local isR15 = char:FindFirstChild("UpperTorso") ~= nil
                    local bones = isR15 and R15Bones or R6Bones
                    for i = 1, #esp.BoneLines do
                        local line = esp.BoneLines[i]
                        local pair = bones[i]
                        if pair then
                            local pA = char:FindFirstChild(pair[1])
                            local pB = char:FindFirstChild(pair[2])
                            if pA and pB then
                                local sA, vA = Camera:WorldToViewportPoint(pA.Position)
                                local sB, vB = Camera:WorldToViewportPoint(pB.Position)
                                if (vA or vB) and sA.Z > 0 and sB.Z > 0 then
                                    DrawLineFrame(line, Vector2.new(sA.X, sA.Y), Vector2.new(sB.X, sB.Y))
                                else
                                    line.Visible = false
                                end
                            else
                                line.Visible = false
                            end
                        else
                            line.Visible = false
                        end
                    end
                else
                    for _, l in ipairs(esp.BoneLines) do
                        l.Visible = false
                    end
                end
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                for _, l in ipairs(esp.BoneLines) do
                    l.Visible = false
                end
            end

            if State.ESP.Arrows and Camera then
                local arrowTarget = char:FindFirstChild("HumanoidRootPart")
                    or char:FindFirstChild("Torso")
                    or char:FindFirstChild("UpperTorso")
                local arrowShow = false
                if arrowTarget then
                    local sp, onScr = Camera:WorldToViewportPoint(arrowTarget.Position)
                    if (not onScr) or sp.Z <= 0 then
                        arrowShow = true
                    end
                end
                if arrowShow then
                    local rel = arrowTarget.Position - Camera.CFrame.Position
                    local lp = Camera.CFrame:VectorToObjectSpace(rel)
                    local dx = lp.X
                    local dy = -lp.Y
                    local len = math.sqrt(dx * dx + dy * dy)
                    if len < 0.001 then
                        len = 0.001
                    end
                    local nx = dx / len
                    local ny = dy / len
                    local vp = Camera.ViewportSize
                    local radius = math.min(vp.X, vp.Y) * 0.5 - 48
                    if radius < 44 then
                        radius = 44
                    end
                    esp.Arrow.Position = UDim2.new(0, vp.X * 0.5 + nx * radius, 0, vp.Y * 0.5 + ny * radius)
                    esp.Arrow.Rotation = math.deg(math.atan2(ny, nx)) + 90
                    esp.Arrow.Visible = true
                else
                    esp.Arrow.Visible = false
                end
            else
                esp.Arrow.Visible = false
            end
        end
    end

    pcall(UpdateCharmPlayers)

    for char, _ in pairs(ESPObjects) do
        if not activeChars[char] then
            RemoveESPObject(char)
        end
    end
end)
