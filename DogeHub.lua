local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local radius = 800  -- Adjusted radius for the circle
local menuGui
local showingVault = false
local targetPlayerName = nil
local gameId = game.PlaceId
local circleGui
local originalPositions = {}
local teleportEnabled = true  -- Teleportation is enabled by default
print("Made By Doge")

-- Create the white circle in the middle of the screen
local function createCircleGui()
    if circleGui then circleGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    circleGui = ScreenGui

    local OuterCircle = Instance.new("Frame")
    OuterCircle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
    OuterCircle.Position = UDim2.new(0.5, -radius, 0.5, -radius)
    OuterCircle.BackgroundTransparency = 1
    OuterCircle.BorderColor3 = Color3.fromRGB(255, 255, 255)
    OuterCircle.BorderSizePixel = 2
    OuterCircle.Parent = ScreenGui

    local InnerCircle = Instance.new("Frame")
    InnerCircle.Size = UDim2.new(1, 0, 1, 0)
    InnerCircle.Position = UDim2.new(0, 0, 0, 0)
    InnerCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    InnerCircle.BackgroundTransparency = 1
    InnerCircle.Parent = OuterCircle
end

-- Check if the target is within the circle
local function isWithinCircle(targetPosition)
    local camera = workspace.CurrentCamera
    local screenPos = camera:WorldToScreenPoint(targetPosition)
    local circleCenter = Vector2.new(circleGui.AbsoluteSize.X / 2, circleGui.AbsoluteSize.Y / 2)
    local circleRadius = circleGui.AbsoluteSize.X / 2
    local distance = (Vector2.new(screenPos.X, screenPos.Y) - circleCenter).magnitude
    return distance <= circleRadius
end

-- Teleport player in front of the local player
local function teleportPlayer(targetPlayer)
    if not teleportEnabled then return end

    local character = targetPlayer.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    -- Save the original position
    if not originalPositions[targetPlayer.Name] then
        originalPositions[targetPlayer.Name] = head.Position
    end

    -- Move player to in front of the local player
    local camera = workspace.CurrentCamera
    local forwardVector = camera.CFrame.LookVector * 10 -- Adjust the distance as needed
    local newPosition = camera.CFrame.Position + forwardVector
    head.CFrame = CFrame.new(newPosition)
end

-- Revert player to their original position
local function revertPlayerPosition(targetPlayer)
    local character = targetPlayer.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    -- Restore the original position
    if originalPositions[targetPlayer.Name] then
        head.CFrame = CFrame.new(originalPositions[targetPlayer.Name])
        originalPositions[targetPlayer.Name] = nil
    end
end

-- Create a GUI for inventory menu
local function createInventoryMenu(playerName, clothing, equipment, inventory, vault)
    if menuGui then menuGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    menuGui = ScreenGui
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 400)
    Frame.Position = UDim2.new(0, 10, 0, 10)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Title.Text = "____MENU_____"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Parent = Frame

    local PlayerNameLabel = Instance.new("TextLabel")
    PlayerNameLabel.Size = UDim2.new(1, 0, 0, 30)
    PlayerNameLabel.Position = UDim2.new(0, 0, 0, 50)
    PlayerNameLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    PlayerNameLabel.Text = "Player: " .. playerName
    PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerNameLabel.Parent = Frame

    local function createList(sectionTitle, items, startY)
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Size = UDim2.new(1, 0, 0, 30)
        SectionTitle.Position = UDim2.new(0, 0, 0, startY)
        SectionTitle.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        SectionTitle.Text = sectionTitle
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.Parent = Frame

        local offset = startY + 30
        for _, item in ipairs(items) do
            local ItemLabel = Instance.new("TextLabel")
            ItemLabel.Size = UDim2.new(1, 0, 0, 30)
            ItemLabel.Position = UDim2.new(0, 0, 0, offset)
            ItemLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            ItemLabel.Text = item
            ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ItemLabel.Parent = Frame
            offset = offset + 30
        end
        return offset
    end

    local yOffset
    if showingVault then
        yOffset = createList("Vault", vault, 80)
    else
        yOffset = createList("Clothing", clothing, 80)
        yOffset = createList("Equipment", equipment, yOffset)
        createList("Inventory", inventory, yOffset)
    end

    -- Adjust GUI position if it doesn't fit the screen
    local function adjustGuiPosition()
        local screenSize = workspace.CurrentCamera.ViewportSize
        local guiSize = Frame.AbsoluteSize
        local guiPosition = Frame.AbsolutePosition

        if guiPosition.X + guiSize.X > screenSize.X then
            Frame.Position = UDim2.new(0, screenSize.X - guiSize.X - 10, 0, Frame.Position.Y.Offset)
        end

        if guiPosition.Y + guiSize.Y > screenSize.Y then
            Frame.Position = UDim2.new(Frame.Position.X.Scale, Frame.Position.X.Offset, 0, screenSize.Y - guiSize.Y - 10)
        end
    end
    adjustGuiPosition()
