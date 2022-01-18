-- HSE utils

-- Default values
-- Note that there must not be any value higher than minAccessLevelScore or accessLevelLocalPlayer (10), as some cumulative values (team score, for instance) are displayed only if all underlying components (culture, etc.) can be accessed.
maskingActive = 1

minAccessLevelDiplomacy = 1
minAccessLevelEconomy = 1
minAccessLevelCulture = 2
minAccessLevelReligion = 2
minAccessLevelScience = 3
minAccessLevelMilitary = 4
minAccessLevelScore = 4

-- Must be higher than any access level
accessLevelLocalPlayer = 10

-- What to replace values by when they cannot be accessed.
hseUnknown = '?'

-- In some cases, only approximate values can be computed using accessible info.
hsePlus = '+'

include("HSE_config")


-- Mod checks
isBLIActive = Modding.IsModActive("60A6CFAE-34CE-5D53-3640-15B122B9955B"); -- Better Leader Icon
isBRWActive = Modding.IsModActive("67B4DBCB-82AD-3F90-1595-43C677C1301E"); -- Better Religion Window (UI)
isBWRActive = Modding.IsModActive("74D4FDCC-14FE-5F52-7676-03B229E7845D"); -- Better World Ranking
isCQUIActive = Modding.IsModActive("1d44b5e7-753e-405b-af24-5ee634ec8a01"); -- CQUI
isCUIActive = Modding.IsModActive("5f504949-398a-4038-a838-43c3acc4dc10") or Modding.IsModActive("37a200f6-c262-46a8-addb-d92566be1d27"); -- Concise UI / Concise UI Reloaded
isEDRActive = Modding.IsModActive("382a187f-c8ba-4094-a6a7-0d5315661f32"); -- Extended Diplomacy Ribbon
isExpandedAlliancesActive = Modding.IsModActive("4e12695f-0ae8-40c4-9230-aa605c284b64"); -- Expanded Alliances
isNominaActive = Modding.IsModActive("8e1c410a-31e6-44c4-a7c3-1d8f9ef30235"); -- Nomina (Dynamic Civilization and Leader Names)
isQuickDealsActive = Modding.IsModActive("5aceed03-8639-4a81-8cbf-03f54d543502"); -- Quick Deals
isSimplifiedGossipActive = Modding.IsModActive("9e9923e5-6842-4e7d-97e7-c9a56a85cf03"); -- Simplified Gossip

isRFActive = Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9"); -- Rise & Fall
isGatheringStormActive = Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68"); -- Gathering Storm

-- Helper functions
function IsMaskingActive()
	if maskingActive ~= 1 or not maskingActive then
		return false
	else
		return true
	end
end

if not IsMaskingActive() then
	minAccessLevelDiplomacy = 0
	minAccessLevelEconomy = 0
	minAccessLevelCulture = 0
	minAccessLevelReligion = 0
	minAccessLevelScience = 0
	minAccessLevelMilitary = 0
	minAccessLevelScore = 0
end

-- For debugging data masking
--[[
minAccessLevelDiplomacy = 7
minAccessLevelEconomy = 7
minAccessLevelCulture = 7
minAccessLevelReligion = 7
minAccessLevelScience = 7
minAccessLevelScore = 7
minAccessLevelMilitary = 7
--]]

--	Round() from SupportFunctions.lua, fixed for negative numbers
function Round(num:number, idp:number)
	local mult:number = 10^(idp or 0);
	if num >= 0 then return math.floor(num * mult + 0.5) / mult; end
	return math.ceil(num * mult - 0.5) / mult;
end


function IsLocationRevealed(x, y, playerID)
	if Game.GetLocalObserver() == PlayerTypes.OBSERVER then
		return true
	end

	if playerID == nil then
		playerID = Game.GetLocalPlayer()
	end
	
	return PlayersVisibility[playerID]:IsRevealed(x, y)
end

function IsCityRevealed(city, playerID)
	return IsLocationRevealed(city:GetX(), city:GetY(), playerID)
