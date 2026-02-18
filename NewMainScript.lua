local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

-- Protect the GUI from being deleted on reset
ScreenGui.Parent = (game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "VortexWatermark"

TextLabel.Parent = ScreenGui
TextLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Dark theme
TextLabel.BackgroundTransparency = 0.3
TextLabel.Position = UDim2.new(0.5, -85, 0, 15) -- Centered at the top
TextLabel.Size = UDim2.new(0, 170, 0, 35)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "VORTEX V4 | pvpez"
TextLabel.TextColor3 = Color3.fromRGB(0, 255, 150) -- Mint/Green accent
TextLabel.TextSize = 16
TextLabel.BorderSizePixel = 0

-- Rounded corners for a modern look
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = TextLabel

-- Optional: Subtle UI Stroke (Border)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Transparency = 0.8
UIStroke.Parent = TextLabel
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'newvape', 'newvape/games', 'newvape/profiles', 'newvape/assets', 'newvape/libraries', 'newvape/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/7GrandDadPGN/VapeV4ForRoblox')
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
		wipeFolder('newvape')
		wipeFolder('newvape/games')
		wipeFolder('newvape/guis')
		wipeFolder('newvape/libraries')
	end
	writefile('newvape/profiles/commit.txt', commit)
end

return loadstring(downloadFile('newvape/main.lua'), 'main')()