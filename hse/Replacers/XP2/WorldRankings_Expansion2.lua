-- Copyright 2018, Firaxis Games

-- ===========================================================================
-- Includes
-- ===========================================================================
include("WorldRankings");

-- ===========================================================================
-- Constants
-- ===========================================================================
local PADDING_GENERIC_ITEM_BG:number = 25;
local SIZE_GENERIC_ITEM_MIN_Y:number = 54;
local DATA_FIELD_SELECTION:string = "Selection";
local PADDING_TAB_BUTTON_TEXT:number = 27;

local m_ScienceIM:table = InstanceManager:new("ScienceInstance", "ButtonBG", Controls.ScienceViewStack);
local m_ScienceTeamIM:table = InstanceManager:new("ScienceTeamInstance", "ButtonFrame", Controls.ScienceViewStack);
local m_ScienceHeaderIM:table = InstanceManager:new("ScienceHeaderInstance", "HeaderTop", Controls.ScienceViewHeader);

local SPACE_PORT_DISTRICT_INFO:table = GameInfo.Districts["DISTRICT_SPACEPORT"];
local EARTH_SATELLITE_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EARTH_SATELLITE"]
};
local MOON_LANDING_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_MOON_LANDING"]
};
local MARS_COLONY_EXP2_PROJECT_INFOS:table = { 
	GameInfo.Projects["PROJECT_LAUNCH_MARS_BASE"],
};
local EXOPLANET_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EXOPLANET_EXPEDITION"],
};
local SCIENCE_PROJECTS_EXP2:table = {
	EARTH_SATELLITE_EXP2_PROJECT_INFOS,
	MOON_LANDING_EXP2_PROJECT_INFOS,
	MARS_COLONY_EXP2_PROJECT_INFOS,
	EXOPLANET_EXP2_PROJECT_INFOS
};

local SCIENCE_ICON:string = "ICON_VICTORY_TECHNOLOGY";
local SCIENCE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_VICTORY");
local SCIENCE_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_DETAILS_EXP2");
local SCIENCE_REQUIREMENTS:table = {
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_1"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_2"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_3"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_4")
};

-- ===========================================================================
-- Cached Functions
-- ===========================================================================
BASE_PopulateTabs = PopulateTabs;
BASE_AddTab = AddTab;
BASE_AddExtraTab = AddExtraTab;
BASE_OnTabClicked = OnTabClicked;
BASE_PopulateGenericInstance = PopulateGenericInstance;
BASE_PopulateGenericTeamInstance = PopulateGenericTeamInstance;
BASE_GetDefaultStackSize = GetDefaultStackSize;

g_victoryData.VICTORY_DIPLOMATIC = {
	GetText = function(p) 
		local total = GlobalParameters.DIPLOMATIC_VICTORY_POINTS_REQUIRED;
		local current = 0;
		if (p:IsAlive()) then
			current = p:GetStats():GetDiplomaticVictoryPoints();
		end

		return Locale.Lookup("LOC_WORLD_RANKINGS_DIPLOMATIC_POINTS_TT", current, total);
	end,
	GetScore = function(p)
		local current = 0;
		if (p:IsAlive()) then
			current = p:GetStats():GetDiplomaticVictoryPoints();
		end

		return current;
	end
};
 
-- ===========================================================================
-- Overrides
-- ===========================================================================
function OnTabClicked(tabInst:table, onClickCallback:ifunction)
	return function()
		DeselectPreviousTab();
		DeselectExtraTabs();
		tabInst.Selection:SetHide(false);
		onClickCallback();
	end
end

