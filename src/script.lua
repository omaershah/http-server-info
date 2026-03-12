local httpService = game:GetService("HttpService")
local workspace = game:GetService('Workspace')

local function fetchServerInfo()
	return httpService:JSONDecode(httpService:GetAsync('http://ip-api.com/json/'))
end

local function retry()
	local retries = 0
	local success = false
	local serverInfo = nil

	while not success and retries < 250 do
		local retrySuccess, retryResult = pcall(fetchServerInfo)

		if retrySuccess then
			success = true
			serverInfo = retryResult
		else
			retries = retries + 1
			task.wait(5)
		end
	end

	return success, serverInfo
end

local success, serverInfo = retry()
if success then
	game:GetService('Workspace'):SetAttribute('Region', serverInfo.regionName .. ', ' .. serverInfo.country)
end