end

-- playerID is the viewer (the one trying to get the information)
function IsCityIDRevealed(cityID, ownerID, playerID)
	if Game.GetLocalObserver() == PlayerTypes.OBSERVER then
		return true
	end

	if playerID == nil then
		playerID = Game.GetLocalPlayer()
	end

	local city = CityManager.GetCity(playerID, cityID)
	return IsCityRevealed(city, playerID)
end

function GetPlayerRevealedCitiesCount(ownerID, playerID)
	local pPlayer:table = Players[ownerID];
	local playerCities = pPlayer:GetCities()
	local revealedCities = 0
	local unrevealedCities = 0

	for _, city in playerCities:Members() do
		if IsCityRevealed(city, playerID) then
			revealedCities = revealedCities + 1
		else
			unrevealedCities = unrevealedCities + 1
		end
	end
	
	return revealedCities, unrevealedCities
end

function GetOriginalCapitalsCount()
	local majorPlayers = PlayerManager.GetAliveMajorIDs()
	
	local visibleOriginalCapitals = 0
	local hiddenOriginalCapitals = 0
	
	-- How many capitals we can see
	for _, id in ipairs(majorPlayers) do
		for _, city in Players[id]:GetCities():Members() do
			local originalOwnerID:number = city:GetOriginalOwner();
			
			if city:IsOriginalCapital() then
				if IsCityRevealed(city) or HasAccessLevel(originalOwnerID, "military") then
					visibleOriginalCapitals = visibleOriginalCapitals + 1
				else
					hiddenOriginalCapitals = hiddenOriginalCapitals + 1
				end
			end
		end
	end

	return visibleOriginalCapitals, hiddenOriginalCapitals
end

function GetOriginalCapitalCityInfo(playerID)
	local majorPlayers = PlayerManager.GetAliveMajorIDs()
	
	-- How many capitals we can see
	for _, id in ipairs(majorPlayers) do
		for _, city in Players[id]:GetCities():Members() do
			if city:IsOriginalCapital() then
				local originalOwnerID:number = city:GetOriginalOwner();
				
				if originalOwnerID == playerID then
					return city:GetID(), (IsCityRevealed(city) or HasAccessLevel(originalOwnerID, "military"))
				end
			end
		end
	end

	return nil, false
end

function CanSeeAllCities()
	local globalCityCount = 0
	local globalCityRevealed = 0
	
	
	local players = PlayerManager.GetAliveIDs()
	local localPlayerID = Game.GetLocalPlayer()

	local localDiplomacy = Players[localPlayerID]:GetDiplomacy()
	for _, id in ipairs(players) do
		for _, city in Players[id]:GetCities():Members() do
			globalCityCount = globalCityCount + 1
			if IsCityRevealed(city) then
				globalCityRevealed = globalCityRevealed + 1
			end
		end
		
		globalCityCount = globalCityCount + Players[id]:GetCities():GetCount()
	end

	return globalCityCount == globalCityRevealed
end