function PopulateGenericTeamInstance(instance:table, teamData:table, victoryType:string)
	PopulateTeamInstanceShared(instance, teamData.TeamID);
	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("GenericInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateGenericInstance(instance.PlayerStackIM:GetInstance(), playerData, victoryType, true);
	end

	local requirementSetID:number = Game.GetVictoryRequirements(teamData.TeamID, victoryType);
	if requirementSetID ~= nil and requirementSetID ~= -1 then

		local detailsText:string = "";
		local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
		for _, requirementID in ipairs(innerRequirements) do

			if detailsText ~= "" then
				detailsText = detailsText .. "[NEWLINE]";
			end

			local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
			local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

			if requirementText ~= nil then
				detailsText = detailsText .. requirementText;
				local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
				if playerData ~= nil then
					civIconClass:SetLeaderTooltip(playerData.PlayerID, requirementText);
				end
			else
				local requirementState:string = GameEffects.GetRequirementState(requirementID);
				local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
				if requirementState == "Met" or requirementState == "AlwaysMet" then
					detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
				else
					detailsText = detailsText .. "[ICON_Bolt]";
				end
				detailsText = detailsText .. requirementDetails.ID;
			end
			
			if victoryType == "VICTORY_DIPLOMATIC" then
				if HasAccessLevelTeam(teamData.TeamID, "diplomacy") then
					detailsText = ""
				end
			end

			instance.Details:SetText(detailsText);
		end
	else
		instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonFrame:SetSizeY(itemSize);
end

function PopulateGenericInstance(instance:table, playerData:table, victoryType:string, showTeamDetails:boolean )
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);
	
	if showTeamDetails then
		local requirementSetID:number = Game.GetVictoryRequirements(Players[playerData.PlayerID]:GetTeam(), victoryType);
		if requirementSetID ~= nil and requirementSetID ~= -1 then

			local detailsText:string = "";
			local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
			if innerRequirements ~= nil then
				for _, requirementID in ipairs(innerRequirements) do

					if detailsText ~= "" then
						detailsText = detailsText .. "[NEWLINE]";
					end

					local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
					local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

					if requirementText ~= nil then
						detailsText = detailsText .. requirementText;
						local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
						
						if victoryType == "VICTORY_DIPLOMATIC" and not HasAccessLevel(playerData.PlayerID, "diplomacy") then
							requirementText = string.gsub(requirementText, "%d+/", hseUnknown..'/')
						end

						civIconClass:SetLeaderTooltip(playerData.PlayerID, requirementText);
					else
						local requirementState:string = GameEffects.GetRequirementState(requirementID);
						local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
						if requirementState == "Met" or requirementState == "AlwaysMet" then
							detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
						else
							detailsText = detailsText .. "[ICON_Bolt]";
						end
						detailsText = detailsText .. requirementDetails.ID;
					end
				end
			else
				detailsText = "";
			end
			
			if victoryType == "VICTORY_DIPLOMATIC" and not HasAccessLevel(playerData.PlayerID, "diplomacy") then
				detailsText = string.gsub(detailsText, "%d+/", hseUnknown..'/')
			end
			
			instance.Details:SetText(detailsText);
		else
			instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
		end
	else
		instance.Details:SetText("");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonBG:SetSizeY(itemSize);
end

