local httpService = game:GetService("HttpService")
local workspace = game:GetService('Workspace')
local MAX_RETRIES = 250
local RETRY_DELAY = 5

local function fetchServerInfo()
	return httpService:JSONDecode(httpService:GetAsync('http://ip-api.com/json/'))
end

-- sometimes the request fails,
-- so we retry until we get a successful response or reach the MAX_RETRIES
local function retry()
	local retries = 0
	local success = false
	local serverInfo = nil

	while not success and retries < MAX_RETRIES do
		local retrySuccess, retryResult = pcall(fetchServerInfo)

		if retrySuccess then
			success = true
			serverInfo = retryResult
		else
			retries = retries + 1
			task.wait(RETRY_DELAY)
		end
	end

	return success, serverInfo
end

local success, serverInfo = retry()
if success then
	workspace:SetAttribute('Region', serverInfo.regionName .. ', ' .. serverInfo.country)
end