function GetReligiousDetails(religionType)
	local localPlayerID:number = Game.GetLocalPlayer();
	local localDiplomacy = Players[localPlayerID]:GetDiplomacy()

	-- Followers and converted cities only for visible cities.
    local numTotalFollowers:number = 0; -- total number of followers
	local numTotalFollowersHidden:number = 0
	
	local totalMinNumConvertedCities = 0
	local totalMaxNumConvertedCities = 0

	local totalMinNumConvertedCitiesMajor = 0
	local totalMaxNumConvertedCitiesMajor = 0

	local totalMinNumConvertedCitiesMinor = 0
	local totalMaxNumConvertedCitiesMinor = 0

	local totalNumConvertedCities = 0
	local totalNumConvertedCitiesMajor = 0
	local totalNumConvertedCitiesMinor = 0
	
	
	local totalNumCities = 0
	local totalNumCitiesHidden = 0
	
	local totalNumCitiesMetPlayers = 0
	local totalNumCitiesMetPlayersHidden = 0
	
	local totalNumCitiesMetMajorPlayers = 0
	local totalNumCitiesMetMajorPlayersHidden = 0
	
	local totalNumCitiesMajorPlayers = 0
	local totalNumCitiesMajorPlayersHidden = 0
	
	local totalNumCitiesMinorPlayers = 0
	local totalNumCitiesMinorPlayersHidden = 0
	
	local totalNumCitiesMetMinorPlayers = 0
	local totalNumCitiesMetMinorPlayersHidden = 0
	
	local convertedPlayers = 0
	local convertedPlayersMet = 0
	
	local metMajorPlayers = 0
	local unMetMajorPlayers = 0
	
	local players:table = PlayerManager.GetAlive();
	local pLocalPlayerVis:table = PlayersVisibility[Game.GetLocalPlayer()];
	
	local convertedCivs = {}
	local convertedCivsYes = 0
	local convertedCivsNo = 0
	local convertedCivsMaybe = 0
	

	for _, player in ipairs(players) do
		local playerID:number = player:GetID();
		local playerCities:table = player:GetCities();
		local isMajor = player:IsMajor(playerID)
		local hasMet = ( playerID == localPlayerID and true or localDiplomacy:HasMet(playerID) )
		
		-- Only for this players
		local numCities = 0
		local numCitiesHidden = 0
		local numConvertedCities:number = 0;
		local numConvertedCitiesHidden:number = 0

		if isMajor then
			if hasMet then
				metMajorPlayers = metMajorPlayers + 1
			else
				unMetMajorPlayers = unMetMajorPlayers + 1
			end
		end
		
		-- count converted cities
		for _, city in playerCities:Members() do
			local hasVisibility = (not IsMaskingActive()) or pLocalPlayerVis:IsRevealed(city:GetX(), city:GetY()) or Game.GetLocalObserver() == PlayerTypes.OBSERVER

			totalNumCities = totalNumCities + 1
			numCities = numCities + 1
			
			if hasMet then
				totalNumCitiesMetPlayers = totalNumCitiesMetPlayers + 1
				if not hasVisibility then
					totalNumCitiesMetPlayersHidden = totalNumCitiesMetPlayersHidden + 1
				end
				if isMajor then
					totalNumCitiesMetMajorPlayers = totalNumCitiesMetMajorPlayers + 1
					metMajorPlayers = metMajorPlayers + 1
					if not hasVisibility then
						totalNumCitiesMetMajorPlayersHidden = totalNumCitiesMetMajorPlayersHidden + 1
					end
				else
					totalNumCitiesMetMinorPlayers = totalNumCitiesMetMinorPlayers + 1
					if not hasVisibility then
						totalNumCitiesMetMinorPlayersHidden = totalNumCitiesMetMinorPlayersHidden + 1
					end
				end
			end
			
			if isMajor then
				totalNumCitiesMajorPlayers = totalNumCitiesMajorPlayers + 1
				if not hasVisibility then
					totalNumCitiesMajorPlayersHidden = totalNumCitiesMajorPlayersHidden + 1
				end
			else
				totalNumCitiesMinorPlayers = totalNumCitiesMinorPlayers + 1
				if not hasVisibility then
					totalNumCitiesMinorPlayersHidden = totalNumCitiesMinorPlayersHidden + 1
				end
			end
			
			if not hasVisibility then				
				totalNumCitiesHidden = totalNumCitiesHidden + 1
				numCitiesHidden = numCitiesHidden + 1
			end
		
					
			local cityReligion:table = city:GetReligion();
			local religionsInCity:table = cityReligion:GetReligionsInCity();
			
			local hasVisibility = (not IsMaskingActive()) or pLocalPlayerVis:IsRevealed(city:GetX(), city:GetY()) or Game.GetLocalObserver() == PlayerTypes.OBSERVER

			if cityReligion:GetMajorityReligion() == religionType then
				numConvertedCities = numConvertedCities + 1;
				
				if not hasVisibility then
					numConvertedCitiesHidden = numConvertedCitiesHidden + 1
				end
			end
			
			for _, cityReligionData in ipairs(religionsInCity) do
				local eReligion:number = cityReligionData.Religion;
				local followers = cityReligionData.Followers;

				if eReligion == religionType then
					numTotalFollowers = numTotalFollowers + followers
					if not hasVisibility then
						numTotalFollowersHidden = numTotalFollowersHidden + followers
					end
				end
			end
		end
		
		-- We can see the religion of this many cities
		local knownCities = numCities - numCitiesHidden
		local convKnownCities = numConvertedCities - numConvertedCitiesHidden
		local halfCities = 0.5 * numCities
		
		totalNumConvertedCities = totalNumConvertedCities + numConvertedCities
		
		if isMajor then
			totalNumConvertedCitiesMajor = totalNumConvertedCitiesMajor + numConvertedCities
		else
			totalNumConvertedCitiesMinor = totalNumConvertedCitiesMinor + numConvertedCities
		end
		
		local halfCitiesInt = Round(halfCities) -- lower or equal to exactly half, never above 50% (religion majority criterion)
		if halfCitiesInt > halfCities then
			halfCitiesInt = halfCitiesInt - 1
		end
				
		-- nil = unknown, false = confirmed not converted to our religion, true = confirmed converted
		local confirmedInfo = nil
		
		local minConvCities = nil
		local maxconvCities = nil

		-- We have global info on the majority religion, so we know the religion of 50% of the cities
		if HasAccessLevel(playerID, "religion") then

			local majorityReligion = Players[playerID]:GetReligion():GetReligionInMajorityOfCities()
			if majorityReligion ~= -1 then
				if majorityReligion == religionType then
					confirmedInfo = true
					minConvCities = math.max(convKnownCities, halfCitiesInt+1)
					maxConvCities = convKnownCities + numCitiesHidden
				else
					confirmedInfo = false
					minConvCities = convKnownCities
					maxConvCities = math.min(convKnownCities + numCitiesHidden, halfCitiesInt)
				end
			else
				-- We know that there are at most halfCitiesInt cities converted to our religion
				confirmedInfo = nil
				minConvCities = convKnownCities
				maxConvCities = math.min(convKnownCities + numCitiesHidden, halfCitiesInt)
			end
		else
			-- No global religion info
			minConvCities = convKnownCities
			maxConvCities = convKnownCities + numCitiesHidden
			if convKnownCities > halfCitiesInt then
				confirmedInfo = true
			elseif convKnownCities + numCitiesHidden <= halfCitiesInt then
				-- Not enough unknown cities to be of our religion
				confirmedInfo = false
			else
				confirmedInfo = nil
			end		
		end

		totalMinNumConvertedCities = totalMinNumConvertedCities + minConvCities
		totalMaxNumConvertedCities = totalMaxNumConvertedCities + maxConvCities
		
		if isMajor then
			totalMinNumConvertedCitiesMajor = totalMinNumConvertedCitiesMajor + minConvCities
			totalMaxNumConvertedCitiesMajor = totalMaxNumConvertedCitiesMajor + maxConvCities
		else
			totalMinNumConvertedCitiesMinor = totalMinNumConvertedCitiesMinor + minConvCities
			totalMaxNumConvertedCitiesMinor = totalMaxNumConvertedCitiesMinor + maxConvCities
		end
		
		if isMajor then
			if confirmedInfo == true then
				convertedPlayers = convertedPlayers + 1
				table.insert(convertedCivs, playerID);
				
				if hasMet then
					convertedPlayersMet = convertedPlayersMet + 1
				end
				
				convertedCivsYes = convertedCivsYes + 1
			elseif confirmedInfo == false then
				convertedCivsNo = convertedCivsNo + 1
			else
				convertedCivsMaybe = convertedCivsMaybe + 1
			end
		end		
	end
	
	local convertedRangeString = ""
	local maxRangeString = ""

	function MakeRangeString(tot, minC, maxC)
		if not IsMaskingActive() then
			return string.format("%d", tot);			
		else
			if minC ~= maxC then
				return string.format("%d~%d", minC, maxC);
			else
				return string.format("%d", minC)
			end
		end
	end
	
	convertedRangeString = MakeRangeString(totalNumConvertedCities, totalMinNumConvertedCities, totalMaxNumConvertedCities)
	
	convertedRangeStringMajor = MakeRangeString(totalNumConvertedCitiesMajor, totalMinNumConvertedCitiesMajor, totalMaxNumConvertedCitiesMajor)
	
	convertedRangeStringMinor = MakeRangeString(totalNumConvertedCitiesMinor, totalMinNumConvertedCitiesMinor, totalMaxNumConvertedCitiesMinor)
	
	if unMetMajorPlayers > 0 and IsMaskingActive() then
		-- We know the number of cities of met civs and seen city-states
		maxRangeString = tostring(totalNumCitiesMetMajorPlayers + (totalNumCitiesMetMinorPlayers - totalNumCitiesMetMinorPlayersHidden)) .. hsePlus
	else
		-- Include city-states even if we haven't met them
		maxRangeString = tostring(totalNumCities)
	end
		
	ratioString = string.format("%s/%s", convertedRangeString, maxRangeString);
	ratioStringMajor = string.format("%s/%s", convertedRangeStringMajor, maxRangeString);
	ratioStringMinor = string.format("%s/%s", convertedRangeStringMinor, maxRangeString);
	
	local followerString = ""
	
	if not IsMaskingActive or CanSeeAllCities() then
		followerString = tostring(NumTotalFollowers)
	else
		followerString = tostring(numTotalFollowers - numTotalFollowersHidden)
	end
	
	local result:table = { 
		UnMetMajorPlayers = unMetMajorPlayers, 
		NumTotalFollowers = numTotalFollowers,
		TotalNumCitiesVisible = (totalNumCities - totalNumCitiesHidden),
		TotalNumCitiesHidden = totalNumCitiesHidden,
		TotalNumCitiesMetPlayers = totalNumCitiesMetPlayers,
		FollowerString = followerString,
		ConvertedPlayersMet = convertedPlayersMet, 
		MetMajorPlayers = metMajorPlayers, 
		ConvertedCivs = convertedCivs,
		ConvertedPlayers = convertedPlayers,
		TotalNumCitiesMajorPlayersHidden = totalNumCitiesMajorPlayersHidden, 
		TotalNumCitiesMinorPlayersHidden = totalNumCitiesMinorPlayersHidden,
		TotalNumCitiesMetMajorPlayers = totalNumCitiesMetMajorPlayers, 
		TotalNumCitiesMetMinorPlayers = totalNumCitiesMetMinorPlayers, 
		RatioString = ratioString, 
		RatioStringMajor = ratioStringMajor,
		RatioStringMinor = ratioStringMinor,
		TotalNumCities = totalNumCities,
		TotalMaxNumConvertedCities = totalMaxNumConvertedCities,
		TotalMinNumConvertedCities = totalMinNumConvertedCities,
		ConvertedRangeStringMajor = convertedRangeStringMajor,
		ConvertedRangeStringMinor = convertedRangeStringMinor,
		TotalNumCitiesMetMajorPlayersHidden = totalNumCitiesMetMajorPlayersHidden, 
		TotalNumCitiesMetMinorPlayersHidden = totalNumCitiesMetMinorPlayersHidden, 
		NumTotalFollowersVisible = numTotalFollowers - numTotalFollowersHidden,
		ConvertedRangeString = convertedRangeString,
		TotalNumConvertedCities = totalNumConvertedCities,
		TotalNumCitiesMajorPlayers = totalNumCitiesMajorPlayers, 
		TotalNumCitiesMinorPlayers = totalNumCitiesMinorPlayers, 
		TotalNumCitiesMetPlayersHidden = totalNumCitiesMetPlayersHidden, 
		NumTotalFollowersHidden = numTotalFollowersHidden,
		ConvertedCivsNo = convertedCivsNo,
		ConvertedCivsYes = convertedCivsYes,
		ConvertedCivsMaybe = convertedCivsMaybe,
		ReligionType = religionType,
		ReligionName = Game.GetReligion():GetName(religionType),
		}
	
	return result
