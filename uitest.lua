--[[
    ╔══════════════════════════════════════════════╗
    ║              SUNUI  v2.0.0                   ║
    ║   Premium Roblox Exploit UI Library          ║
    ╚══════════════════════════════════════════════╝

    Changelog v2.0.0
      • Visual config-restore on element spawn
      • Element Control API  (Set / OnChanged / Refresh)
      • Floating cursor-tracked tooltip system
      • Color Picker Saturation + Value sliders
]]

-- ──────────────────────────────────────────────
--  SERVICES
-- ──────────────────────────────────────────────
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer      = Players.LocalPlayer

-- ──────────────────────────────────────────────
--  GLOBAL GUARD
-- ──────────────────────────────────────────────
if getgenv and getgenv().SUNUI then
    local old = getgenv().SUNUI
    if old._gui and old._gui.Parent then old._gui:Destroy() end
end

-- ──────────────────────────────────────────────
--  CONSTANTS
-- ──────────────────────────────────────────────
local CORNER_RADIUS   = UDim.new(0, 8)
local STROKE_THICK    = 1
local TWEEN_FAST      = TweenInfo.new(0.18, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TWEEN_MED       = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local NOTIFY_DURATION = 4
local LOGO_ASSET_ID   = "rbxassetid://7733960981"   -- ← replace with your asset

-- ──────────────────────────────────────────────
--  THEMES
-- ──────────────────────────────────────────────
local THEMES = {
    TrueBlack = {
        Background  = Color3.fromRGB(10,  10,  12),
        Surface     = Color3.fromRGB(18,  18,  22),
        SurfaceAlt  = Color3.fromRGB(26,  26,  32),
        Border      = Color3.fromRGB(45,  45,  55),
        Accent      = Color3.fromRGB(99, 102, 241),
        AccentHover = Color3.fromRGB(129,132,255),
        Text        = Color3.fromRGB(230,230,235),
        TextMuted   = Color3.fromRGB(120,120,135),
        Toggle      = Color3.fromRGB(55,  55,  70),
        ToggleOn    = Color3.fromRGB(99, 102, 241),
        Notify      = Color3.fromRGB(22,  22,  28),
        Tooltip     = Color3.fromRGB(30,  30,  38),
    },
    Graphite = {
        Background  = Color3.fromRGB(24,  24,  28),
        Surface     = Color3.fromRGB(34,  34,  40),
        SurfaceAlt  = Color3.fromRGB(44,  44,  52),
        Border      = Color3.fromRGB(65,  65,  80),
        Accent      = Color3.fromRGB(148,163,184),
        AccentHover = Color3.fromRGB(203,213,225),
        Text        = Color3.fromRGB(226,232,240),
        TextMuted   = Color3.fromRGB(100,116,139),
        Toggle      = Color3.fromRGB(55,  60,  70),
        ToggleOn    = Color3.fromRGB(148,163,184),
        Notify      = Color3.fromRGB(30,  30,  36),
        Tooltip     = Color3.fromRGB(38,  38,  46),
    },
    CosmicPurple = {
        Background  = Color3.fromRGB(10,   8,  20),
        Surface     = Color3.fromRGB(20,  16,  36),
        SurfaceAlt  = Color3.fromRGB(30,  24,  52),
        Border      = Color3.fromRGB(80,  50, 130),
        Accent      = Color3.fromRGB(168, 85, 247),
        AccentHover = Color3.fromRGB(196,130,255),
        Text        = Color3.fromRGB(240,230,255),
        TextMuted   = Color3.fromRGB(130,100,180),
        Toggle      = Color3.fromRGB(50,  35,  80),
        ToggleOn    = Color3.fromRGB(168, 85, 247),
        Notify      = Color3.fromRGB(18,  14,  32),
        Tooltip     = Color3.fromRGB(28,  20,  46),
    },
    Mint = {
        Background  = Color3.fromRGB(8,  18,  18),
        Surface     = Color3.fromRGB(14, 28,  28),
        SurfaceAlt  = Color3.fromRGB(20, 38,  38),
        Border      = Color3.fromRGB(40, 90,  85),
        Accent      = Color3.fromRGB(52,211,153),
        AccentHover = Color3.fromRGB(110,240,190),
        Text        = Color3.fromRGB(220,255,245),
        TextMuted   = Color3.fromRGB(80, 150,130),
        Toggle      = Color3.fromRGB(30,  65,  60),
        ToggleOn    = Color3.fromRGB(52, 211,153),
        Notify      = Color3.fromRGB(12,  24,  24),
        Tooltip     = Color3.fromRGB(14,  32,  30),
    },
}

-- ──────────────────────────────────────────────
--  UTILITY HELPERS
-- ──────────────────────────────────────────────
local function tween(obj, props, info)
    TweenService:Create(obj, info or TWEEN_FAST, props):Play()
end

local function newInstance(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function addCorner(parent, radius)
    return newInstance("UICorner", {CornerRadius = radius or CORNER_RADIUS}, parent)
end

local function addStroke(parent, color, thickness)
    local s = parent:FindFirstChildOfClass("UIStroke")
    if s then s:Destroy() end
    return newInstance("UIStroke", {
        Color           = color,
        Thickness       = thickness or STROKE_THICK,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function addPadding(parent, top, bottom, left, right)
    return newInstance("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 6),
        PaddingBottom = UDim.new(0, bottom or 6),
        PaddingLeft   = UDim.new(0, left   or 8),
        PaddingRight  = UDim.new(0, right  or 8),
    }, parent)
end

local function addListLayout(parent, dir, gap)
    return newInstance("UIListLayout", {
        FillDirection       = dir or Enum.FillDirection.Vertical,
        SortOrder           = Enum.SortOrder.LayoutOrder,
        Padding             = UDim.new(0, gap or 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, parent)
end

-- Generic single-axis slider builder used by multiple elements
-- Returns: sliderFrame, updateFn (rel 0-1 → visual sync)
local function buildHorizSlider(parent, T, trackColor, fillColor, initialRel, onChanged)
    local track = newInstance("Frame", {
        Size             = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = trackColor or T.Toggle,
    }, parent)
    addCorner(track, UDim.new(1, 0))

    local fill = newInstance("Frame", {
        Size             = UDim2.new(initialRel or 0, 0, 1, 0),
        BackgroundColor3 = fillColor or T.Accent,
    }, track)
    addCorner(fill, UDim.new(1, 0))

    local thumb = newInstance("Frame", {
        Size             = UDim2.new(0, 14, 0, 14),
        Position         = UDim2.new(initialRel or 0, -7, 0.5, -7),
        BackgroundColor3 = Color3.new(1, 1, 1),
        ZIndex           = 5,
    }, track)
    addCorner(thumb, UDim.new(1, 0))
    addStroke(thumb, fillColor or T.Accent)

    local function syncVisual(rel)
        fill.Size     = UDim2.new(rel, 0, 1, 0)
        thumb.Position = UDim2.new(rel, -7, 0.5, -7)
    end

    local sliding = false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            -- immediate seek on click
            local rel = math.clamp(
                (inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            syncVisual(rel)
            onChanged(rel)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not sliding then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local rel = math.clamp(
            (inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        syncVisual(rel)
        onChanged(rel)
    end)

    return track, syncVisual, fill, thumb
end

-- ──────────────────────────────────────────────
--  FILE SYSTEM CONFIG HELPERS
-- ──────────────────────────────────────────────
local function fsAvailable()
    return isfile ~= nil and readfile ~= nil and writefile ~= nil and makefolder ~= nil
end

local function jsonEncode(t)
    if syn and syn.json_encode  then return syn.json_encode(t)  end
    if hs  and hs.jsonencode    then return hs.jsonencode(t)    end
    return HttpService:JSONEncode(t)
end

local function jsonDecode(s)
    if syn and syn.json_decode  then return syn.json_decode(s)  end
    if hs  and hs.jsondecode    then return hs.jsondecode(s)    end
    return HttpService:JSONDecode(s)
end

local CONFIG_FOLDER = "SUNUI_Configs"

local function ensureFolder()
    if fsAvailable() and not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
end

local function saveConfig(name, data)
    if not fsAvailable() then return end
    ensureFolder()
    writefile(CONFIG_FOLDER .. "/" .. name .. ".json", jsonEncode(data))
end

local function loadConfig(name)
    if not fsAvailable() then return nil end
    local path = CONFIG_FOLDER .. "/" .. name .. ".json"
    if isfile(path) then
        local ok, result = pcall(jsonDecode, readfile(path))
        if ok then return result end
    end
    return nil
end

-- ──────────────────────────────────────────────
--  LIBRARY STATE
-- ──────────────────────────────────────────────
local SUNUI = {}
SUNUI._flags      = {}
SUNUI._keybinds   = {}
SUNUI._globalKey  = Enum.KeyCode.RightShift
SUNUI._autoSave   = false
SUNUI._autoLoad   = false
SUNUI._configName = "default"
SUNUI._theme      = THEMES.TrueBlack
SUNUI._windows    = {}
SUNUI._gui        = nil
SUNUI._notifyHold = {}
SUNUI._tooltip    = nil   -- tooltip control handle

-- ──────────────────────────────────────────────
--  SCREEN GUI  (protected)
-- ──────────────────────────────────────────────
local function buildScreenGui()
    local sg = newInstance("ScreenGui", {
        Name           = "SUNUI_Root",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999,
        IgnoreGuiInset = true,
    })
    if syn and syn.protect_gui then
        syn.protect_gui(sg)
        sg.Parent = CoreGui
    elseif protect_gui then
        protect_gui(sg)
        sg.Parent = CoreGui
    else
        local ok = pcall(function() sg.Parent = CoreGui end)
        if not ok then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    end
    return sg
end

-- ──────────────────────────────────────────────
--  TOOLTIP SYSTEM
-- ──────────────────────────────────────────────
local function buildTooltip(sg, T)
    local OFFSET_X, OFFSET_Y = 14, 10
    local MAX_WIDTH = 220

    local frame = newInstance("Frame", {
        Name                 = "SUNUI_Tooltip",
        Size                 = UDim2.new(0, 0, 0, 0),
        AutomaticSize        = Enum.AutomaticSize.XY,
        BackgroundColor3     = T.Tooltip,
        BackgroundTransparency = 1,
        ZIndex               = 9999,
        Visible              = true,
    }, sg)
    addCorner(frame, UDim.new(0, 6))
    addStroke(frame, T.Border)
    addPadding(frame, 5, 5, 8, 8)

    local label = newInstance("TextLabel", {
        Size                 = UDim2.new(0, MAX_WIDTH, 0, 0),
        AutomaticSize        = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text                 = "",
        TextColor3           = T.Text,
        Font                 = Enum.Font.Gotham,
        TextSize             = 11,
        TextWrapped          = true,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ZIndex               = 10000,
        RichText             = true,
    }, frame)

    -- Keep a UIStroke reference on the frame so we can tween it
    local stroke = frame:FindFirstChildOfClass("UIStroke")
    if stroke then stroke.Transparency = 1 end

    local visible = false
    local tweenIn  = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenOut = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Mouse tracking via RenderStepped for zero-lag positioning
    RunService.RenderStepped:Connect(function()
        if not visible then return end
        local mouse = UserInputService:GetMouseLocation()
        local vp    = workspace.CurrentCamera.ViewportSize
        local fw    = frame.AbsoluteSize.X
        local fh    = frame.AbsoluteSize.Y
        local px    = mouse.X + OFFSET_X
        local py    = mouse.Y + OFFSET_Y
        if px + fw > vp.X then px = mouse.X - fw - OFFSET_X end
        if py + fh > vp.Y then py = mouse.Y - fh - OFFSET_Y end
        frame.Position = UDim2.new(0, px, 0, py)
    end)

    local handle = {}

    function handle.Show(text)
        if not text or text == "" then return end
        label.Text = text
        visible    = true
        TweenService:Create(frame, tweenIn, {BackgroundTransparency = 0}):Play()
        if stroke then
            TweenService:Create(stroke, tweenIn, {Transparency = 0}):Play()
        end
        TweenService:Create(label, tweenIn, {TextTransparency = 0}):Play()
    end

    function handle.Hide()
        visible = false
        TweenService:Create(frame, tweenOut, {BackgroundTransparency = 1}):Play()
        if stroke then
            TweenService:Create(stroke, tweenOut, {Transparency = 1}):Play()
        end
        TweenService:Create(label, tweenOut, {TextTransparency = 1}):Play()
    end

    -- Start hidden
    frame.BackgroundTransparency  = 1
    label.TextTransparency        = 1
    if stroke then stroke.Transparency = 1 end

    return handle
end

-- Wire tooltip to a GuiObject.  tooltip may be "" — no wiring if so.
local function wireTooltip(lib, guiObj, tooltipText)
    if not tooltipText or tooltipText == "" then return end
    guiObj.MouseEnter:Connect(function()  lib._tooltip and lib._tooltip.Show(tooltipText) end)
    guiObj.MouseLeave:Connect(function()  lib._tooltip and lib._tooltip.Hide()            end)
end

-- ──────────────────────────────────────────────
--  NOTIFICATION SYSTEM
-- ──────────────────────────────────────────────
local function buildNotifyHolder(sg)
    local holder = newInstance("Frame", {
        Name                 = "NotifyHolder",
        AnchorPoint          = Vector2.new(1, 1),
        Position             = UDim2.new(1, -16, 1, -16),
        Size                 = UDim2.new(0, 300, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize        = Enum.AutomaticSize.Y,
    }, sg)
    newInstance("UIListLayout", {
        FillDirection      = Enum.FillDirection.Vertical,
        VerticalAlignment  = Enum.VerticalAlignment.Bottom,
        SortOrder          = Enum.SortOrder.LayoutOrder,
        Padding            = UDim.new(0, 8),
    }, holder)
    return holder
end

function SUNUI:Notify(opts)
    opts = opts or {}
    local title    = opts.Title    or "SUNUI"
    local message  = opts.Message  or ""
    local duration = opts.Duration or NOTIFY_DURATION
    local T        = self._theme
    local holder   = self._notifyHolder
    if not holder then return end

    local card = newInstance("Frame", {
        Name                 = "NotifyCard",
        Size                 = UDim2.new(1, 0, 0, 0),
        AutomaticSize        = Enum.AutomaticSize.Y,
        BackgroundColor3     = T.Notify,
        BackgroundTransparency = 1,
        ClipsDescendants     = true,
    }, holder)
    addCorner(card, UDim.new(0, 8))
    addStroke(card, T.Accent)

    local inner = newInstance("Frame", {
        Size                 = UDim2.new(1, 0, 0, 0),
        AutomaticSize        = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    }, card)
    addPadding(inner, 10, 10, 12, 12)
    addListLayout(inner, Enum.FillDirection.Vertical, 4)

    newInstance("TextLabel", {
        Size                 = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text                 = title,
        TextColor3           = T.Accent,
        Font                 = Enum.Font.GothamBold,
        TextSize             = 13,
        TextXAlignment       = Enum.TextXAlignment.Left,
    }, inner)

    if message ~= "" then
        newInstance("TextLabel", {
            Size                 = UDim2.new(1, 0, 0, 0),
            AutomaticSize        = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text                 = message,
            TextColor3           = T.Text,
            Font                 = Enum.Font.Gotham,
            TextSize             = 12,
            TextWrapped          = true,
            TextXAlignment       = Enum.TextXAlignment.Left,
        }, inner)
    end

    card.Position = UDim2.new(1.1, 0, 0, 0)
    tween(card, {BackgroundTransparency = 0},              TWEEN_MED)
    tween(card, {Position = UDim2.new(0, 0, 0, 0)},       TWEEN_MED)
    table.insert(self._notifyHold, card)

    task.delay(duration, function()
        tween(card, {BackgroundTransparency = 1,
                     Position = UDim2.new(1.1, 0, 0, 0)}, TWEEN_MED)
        task.delay(0.32, function()
            card:Destroy()
            for i, c in ipairs(self._notifyHold) do
                if c == card then table.remove(self._notifyHold, i) break end
            end
        end)
    end)
end

-- ──────────────────────────────────────────────
--  FLOATING TOGGLE BUTTON
-- ──────────────────────────────────────────────
local function buildFloatButton(sg, T, onToggle)
    local btn = newInstance("Frame", {
        Name             = "FloatBtn",
        Size             = UDim2.new(0, 46, 0, 46),
        Position         = UDim2.new(0, 16, 0.5, 0),
        BackgroundColor3 = T.Accent,
        ZIndex           = 100,
    }, sg)
    addCorner(btn, UDim.new(1, 0))
    addStroke(btn, T.AccentHover)

    newInstance("TextLabel", {
        Size                 = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                 = "☀",
        TextColor3           = Color3.new(1, 1, 1),
        Font                 = Enum.Font.GothamBold,
        TextSize             = 22,
        ZIndex               = 101,
    }, btn)

    local clickBtn = newInstance("TextButton", {
        Size                 = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                 = "",
        ZIndex               = 102,
    }, btn)
    addCorner(clickBtn, UDim.new(1, 0))

    local dragging, dragStart, startPos, hasMoved = false, nil, nil, false

    clickBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            hasMoved  = false
            dragStart = input.Position
            startPos  = btn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if delta.Magnitude > 4 then hasMoved = true end
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and not hasMoved then onToggle() end
            dragging = false
        end
    end)
    clickBtn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = T.AccentHover}, TWEEN_FAST) end)
    clickBtn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = T.Accent},      TWEEN_FAST) end)

    return btn
end

-- ──────────────────────────────────────────────
--  GLOBAL KEYBIND LISTENER
-- ──────────────────────────────────────────────
local function startKeybindListener(lib)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == lib._globalKey then
            for _, w in ipairs(lib._windows) do
                if w._mainFrame then
                    local visible = not w._mainFrame.Visible
                    w._mainFrame.Visible = visible
                    if lib._floatBtn then
                        tween(lib._floatBtn, {
                            BackgroundColor3 = visible and lib._theme.Accent or lib._theme.Toggle
                        }, TWEEN_FAST)
                    end
                end
            end
        end
        for key, entry in pairs(lib._keybinds) do
            if input.KeyCode.Name == key then pcall(entry.callback) end
        end
    end)
end

-- ──────────────────────────────────────────────
--  PUBLIC LIBRARY API
-- ──────────────────────────────────────────────
function SUNUI:SetTheme(name)
    local t = THEMES[name]
    if not t then warn("SUNUI: Unknown theme: " .. tostring(name)) return end
    self._theme = t
end

function SUNUI:SetAutoSave(bool) self._autoSave = bool == true end
function SUNUI:SetAutoLoad(bool) self._autoLoad = bool == true end

-- ──────────────────────────────────────────────
--  CREATE MANAGED WINDOW
-- ──────────────────────────────────────────────
function SUNUI:CreateManagedWindow(opts)
    opts = opts or {}
    local title  = opts.Title          or "SUNUI"
    local logoId = opts.LogoAssetId    or LOGO_ASSET_ID
    local defKey = opts.DefaultKeybind or Enum.KeyCode.RightShift

    self._globalKey  = defKey
    self._configName = title:lower():gsub("%s+", "_")

    -- Build root GUI once
    if not self._gui then
        self._gui          = buildScreenGui()
        self._notifyHolder = buildNotifyHolder(self._gui)
        self._tooltip      = buildTooltip(self._gui, self._theme)
        startKeybindListener(self)
    end

    -- Auto-load config
    if self._autoLoad then
        local saved = loadConfig(self._configName)
        if saved then
            for k, v in pairs(saved) do self._flags[k] = v end
        end
    end

    local T  = self._theme
    local sg = self._gui

    -- ── MAIN FRAME ────────────────────────────
    local mainFrame = newInstance("Frame", {
        Name             = "Window_" .. title,
        Size             = UDim2.new(0, 680, 0, 460),
        Position         = UDim2.new(0.5, -340, 0.5, -230),
        BackgroundColor3 = T.Background,
        ClipsDescendants = true,
    }, sg)
    addCorner(mainFrame, UDim.new(0, 10))
    addStroke(mainFrame, T.Border)

    -- Drop shadow
    local shadow = newInstance("Frame", {
        Size                 = UDim2.new(1, 16, 1, 16),
        Position             = UDim2.new(0, -8, 0, 8),
        BackgroundColor3     = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.72,
        ZIndex               = -1,
    }, mainFrame)
    addCorner(shadow, UDim.new(0, 14))

    -- ── TITLE BAR ─────────────────────────────
    local titleBar = newInstance("Frame", {
        Name             = "TitleBar",
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = T.Surface,
    }, mainFrame)
    addStroke(titleBar, T.Border)

    newInstance("ImageLabel", {
        Size                 = UDim2.new(0, 26, 0, 26),
        Position             = UDim2.new(0, 10, 0.5, -13),
        BackgroundTransparency = 1,
        Image                = logoId,
    }, titleBar)

    newInstance("TextLabel", {
        Size                 = UDim2.new(1, -120, 1, 0),
        Position             = UDim2.new(0, 44, 0, 0),
        BackgroundTransparency = 1,
        Text                 = title,
        TextColor3           = T.Text,
        Font                 = Enum.Font.GothamBold,
        TextSize             = 15,
        TextXAlignment       = Enum.TextXAlignment.Left,
    }, titleBar)

    -- Close button
    local closeBtn = newInstance("TextButton", {
        Size             = UDim2.new(0, 32, 0, 32),
        Position         = UDim2.new(1, -40, 0.5, -16),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Text             = "✕",
        TextColor3       = Color3.new(1, 1, 1),
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
    }, titleBar)
    addCorner(closeBtn, UDim.new(0, 6))
    closeBtn.MouseButton1Click:Connect(function()
        tween(mainFrame, {Size = UDim2.new(0, 680, 0, 0)}, TWEEN_MED)
        task.delay(0.3, function()
            mainFrame.Visible = false
            mainFrame.Size    = UDim2.new(0, 680, 0, 460)
        end)
    end)
    closeBtn.MouseEnter:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 80,  80)}, TWEEN_FAST) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50,  50)}, TWEEN_FAST) end)

    -- Minimize button
    local minBtn = newInstance("TextButton", {
        Size             = UDim2.new(0, 32, 0, 32),
        Position         = UDim2.new(1, -76, 0.5, -16),
        BackgroundColor3 = Color3.fromRGB(180, 130, 20),
        Text             = "—",
        TextColor3       = Color3.new(1, 1, 1),
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
    }, titleBar)
    addCorner(minBtn, UDim.new(0, 6))
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tween(mainFrame,
            {Size = minimized and UDim2.new(0, 680, 0, 44) or UDim2.new(0, 680, 0, 460)},
            TWEEN_MED)
    end)
    minBtn.MouseEnter:Connect(function() tween(minBtn, {BackgroundColor3 = Color3.fromRGB(220,170, 30)}, TWEEN_FAST) end)
    minBtn.MouseLeave:Connect(function() tween(minBtn, {BackgroundColor3 = Color3.fromRGB(180,130, 20)}, TWEEN_FAST) end)

    -- Drag titleBar
    local dragActive, dragStart2, frameStart = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragActive = true
            dragStart2 = input.Position
            frameStart = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragActive and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart2
            mainFrame.Position = UDim2.new(
                frameStart.X.Scale, frameStart.X.Offset + delta.X,
                frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragActive = false
        end
    end)

    -- ── BODY ──────────────────────────────────
    local body = newInstance("Frame", {
        Name                 = "Body",
        Size                 = UDim2.new(1, 0, 1, -44),
        Position             = UDim2.new(0, 0, 0, 44),
        BackgroundTransparency = 1,
    }, mainFrame)

    -- ── SIDEBAR ───────────────────────────────
    local sidebar = newInstance("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, 168, 1, 0),
        BackgroundColor3 = T.Surface,
    }, body)
    addStroke(sidebar, T.Border)

    local searchHolder = newInstance("Frame", {
        Size             = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = T.SurfaceAlt,
    }, sidebar)
    addCorner(searchHolder, UDim.new(0, 6))
    addPadding(searchHolder, 0, 0, 8, 8)

    local searchBox = newInstance("TextBox", {
        Size                 = UDim2.new(1, -24, 1, -8),
        Position             = UDim2.new(0, 24, 0, 4),
        BackgroundTransparency = 1,
        PlaceholderText      = "Search tabs…",
        PlaceholderColor3    = T.TextMuted,
        Text                 = "",
        TextColor3           = T.Text,
        Font                 = Enum.Font.Gotham,
        TextSize             = 12,
        ClearTextOnFocus     = false,
    }, searchHolder)
    newInstance("TextLabel", {
        Size                 = UDim2.new(0, 16, 1, 0),
        Position             = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text                 = "🔍",
        TextSize             = 12,
        TextColor3           = T.TextMuted,
        Font                 = Enum.Font.Gotham,
    }, searchHolder)

    local tabScroll = newInstance("ScrollingFrame", {
        Name                 = "TabScroll",
        Size                 = UDim2.new(1, 0, 1, -44),
        Position             = UDim2.new(0, 0, 0, 44),
        BackgroundTransparency = 1,
        ScrollBarThickness   = 2,
        ScrollBarImageColor3 = T.Accent,
        CanvasSize           = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    }, sidebar)
    addPadding(tabScroll, 4, 4, 6, 6)
    addListLayout(tabScroll, Enum.FillDirection.Vertical, 4)

    -- ── CONTENT AREA ──────────────────────────
    local contentArea = newInstance("Frame", {
        Name             = "ContentArea",
        Size             = UDim2.new(1, -168, 1, 0),
        Position         = UDim2.new(0, 168, 0, 0),
        BackgroundColor3 = T.Background,
    }, body)

    -- ── WINDOW OBJECT ─────────────────────────
    local window = {}
    window._tabs       = {}
    window._activeTab  = nil
    window._mainFrame  = mainFrame
    window._tabScroll  = tabScroll
    window._contentArea = contentArea
    window._T          = T
    window._lib        = self

    -- Tab search
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchBox.Text:lower()
        for _, tabObj in ipairs(window._tabs) do
            local m = q == "" or tabObj._name:lower():find(q, 1, true)
            tabObj._btn.Visible = m ~= nil and m ~= false
        end
    end)

    -- ──────────────────────────────────────────
    --  CREATE DEVELOPER TAB
    -- ──────────────────────────────────────────
    function window:CreateDeveloperTab(opts2)
        opts2 = opts2 or {}
        local tabName = opts2.Name or "Tab"
        local tabIcon = opts2.Icon or ""

        local btn = newInstance("TextButton", {
            Name             = "TabBtn_" .. tabName,
            Size             = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T.SurfaceAlt,
            Text             = (tabIcon ~= "" and tabIcon .. "  " or "") .. tabName,
            TextColor3       = T.TextMuted,
            Font             = Enum.Font.Gotham,
            TextSize         = 12,
            TextXAlignment   = Enum.TextXAlignment.Left,
        }, tabScroll)
        addCorner(btn, UDim.new(0, 6))
        addPadding(btn, 0, 0, 10, 0)

        local scroll = newInstance("ScrollingFrame", {
            Name                 = "TabContent_" .. tabName,
            Size                 = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness   = 3,
            ScrollBarImageColor3 = T.Accent,
            CanvasSize           = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize  = Enum.AutomaticSize.Y,
            Visible              = false,
        }, contentArea)
        addPadding(scroll, 10, 10, 10, 10)
        addListLayout(scroll, Enum.FillDirection.Vertical, 8)

        local tabObj = {_name = tabName, _btn = btn, _scroll = scroll, _sections = {}}

        local function activate()
            for _, other in ipairs(window._tabs) do
                other._scroll.Visible = false
                tween(other._btn, {BackgroundColor3 = T.SurfaceAlt, TextColor3 = T.TextMuted}, TWEEN_FAST)
            end
            scroll.Visible = true
            tween(btn, {BackgroundColor3 = T.Accent, TextColor3 = Color3.new(1,1,1)}, TWEEN_FAST)
            window._activeTab = tabObj
        end

        btn.MouseButton1Click:Connect(activate)
        btn.MouseEnter:Connect(function()
            if window._activeTab ~= tabObj then tween(btn, {BackgroundColor3 = T.Border},    TWEEN_FAST) end
        end)
        btn.MouseLeave:Connect(function()
            if window._activeTab ~= tabObj then tween(btn, {BackgroundColor3 = T.SurfaceAlt}, TWEEN_FAST) end
        end)

        if #window._tabs == 0 then activate() end
        table.insert(window._tabs, tabObj)

        -- ────────────────────────────────────
        --  ADD SECTION
        -- ────────────────────────────────────
        function tabObj:AddSection(sectionName)
            local sectionFrame = newInstance("Frame", {
                Name             = "Section_" .. sectionName,
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = T.Surface,
            }, scroll)
            addCorner(sectionFrame, UDim.new(0, 8))
            addStroke(sectionFrame, T.Border)
            addPadding(sectionFrame, 8, 10, 10, 10)
            addListLayout(sectionFrame, Enum.FillDirection.Vertical, 8)

            newInstance("TextLabel", {
                Size                 = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text                 = sectionName:upper(),
                TextColor3           = T.Accent,
                Font                 = Enum.Font.GothamBold,
                TextSize             = 11,
                TextXAlignment       = Enum.TextXAlignment.Left,
            }, sectionFrame)

            local lib     = window._lib
            local section = {_frame = sectionFrame, _lib = lib}

            -- ── BUTTON ────────────────────────
            function section:AddButton(o)
                o = o or {}
                local name     = o.Name     or "Button"
                local tooltip  = o.Tooltip  or ""
                local callback = o.Callback or function() end

                local row = newInstance("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                }, sectionFrame)
                local b = newInstance("TextButton", {
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = T.SurfaceAlt,
                    Text             = name,
                    TextColor3       = T.Text,
                    Font             = Enum.Font.Gotham,
                    TextSize         = 13,
                }, row)
                addCorner(b)
                addStroke(b, T.Border)

                b.MouseButton1Click:Connect(function()
                    tween(b, {BackgroundColor3 = T.Accent},    TWEEN_FAST)
                    task.delay(0.18, function()
                        tween(b, {BackgroundColor3 = T.SurfaceAlt}, TWEEN_FAST)
                    end)
                    pcall(callback)
                end)
                b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = T.Border},    TWEEN_FAST) end)
                b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = T.SurfaceAlt}, TWEEN_FAST) end)
                wireTooltip(lib, b, tooltip)

                -- Buttons return their frame (no flag state needed)
                return row
            end

            -- ── TOGGLE ────────────────────────
            function section:AddToggle(o)
                o = o or {}
                local name     = o.Name     or "Toggle"
                local flag     = o.Flag     or name
                local default  = o.Default  ~= nil and o.Default or false
                local tooltip  = o.Tooltip  or ""
                local callback = o.Callback or function() end

                -- Restore saved value if present
                local saved = lib._flags[flag]
                local value = (saved ~= nil) and saved or default
                lib._flags[flag] = value

                local row = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = T.SurfaceAlt,
                }, sectionFrame)
                addCorner(row)
                addStroke(row, T.Border)
                addPadding(row, 0, 0, 10, 10)

                newInstance("TextLabel", {
                    Size                 = UDim2.new(1, -54, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = name,
                    TextColor3           = T.Text,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, row)

                local track = newInstance("Frame", {
                    Size             = UDim2.new(0, 44, 0, 22),
                    Position         = UDim2.new(1, -44, 0.5, -11),
                    -- Immediate visual state from restored value
                    BackgroundColor3 = value and T.ToggleOn or T.Toggle,
                }, row)
                addCorner(track, UDim.new(1, 0))

                local dot = newInstance("Frame", {
                    Size             = UDim2.new(0, 16, 0, 16),
                    -- Immediate position from restored value
                    Position         = value
                        and UDim2.new(1, -19, 0.5, -8)
                        or  UDim2.new(0,   3, 0.5, -8),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                }, track)
                addCorner(dot, UDim.new(1, 0))

                local clickZone = newInstance("TextButton", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = "",
                }, row)

                -- Collected OnChanged callbacks
                local changedCallbacks = {}

                local function applyState(v, fire)
                    value = v
                    lib._flags[flag] = v
                    tween(track, {BackgroundColor3 = v and T.ToggleOn or T.Toggle},          TWEEN_FAST)
                    tween(dot,   {Position = v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)}, TWEEN_FAST)
                    if fire then
                        pcall(callback, v)
                        for _, cb in ipairs(changedCallbacks) do pcall(cb, v) end
                    end
                    if lib._autoSave then saveConfig(lib._configName, lib._flags) end
                end

                clickZone.MouseButton1Click:Connect(function() applyState(not value, true) end)
                wireTooltip(lib, row, tooltip)

                -- ── CONTROL API ───────────────
                local ctrl = {}
                function ctrl:Set(v)       applyState(v == true, false) end
                function ctrl:OnChanged(cb) table.insert(changedCallbacks, cb) end
                return ctrl
            end

            -- ── SLIDER ────────────────────────
            function section:AddSlider(o)
                o = o or {}
                local name     = o.Name     or "Slider"
                local flag     = o.Flag     or name
                local minV     = o.Min      or 0
                local maxV     = o.Max      or 100
                local default  = o.Default  ~= nil and o.Default or minV
                local tooltip  = o.Tooltip  or ""
                local callback = o.Callback or function() end

                -- Restore saved value if present
                local saved = lib._flags[flag]
                local value = math.clamp(
                    (saved ~= nil) and tonumber(saved) or default, minV, maxV)
                lib._flags[flag] = value
                local initRel   = (value - minV) / (maxV - minV)

                local holder = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    BackgroundColor3 = T.SurfaceAlt,
                }, sectionFrame)
                addCorner(holder)
                addStroke(holder, T.Border)
                addPadding(holder, 8, 10, 10, 10)
                addListLayout(holder, Enum.FillDirection.Vertical, 6)

                local labelRow = newInstance("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                }, holder)
                newInstance("TextLabel", {
                    Size                 = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = name,
                    TextColor3           = T.Text,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, labelRow)
                local valLabel = newInstance("TextLabel", {
                    Size                 = UDim2.new(0.3, 0, 1, 0),
                    Position             = UDim2.new(0.7, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text                 = tostring(value),
                    TextColor3           = T.Accent,
                    Font                 = Enum.Font.GothamBold,
                    TextSize             = 13,
                    TextXAlignment       = Enum.TextXAlignment.Right,
                }, labelRow)

                local _, syncVisual = buildHorizSlider(holder, T, T.Toggle, T.Accent, initRel,
                    function(rel)
                        value = math.round(minV + rel * (maxV - minV))
                        lib._flags[flag] = value
                        valLabel.Text    = tostring(value)
                        pcall(callback, value)
                        if lib._autoSave then saveConfig(lib._configName, lib._flags) end
                    end)

                wireTooltip(lib, holder, tooltip)

                -- ── CONTROL API ───────────────
                local ctrl = {}
                function ctrl:Set(v)
                    v = math.clamp(v, minV, maxV)
                    value = v
                    lib._flags[flag] = v
                    valLabel.Text    = tostring(v)
                    syncVisual((v - minV) / (maxV - minV))
                    pcall(callback, v)
                    if lib._autoSave then saveConfig(lib._configName, lib._flags) end
                end
                return ctrl
            end

            -- ── TEXTBOX ───────────────────────
            function section:AddTextbox(o)
                o = o or {}
                local name        = o.Name        or "Textbox"
                local flag        = o.Flag        or name
                local placeholder = o.Placeholder or "Enter text…"
                local tooltip     = o.Tooltip     or ""
                local callback    = o.Callback    or function() end

                -- Restore saved value if present
                local saved = lib._flags[flag]
                local initText = (saved ~= nil) and tostring(saved) or ""
                lib._flags[flag] = initText

                local holder = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    BackgroundColor3 = T.SurfaceAlt,
                }, sectionFrame)
                addCorner(holder)
                addStroke(holder, T.Border)
                addPadding(holder, 8, 8, 10, 10)
                addListLayout(holder, Enum.FillDirection.Vertical, 4)

                newInstance("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Text                 = name,
                    TextColor3           = T.Text,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, holder)

                local inputFrame = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = T.Background,
                }, holder)
                addCorner(inputFrame)
                addStroke(inputFrame, T.Border)
                addPadding(inputFrame, 0, 0, 8, 8)

                local tb = newInstance("TextBox", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    PlaceholderText      = placeholder,
                    PlaceholderColor3    = T.TextMuted,
                    Text                 = initText,   -- ← restored value
                    TextColor3           = T.Text,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    ClearTextOnFocus     = false,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, inputFrame)

                tb.Focused:Connect(function()
                    tween(inputFrame, {BackgroundColor3 = T.Surface}, TWEEN_FAST)
                    addStroke(inputFrame, T.Accent)
                end)
                tb.FocusLost:Connect(function(enter)
                    tween(inputFrame, {BackgroundColor3 = T.Background}, TWEEN_FAST)
                    addStroke(inputFrame, T.Border)
                    lib._flags[flag] = tb.Text
                    if enter then pcall(callback, tb.Text) end
                    if lib._autoSave then saveConfig(lib._configName, lib._flags) end
                end)

                wireTooltip(lib, holder, tooltip)

                -- ── CONTROL API ───────────────
                local ctrl = {}
                function ctrl:Set(text)
                    tb.Text          = tostring(text)
                    lib._flags[flag] = tb.Text
                    if lib._autoSave then saveConfig(lib._configName, lib._flags) end
                end
                return ctrl
            end

            -- ── DROPDOWN ──────────────────────
            function section:AddDropdown(o)
                o = o or {}
                local name     = o.Name        or "Dropdown"
                local options  = o.Options     or {}
                local multi    = o.MultiSelect == true
                local tooltip  = o.Tooltip     or ""
                local callback = o.Callback    or function() end

                local selected = {}
                local open     = false
                local optBtns  = {}   -- {text → button} for Refresh/Set

                -- Restore saved selection
                local saved = lib._flags[name]
                if saved ~= nil then
                    if multi and type(saved) == "table" then
                        selected = saved
                    elseif not multi and type(saved) == "string" then
                        selected = {saved}
                    end
                end

                local holder = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    BackgroundColor3 = T.SurfaceAlt,
                }, sectionFrame)
                addCorner(holder)
                addStroke(holder, T.Border)
                addPadding(holder, 8, 8, 10, 10)
                addListLayout(holder, Enum.FillDirection.Vertical, 4)

                newInstance("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Text                 = name,
                    TextColor3           = T.Text,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, holder)

                local header = newInstance("TextButton", {
                    Size             = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = T.Background,
                    Text             = "",
                    Font             = Enum.Font.Gotham,
                    TextSize         = 13,
                }, holder)
                addCorner(header)
                addStroke(header, T.Border)

                local headerLabel = newInstance("TextLabel", {
                    Size                 = UDim2.new(1, -30, 1, 0),
                    Position             = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency = 1,
                    Text                 = multi and "None selected" or "Select…",
                    TextColor3           = T.TextMuted,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, header)

                local arrow = newInstance("TextLabel", {
                    Size                 = UDim2.new(0, 22, 1, 0),
                    Position             = UDim2.new(1, -26, 0, 0),
                    BackgroundTransparency = 1,
                    Text                 = "▾",
                    TextColor3           = T.TextMuted,
                    Font                 = Enum.Font.GothamBold,
                    TextSize             = 14,
                }, header)

                local optContainer = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    BackgroundColor3 = T.Background,
                    Visible          = false,
                }, holder)
                addCorner(optContainer)
                addStroke(optContainer, T.Border)
                addPadding(optContainer, 4, 4, 4, 4)
                addListLayout(optContainer, Enum.FillDirection.Vertical, 2)

                local function updateDisplay()
                    if #selected == 0 then
                        headerLabel.Text      = multi and "None selected" or "Select…"
                        headerLabel.TextColor3 = T.TextMuted
                    elseif #selected == 1 then
                        headerLabel.Text      = selected[1]
                        headerLabel.TextColor3 = T.Text
                    else
                        headerLabel.Text      = #selected .. " selected"
                        headerLabel.TextColor3 = T.Text
                    end
                end

                local function buildOptionBtn(opt)
                    local already = table.find(selected, opt) ~= nil
                    local optBtn  = newInstance("TextButton", {
                        Size             = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = already and T.Accent or T.Surface,
                        Text             = opt,
                        TextColor3       = T.Text,
                        Font             = Enum.Font.Gotham,
                        TextSize         = 12,
                        TextXAlignment   = Enum.TextXAlignment.Left,
                    }, optContainer)
                    addCorner(optBtn, UDim.new(0, 5))
                    addPadding(optBtn, 0, 0, 8, 0)

                    optBtn.MouseButton1Click:Connect(function()
                        if multi then
                            local found = table.find(selected, opt)
                            if found then
                                table.remove(selected, found)
                                tween(optBtn, {BackgroundColor3 = T.Surface}, TWEEN_FAST)
                            else
                                table.insert(selected, opt)
                                tween(optBtn, {BackgroundColor3 = T.Accent}, TWEEN_FAST)
                            end
                        else
                            selected = {opt}
                            for _, b2 in pairs(optBtns) do
                                tween(b2, {BackgroundColor3 = T.Surface}, TWEEN_FAST)
                            end
                            tween(optBtn, {BackgroundColor3 = T.Accent}, TWEEN_FAST)
                            open = false
                            optContainer.Visible = false
                            tween(arrow, {Rotation = 0}, TWEEN_FAST)
                        end
                        lib._flags[name] = multi and selected or selected[1]
                        updateDisplay()
                        pcall(callback, multi and selected or selected[1])
                        if lib._autoSave then saveConfig(lib._configName, lib._flags) end
                    end)
                    optBtn.MouseEnter:Connect(function()
                        if not table.find(selected, opt) then tween(optBtn, {BackgroundColor3 = T.SurfaceAlt}, TWEEN_FAST) end
                    end)
                    optBtn.MouseLeave:Connect(function()
                        if not table.find(selected, opt) then tween(optBtn, {BackgroundColor3 = T.Surface},    TWEEN_FAST) end
                    end)
                    optBtns[opt] = optBtn
                end

                for _, opt in ipairs(options) do buildOptionBtn(opt) end
                updateDisplay()

                header.MouseButton1Click:Connect(function()
                    open = not open
                    optContainer.Visible = open
                    tween(arrow,  {Rotation = open and 180 or 0},             TWEEN_FAST)
                    tween(header, {BackgroundColor3 = open and T.Surface or T.Background}, TWEEN_FAST)
                end)

                wireTooltip(lib, holder, tooltip)

                -- ── CONTROL API ───────────────
                local ctrl = {}

                function ctrl:Refresh(newOpts)
                    for _, child in ipairs(optContainer:GetChildren()) do
                        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                            child:Destroy()
                        end
                    end
                    for k in pairs(optBtns) do optBtns[k] = nil end
                    selected = {}
                    updateDisplay()
                    for _, opt in ipairs(newOpts) do buildOptionBtn(opt) end
                end

                function ctrl:Set(val)
                    if multi then
                        local vals = type(val) == "table" and val or {val}
                        selected = {}
                        for _, b2 in pairs(optBtns) do
                            tween(b2, {BackgroundColor3 = T.Surface}, TWEEN_FAST)
                        end
                        for _, v in ipairs(vals) do
                            if optBtns[v] then
                                table.insert(selected, v)
                                tween(optBtns[v], {BackgroundColor3 = T.Accent}, TWEEN_FAST)
                            end
                        end
                    else
                        selected = type(val) == "string" and {val} or {}
                        for _, b2 in pairs(optBtns) do
                            tween(b2, {BackgroundColor3 = T.Surface}, TWEEN_FAST)
                        end
                        if optBtns[val] then
                            tween(optBtns[val], {BackgroundColor3 = T.Accent}, TWEEN_FAST)
                        end
                    end
                    lib._flags[name] = multi and selected or selected[1]
                    updateDisplay()
                    if lib._autoSave then saveConfig(lib._configName, lib._flags) end
                end

                return ctrl
            end

            -- ── COLOR PICKER ──────────────────
            function section:AddColorPicker(o)
                o = o or {}
                local name     = o.Name         or "ColorPicker"
                local default  = o.DefaultColor  or Color3.fromRGB(99, 102, 241)
                local tooltip  = o.Tooltip       or ""
                local callback = o.Callback      or function() end

                local currentColor = default
                -- Decompose to HSV so sliders start correct
                local hue, sat, bri = Color3.toHSV(currentColor)

                local holder = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    BackgroundColor3 = T.SurfaceAlt,
                }, sectionFrame)
                addCorner(holder)
                addStroke(holder, T.Border)
                addPadding(holder, 8, 10, 10, 10)
                addListLayout(holder, Enum.FillDirection.Vertical, 6)

                newInstance("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Text                 = name,
                    TextColor3           = T.Text,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, holder)

                local preview = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = currentColor,
                }, holder)
                addCorner(preview)
                addStroke(preview, T.Border)

                local function rebuildColor()
                    currentColor = Color3.fromHSV(hue, sat, bri)
                    preview.BackgroundColor3 = currentColor
                    if o.ApplyToTheme then T.Accent = currentColor end
                    pcall(callback, currentColor)
                end

                -- ── Hue slider (rainbow gradient) ──
                local hueRow = newInstance("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 0),
                    AutomaticSize        = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                }, holder)
                addListLayout(hueRow, Enum.FillDirection.Vertical, 2)
                newInstance("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 13),
                    BackgroundTransparency = 1,
                    Text                 = "HUE",
                    TextColor3           = T.TextMuted,
                    Font                 = Enum.Font.GothamBold,
                    TextSize             = 9,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, hueRow)

                local hueTrack = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 14),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                }, hueRow)
                addCorner(hueTrack, UDim.new(0, 5))
                newInstance("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,   0,   0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255,   0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(  0, 255,   0)),
                        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(  0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(  0,   0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,   0, 255)),
                        ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,   0,   0)),
                    }),
                }, hueTrack)

                -- Hue thumb
                local hueThumb = newInstance("Frame", {
                    Size             = UDim2.new(0, 12, 1, 2),
                    Position         = UDim2.new(hue, -6, 0, -1),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    ZIndex           = 5,
                }, hueTrack)
                addCorner(hueThumb, UDim.new(0, 4))
                addStroke(hueThumb, Color3.fromRGB(80, 80, 80))

                local slidingHue = false
                hueTrack.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        slidingHue = true
                        local rel = math.clamp((inp.Position.X - hueTrack.AbsolutePosition.X) / hueTrack.AbsoluteSize.X, 0, 1)
                        hue = rel
                        hueThumb.Position = UDim2.new(rel, -6, 0, -1)
                        rebuildColor()
                    end
                end)

                -- ── Saturation slider ──
                local satRow = newInstance("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 0),
                    AutomaticSize        = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                }, holder)
                addListLayout(satRow, Enum.FillDirection.Vertical, 2)
                newInstance("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 13),
                    BackgroundTransparency = 1,
                    Text                 = "SATURATION",
                    TextColor3           = T.TextMuted,
                    Font                 = Enum.Font.GothamBold,
                    TextSize             = 9,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, satRow)

                local satTrack = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 14),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                }, satRow)
                addCorner(satTrack, UDim.new(0, 5))
                local satGrad = newInstance("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, bri)),
                    }),
                }, satTrack)

                local satThumb = newInstance("Frame", {
                    Size             = UDim2.new(0, 12, 1, 2),
                    Position         = UDim2.new(sat, -6, 0, -1),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    ZIndex           = 5,
                }, satTrack)
                addCorner(satThumb, UDim.new(0, 4))
                addStroke(satThumb, Color3.fromRGB(80, 80, 80))

                -- ── Value / Brightness slider ──
                local valRow = newInstance("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 0),
                    AutomaticSize        = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                }, holder)
                addListLayout(valRow, Enum.FillDirection.Vertical, 2)
                newInstance("TextLabel", {
                    Size                 = UDim2.new(1, 0, 0, 13),
                    BackgroundTransparency = 1,
                    Text                 = "BRIGHTNESS",
                    TextColor3           = T.TextMuted,
                    Font                 = Enum.Font.GothamBold,
                    TextSize             = 9,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, valRow)

                local valTrack = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 14),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                }, valRow)
                addCorner(valTrack, UDim.new(0, 5))
                local valGrad = newInstance("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 1)),
                    }),
                }, valTrack)

                local valThumb = newInstance("Frame", {
                    Size             = UDim2.new(0, 12, 1, 2),
                    Position         = UDim2.new(bri, -6, 0, -1),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    ZIndex           = 5,
                }, valTrack)
                addCorner(valThumb, UDim.new(0, 4))
                addStroke(valThumb, Color3.fromRGB(80, 80, 80))

                -- Shared rebuild that also updates gradients when hue changes
                local function fullRebuild()
                    satGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, bri)),
                    })
                    valGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 1)),
                    })
                    rebuildColor()
                end

                -- Finish hue slider connection
                local slidingSat, slidingVal = false, false

                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        slidingHue = false
                        slidingSat = false
                        slidingVal = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(inp)
                    if inp.UserInputType ~= Enum.UserInputType.MouseMovement
                    and inp.UserInputType ~= Enum.UserInputType.Touch then return end

                    if slidingHue then
                        local rel = math.clamp((inp.Position.X - hueTrack.AbsolutePosition.X) / hueTrack.AbsoluteSize.X, 0, 1)
                        hue = rel
                        hueThumb.Position = UDim2.new(rel, -6, 0, -1)
                        fullRebuild()
                    elseif slidingSat then
                        local rel = math.clamp((inp.Position.X - satTrack.AbsolutePosition.X) / satTrack.AbsoluteSize.X, 0, 1)
                        sat = rel
                        satThumb.Position = UDim2.new(rel, -6, 0, -1)
                        fullRebuild()
                    elseif slidingVal then
                        local rel = math.clamp((inp.Position.X - valTrack.AbsolutePosition.X) / valTrack.AbsoluteSize.X, 0, 1)
                        bri = rel
                        valThumb.Position = UDim2.new(rel, -6, 0, -1)
                        fullRebuild()
                    end
                end)

                satTrack.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        slidingSat = true
                        local rel = math.clamp((inp.Position.X - satTrack.AbsolutePosition.X) / satTrack.AbsoluteSize.X, 0, 1)
                        sat = rel
                        satThumb.Position = UDim2.new(rel, -6, 0, -1)
                        fullRebuild()
                    end
                end)

                valTrack.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        slidingVal = true
                        local rel = math.clamp((inp.Position.X - valTrack.AbsolutePosition.X) / valTrack.AbsoluteSize.X, 0, 1)
                        bri = rel
                        valThumb.Position = UDim2.new(rel, -6, 0, -1)
                        fullRebuild()
                    end
                end)

                -- ── Hex input ─────────────────
                local hexFrame = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = T.Background,
                }, holder)
                addCorner(hexFrame)
                addStroke(hexFrame, T.Border)
                addPadding(hexFrame, 0, 0, 8, 8)

                local function colorToHex(c)
                    return string.format("#%02X%02X%02X",
                        math.round(c.R * 255),
                        math.round(c.G * 255),
                        math.round(c.B * 255))
                end

                local hexBox = newInstance("TextBox", {
                    Size                 = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    PlaceholderText      = "#RRGGBB",
                    PlaceholderColor3    = T.TextMuted,
                    Text                 = colorToHex(currentColor),
                    TextColor3           = T.Text,
                    Font                 = Enum.Font.Code,
                    TextSize             = 12,
                    ClearTextOnFocus     = false,
                }, hexFrame)

                hexBox.Focused:Connect(function()
                    addStroke(hexFrame, T.Accent)
                end)
                hexBox.FocusLost:Connect(function()
                    addStroke(hexFrame, T.Border)
                    local hex = hexBox.Text:gsub("#", "")
                    if #hex == 6 then
                        local r = tonumber(hex:sub(1,2), 16)
                        local g = tonumber(hex:sub(3,4), 16)
                        local b = tonumber(hex:sub(5,6), 16)
                        if r and g and b then
                            currentColor = Color3.fromRGB(r, g, b)
                            hue, sat, bri = Color3.toHSV(currentColor)
                            hueThumb.Position = UDim2.new(hue, -6, 0, -1)
                            satThumb.Position = UDim2.new(sat, -6, 0, -1)
                            valThumb.Position = UDim2.new(bri, -6, 0, -1)
                            fullRebuild()
                        end
                    end
                    hexBox.Text = colorToHex(currentColor)
                end)

                -- Keep hex box in sync when sliders move
                local origRebuild = fullRebuild
                fullRebuild = function()
                    origRebuild()
                    hexBox.Text = colorToHex(currentColor)
                end

                wireTooltip(lib, holder, tooltip)

                return holder   -- ColorPicker doesn't expose a control API but could be extended
            end

            -- ── KEYBIND ───────────────────────
            function section:AddKeybind(o)
                o = o or {}
                local name       = o.Name           or "Keybind"
                local defaultKey = o.DefaultKeybind  or Enum.KeyCode.F
                local tooltip    = o.Tooltip         or ""
                local callback   = o.Callback        or function() end

                local currentKey = defaultKey
                lib._keybinds[currentKey.Name] = {callback = callback, name = name}

                local holder = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = T.SurfaceAlt,
                }, sectionFrame)
                addCorner(holder)
                addStroke(holder, T.Border)
                addPadding(holder, 0, 0, 10, 10)

                newInstance("TextLabel", {
                    Size                 = UDim2.new(0.6, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                 = name,
                    TextColor3           = T.Text,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                }, holder)

                local keyBtn = newInstance("TextButton", {
                    Size             = UDim2.new(0, 100, 0, 24),
                    Position         = UDim2.new(1, -104, 0.5, -12),
                    BackgroundColor3 = T.Background,
                    Text             = "[" .. currentKey.Name .. "]",
                    TextColor3       = T.Accent,
                    Font             = Enum.Font.GothamBold,
                    TextSize         = 12,
                }, holder)
                addCorner(keyBtn, UDim.new(0, 5))
                addStroke(keyBtn, T.Border)

                keyBtn.MouseButton1Click:Connect(function()
                    keyBtn.Text = "[Press key…]"
                    tween(keyBtn, {BackgroundColor3 = T.Accent}, TWEEN_FAST)
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(inp, gpe)
                        if gpe then return end
                        if inp.UserInputType == Enum.UserInputType.Keyboard then
                            lib._keybinds[currentKey.Name] = nil
                            currentKey = inp.KeyCode
                            lib._keybinds[currentKey.Name] = {callback = callback, name = name}
                            keyBtn.Text = "[" .. currentKey.Name .. "]"
                            tween(keyBtn, {BackgroundColor3 = T.Background}, TWEEN_FAST)
                            conn:Disconnect()
                        end
                    end)
                end)

                wireTooltip(lib, holder, tooltip)
                return holder
            end

            -- ── SERVER BROWSER ────────────────
            function section:AddServerBrowser(o)
                o = o or {}
                local autoRefresh     = o.AutoRefresh     ~= false
                local refreshCallback = o.RefreshCallback or function() end

                local MOCK_SERVERS = {
                    {id="s1", region="NA-East",    players=14, max=20, ping=42,  fill=70 },
                    {id="s2", region="EU-West",    players=8,  max=20, ping=118, fill=40 },
                    {id="s3", region="NA-Central", players=20, max=20, ping=28,  fill=100},
                    {id="s4", region="Asia",       players=3,  max=16, ping=210, fill=19 },
                    {id="s5", region="NA-West",    players=17, max=20, ping=55,  fill=85 },
                    {id="s6", region="SA",         players=11, max=18, ping=95,  fill=61 },
                }

                local container = newInstance("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    BackgroundColor3 = T.Surface,
                }, sectionFrame)
                addCorner(container)
                addStroke(container, T.Border)
                addPadding(container, 8, 8, 8, 8)
                addListLayout(container, Enum.FillDirection.Vertical, 6)

                local headerRow = newInstance("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                }, container)

                local function makeHdrLabel(text, xp, wp)
                    newInstance("TextLabel", {
                        Size                 = UDim2.new(wp, 0, 1, 0),
                        Position             = UDim2.new(xp, 0, 0, 0),
                        BackgroundTransparency = 1,
                        Text                 = text,
                        TextColor3           = T.TextMuted,
                        Font                 = Enum.Font.GothamBold,
                        TextSize             = 10,
                        TextXAlignment       = Enum.TextXAlignment.Left,
                    }, headerRow)
                end
                makeHdrLabel("REGION",  0,    0.30)
                makeHdrLabel("PLAYERS", 0.30, 0.25)
                makeHdrLabel("PING",    0.55, 0.20)
                makeHdrLabel("FILL",    0.75, 0.15)

                local refreshBtn = newInstance("TextButton", {
                    Size             = UDim2.new(0, 66, 0, 20),
                    Position         = UDim2.new(1, -66, 0, 0),
                    BackgroundColor3 = T.Accent,
                    Text             = "↻ Refresh",
                    TextColor3       = Color3.new(1,1,1),
                    Font             = Enum.Font.GothamBold,
                    TextSize         = 10,
                }, headerRow)
                addCorner(refreshBtn, UDim.new(0, 4))

                local serverList = newInstance("Frame", {
                    Size                 = UDim2.new(1, 0, 0, 0),
                    AutomaticSize        = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                }, container)
                addListLayout(serverList, Enum.FillDirection.Vertical, 4)

                local function populateServers(servers)
                    for _, child in ipairs(serverList:GetChildren()) do
                        if not child:IsA("UIListLayout") then child:Destroy() end
                    end
                    for _, sv in ipairs(servers) do
                        local row = newInstance("Frame", {
                            Size             = UDim2.new(1, 0, 0, 32),
                            BackgroundColor3 = T.SurfaceAlt,
                        }, serverList)
                        addCorner(row, UDim.new(0, 5))
                        addStroke(row, T.Border)
                        newInstance("UIPadding", {PaddingLeft = UDim.new(0, 6)}, row)

                        local pingColor = sv.ping < 80  and Color3.fromRGB(52,211,153)
                                       or sv.ping < 150 and Color3.fromRGB(250,204,21)
                                       or                    Color3.fromRGB(239,68,68)

                        local function makeCell(text, xp, wp, color)
                            newInstance("TextLabel", {
                                Size                 = UDim2.new(wp, 0, 1, 0),
                                Position             = UDim2.new(xp, 0, 0, 0),
                                BackgroundTransparency = 1,
                                Text                 = text,
                                TextColor3           = color or T.Text,
                                Font                 = Enum.Font.Gotham,
                                TextSize             = 11,
                                TextXAlignment       = Enum.TextXAlignment.Left,
                            }, row)
                        end
                        makeCell(sv.region,                    0,    0.30)
                        makeCell(sv.players.."/"..sv.max,      0.30, 0.22)
                        makeCell(sv.ping.."ms",                0.52, 0.18, pingColor)
                        makeCell(sv.fill.."%",                 0.70, 0.12)

                        local barBg = newInstance("Frame", {
                            Size             = UDim2.new(0, 36, 0, 6),
                            Position         = UDim2.new(0.82, 0, 0.5, -3),
                            BackgroundColor3 = T.Toggle,
                        }, row)
                        addCorner(barBg, UDim.new(1, 0))
                        newInstance("Frame", {
                            Size             = UDim2.new(sv.fill/100, 0, 1, 0),
                            BackgroundColor3 = sv.fill >= 100 and Color3.fromRGB(239,68,68) or T.Accent,
                        }, barBg)

                        local full    = sv.players >= sv.max
                        local joinBtn = newInstance("TextButton", {
                            Size             = UDim2.new(0, 42, 0, 22),
                            Position         = UDim2.new(1, -46, 0.5, -11),
                            BackgroundColor3 = full and T.Toggle or T.Accent,
                            Text             = full and "Full" or "Join",
                            TextColor3       = Color3.new(1,1,1),
                            Font             = Enum.Font.GothamBold,
                            TextSize         = 11,
                            Active           = not full,
                        }, row)
                        addCorner(joinBtn, UDim.new(0, 5))

                        if not full then
                            joinBtn.MouseButton1Click:Connect(function()
                                tween(joinBtn, {BackgroundColor3 = T.AccentHover}, TWEEN_FAST)
                                task.delay(0.2, function()
                                    tween(joinBtn, {BackgroundColor3 = T.Accent}, TWEEN_FAST)
                                end)
                                print("Joining server: " .. sv.id .. " | " .. sv.region)
                            end)
                            joinBtn.MouseEnter:Connect(function() tween(joinBtn, {BackgroundColor3 = T.AccentHover}, TWEEN_FAST) end)
                            joinBtn.MouseLeave:Connect(function() tween(joinBtn, {BackgroundColor3 = T.Accent},      TWEEN_FAST) end)
                        end
                    end
                end

                populateServers(MOCK_SERVERS)

                refreshBtn.MouseButton1Click:Connect(function()
                    tween(refreshBtn, {BackgroundColor3 = T.AccentHover}, TWEEN_FAST)
                    local result = refreshCallback()
                    populateServers(type(result) == "table" and result or MOCK_SERVERS)
                    task.delay(0.4, function()
                        tween(refreshBtn, {BackgroundColor3 = T.Accent}, TWEEN_FAST)
                    end)
                end)

                if autoRefresh then
                    task.delay(30, function()
                        while container.Parent do
                            local result = refreshCallback()
                            if type(result) == "table" then populateServers(result) end
                            task.wait(30)
                        end
                    end)
                end

                return container
            end

            table.insert(tabObj._sections, section)
            return section
        end  -- AddSection

        return tabObj
    end  -- CreateDeveloperTab

    self._floatBtn = buildFloatButton(sg, T, function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    table.insert(self._windows, window)
    return window
end  -- CreateManagedWindow

-- ──────────────────────────────────────────────
--  STORE IN GLOBAL ENV
-- ──────────────────────────────────────────────
if getgenv then getgenv().SUNUI = SUNUI end

return SUNUI