end

-- Get data from ReplicatedStorage
local function getPlayerData(targetPlayerName)
    local clothing = {}
    local equipment = {}
    local inventory = {}
    local vault = {}

    local playerData = ReplicatedStorage:FindFirstChild("Players"):FindFirstChild(targetPlayerName)
    if playerData then
        local clothingFolder = playerData:FindFirstChild("Clothing")
        local equipmentFolder = playerData:FindFirstChild("Equipment")
        local inventoryFolder = playerData:FindFirstChild("Inventory")
        local vaultFolder = playerData:FindFirstChild("Vault")

        if clothingFolder then
            for _, item in ipairs(clothingFolder:GetChildren()) do
                table.insert(clothing, item.Name)
            end
        end
        if equipmentFolder then
            for _, item in ipairs(equipmentFolder:GetChildren()) do
                table.insert(equipment, item.Name)
            end
        end
        if inventoryFolder then
            for _, item in ipairs(inventoryFolder:GetChildren()) do
                table.insert(inventory, item.Name)
            end
        end
        if vaultFolder then
            for _, item in ipairs(vaultFolder:GetChildren()) do
                table.insert(vault, item.Name)
            end
        end
    end
    return clothing, equipment, inventory, vault
end

-- Check mouse target
local function checkMouseTarget()
    local mouse = LocalPlayer:GetMouse()
    local target = mouse.Target
    if target and target.Parent and Players:FindFirstChild(target.Parent.Name) then
        local targetPlayer = Players:FindFirstChild(target.Parent.Name)
        if targetPlayer and targetPlayer ~= LocalPlayer then
            local targetPosition = targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") and targetPlayer.Character.Head.Position
            if targetPosition and isWithinCircle(targetPosition) then
                -- Teleport player and get data
                if teleportEnabled then
                    teleportPlayer(targetPlayer)
                end
                local clothing, equipment, inventory, vault = getPlayerData(targetPlayer.Name)
                createInventoryMenu(targetPlayer.Name, clothing, equipment, inventory, vault)
            end
        end
    else
        if menuGui then
            menuGui:Destroy()
        end
        if teleportEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    revertPlayerPosition(player)
                end
            end
        end
    end
end

-- Handle input for toggling teleportation and vault visibility
local function onInput(input)
    if input.KeyCode == Enum.KeyCode.B then
        teleportEnabled = not teleportEnabled
        print("Teleportation " .. (teleportEnabled and "Enabled" or "Disabled"))
    elseif input.KeyCode == Enum.KeyCode.Z and gameId == 7336302630 then
        showingVault = not showingVault
        print("Showing Vault: " .. tostring(showingVault))
        -- Update the menu if open
        if menuGui then
            local playerName = menuGui:FindFirstChild("PlayerNameLabel") and menuGui.PlayerNameLabel.Text:match("Player: (.+)")
            if playerName then
                local clothing, equipment, inventory, vault = getPlayerData(playerName)
                createInventoryMenu(playerName, clothing, equipment, inventory, vault)
            end
        end
    end
end

-- Connect input event
UserInputService.InputBegan:Connect(onInput)

-- Update GUI and teleport player every frame
RunService.RenderStepped:Connect(checkMouseTarget)

-- Create initial circle GUI
createCircleGui()