end


function GetLowestAccessLevel(teamID)
	players = Teams[teamID]
	
	lowestAccessLevel = accessLevelLocalPlayer

	if players ~= nil then
		for i, playerID in ipairs(players) do
			playerAccessLevel = GetAccessLevel(playerID)
			if playerAccessLevel < lowestAccessLevel then
				lowestAccessLevel = playerAccessLevel
			end
		end
	end
	
	return lowestAccessLevel
end

-- Helper method to quickly generate a list of teams of living major players.
function GetAliveMajorTeamIDs()
	local ti = 1;
	local result = {};
	local duplicate_team = {};
	for i,v in ipairs(PlayerManager.GetAliveMajors()) do
		local teamId = v:GetTeam();
		if(duplicate_team[teamId] == nil) then
			duplicate_team[teamId] = true;
			result[ti] = teamId;
			ti = ti + 1;
		end
	end

	return result;
end

function GetPlayerTeamID(playerID)
	local teamIDs = GetAliveMajorTeamIDs();

	for _, teamID in ipairs(teamIDs) do
		team = Teams[teamID]
		if (team ~= nil) then
			for i, playerIDToCheck in ipairs(Teams[teamID]) do
				if playerIDToCheck == playerID then
					return teamID
				end
			end
		end
	end
	
	return nil
