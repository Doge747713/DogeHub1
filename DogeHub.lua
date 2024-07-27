local badremote = game.ReplicatedStorage.Remotes:WaitForChild("\208\149rrrorLog")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Containers = workspace:WaitForChild("Containers")
local player = game.Players.LocalPlayer
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Doge747713/DogeHub1/main/OrionLoader.lua')))()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local radius = 950  -- Adjusted radius for the circle
local menuGui
local showingVault = false
local targetPlayerName = nil
local gameId = game.PlaceId
local circleGui
local espenabled22 = true  -- Variable to track ESP state
local highlightCache = {}
local originalPositions = {}
local teleportEnabled = true  -- Teleportation is enabled by default
local espEnabled = false  -- Toggle ESP feature
print("Made By Doge")
print("TELEPORTATION = SILENT AIM")
print("Loaded Succ")
warn("System Error")

badremote:Destroy()


-- Function to create a highlight for a player
local function createHighlight(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"  -- Give the highlight a name for easy removal
        highlight.Parent = player.Character
        highlight.FillColor = Color3.new(1, 0, 0) -- Red fill color
        highlight.FillTransparency = 0.5 -- Transparency of the fill
        highlight.OutlineColor = Color3.new(1, 1, 0) -- Yellow outline color
        highlight.OutlineTransparency = 0.5 -- Transparency of the outline
        
        -- Store the highlight in the cache
        highlightCache[player.UserId] = highlight
    end
end

-- Function to create or update the BillboardGui for each container
local function createBillboardGui(container)
    -- Check if the container has an Inventory folder
    local inventory = container:FindFirstChild("Inventory")
    if not inventory then
        warn("No Inventory found in container: " .. container.Name)
        return
    end

    -- Create BillboardGui if it doesn't exist
    local billboardGui = container:FindFirstChild("BillboardGui")
    if not billboardGui then
        billboardGui = Instance.new("BillboardGui")
        billboardGui.Size = UDim2.new(0, 200, 0, 100) -- Adjust size as needed
        billboardGui.StudsOffset = Vector3.new(0, 3, 0) -- Position above the container
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = container
    end

    -- Create a Frame to hold inventory items if it doesn't exist
    local frame = billboardGui:FindFirstChild("Frame")
    if not frame then
        frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
        frame.Name = "Frame"
        frame.Parent = billboardGui
    end

    -- Create a TextLabel to display the inventory items if it doesn't exist
    local textLabel = frame:FindFirstChild("TextLabel")
    if not textLabel then
        textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1) -- White text
        textLabel.TextSize = 14
        textLabel.TextWrapped = true
        textLabel.Name = "TextLabel"
        textLabel.Parent = frame
    end

    -- Function to update the TextLabel with current inventory items
    local function updateInventoryDisplay()
        local itemNames = {}
        for _, item in ipairs(inventory:GetChildren()) do
            if item:IsA("StringValue") or item:IsA("IntValue") or item:IsA("BoolValue") then
                table.insert(itemNames, item.Name) -- Assuming the item's name is what you want to display
            else
                warn("Item is not a valid value type in Inventory: " .. item.Name)
            end
        end

        -- Check if itemNames is empty
        if #itemNames == 0 then
            textLabel.Text = "No items in inventory"
        else
            -- Display items in the TextLabel
            textLabel.Text = table.concat(itemNames, "\n") -- Join names with newline
        end
    end

    -- Initial inventory display
    updateInventoryDisplay()

    -- Connect inventory updates
    inventory.ChildAdded:Connect(updateInventoryDisplay)
    inventory.ChildRemoved:Connect(updateInventoryDisplay)
end

-- Function to iterate through all containers and create Billboards
local function setupContainers()
    for _, container in ipairs(Containers:GetChildren()) do
        createBillboardGui(container)
    end
end

-- Call the setup function
setupContainers()

