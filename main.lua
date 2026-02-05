local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local aimbotSettings = {
	enabled = false,
	maxDistance = 50,
	targetPart = "Head",
	smoothness = 0.2,
	active = false,
	currentTarget = nil
}

local function createGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AimbotGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 320, 0, 380)
	mainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 45)
	titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 12)
	titleCorner.Parent = titleBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 1, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "🎯 Aimbot System"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 20
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Size = UDim2.new(0, 35, 0, 35)
	minimizeButton.Position = UDim2.new(1, -80, 0, 5)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
	minimizeButton.Text = "─"
	minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizeButton.TextSize = 18
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.Parent = titleBar

	local minimizeCorner = Instance.new("UICorner")
	minimizeCorner.CornerRadius = UDim.new(0, 8)
	minimizeCorner.Parent = minimizeButton

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 35, 0, 35)
	closeButton.Position = UDim2.new(1, -40, 0, 5)
	closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	closeButton.Text = "✕"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 18
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = titleBar

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, -30, 1, -60)
	contentFrame.Position = UDim2.new(0, 15, 0, 55)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = mainFrame

	local isMinimized = false
	minimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			contentFrame.Visible = false
			mainFrame:TweenSize(
				UDim2.new(0, 320, 0, 45),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.3,
				true
			)
			minimizeButton.Text = "□"
		else
			mainFrame:TweenSize(
				UDim2.new(0, 320, 0, 380),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.3,
				true
			)
			wait(0.3)
			contentFrame.Visible = true
			minimizeButton.Text = "─"
		end
	end)

	closeButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
		aimbotSettings.enabled = false
		aimbotSettings.active = false
	end)

	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or 
			input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	local enableButton = Instance.new("TextButton")
	enableButton.Name = "EnableButton"
	enableButton.Size = UDim2.new(1, 0, 0, 50)
	enableButton.Position = UDim2.new(0, 0, 0, 0)
	enableButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	enableButton.Text = "❌ Aimbot: معطل"
	enableButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	enableButton.TextSize = 16
	enableButton.Font = Enum.Font.GothamBold
	enableButton.Parent = contentFrame

	local enableCorner = Instance.new("UICorner")
	enableCorner.CornerRadius = UDim.new(0, 10)
	enableCorner.Parent = enableButton

	enableButton.MouseButton1Click:Connect(function()
		aimbotSettings.enabled = not aimbotSettings.enabled
		if aimbotSettings.enabled then
			enableButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
			enableButton.Text = "✅ Aimbot: مفعّل"
		else
			enableButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
			enableButton.Text = "❌ Aimbot: معطل"
			aimbotSettings.active = false
			aimbotSettings.currentTarget = nil
		end
	end)

	local distanceLabel = Instance.new("TextLabel")
	distanceLabel.Size = UDim2.new(1, 0, 0, 30)
	distanceLabel.Position = UDim2.new(0, 0, 0, 65)
	distanceLabel.BackgroundTransparency = 1
	distanceLabel.Text = "📏 المسافة القصوى: " .. aimbotSettings.maxDistance .. " متر"
	distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	distanceLabel.TextSize = 14
	distanceLabel.Font = Enum.Font.GothamBold
	distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
	distanceLabel.Parent = contentFrame

	local distanceSliderBg = Instance.new("Frame")
	distanceSliderBg.Size = UDim2.new(1, 0, 0, 35)
	distanceSliderBg.Position = UDim2.new(0, 0, 0, 100)
	distanceSliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	distanceSliderBg.Parent = contentFrame

	local distanceSliderCorner = Instance.new("UICorner")
	distanceSliderCorner.CornerRadius = UDim.new(0, 8)
	distanceSliderCorner.Parent = distanceSliderBg

	local distanceSlider = Instance.new("Frame")
	distanceSlider.Size = UDim2.new(0.5, 0, 1, 0)
	distanceSlider.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	distanceSlider.BorderSizePixel = 0
	distanceSlider.Parent = distanceSliderBg

	local distanceSliderFill = Instance.new("UICorner")
	distanceSliderFill.CornerRadius = UDim.new(0, 8)
	distanceSliderFill.Parent = distanceSlider

	local minusButton = Instance.new("TextButton")
	minusButton.Size = UDim2.new(0, 40, 0, 35)
	minusButton.Position = UDim2.new(0, 0, 0, 140)
	minusButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	minusButton.Text = "-"
	minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minusButton.TextSize = 24
	minusButton.Font = Enum.Font.GothamBold
	minusButton.Parent = contentFrame

	local minusCorner = Instance.new("UICorner")
	minusCorner.CornerRadius = UDim.new(0, 8)
	minusCorner.Parent = minusButton

	local plusButton = Instance.new("TextButton")
	plusButton.Size = UDim2.new(0, 40, 0, 35)
	plusButton.Position = UDim2.new(1, -40, 0, 140)
	plusButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	plusButton.Text = "+"
	plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	plusButton.TextSize = 24
	plusButton.Font = Enum.Font.GothamBold
	plusButton.Parent = contentFrame

	local plusCorner = Instance.new("UICorner")
	plusCorner.CornerRadius = UDim.new(0, 8)
	plusCorner.Parent = plusButton

	local distanceInput = Instance.new("TextBox")
	distanceInput.Size = UDim2.new(1, -90, 0, 35)
	distanceInput.Position = UDim2.new(0, 45, 0, 140)
	distanceInput.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	distanceInput.Text = tostring(aimbotSettings.maxDistance)
	distanceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	distanceInput.TextSize = 16
	distanceInput.Font = Enum.Font.GothamBold
	distanceInput.PlaceholderText = "أدخل المسافة"
	distanceInput.Parent = contentFrame

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 8)
	inputCorner.Parent = distanceInput

	local function updateDistance(newDistance)
		newDistance = math.clamp(newDistance, 10, 500)
		aimbotSettings.maxDistance = newDistance
		distanceLabel.Text = "📏 المسافة القصوى: " .. newDistance .. " متر"
		distanceInput.Text = tostring(newDistance)
		distanceSlider.Size = UDim2.new(newDistance / 500, 0, 1, 0)
	end

	minusButton.MouseButton1Click:Connect(function()
		updateDistance(aimbotSettings.maxDistance - 5)
	end)

	plusButton.MouseButton1Click:Connect(function()
		updateDistance(aimbotSettings.maxDistance + 5)
	end)

	distanceInput.FocusLost:Connect(function()
		local newValue = tonumber(distanceInput.Text)
		if newValue then
			updateDistance(newValue)
		else
			distanceInput.Text = tostring(aimbotSettings.maxDistance)
		end
	end)

	local targetLabel = Instance.new("TextLabel")
	targetLabel.Size = UDim2.new(1, 0, 0, 30)
	targetLabel.Position = UDim2.new(0, 0, 0, 190)
	targetLabel.BackgroundTransparency = 1
	targetLabel.Text = "🎯 الجزء المستهدف:"
	targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	targetLabel.TextSize = 14
	targetLabel.Font = Enum.Font.GothamBold
	targetLabel.TextXAlignment = Enum.TextXAlignment.Left
	targetLabel.Parent = contentFrame

	local headButton = Instance.new("TextButton")
	headButton.Size = UDim2.new(0.48, 0, 0, 45)
	headButton.Position = UDim2.new(0, 0, 0, 225)
	headButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	headButton.Text = "🧠 الرأس (Head)"
	headButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	headButton.TextSize = 14
	headButton.Font = Enum.Font.GothamBold
	headButton.Parent = contentFrame

	local headCorner = Instance.new("UICorner")
	headCorner.CornerRadius = UDim.new(0, 8)
	headCorner.Parent = headButton

	local bodyButton = Instance.new("TextButton")
	bodyButton.Size = UDim2.new(0.48, 0, 0, 45)
	bodyButton.Position = UDim2.new(0.52, 0, 0, 225)
	bodyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	bodyButton.Text = "👤 الجسم (Body)"
	bodyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	bodyButton.TextSize = 14
	bodyButton.Font = Enum.Font.GothamBold
	bodyButton.Parent = contentFrame

	local bodyCorner = Instance.new("UICorner")
	bodyCorner.CornerRadius = UDim.new(0, 8)
	bodyCorner.Parent = bodyButton

	headButton.MouseButton1Click:Connect(function()
		aimbotSettings.targetPart = "Head"
		headButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
		bodyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	end)

	bodyButton.MouseButton1Click:Connect(function()
		aimbotSettings.targetPart = "HumanoidRootPart"
		bodyButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
		headButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	end)

	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(1, 0, 0, 60)
	infoLabel.Position = UDim2.new(0, 0, 0, 285)
	infoLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	infoLabel.Text = "⌨️ اضغط C للتفعيل\n✅ يجب أن يكون اللاعب ضمن المسافة"
	infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	infoLabel.TextSize = 12
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextWrapped = true
	infoLabel.Parent = contentFrame

	local infoCorner = Instance.new("UICorner")
	infoCorner.CornerRadius = UDim.new(0, 8)
	infoCorner.Parent = infoLabel

	return screenGui