end

function GetAccessLevel(playerID)
	local localPlayerID:number = Game.GetLocalPlayer();
	
	if playerID == localPlayerID then
		-- Pseudo "unlimited access" level.
		return accessLevelLocalPlayer;
	end
	
	if GetPlayerTeamID(playerID) == Players[localPlayerID]:GetTeam() then
		return accessLevelLocalPlayer
	end
	
	if not Players[localPlayerID]:GetDiplomacy():HasMet(playerID) then
		-- We cannot get any info if we haven't met the player!
		return -1
	end
	
	local localPlayerDiplomacy = Players[localPlayerID]:GetDiplomacy();
	local iAccessLevel = localPlayerDiplomacy:GetVisibilityOn(playerID);
	
	return iAccessLevel
end

function HasAccessLevelString(playerID, infoType, s)
	if HasAccessLevel(playerID, infoType) then
		return s
	else
		return hseUnknown
	end
end

function HasAccessLevelTeamString(teamID, infoType, s)
	if HasAccessLevelTeam(playerID, infoType) then
		return s
	else
		return hseUnknown
	end
end

function GetAccessLevelTeam(teamID)
	local localPlayerID:number = Game.GetLocalPlayer();
	local localTeamID = Players[localPlayerID]:GetTeam();

	if type(teamID) ~= "number" then
		print("Warning: teamID is " .. tostring(teamID))
	end
	
	if teamID == localTeamID then
		-- Pseudo "unlimited access" level.
		return accessLevelLocalPlayer;
	end
	
	local lowestAccessLevelTeam = GetLowestAccessLevel(teamID)
	
	return lowestAccessLevelTeam;