-- Optional: If you want to listen for changes in Containers (e.g., new containers added)
Containers.ChildAdded:Connect(function(newContainer)
    createBillboardGui(newContainer)
end)

-- Function to remove highlight for a player
local function removeHighlight(player)
    local highlight = highlightCache[player.UserId]
    if highlight then
        highlight:Destroy()
        highlightCache[player.UserId] = nil
    end
end

-- Function to update highlights for all players
local function updateHighlights()
    if espenabled22 then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and not highlightCache[player.UserId] then
                createHighlight(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            removeHighlight(player)
        end
    end
end

-- Function to toggle ESP
local function toggleESP()
    espenabled22 = not espenabled22
    print("ESP " .. (espenabled22 and "Enabled" or "Disabled"))
    updateHighlights()  -- Update highlights based on the new state
end

-- Connect to PlayerAdded and PlayerRemoving events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espenabled22 then
            createHighlight(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
end)

-- Call updateHighlights to initially create highlights for all players
updateHighlights()

-- Continuous highlight update
RunService.RenderStepped:Connect(function()
    if espenabled22 then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and not highlightCache[player.UserId] then
                createHighlight(player)
            end
        end
    end
end)

-- This function can be called from your GUI or any other part of your script
-- Example: toggleESP() to enable or disable the ESP

--Anti Cheat Break

local function loopBreakAntiCheatTest()
    while wait(1) do
        if badremote and badremote:IsA("RemoteEvent") then -- Check if badremote exists and is a RemoteEvent
            badremote:Destroy() -- Destroy the remote event
            print("Bad remote destroyed.")
            break -- Break the loop after destroying
        end
    end
end

loopBreakAntiCheatTest() 


local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    print("Aimbot " .. (aimbotEnabled and "Enabled" or "Disabled"))

    if aimbotEnabled then
        -- Connect the aiming function to RenderStepped when enabled
        RunService.RenderStepped:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target.Parent and game.Players:FindFirstChild(target.Parent.Name) then
                local targetPlayer = game.Players:FindFirstChild(target.Parent.Name)
                if targetPlayer and targetPlayer ~= LocalPlayer then
                    silentAim(targetPlayer)
                end
            end
        end)
    end
end

local Window = OrionLib:MakeWindow({
    Name = "DOGE HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "doge.pub"
})

local Credits = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Premium = Window:MakeTab({
    Name = "Premium",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = true
})

-- Main Tab
local mainTab = Window:MakeTab({
    Name = "main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/SemaP1rat/sanya.pub/main/alwaysdies_hitlogs.lua"))()

-- Main Tab Buttons
mainTab:AddButton({
    Name = "SILENT AIM KEYBIND: P",
    Callback = function()
            teleportEnabled = not teleportEnabled
        print("Teleportation " .. (teleportEnabled and "Enabled" or "Disabled"))
    end
})

Credits:AddButton({
    Name = "CREATED BY DOGE",
    Callback = function()

    end
})



Premium:AddButton({
    Name = "SOON!",
    Callback = function()

    end
})

Credits:AddButton({
    Name = "VERSION 0.4",
    Callback = function()

    end
})

-- Function to toggle the aimbot

mainTab:AddButton({
    Name = "AIMBOT NOT WORKING",
    Callback = function()
        toggleAimbot()
    end
})

mainTab:AddButton({
    Name = "Check For Target",
    Callback = function()

checkForTarget()
        
    end
})

mainTab:AddButton({
    Name = "Night Vision Keybind: U",
    Callback = function()

            nightVisionEnabled = not nightVisionEnabled
            if nightVisionEnabled then
                game.Lighting.Ambient = Color3.fromRGB(255,255,255)  -- Example color for night vision
                game.Lighting.Brightness = 7  -- Increase brightness for night vision
            else
                game.Lighting.Ambient = Color3.fromRGB(128, 128, 128)  -- Default ambient color
                game.Lighting.Brightness = 3  -- Default brightness
            end
        
    end
})