end

local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = aimbotSettings.maxDistance

	if not character or not character.Parent then
		character = player.Character
		if character then
			humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		end
	end

	if not humanoidRootPart then return nil end

	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local otherCharacter = otherPlayer.Character
			local otherHRP = otherCharacter:FindFirstChild("HumanoidRootPart")
			local otherHumanoid = otherCharacter:FindFirstChild("Humanoid")

			if otherHRP and otherHumanoid and otherHumanoid.Health > 0 then
				local distance = (humanoidRootPart.Position - otherHRP.Position).Magnitude

				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = otherCharacter
				end
			end
		end
	end

	return closestPlayer
end

local function aimAtTarget(targetCharacter)
	if not targetCharacter then return end

	local targetPart = targetCharacter:FindFirstChild(aimbotSettings.targetPart)
	if not targetPart then
		targetPart = targetCharacter:FindFirstChild("HumanoidRootPart")
	end

	if targetPart then
		local targetPosition = targetPart.Position
		local cameraPosition = camera.CFrame.Position
		local direction = (targetPosition - cameraPosition).Unit

		local newCFrame = CFrame.new(cameraPosition, targetPosition)

		camera.CFrame = camera.CFrame:Lerp(newCFrame, aimbotSettings.smoothness)
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.C and aimbotSettings.enabled then
		aimbotSettings.active = not aimbotSettings.active

		if aimbotSettings.active then
			aimbotSettings.currentTarget = getClosestPlayer()

			if not aimbotSettings.currentTarget then
				aimbotSettings.active = false
			end
		else
			aimbotSettings.currentTarget = nil
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.C then
		aimbotSettings.active = false
		aimbotSettings.currentTarget = nil
	end
end)

RunService.RenderStepped:Connect(function()
	if aimbotSettings.enabled and aimbotSettings.active and aimbotSettings.currentTarget then
		local targetHumanoid = aimbotSettings.currentTarget:FindFirstChild("Humanoid")
		local targetHRP = aimbotSettings.currentTarget:FindFirstChild("HumanoidRootPart")

		if targetHumanoid and targetHumanoid.Health > 0 and targetHRP and humanoidRootPart then
			local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude

			if distance <= aimbotSettings.maxDistance then
				aimAtTarget(aimbotSettings.currentTarget)
			else
				aimbotSettings.active = false
				aimbotSettings.currentTarget = nil
			end
		else
			aimbotSettings.active = false
			aimbotSettings.currentTarget = nil
		end
	end
end)

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	aimbotSettings.active = false
	aimbotSettings.currentTarget = nil
end)

createGUI()