end

function HasAccessLevel(playerID, infoType)
	if type(playerID) ~= "number" then
		print("Warning: playerID is " .. tostring(playerID) .. " when requesting info " .. infoType)
	end
	
	accessLevel = GetAccessLevel(playerID)
	minAccessLevel = GetMinAccessLevelFromInfoType(playerID, infoType)
	
	if CheckAllianceForType(playerID, infoType) then
		minAccessLevel = 0
	end
		
	return accessLevel >= minAccessLevel
end

function HasAccessLevelTeam(teamID, infoType)
	accessLevel = GetAccessLevelTeam(teamID)
	minAccessLevel = GetMinAccessLevelFromInfoType(playerID, infoType)
	
	-- If we have the required alliance type with at least one of the players of the team, we get the info
	
	players = Teams[teamID]

	if players ~= nil then
		for i, playerID in ipairs(players) do
			if CheckAllianceForType(playerID, infoType) then
				minAccessLevel = 0
				break
			end
		end
	end
	
	return accessLevel >= minAccessLevel
end

function CheckAllianceForType(playerID, infoType)
	local allianceType = nil
	local allianceName = nil
	local localPlayerDiplomacy = Players[Game.GetLocalPlayer()]:GetDiplomacy();
	
	-- Function requires at least Rise & Fall
	if localPlayerDiplomacy and (isRFActive or isGatheringStormActive) then
		allianceType = localPlayerDiplomacy:GetAllianceType(playerID);
		
		if allianceType ~= nil and allianceType ~= -1 then
			allianceName = GameInfo.Alliances[allianceType].PrimaryKey
		end
	
		-- Not needed, but here for reference
		--[[
		if allianceType ~= -1 then
			allianceLevel = localPlayerDiplomacy:GetAllianceLevel(playerID);
		end
		]]
	end
	
	--[[
		Alliances:
		0	ALLIANCE_RESEARCH
		1	ALLIANCE_CULTURAL
		2	ALLIANCE_ECONOMIC
		3	ALLIANCE_MILITARY
		4	ALLIANCE_RELIGIOUS
		
		If using Expanded Alliances:
		5	ALLIANCE_JNR_INDUSTRIAL
		6	ALLIANCE_JNR_URBAN
		7	ALLIANCE_JNR_MARITIME
		8	ALLIANCE_JNR_ESPIONAGE
	]]
	
	if allianceType ~= nil and allianceType ~= -1 and allianceName ~= nil then
		if infoType == "science" and allianceName == "ALLIANCE_RESEARCH" then 
			return true
		elseif infoType == "culture" and allianceName == "ALLIANCE_CULTURAL" then
			return true
		elseif infoType == "military" and (allianceName == "ALLIANCE_MILITARY" or allianceName == "ALLIANCE_JNR_ESPIONAGE") then
			return true
		elseif infoType == "religion" and (allianceName == "ALLIANCE_RELIGIOUS") then
			return true
		elseif infoType == "diplomacy" and allianceType >= 0 then
			return true
		elseif infoType == "economy" and (allianceName == "ALLIANCE_ECONOMIC" or allianceName == "ALLIANCE_JNR_INDUSTRIAL" or allianceName == "ALLIANCE_JNR_MARITIME" or allianceName == "ALLIANCE_JNR_URBAN") then
			return true
		elseif infoType == "score" and (allianceName == "ALLIANCE_MILITARY" or allianceName == "ALLIANCE_JNR_ESPIONAGE") then
			return true
		end
	end
	
	return false