mainTab:AddButton({
    Name = "SHOW VAULT KEYBIND: Z (ONLY WORKS IN LOBBY)",
    Callback = function()
        showingVault = not showingVault
        print("Showing Vault: " .. tostring(showingVault))
    end
})


mainTab:AddButton({
    Name = "ESP&hitbox body(medium=5 zxy; possible ban)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SemaP1rat/sanya.pub/main/hbbodymedium.lua", true))()
    end
})

mainTab:AddButton({
    Name = "ESP&Hitbox body(legit)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SemaP1rat/sanya.pub/main/hbbodylegit.lua", true))()
    end
})

-- Visual Tab
local visualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

visualTab:AddButton({
    Name = "Night vision",
    Callback = function()
            
    end
})

visualTab:AddButton({
    Name = "ESP",
    Callback = function()
toggleESP()
    end
})

visualTab:AddButton({
    Name = "Show Loot Containers",
    Callback = function()
       
    end
})

visualTab:AddButton({
    Name = "Crosshair",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SemaP1rat/standoff_chetiks_crack/main/crosshair.lua"))()
    end
})

visualTab:AddButton({
    Name = "FOV keybind = -",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SemaP1rat/sanya.pub/main/megafovpasta.lua"))()
    end
})

-- Additional Code
print'DOGE'


-- LocalScript placed in StarterPlayerScripts

-- Function to execute the desired action
local function executeAction()
    local player = game.Players.LocalPlayer
    -- Wait for the GUI to be fully loaded
    repeat
        wait()
    until player.PlayerGui:FindFirstChild("MainGui") and player.PlayerGui.MainGui:FindFirstChild("MainFrame") and player.PlayerGui.MainGui.MainFrame:FindFirstChild("ScreenEffects")

    -- Set the visibility of the specific GUI element
    local visor = player.PlayerGui.MainGui.MainFrame:FindFirstChild("ScreenEffects")
    if visor then
        visor.Visor.Visible = false
    else
        warn("AltynVisor not found!")
    end
end

-- Connect the function to the player's character being added
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    -- Run the action when the character is added
    executeAction()
end)

-- Run the action immediately in case the character is already loaded
if game.Players.LocalPlayer.Character then
    executeAction()
end


-- Function to create and display the GUI
local function createTemporaryGui()
    -- Create the ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui

    -- Create the Frame
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 100) -- Adjust size as needed
    Frame.Position = UDim2.new(0.5, -150, 0.5, -50) -- Centered position
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.Parent = ScreenGui

    -- Create the TextLabel
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Created By Doge"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = true
    TextLabel.Parent = Frame

    -- Remove the GUI after 5 seconds
    delay(3, function()
        ScreenGui:Destroy()
    end)
end

-- Call the function to create the GUI when the script executes


-- Function to create video GUI
local function createVideoGui(videoId)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    
    local VideoFrame = Instance.new("VideoFrame")
    VideoFrame.Size = UDim2.new(1, 0, 1, 0)  -- Full screen size
    VideoFrame.Position = UDim2.new(0, 0, 0, 0)
    VideoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    VideoFrame.Video = "rbxassetid://" .. videoId
    VideoFrame.Playing = true
    VideoFrame.Parent = ScreenGui

    -- Destroy video GUI after the video ends
    VideoFrame.Ended:Connect(function()
        ScreenGui:Destroy()
    end)
end

-- Call the function with your video asset ID
createVideoGui(5608359401)  -- Replace with your actual video asset ID
wait(6.4)
createTemporaryGui()


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

