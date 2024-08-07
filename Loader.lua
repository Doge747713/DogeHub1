local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local keys = {
    "000377X99100E887e99F938Nf",
    "xDTkErqYYf2XuaQMszj6jm", --ömer
    "qT81680yv7GBFhdZGJbBug", --özer
    "Sikici-ozer", --özer 2
    "Ejf2YZdhauGY11MGDVbB6Y", --garland
    "Dogebest",
    "Z1dnNh5NBqgT2E44eZG61u",
    -- Add more keys here if needed
}

local privatekeys = {
    "HVAQBEnnaduryyHQVatgMM",
    "bnaaAMUTDPeTwbbKbfAggb", --ömer
    "cfhhcLqiKqUrNbucCRnXey", --özer
    "NkJNmjHanWQgYCytpoYrvH",
    "wxAsMnmtZAFXDxnnrddnaa", --özer 2
    "aXUVRuWAxAobVsCz88nPnZ", --garland
    "Dogebestpriv",
    "fRtWKVPvRaqLeLnPeLjjad",
    -- Add more keys here if needed
}

-- Function to check if the provided key is valid
local function isValidKey(inputKey)
    for _, key in ipairs(keys) do
        if key == inputKey then
            return "Normal"
        end
    end
    for _, key in ipairs(privatekeys) do
        if key == inputKey then
            return "priv"
        end
    end
    return false
end

-- Create the GUI elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyGui"
ScreenGui.Parent = game.CoreGui

-- Create a background frame for better aesthetics
local BackgroundFrame = Instance.new("Frame")
BackgroundFrame.Size = UDim2.new(0, 300, 0, 200)
BackgroundFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BackgroundFrame.BorderSizePixel = 0
BackgroundFrame.Parent = ScreenGui

-- Create a UI corner for rounded edges
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0) -- Rounded corners
UICorner.Parent = BackgroundFrame

-- Create the TextBox for key input
local TextBox = Instance.new("TextBox")
TextBox.Name = "KeyTextBox"
TextBox.Size = UDim2.new(0, 250, 0, 50)
TextBox.Position = UDim2.new(0.5, -125, 0.5, -30)
TextBox.PlaceholderText = "Enter your key"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.BorderSizePixel = 0
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 18
TextBox.Parent = BackgroundFrame

-- Create a UI corner for the TextBox
local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(5, 0)
TextBoxCorner.Parent = TextBox

-- Create the TextButton for submission
local TextButton = Instance.new("TextButton")
TextButton.Name = "SubmitButton"
TextButton.Size = UDim2.new(0, 100, 0, 50)
TextButton.Position = UDim2.new(0.5, -50, 0.5, 40)
TextButton.Text = "Submit"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Green background
TextButton.BorderSizePixel = 0
TextButton.Font = Enum.Font.SourceSans
TextButton.TextSize = 18
TextButton.Parent = BackgroundFrame

-- Create a UI corner for the TextButton
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0.1, 0)
ButtonCorner.Parent = TextButton

-- Variable to track if the script should execute
local shouldExecute = false

-- Handle key submission
TextButton.MouseButton1Click:Connect(function()
    local userKey = TextBox.Text
    local keyType = isValidKey(userKey)

    if keyType then
        print("Valid key. The script will execute.")
        shouldExecute = true
        ScreenGui:Destroy() -- Hide and remove the GUI

        -- Place your script's main code here
        if shouldExecute then
            if keyType == "Normal" then
                loadstring(game:HttpGet('https://raw.githubusercontent.com/Doge747713/DogeHub1/main/DogeHubNormal.lua'))()
            elseif keyType == "priv" then
                loadstring(game:HttpGet('https://raw.githubusercontent.com/Doge747713/DogeHub1/main/DogeHubPriv.lua'))()
            end
            -- You can replace the print statement with your main script code
        end
    else
        print("Invalid key. The script will not execute.")
        -- Optionally, you could add feedback for the user, like changing the text color of the TextBox or showing an error message.
        TextBox.Text = "" -- Clear the TextBox for new input
    end
end)

-- Main script code that should not run until the key is validated
while not shouldExecute do
    wait(1) -- Wait until the key is validated and shouldExecute is true
end