end
	
function ConvertVictoryTypeToInfoType(victoryType)
	if victoryType == "VICTORY_TECHNOLOGY" or victoryType == "SCIENCE" then 
		return "science"
	elseif victoryType == "VICTORY_CULTURE" or victoryType == "CULTURE" then
		return "culture"
	elseif victoryType == "VICTORY_CONQUEST" or victoryType == "DOMINATION" then
		return "military"
	elseif victoryType == "VICTORY_RELIGIOUS" or victoryType == "RELIGION" then
		return "religion"
	elseif victoryType == "VICTORY_DIPLOMATIC" or victoryType == "DIPLOMATIC" then
		return "diplomacy"
	end

	print("Warning: unknown victory type: " .. tostring(victoryType))

	return nil
end

-- Category in playerData.Categories
function ConvertCategoryToInfoType(categoryID)
	if categoryID == 0 then -- Civics
		return "culture"
	elseif categoryID == 1 then -- Population
		return "default"
	elseif categoryID == 2 then -- Great People
		return "default" -- This is public info
	elseif categoryID == 3 then -- Religion
		return "religion"
	elseif categoryID == 4 then -- Technologies
		return "science"
	elseif categoryID == 5 then -- Wonders
		return "default" -- This is public info
	elseif categoryID == 12 then -- Era Score
		return "score"
	end
	
	print("Warning: unknown category ID: " .. tostring(categoryID))
	
	return nil