-- Function to aim at the target player's head
local function silentAim(targetPlayer)
    if not teleportEnabled then return end

    local character = targetPlayer.Character
    if not character or not character:FindFirstChild("Head") then return end

    local head = character.Head

    -- Set the camera's CFrame to aim at the target player's head
    local camera = workspace.CurrentCamera
    local aimPosition = head.Position + Vector3.new(0, 0.5, 0) -- Adjust height if necessary

    -- Calculate the new CFrame that points to the target player's head
    camera.CFrame = CFrame.new(camera.CFrame.Position, aimPosition)

    -- Optionally trigger shooting (implement the appropriate remote event for your game)
    -- Example: game.ReplicatedStorage:WaitForChild("ShootEvent"):FireServer(aimPosition)
end

-- Teleport player to in front of the local player (if needed)
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
    head.CFrame = CFrame.new(camera.CFrame.Position + forwardVector)
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

-- Example of using the silent aim function when targeting a player
local function checkForTarget()
    local mouse = LocalPlayer:GetMouse()
    local target = mouse.Target
    if target and target.Parent and Players:FindFirstChild(target.Parent.Name) then
        local targetPlayer = Players:FindFirstChild(target.Parent.Name)
        if targetPlayer and targetPlayer ~= LocalPlayer then
            -- Call silent aim on the target player
            silentAim(targetPlayer)

            -- Optionally, teleport the player if needed
            -- teleportPlayer(targetPlayer)
        end
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
    Title.Text = "MENU CREATED BY DOGE"
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

-- Create ESP (box, tracer, and name display)
local function createESP(player)
    if not espEnabled then return end

    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    -- Box
    local boxGui = Instance.new("BillboardGui")
    boxGui.Size = UDim2.new(0, 100, 0, 100)
    boxGui.StudsOffset = Vector3.new(0, 3, 0)
    boxGui.AlwaysOnTop = true
    boxGui.Parent = character

    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(1, 0, 1, 0)
    boxFrame.BorderSizePixel = 2
    boxFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    boxFrame.BackgroundTransparency = 1
    boxFrame.Parent = boxGui

    -- Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 30)
    nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.BackgroundTransparency = 0.5
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Text = player.Name
    nameLabel.Parent = boxGui

    -- Tracer
    local tracerLine = Instance.new("Line")
    tracerLine.Color = Color3.fromRGB(0, 255, 0)
    tracerLine.Thickness = 2
    tracerLine.Parent = game.CoreGui
    local function updateTracer()
        local camera = workspace.CurrentCamera
        local screenPos = camera:WorldToScreenPoint(head.Position)
        tracerLine.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
        tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
    end
    RunService.RenderStepped:Connect(updateTracer)
end

-- Remove ESP
local function removeESP(player)
    if not player.Character then return end

    local character = player.Character
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("BillboardGui") then
            child:Destroy()
        end
    end
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
                
                -- Add ESP to the player
                createESP(targetPlayer)
            else
                -- Remove ESP if not within circle
                removeESP(targetPlayer)
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
        -- Remove ESP for all players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                removeESP(player)
            end
        end
    end
end

-- Handle input for toggling teleportation, vault visibility, and ESP
local function onInput(input)
    if input.KeyCode == Enum.KeyCode.P then
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
                elseif input.KeyCode == Enum.KeyCode.U then
            -- Toggle Night Vision
            nightVisionEnabled = not nightVisionEnabled
            if nightVisionEnabled then
                game.Lighting.Ambient = Color3.fromRGB(255,255,255)  -- Example color for night vision
                game.Lighting.Brightness = 7  -- Increase brightness for night vision
            else
                game.Lighting.Ambient = Color3.fromRGB(128, 128, 128)  -- Default ambient color
                game.Lighting.Brightness = 3  -- Default brightness
            end
    elseif input.KeyCode == Enum.KeyCode.E then
        print("ESP " .. (espEnabled and "Enabled" or "Disabled"))
    end
end



-- Connect input event
UserInputService.InputBegan:Connect(onInput)

-- Update GUI, teleport player, and ESP every frame
RunService.RenderStepped:Connect(checkMouseTarget)

-- Create initial circle GUI
createCircleGui()