-- ===========================================================================
--	Called when Science tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewScience()
	ResetState(ViewScience);
	Controls.ScienceView:SetHide(false);

	ChangeActiveHeader("VICTORY_TECHNOLOGY", m_ScienceHeaderIM, Controls.ScienceViewHeader);
	PopulateGenericHeader(RealizeScienceStackSize, SCIENCE_TITLE, "", SCIENCE_DETAILS, SCIENCE_ICON);
	
	local totalCost:number = 0;
	local currentProgress:number = 0;
	local progressText:string = "";
	local progressResults:table = { 0, 0, 0, 0 }; -- initialize with 3 elements
	local finishedProjects:table = { {}, {}, {}, {} };
	
	local bHasSpaceport:boolean = false;
	if (g_LocalPlayer ~= nil) then
		for _,district in g_LocalPlayer:GetDistricts():Members() do
			if (district ~= nil and district:IsComplete() and district:GetType() == SPACE_PORT_DISTRICT_INFO.Index) then
				bHasSpaceport = true;
				break;
			end
		end

		local pPlayerStats:table = g_LocalPlayer:GetStats();
		local pPlayerCities:table = g_LocalPlayer:GetCities();
		for _, city in pPlayerCities:Members() do
			local pBuildQueue:table = city:GetBuildQueue();
			-- 1st milestone - satellite launch
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(EARTH_SATELLITE_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[1][i] = projectProgress == projectCost;
			end
			progressResults[1] = currentProgress / totalCost;

			-- 2nd milestone - moon landing
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(MOON_LANDING_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[2][i] = projectProgress == projectCost;
			end
			progressResults[2] = currentProgress / totalCost;
		
			-- 3rd milestone - mars landing
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(MARS_COLONY_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[3][i] = projectProgress == projectCost;
			end
			progressResults[3] = currentProgress / totalCost;

			-- 4th milestone - exoplanet expeditiion
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(EXOPLANET_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[4][i] = projectProgress == projectCost;
			end
			progressResults[4] = currentProgress / totalCost;
		end
	end

	local nextStep:string = "";
	for i, result in ipairs(progressResults) do
		if(result < 1) then
			progressText = progressText .. "[ICON_Bolt]";
			if(nextStep == "") then
				nextStep = GetNextStepForScienceProject(g_LocalPlayer, SCIENCE_PROJECTS_EXP2[i], bHasSpaceport, finishedProjects[i]);
			end
		else
			progressText = progressText .. "[ICON_CheckmarkBlue] ";
		end
		progressText = progressText .. SCIENCE_REQUIREMENTS[i] .. "[NEWLINE]";
	end

	-- Final milestone - Earning Victory Points (Light Years)
	local totalLightYears:number = g_LocalPlayer:GetStats():GetScienceVictoryPointsTotalNeeded();
	local lightYears = g_LocalPlayer:GetStats():GetScienceVictoryPoints();
	if (lightYears < totalLightYears) then
		progressText = progressText .. "[ICON_Bolt]";
	else
		progressText = progressText .. "[ICON_CheckmarkBlue]";
	end
	progressText = progressText .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_FINAL", totalLightYears);

	g_activeheader.AdvisorTextCentered:SetText(progressText);
    if (nextStep ~= "") then
        g_activeheader.AdvisorTextNextStep:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP", nextStep));
	else
		-- If the user One More Turns, this keeps rolling in the DLL and makes us look goofy.
		if lightYears > totalLightYears then
			lightYears = totalLightYears;
		end

        g_activeheader.AdvisorTextNextStep:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_HAS_MOVED", lightYears, totalLightYears));
    end

	m_ScienceIM:ResetInstances();
	m_ScienceTeamIM:ResetInstances();

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			if #team > 1 then
				PopulateScienceTeamInstance(m_ScienceTeamIM:GetInstance(), teamID);
			else
				local pPlayer = Players[team[1]];
				if (pPlayer:IsAlive() == true and pPlayer:IsMajor() == true) then
					PopulateScienceInstance(m_ScienceIM:GetInstance(), pPlayer);
				end
			end
		end
	end
	
	RealizeScienceStackSize();
end

function GetNextStepForScienceProject(pPlayer:table, projectInfos:table, bHasSpaceport:boolean, finishedProjects:table)

	if(not bHasSpaceport) then 
		return Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_BUILD", Locale.Lookup(SPACE_PORT_DISTRICT_INFO.Name));
	end

	local playerTech:table = pPlayer:GetTechs();
	local numProjectInfos:number = table.count(projectInfos);
	for i, projectInfo in ipairs(projectInfos) do

		if(projectInfo.PrereqTech ~= nil) then
			local tech:table = GameInfo.Technologies[projectInfo.PrereqTech];
			if(not playerTech:HasTech(tech.Index)) then
				return Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_RESEARCH", Locale.Lookup(tech.Name));
			end
		end

		if(not finishedProjects[i]) then
			return Locale.Lookup(projectInfo.Name);
		end
	end
	return "";
end

function PopulateScienceInstance(instance:table, pPlayer:table)
	local playerID:number = pPlayer:GetID();
	PopulatePlayerInstanceShared(instance, playerID);
	
	-- Progress Data to be returned from function
	local progressData = nil; 

	local bHasSpaceport:boolean = false;
	for _,district in pPlayer:GetDistricts():Members() do
		if (district ~= nil and district:IsComplete() and district:GetType() == SPACE_PORT_DISTRICT_INFO.Index) then
			bHasSpaceport = true;
			break;
		end
	end

	local pPlayerStats:table = pPlayer:GetStats();
	local pPlayerCities:table = pPlayer:GetCities();
	local projectTotals:table = { 0, 0, 0, 0 };
	local projectProgresses:table = { 0, 0, 0, 0 };
	local finishedProjects:table = { {}, {}, {}, {} };
	for _, city in pPlayerCities:Members() do
		local pBuildQueue:table = city:GetBuildQueue();

		-- 1st milestone - satelite launch
		for i, projectInfo in ipairs(EARTH_SATELLITE_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[1][i] = false;
			if projectProgress ~= 0 then
				projectTotals[1] = projectTotals[1] + projectCost;
				projectProgresses[1] = projectProgresses[1] + projectProgress;
				finishedProjects[1][i] = projectProgress == projectCost;
			end
		end

		-- 2nd milestone - moon landing
		for i, projectInfo in ipairs(MOON_LANDING_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[2][i] = false;
			if projectProgress ~= 0 then
				projectTotals[2] = projectTotals[2] + projectCost;
				projectProgresses[2] = projectProgresses[2] + projectProgress;
				finishedProjects[2][i] = projectProgress == projectCost;
			end
		end

		-- 3rd milestone - mars landing
		for i, projectInfo in ipairs(MARS_COLONY_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[3][i] = false;
			projectTotals[3] = projectTotals[3] + projectCost;
			if projectProgress ~= 0 then
				projectProgresses[3] = projectProgresses[3] + projectProgress;
				finishedProjects[3][i] = projectProgress == projectCost;
			end
		end

		-- 4th milestone - exoplanet expedition
		for i, projectInfo in ipairs(EXOPLANET_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[4][i] = false;
			projectTotals[4] = projectTotals[4] + projectCost;
			if projectProgress ~= 0 then
				projectProgresses[4] = projectProgresses[4] + projectProgress;
				finishedProjects[4][i] = projectProgress == projectCost;
			end
		end
	end

	-- Save data to be returned
	progressData = {};
	progressData.playerID = playerID;
	progressData.projectTotals = projectTotals;
	progressData.projectProgresses = projectProgresses;
	progressData.bHasSpaceport = bHasSpaceport;
	progressData.finishedProjects = finishedProjects;

	if HasAccessLevel(playerID, "science") then
		PopulateScienceProgressMeters(instance, progressData);
	end
	
	return progressData;
end

function GetTooltipForScienceProject(pPlayer:table, projectInfos:table, bHasSpaceport:boolean, finishedProjects:table)

	local result:string = "";

	-- Only show spaceport for first tooltip
	if bHasSpaceport ~= nil then
		if(bHasSpaceport) then 
			result = result .. "[ICON_CheckmarkBlue]";
		else
			result = result .. "[ICON_Bolt]";
		end
		result = result .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_BUILD", Locale.Lookup(SPACE_PORT_DISTRICT_INFO.Name)) .. "[NEWLINE]";
	end

	local playerTech:table = pPlayer:GetTechs();
	local numProjectInfos:number = table.count(projectInfos);
	for i, projectInfo in ipairs(projectInfos) do

		if(projectInfo.PrereqTech ~= nil) then
			local tech:table = GameInfo.Technologies[projectInfo.PrereqTech];
			if(playerTech:HasTech(tech.Index)) then
				result = result .. "[ICON_CheckmarkBlue]";
			else
				result = result .. "[ICON_Bolt]";
			end
			result = result .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_RESEARCH", Locale.Lookup(tech.Name)) .. "[NEWLINE]";
		end

		if(finishedProjects[i]) then
			result = result .. "[ICON_CheckmarkBlue]";
		else
			result = result .. "[ICON_Bolt]";
		end
		result = result .. Locale.Lookup(projectInfo.Name);
		if(i < numProjectInfos) then result = result .. "[NEWLINE]"; end
	end

	return result;
end

function PopulateScienceProgressMeters(instance:table, progressData:table)
	local pPlayer = Players[progressData.playerID];

	for i = 1, 4 do
		instance["ObjHidden_" .. i]:SetHide(true);
		instance["ObjFill_" .. i]:SetHide(progressData.projectProgresses[i] == 0);
		instance["ObjBar_" .. i]:SetPercent(progressData.projectProgresses[i] / progressData.projectTotals[i]);
		instance["ObjToggle_ON_" .. i]:SetHide(progressData.projectTotals[i] == 0 or progressData.projectProgresses[i] ~= progressData.projectTotals[i]);
	end
	
    instance["ObjHidden_5"]:SetHide(true);
    -- if bar 4 is at 100%, light up bar 5
    if ((progressData.projectProgresses[4] >= progressData.projectTotals[4]) and (progressData.projectTotals[4] ~= 0)) then
		local lightYears = pPlayer:GetStats():GetScienceVictoryPoints();
		local lightYearsPerTurn = pPlayer:GetStats():GetScienceVictoryPointsPerTurn();
		local totalLightYears = g_LocalPlayer:GetStats():GetScienceVictoryPointsTotalNeeded();

		instance["ObjFill_5"]:SetHide(false);
        instance["ObjToggle_ON_5"]:SetHide(lightYears == 0 or lightYears < lightYearsPerTurn);
        -- my test save returns a larger value for light years than for years needed, so guard against drawing errors
        if lightYears > totalLightYears then
            lightYears = totalLightYears;
        end
        instance["ObjBar_5"]:SetPercent(lightYears/totalLightYears);
		instance.ObjBG_5:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_IS_MOVING", lightYearsPerTurn));
    else
        instance["ObjFill_5"]:SetHide(true);
        instance["ObjToggle_ON_5"]:SetHide(true);
        instance["ObjBar_5"]:SetPercent(0);
		instance.ObjBG_5:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NO_LAUNCH"));
    end
    		
	instance.ObjBG_1:SetToolTipString(GetTooltipForScienceProject(pPlayer, EARTH_SATELLITE_EXP2_PROJECT_INFOS, progressData.bHasSpaceport, progressData.finishedProjects[1]));
	instance.ObjBG_2:SetToolTipString(GetTooltipForScienceProject(pPlayer, MOON_LANDING_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[2]));
	instance.ObjBG_3:SetToolTipString(GetTooltipForScienceProject(pPlayer, MARS_COLONY_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[3]));
	instance.ObjBG_4:SetToolTipString(GetTooltipForScienceProject(pPlayer, EXOPLANET_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[4]));
end

-- ===========================================================================
--	Called once during Init
-- ===========================================================================
function PopulateTabs()

	-- Clean up previous data
	m_ExtraTabs = {};
	m_TotalTabSize = 0;
	m_MaxExtraTabSize = 0;
	g_ExtraTabsIM:ResetInstances();
	g_TabSupportIM:ResetInstances();
	
	-- Deselect previously selected tab
	if g_TabSupport then
		g_TabSupport.SelectTab(nil);
		DeselectPreviousTab();
		DeselectExtraTabs();
	end

	-- Create TabSupport object
	g_TabSupport = CreateTabs(Controls.TabContainer, 42, 44, UI.GetColorValueFromHexLiteral(0xFF331D05));

	local defaultTab = AddTab(TAB_OVERALL, ViewOverall);

	-- Add default victory types in a pre-determined order
	if(GameConfiguration.IsAnyMultiplayer() or Game.IsVictoryEnabled("VICTORY_SCORE")) then
		BASE_AddTab(TAB_SCORE, ViewScore);
	end
	if(Game.IsVictoryEnabled("VICTORY_TECHNOLOGY")) then
		AddTab(TAB_SCIENCE, ViewScience);
	end
	if(Game.IsVictoryEnabled("VICTORY_CULTURE")) then
		g_CultureInst = AddTab(TAB_CULTURE, ViewCulture);
	end
	if(Game.IsVictoryEnabled("VICTORY_CONQUEST")) then
		AddTab(TAB_DOMINATION, ViewDomination);
	end
	if(Game.IsVictoryEnabled("VICTORY_RELIGIOUS")) then
		AddTab(TAB_RELIGION, ViewReligion);
	end

	-- Add custom (modded) victory types
	for row in GameInfo.Victories() do
   	local victoryType:string = row.VictoryType;
		if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) then
            if (victoryType == "VICTORY_DIPLOMATIC") then
                AddTab(Locale.Lookup("LOC_TOOLTIP_DIPLOMACY_CONGRESS_BUTTON"), function() ViewDiplomatic(victoryType); end);
            else
                AddTab(Locale.Lookup(row.Name), function() ViewGeneric(victoryType); end);
            end
		end
	end

	if m_TotalTabSize > (Controls.TabContainer:GetSizeX()*2) then
		Controls.ExpandExtraTabs:SetHide(false);
		for _, tabInst in pairs(m_ExtraTabs) do
			tabInst.Button:SetSizeX(m_MaxExtraTabSize);
		end
	else
		Controls.ExpandExtraTabs:SetHide(true);
	end

	Controls.ExpandExtraTabs:SetHide(true);

	g_TabSupport.SelectTab(defaultTab);
	g_TabSupport.CenterAlignTabs(0, 450, 32);
end

function AddTab(label:string, onClickCallback:ifunction)

	local tabInst:table = g_TabSupportIM:GetInstance();
	tabInst.Button[DATA_FIELD_SELECTION] = tabInst.Selection;

	tabInst.Button:SetText(label);
	local textControl = tabInst.Button:GetTextControl();
	textControl:SetHide(false);

	local textSize:number = textControl:GetSizeX();
	tabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	tabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	tabInst.Selection:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT + 4);

	m_TotalTabSize = m_TotalTabSize + tabInst.Button:GetSizeX();
	if m_TotalTabSize > (Controls.TabContainer:GetSizeX() * 2) then
		g_TabSupportIM:ReleaseInstance(tabInst);
		AddExtraTab(label, onClickCallback);
	else
		g_TabSupport.AddTab(tabInst.Button, OnTabClicked(tabInst, onClickCallback));
	end

	return tabInst.Button;
end

function AddExtraTab(label:string, onClickCallback:ifunction)
	local extraTabInst:table = g_ExtraTabsIM:GetInstance();
	
	extraTabInst.Button:SetText(label);
	extraTabInst.Button:RegisterCallback(Mouse.eLClick, OnExtraTabClicked(extraTabInst, onClickCallback));

	local textControl = extraTabInst.Button:GetTextControl();
	local textSize:number = textControl:GetSizeX();
	extraTabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	extraTabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	local tabSize:number = extraTabInst.Button:GetSizeX();
	if tabSize > m_MaxExtraTabSize then
		m_MaxExtraTabSize = tabSize;
	end

	table.insert(m_ExtraTabs, extraTabInst);
end

function ViewDiplomatic(victoryType:string)
	ResetState(function() ViewDiplomatic(victoryType); end);
	Controls.GenericView:SetHide(false);

	ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);

	local victoryInfo:table = GameInfo.Victories[victoryType];
    if victoryInfo.Icon ~= nil then
        PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, victoryInfo.Icon);
    else
        PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, ICON_GENERIC);
    end

	local genericData:table = GatherGenericData();

	g_GenericIM:ResetInstances();
	g_GenericTeamIM:ResetInstances();

	local ourData:table = {};

	for i, teamData in ipairs(genericData) do
		local ourTeamData:table = { teamData, score };

		ourTeamData.teamData = teamData;
		local progress = Game.GetVictoryProgressForTeam(victoryType, teamData.TeamID);
		if progress == nil then
			progress = 0;
		end
		ourTeamData.score = progress;

		table.insert(ourData, ourTeamData);
	end

	--[[
	table.sort(ourData, function(a, b)
		return a.score > b.score;
	end);
	]]
	table.sort(ourData, SortTeamsDiplomacy);
	
	for i, theData in ipairs(ourData) do
		
		if #theData.teamData.PlayerData > 1 then
			PopulateGenericTeamInstance(g_GenericTeamIM:GetInstance(), theData.teamData, victoryType);
		else
			local uiGenericInstance:table = g_GenericIM:GetInstance();
			local pPlayer:table = Players[theData.teamData.PlayerData[1].PlayerID];
			if pPlayer ~= nil then
				local pStats:table = pPlayer:GetStats();
				if pStats == nil then
					UI.DataError("Stats not found for PlayerID:" .. theData.teamData.PlayerData[1].PlayerID .. "! WorldRankings XP2");
					return;
				end
				
				text = pStats:GetDiplomaticVictoryPointsTooltip()
				PopulateGenericInstance(uiGenericInstance, theData.teamData.PlayerData[1], victoryType, true);
				
				if HasAccessLevel(theData.teamData.PlayerData[1].PlayerID, "diplomacy") then
					uiGenericInstance.ButtonBG:SetToolTipString(text);
				else
					uiGenericInstance.ButtonBG:SetToolTipString(string.gsub(text, "%d+", hseUnknown));
				end
			end
		end
	end

	RealizeGenericStackSize();
end

function GetDefaultStackSize()
    return 265;
end

-- ===========================================================================
-- Constructor
-- ===========================================================================
function Initialize()
	ToggleExtraTabs(); -- Start with extra tabs opened so DiplomaticVictory tab is visible by default
end


if isBWRActive  then
	include("WorldRanking_BWR_HSE")
end


Initialize();