end

function GetMinAccessLevelFromInfoType(playerID, infoType)
	-- If an observer, all info is always available
	-- This doesn't work: skip
	-- if Game.GetLocalObserver() == PlayerTypes.OBSERVER then
	--	return 0
	-- end
	
	if infoType == "science" then 
		return minAccessLevelScience
	elseif infoType == "culture" then
		return minAccessLevelCulture
	elseif infoType == "military" then
		return minAccessLevelMilitary
	elseif infoType == "religion" then
		return minAccessLevelReligion
	elseif infoType == "diplomacy" then
		return minAccessLevelDiplomacy
	elseif infoType == "economy" then
		local localPlayerDiplomacy = Players[Game.GetLocalPlayer()]:GetDiplomacy()
		
		-- Hide all info that would available via the deal panel if at war and a peace deal is not possible.
		if localPlayerDiplomacy:IsAtWarWith(playerID) then
			if not localPlayerDiplomacy:IsDiplomaticActionValid("DIPLOACTION_PROPOSE_PEACE_DEAL", playerID, true) then
				return minAccessLevelEconomy
			end
		end

		return 0
	elseif infoType == "score" then
		return minAccessLevelScore
	elseif infoType == "default" then -- placeholder for "no access level requirement"
		return 0
	end
	
	print("Warning: unknown info type " .. tostring(infoType))
	
	return 0
end

-- Deep copy tables
function deepcopy(o, seen)
  seen = seen or {}
  if o == nil then return nil end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[deepcopy(k, seen)] = deepcopy(v, seen)
    end
    setmetatable(no, deepcopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
end


-- For debugging

function print_table(node, full)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"
	
	if node == nil then
		print("<nil>")
	elseif type(node) == "string" then
		print(node)
	elseif type(node) == "number" then
		print(node)
	else
		while true do
			local size = 0
			for k,v in pairs(node) do
				size = size + 1
			end

			local cur_index = 1
			for k,v in pairs(node) do
				if (cache[node] == nil) or (cur_index >= cache[node]) then

					if (string.find(output_str,"}",output_str:len())) then
						output_str = output_str .. ",\n"
					elseif not (string.find(output_str,"\n",output_str:len())) then
						output_str = output_str .. "\n"
					end

					-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
					table.insert(output,output_str)
					output_str = ""

					local key
					if (type(k) == "number" or type(k) == "boolean") then
						key = "["..tostring(k).."]"
					else
						key = "['"..tostring(k).."']"
					end

					if (type(v) == "number" or type(v) == "boolean") then
						output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
					elseif (type(v) == "table") then
						if full == true then
							output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
							table.insert(stack,node)
							table.insert(stack,v)
							cache[node] = cur_index+1
							break
						else
							output_str = output_str .. "[SHORTENED]"
						end
					else
						output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
					end

					if (cur_index == size) then
						output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
					else
						output_str = output_str .. ","
					end
				else
					-- close the table
					if (cur_index == size) then
						output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
					end
				end

				cur_index = cur_index + 1
			end

			if (size == 0) then
				output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
			end

			if (#stack > 0) then
				node = stack[#stack]
				stack[#stack] = nil
				depth = cache[node] == nil and depth + 1 or depth - 1
			else
				break
			end
		end

		-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
		table.insert(output,output_str)
		
		
		-- A for loop + print makes the ouput easier to handle by the lua engine.
		-- output_str = table.concat(output)
		-- print(output_str)
		
		for _, v in ipairs(output) do
		  print(v)
		end
	end
end