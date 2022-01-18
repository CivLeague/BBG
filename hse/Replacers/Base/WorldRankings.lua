-- Copyright 2018, Firaxis Games

-- ===========================================================================
--	Contains scaffolding for WorldRankings
-- ===========================================================================
include("TabSupport");
include("InstanceManager");
include("SupportFunctions");
include("AnimSidePanelSupport");
include("TeamSupport");
include("CivilizationIcon");
include("Colors");
include("HSE_utils")

local debugTeams = false

-- ===========================================================================
--	DEBUG
-- ===========================================================================
local m_isDebugForceShowAllScoreCategories:boolean = false; -- (false) Show all scoring categories under details

-- ===========================================================================
--	GLOBALS
-- ===========================================================================
g_TabSupport = nil; -- Gets initialized in PopulateTabs
g_CultureInst = nil; -- Also initialized in PopulateTabs.  Used by OpenCulture()
g_victoryData = {
	VICTORY_CONQUEST = {
		GetText = function(p) return "LOC_WORLD_RANKINGS_OVERVIEW_DOMINATION_MILITARY_STRENGTH" end,
		GetScore = function(p) return p:GetStats():GetMilitaryStrengthWithoutTreasury(); end
	},
	VICTORY_CULTURE = {
		Primary = {
			GetText = function(p) return "LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_TOURISM_RATE" end,
			GetScore = function(p) return p:GetStats():GetTourism(); end
		},
		Secondary = {
			GetText = function(p) return "LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_CULTURE_RATE" end,
			GetScore = function(p) return p:GetCulture():GetCultureYield(); end
		}
	},
	VICTORY_RELIGIOUS = {
		Primary = {
			GetText = function(p) return "LOC_WORLD_RANKINGS_OVERVIEW_RELIGION_CITIES_FOLLOWING_RELIGION" end,
			GetScore = function(p) return p:GetStats():GetNumCitiesFollowingReligion(); end
		},
		Secondary = {
			GetText = function(p) return "LOC_WORLD_RANKINGS_OVERVIEW_RELIGION_FAITH_RATE" end;
			GetScore = function(p) return p:GetReligion():GetFaithYield(); end
		}
	},
	VICTORY_TECHNOLOGY = {
		Primary = {
			GetText = function(p) return "LOC_WORLD_RANKINGS_OVERVIEW_SCIENCE_NUM_TECHS" end,
			GetScore = function(p) return p:GetStats():GetNumTechsResearched(); end
		},
		Secondary = {
			GetText = function(p) return "LOC_WORLD_RANKINGS_OVERVIEW_SCIENCE_SCIENCE_RATE" end,
			GetScore = function(p) return p:GetTechs():GetScienceYield(); end
		}
	}
};
-- If victory type isn't specified, return default domination data
setmetatable(g_victoryData, { 
	__index = function()
		return {
			GetText = function(p) return "LOC_WORLD_RANKINGS_OVERVIEW_DOMINATION_SCORE" end,
			GetScore = function(p) return p:GetScore(); end
		}
	end
});

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
SIZE_SCORE_ITEM_DEFAULT = 54;
SIZE_SCORE_ITEM_DETAILS = 180;
SIZE_HEADER_MAX_Y = 270;

local RELOAD_CACHE_ID:string = "WorldRankings"; -- Must be unique (usually the same as the file name)
local REQUIREMENT_CONTEXT:string = "VictoryProgress";
local DATA_FIELD_SELECTION:string = "Selection";
local DATA_FIELD_HEADER_HEIGHT:string = "HeaderHeight";
local DATA_FIELD_HEADER_RESIZED:string = "HeaderResized";
local DATA_FIELD_HEADER_EXPANDED:string = "HeaderExpanded";
local DATA_FIELD_OVERALL_PLAYERS_IM:string = "OverallPlayersIM";
local DATA_FIELD_DOMINATED_CITIES_IM:string = "DominatedCitiesIM";
local DATA_FIELD_RELIGION_CONVERTED_CIVS_IM:string = "ConvertedCivsIM";

local PADDING_HEADER:number = 10;
local PADDING_CULTURE_HEADER:number = 90;
local PADDING_GENERIC_ITEM_BG:number = 25;
local PADDING_TAB_BUTTON_TEXT:number = 17;
local PADDING_ADVISOR_TEXT_BG:number = 20;
local PADDING_RELIGION_NAME_BG:number = 42;
local PADDING_RELIGION_BG_HEIGHT:number = 26;
local PADDING_VICTORY_GRADIENT:number = 45;
local PADDING_VICTORY_LABEL_UNDERLINE:number = 90;
local PADDING_SCORE_DETAILS_BUTTON_WIDTH:number = 40;
local OFFSET_VIEW_CONTENTS:number = 130;
local OFFSET_ADVISOR_ICON_Y:number = 5;
local OFFSET_ADVISOR_TEXT_Y:number = 70;
local OFFSET_HIDDEN_SCROLLBAR:number = 7;
local OFFSET_CONTRACT_BUTTON_Y:number = 63;
local SIZE_OVERALL_TOP_PLAYER_ICON:number = 48;
local SIZE_OVERALL_PLAYER_ICON:number = 36;
local SIZE_OVERALL_BG_HEIGHT:number = 100;
local SIZE_OVERALL_INSTANCE:number = 40;
local SIZE_VICTORY_ICON_SMALL:number = 64;
local SIZE_RELIGION_BG_HEIGHT:number = 55;
local SIZE_RELIGION_ICON_SMALL:number = 22;
local SIZE_GENERIC_ITEM_MIN_Y:number = 54;
local SIZE_LOCAL_PLAYER_BORDER_PADDING:number = 9;
local SIZE_STACK_DEFAULT:number = 225;
local SIZE_HEADER_DEFAULT:number = 60;
local SIZE_HEADER_MIN_Y:number = 46;
local SIZE_HEADER_ICON:number = 80;
local SIZE_LEADER_ICON:number = 55;
local SIZE_CIV_ICON:number = 36;
local SIZE_DETAILS_SPACING:number = 10;
local SIZE_DEFAULT_CIVNAME:number = 150;

local TEAM_RIBBON_PREFIX:string = "ICON_TEAM_RIBBON_";
local TEAM_RIBBON_SIZE_TOP_TEAM:number = 53;
local TEAM_RIBBON_SIZE:number = 44;

local TEAM_ICON_PREFIX:string = "Team";
local TEAM_ICON_SIZE_TOP_TEAM:number = 38;
local TEAM_ICON_SIZE:number = 28;

TAB_SCORE = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_TAB");
TAB_OVERALL = Locale.Lookup("LOC_WORLD_RANKINGS_OVERALL_TAB");
TAB_SCIENCE = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_TAB");
TAB_CULTURE = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_TAB");
TAB_RELIGION = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_TAB");
TAB_DOMINATION = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_TAB");

SCORE_TITLE = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_VICTORY");
SCORE_DETAILS = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_DETAILS");

local SCIENCE_ICON:string = "ICON_VICTORY_TECHNOLOGY";
local SCIENCE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_VICTORY");
local SCIENCE_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_DETAILS");
local SCIENCE_REQUIREMENTS:table = {
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_1"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_2"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_3")
};

local CULTURE_ICON:string = "ICON_VICTORY_CULTURE";
local CULTURE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_VICTORY");
local CULTURE_VICTORY_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_VICTORY_DETAILS");
local CULTURE_DOMESTIC_TOURISTS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_DETAILS_DOMESTIC_TOURISTS");
local CULTURE_VISITING_TOURISTS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_DETAILS_VISITING_TOURISTS");

local DOMINATION_ICON:string = "ICON_VICTORY_DOMINATION";
local DOMINATION_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_VICTORY");
local DOMINATION_DETAILS:string  = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_DETAILS");
local DOMINATION_HAS_ORIGINAL_CAPITAL:string  = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_HAS_ORIGINAL_CAPITAL");

local RELIGION_ICON:string = "ICON_VICTORY_RELIGIOUS";
local RELIGION_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_VICTORY");
local RELIGION_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_DETAILS");

ICON_GENERIC = "ICON_VICTORY_GENERIC";
local ICON_UNKNOWN_CIV:string = "ICON_CIVILIZATION_UNKNOWN";
local LOC_UNKNOWN_CIV:string = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER");
local LOC_UNKNOWN_CIV_COLORED:string = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER_COLORED");

--antonjs: Removed the other state and related text, in favor of showing all information together. Leaving state functionality intact in case we want to use it in the future.
--[[
local CULTURE_HOW_TO_VICTORY:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_HOW_TO_VICTORY");
local CULTURE_HOW_TO_TOURISM:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_HOW_TO_TOURISM");
local CULTURE_TOURISM_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_TOURISM_DETAILS");
--]]
local CULTURE_HEADER_STATES:table = {
	WHAT_IS_CULTURE_VICTORY	= 0;
};

local SPACE_PORT_DISTRICT_INFO:table = GameInfo.Districts["DISTRICT_SPACEPORT"];
local EARTH_SATELLITE_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EARTH_SATELLITE"]
};
local MOON_LANDING_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_MOON_LANDING"]
};
local MARS_COLONY_PROJECT_INFOS:table = { 
	GameInfo.Projects["PROJECT_LAUNCH_MARS_REACTOR"],
	GameInfo.Projects["PROJECT_LAUNCH_MARS_HABITATION"],
	GameInfo.Projects["PROJECT_LAUNCH_MARS_HYDROPONICS"]
};
local SCIENCE_PROJECTS:table = {
	EARTH_SATELLITE_PROJECT_INFOS,
	MOON_LANDING_PROJECT_INFOS,
	MARS_COLONY_PROJECT_INFOS
};

local STANDARD_VICTORY_TYPES:table = {
	"VICTORY_DEFAULT",
	"VICTORY_SCORE",
	"VICTORY_TECHNOLOGY",
	"VICTORY_CULTURE",
	"VICTORY_CONQUEST",
	"VICTORY_RELIGIOUS"
};

function IsCustomVictoryType(victoryType:string)
	for _, checkVictoryType in ipairs(STANDARD_VICTORY_TYPES) do
		if victoryType == checkVictoryType then
			return false;
		end
	end
	return true;
end

-- ===========================================================================
--	PLAYER VARIABLES
-- ===========================================================================
g_LocalPlayer = {};
g_LocalPlayerID = 0;
-- ===========================================================================
--	SCREEN VARIABLES
-- ===========================================================================
g_activeheader = {};
m_ExtraTabs = {};

g_TabSupportIM = InstanceManager:new("TabInstance", "Button", Controls.TabContainer);
m_GenericHeaderIM = InstanceManager:new("GenericHeaderInstance", "HeaderTop"); -- Used by Score, Religion and Domination Views

g_ScoreIM = InstanceManager:new("ScoreInstance", "ButtonBG", Controls.ScoreViewStack);
g_ScoreTeamIM = InstanceManager:new("ScoreTeamInstance", "ButtonFrame", Controls.ScoreViewStack);

local m_AnimSupport		:table; --AnimSidePanelSupport
local m_TotalTabSize    :number = 0;
local m_MaxExtraTabSize :number = 0;
local m_HeaderInstances :table = {};
local m_ActiveViewUpdate:ifunction;
local m_ShowScoreDetails:boolean = false;
local m_CultureHeaderState:number = CULTURE_HEADER_STATES.WHAT_IS_CULTURE_VICTORY;

local m_ScienceHeaderIM	:table = InstanceManager:new("ScienceHeaderInstance", "HeaderTop", Controls.ScienceViewHeader);
local m_CultureHeaderIM	:table = InstanceManager:new("CultureHeaderInstance", "HeaderTop", Controls.CultureViewHeader);
local m_OverallIM		:table = InstanceManager:new("OverallInstance", "ButtonBG", Controls.OverallViewStack);

local m_ScienceIM:table = InstanceManager:new("ScienceInstance", "ButtonBG", Controls.ScienceViewStack);
local m_ScienceTeamIM:table = InstanceManager:new("ScienceTeamInstance", "ButtonFrame", Controls.ScienceViewStack);

local m_CultureIM:table = InstanceManager:new("CultureInstance", "ButtonBG", Controls.CultureViewStack);
local m_CultureTeamIM:table = InstanceManager:new("CultureTeamInstance", "ButtonFrame", Controls.CultureViewStack);

local m_DominationIM = InstanceManager:new("DominationInstance", "ButtonBG", Controls.DominationViewStack);
local m_DominationTeamIM = InstanceManager:new("DominationTeamInstance", "ButtonFrame", Controls.DominationViewStack);

local m_ReligionIM:table = InstanceManager:new("ReligionInstance", "ButtonBG", Controls.ReligionViewStack);
local m_ReligionTeamIM:table = InstanceManager:new("ReligionTeamInstance", "ButtonFrame", Controls.ReligionViewStack);

g_GenericIM = InstanceManager:new("GenericInstance", "ButtonBG", Controls.GenericViewStack);
g_GenericTeamIM = InstanceManager:new("GenericTeamInstance", "ButtonFrame", Controls.GenericViewStack);

g_ExtraTabsIM = InstanceManager:new("ExtraTabInstance", "Button", Controls.ExtraTabStack);

local m_CivTooltip = {};
TTManager:GetTypeControlTable("CivTooltip", m_CivTooltip);

local m_TeamTooltip = {};
TTManager:GetTypeControlTable("TeamTooltip", m_TeamTooltip);

-- Track the number of turns till the closest cultural victory
local m_iTurnsTillCulturalVictory:number = -1;

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

-- ===========================================================================
--	Tab selection helpers
-- ===========================================================================
function DeselectExtraTabs()
	for _, extraTabInst in pairs(m_ExtraTabs) do
		extraTabInst.Button:SetSelected(false);
	end
end

function DeselectPreviousTab()
	if g_TabSupport.prevSelectedControl ~= nil then
		if g_TabSupport.prevSelectedControl.Selection then -- TabInstance
			g_TabSupport.prevSelectedControl.Selection:SetHide(true);
		end
	end
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
	g_TabSupport = CreateTabs(Controls.TabContainer, 42, 34, UI.GetColorValueFromHexLiteral(0xFF331D05));

	if (ShouldShowOverall()) then
		defaultTab = AddTab(TAB_OVERALL, ViewOverall);
	else
		defaultTab = nil;
	end

	-- Add custom (modded) victory types
	if(ShouldCheckCustomVictories()) then
		for row in GameInfo.Victories() do
			local victoryType:string = row.VictoryType;
			if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) then
				if(defaultTab == nil) then
					defaultTab = AddTab(Locale.Lookup(row.Name), function() ViewGeneric(victoryType); end);
				else
					AddTab(Locale.Lookup(row.Name), function() ViewGeneric(victoryType); end);
				end
			end
		end
	end

	-- Add default victory types in a pre-determined order
	if(GameConfiguration.IsAnyMultiplayer() or Game.IsVictoryEnabled("VICTORY_SCORE") or ForceShowScore()) then
		AddTab(TAB_SCORE, ViewScore);
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

	if m_TotalTabSize > Controls.TabContainer:GetSizeX() then
		Controls.ExpandExtraTabs:SetHide(false);
		for _, tabInst in pairs(m_ExtraTabs) do
			tabInst.Button:SetSizeX(m_MaxExtraTabSize);
		end
	else
		Controls.ExpandExtraTabs:SetHide(true);
	end

	g_TabSupport.SelectTab(defaultTab);
	g_TabSupport.EvenlySpreadTabs();
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
	if m_TotalTabSize > Controls.TabContainer:GetSizeX() then
		g_TabSupportIM:ReleaseInstance(tabInst);
		AddExtraTab(label, onClickCallback);
	else
		local callback:ifunction = function()
			if(g_TabSupport.prevSelectedControl ~= nil) then
				g_TabSupport.prevSelectedControl[DATA_FIELD_SELECTION]:SetHide(true);
			end
			tabInst.Selection:SetHide(false);
			onClickCallback();
			CloseExtraTabs();
		end

		g_TabSupport.AddTab(tabInst.Button, callback);
	end

	return tabInst.Button;
end

function OnTabClicked(tabInst:table, onClickCallback:ifunction)
	return function()
		tabInst.Selection:SetHide(false);
		DeselectPreviousTab();
		DeselectExtraTabs();
		onClickCallback();
		CloseExtraTabs();
	end
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

function OnExtraTabClicked(extraTabInst:table, onClickCallback:ifunction)
	return function()
		g_TabSupport.SelectTab(nil);
		DeselectPreviousTab();
		DeselectExtraTabs();
		extraTabInst.Button:SetSelected(true);
		onClickCallback();
	end
end

-- ===========================================================================
--	Called anytime player switches tabs
-- ===========================================================================
function ResetState(newView:ifunction)
	g_activeheader = nil;
	m_ActiveViewUpdate = newView;
	Controls.OverallView:SetHide(true);
	Controls.ScoreView:SetHide(true);
	Controls.ScienceView:SetHide(true);
	Controls.CultureView:SetHide(true);
	Controls.DominationView:SetHide(true);
	Controls.ReligionView:SetHide(true);
	Controls.GenericView:SetHide(true);

	-- Reset tourism lens unless we're now view the Culture tab
	if newView ~= ViewCulture then
		ResetTourismLens();
	end

	DeactivateReligionLens();
end

function ChangeActiveHeader(headerType:string, headerIM:table, parentControl:table)
	g_activeheader = m_HeaderInstances[headerType];
	if(g_activeheader == nil) then
		g_activeheader = headerIM:GetInstance(parentControl);
		m_HeaderInstances[headerType] = g_activeheader;
	end
end

function GetCivNameAndIcon(playerID:number, bColorUnmetPlayer:boolean)
	local name:string, icon:string;
	local playerConfig:table = PlayerConfigurations[playerID];
	if(playerID == g_LocalPlayerID or playerConfig:IsHuman() or g_LocalPlayer == nil or g_LocalPlayer:GetDiplomacy():HasMet(playerID)) then
		name = Locale.Lookup(playerConfig:GetPlayerName());
		if playerID == g_LocalPlayerID or g_LocalPlayer == nil or g_LocalPlayer:GetDiplomacy():HasMet(playerID) then
			icon = "ICON_" .. playerConfig:GetCivilizationTypeName();
		else
			icon = ICON_UNKNOWN_CIV;
		end
	else
		name = bColorUnmetPlayer and LOC_UNKNOWN_CIV_COLORED or LOC_UNKNOWN_CIV;
		icon = ICON_UNKNOWN_CIV;
	end
	
	return name, icon;
end

-- ===========================================================================
--	Called to update a generic header instance
-- ===========================================================================
function PopulateGenericHeader(resizeCallback:ifunction, title:string, subTitle:string, details:string, headerIcon:string, advisorIcon:string)
	
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(headerIcon, SIZE_HEADER_ICON);
	if(textureSheet == nil or textureSheet == "") then
		UI.DataError("Could not find icon in PopulateGenericHeader: icon=\""..headerIcon.."\", iconSize="..tostring(SIZE_HEADER_ICON));
	else
		g_activeheader.HeaderIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
	end

	g_activeheader.HeaderLabel:SetText(Locale.ToUpper(Locale.Lookup(title)));
	if(subTitle ~= nil and subTitle ~= "") then
		g_activeheader.HeaderSubLabel:SetHide(false);
		g_activeheader.HeaderSubLabel:SetText(Locale.Lookup(subTitle));
	else
		g_activeheader.HeaderSubLabel:SetHide(true);
	end

	g_activeheader.AdvisorText:SetText(details and Locale.Lookup(details) or "");
	
	g_activeheader.ExpandHeaderButton:RegisterCallback(Mouse.eLClick, OnExpandHeader);
	g_activeheader.ContractHeaderButton:RegisterCallback(Mouse.eLClick, OnContractHeader);
	
	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED] == nil) then 
		g_activeheader[DATA_FIELD_HEADER_EXPANDED] = true;
	end

	g_activeheader[DATA_FIELD_HEADER_RESIZED] = resizeCallback;
	RealizeHeaderSize();
end

-- ===========================================================================
--	Called anytime player presses expand/contract button on a Header Instance 
-- ===========================================================================
function OnExpandHeader(data1:number, data2:number, control:table)
	if(control == g_activeheader.ExpandHeaderButton) then
		g_activeheader.AdvisorIcon:SetHide(false);
		g_activeheader.AdvisorText:SetHide(false);
		g_activeheader.AdvisorTextBG:SetHide(false);
		g_activeheader.ExpandHeaderButton:SetHide(true);
		g_activeheader.ContractHeaderButton:SetHide(false);
		g_activeheader[DATA_FIELD_HEADER_EXPANDED] = true;
		RealizeHeaderSize();
	end
end
function OnContractHeader(data1:number, data2:number, control:table)
	if(control == g_activeheader.ContractHeaderButton) then
		g_activeheader.AdvisorIcon:SetHide(true);
		g_activeheader.AdvisorText:SetHide(true);
		g_activeheader.AdvisorTextBG:SetHide(true);
		g_activeheader.ExpandHeaderButton:SetHide(false);
		g_activeheader.ContractHeaderButton:SetHide(true);
		g_activeheader[DATA_FIELD_HEADER_EXPANDED] = false;
		RealizeHeaderSize();
	end
end

-- ===========================================================================
--	Called anytime header changes size (when it's expanded / contracted)
-- ===========================================================================
function RealizeHeaderSize()
	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local textBubbleHeight:number = g_activeheader.AdvisorText:GetSizeY() + PADDING_ADVISOR_TEXT_BG;
		if(textBubbleHeight > SIZE_HEADER_MAX_Y) then
			textBubbleHeight = SIZE_HEADER_MAX_Y;
		elseif textBubbleHeight < SIZE_HEADER_MIN_Y then
			textBubbleHeight = SIZE_HEADER_MIN_Y;
		end
		g_activeheader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + textBubbleHeight);
		g_activeheader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + textBubbleHeight);
		g_activeheader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + textBubbleHeight);
		g_activeheader[DATA_FIELD_HEADER_HEIGHT] = textBubbleHeight;
	else
		g_activeheader.HeaderFrame:SetSizeY(SIZE_HEADER_DEFAULT);
		g_activeheader[DATA_FIELD_HEADER_HEIGHT] = SIZE_HEADER_DEFAULT;
	end
	-- Center header label if sub label is not present
	if(g_activeheader.HeaderSubLabel:IsHidden()) then
		g_activeheader.HeaderLabel:SetOffsetY(25);
	else
		g_activeheader.HeaderLabel:SetOffsetY(18);
	end
	if(g_activeheader[DATA_FIELD_HEADER_RESIZED] ~= nil) then
		g_activeheader[DATA_FIELD_HEADER_RESIZED]();
	end
end

-- ===========================================================================
--	Utility to reduce code duplication
-- ===========================================================================
function RealizeStackAndScrollbar(stackControl:table, scrollbarControl:table, offsetStackIfScrollbarHidden:boolean)
	stackControl:CalculateSize();
	stackControl:ReprocessAnchoring();
	scrollbarControl:CalculateInternalSize();
	scrollbarControl:ReprocessAnchoring();
	scrollbarControl:SetScrollValue(0);
	if(offsetStackIfScrollbarHidden ~= nil) then
		if(scrollbarControl:GetScrollBar():IsHidden()) then
			stackControl:SetOffsetX(OFFSET_HIDDEN_SCROLLBAR);
		else
			stackControl:SetOffsetX(0);
		end
	end
end

-- ===========================================================================
--	Called when Overall tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewOverall()
	ResetState(ViewOverall);
	Controls.OverallView:SetHide(false);
	
	m_OverallIM:ResetInstances();

	-- Add default victory types in a pre-determined order
	if(Game.IsVictoryEnabled("VICTORY_TECHNOLOGY")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_TECHNOLOGY", "SCIENCE");
	end
	if(Game.IsVictoryEnabled("VICTORY_CULTURE")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_CULTURE", "CULTURE");
	end
	if(Game.IsVictoryEnabled("VICTORY_CONQUEST")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_CONQUEST", "DOMINATION");
	end
	if(Game.IsVictoryEnabled("VICTORY_RELIGIOUS")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_RELIGIOUS", "RELIGION");
	end

	-- Add custom (modded) victory types
	for row in GameInfo.Victories() do
		local victoryType:string = row.VictoryType;
		if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) then
			PopulateOverallInstance(m_OverallIM:GetInstance(), victoryType);
		end
	end

	Controls.OverallViewStack:CalculateSize();
	Controls.OverallViewStack:ReprocessAnchoring();
	Controls.OverallViewScrollbar:CalculateInternalSize();
	Controls.OverallViewScrollbar:ReprocessAnchoring();

	if(Controls.OverallViewScrollbar:GetScrollBar():IsHidden()) then
		Controls.OverallViewStack:SetOffsetX(-3);
	else
		Controls.OverallViewStack:SetOffsetX(-5);
	end
end


function PopulateOverallInstance(instance:table, victoryType:string, typeText:string)

	local victoryInfo:table= GameInfo.Victories[victoryType];
	local numIcons = 0;

	instance.VictoryLabel:SetText(Locale.ToUpper(Locale.Lookup(victoryInfo.Name)));
	instance.VictoryLabelUnderline:SetSizeX(instance.VictoryLabel:GetSizeX() + PADDING_VICTORY_LABEL_UNDERLINE);
	
	local icon:string;
	local color:number;
	if typeText ~= nil then
		icon = "ICON_VICTORY_" .. typeText;
		color = UI.GetColorValue("COLOR_VICTORY_" .. typeText);
	else
		icon = victoryInfo.Icon or ICON_GENERIC;
		color = UI.GetColorValue("White");
	end
	instance.VictoryBanner:SetColor(color);
	instance.VictoryLabelGradient:SetColor(color);

	if icon ~= nil then
		local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(icon, SIZE_VICTORY_ICON_SMALL);
		if(textureSheet == nil or textureSheet == "") then
			UI.DataError("Could not find icon in PopulateOverallInstance: icon=\""..icon.."\", iconSize="..tostring(SIZE_VICTORY_ICON_SMALL));
		else
			instance.VictoryIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
			instance.VictoryIcon:SetHide(false);
		end
	else
		instance.VictoryIcon:SetHide(true);
	end

	-- Cache victory data to avoid table access within loops
	local victoryData = g_victoryData[victoryType];

	-- Team tiebreaker score functions
	local averageScores = function(playerData, playerCount, scoreKey)
		-- Add player scores
		local score:number = 0;
		for _, player in pairs(playerData) do
			score = score + player[scoreKey];
		end
		-- Divide by player count
		return score / playerCount;
	end;

	-- Gather team data
	local teamIDs = GetAliveMajorTeamIDs();
	
	local teamData:table = {};
	for _, teamID in ipairs(teamIDs) do
		local team = Teams[teamID];
		if(team ~= nil) then
			-- If progress is nil, then the team is not capable of earning a victory (ex: city-state teams and barbarian teams).
			-- Skip any team that is incapable of earning a victory.
			local progress = Game.GetVictoryProgressForTeam(victoryType, teamID);
			if(progress ~= nil) then

				-- PlayerData
				local playerData:table = {};
				local playerCount:number = 0;
				local teamGenericScore = 0;

				for i, playerID in ipairs(team) do
					if IsAliveAndMajor(playerID) then
						-- Never hide tie breaker
						local forceShow1 = false
						local forceShow2 = false
						
						-- For HSE in BWR
						local forceReplace1 = nil
						local forceReplace2 = nil
						
						local pPlayer:table = Players[playerID];

						local firstTiebreaker:table = victoryData.Primary or victoryData;
						local secondTiebreaker:table = victoryData.Secondary or victoryData;
						local primaryScore:number = firstTiebreaker.GetScore(pPlayer);
						local secondaryScore:number = secondTiebreaker.GetScore(pPlayer);

						local genericScore = pPlayer:GetScore();

						-- Team score is calculated as the highest individual score.
						teamGenericScore = math.max(teamGenericScore, genericScore); 
						
						local firstTiebreakSummary = Locale.Lookup(firstTiebreaker.GetText(pPlayer), Round(primaryScore, 1))
						
						local secondTiebreakSummary = Locale.Lookup(secondTiebreaker.GetText(pPlayer), Round(secondaryScore, 1))
						
						if victoryType == "VICTORY_RELIGIOUS" then
							--print(firstTiebreakSummary, secondTiebreakSummary)
							firstTiebreakSummary = Locale.Lookup(firstTiebreaker.GetText(pPlayer), Round(primaryScore, 1))
							

							local pPlayerReligion:table = Players[playerID]:GetReligion();
							local playerReligionType = pPlayerReligion:GetReligionTypeCreated();

							local religiousDetails = GetReligiousDetails(playerReligionType)
								 
							FirstTiebreakScore = religiousDetails.TotalMinNumConvertedCities
							firstTiebreakSummary = Locale.Lookup(firstTiebreaker.GetText(pPlayer), religiousDetails.RatioString)
							
							forceShow1 = true
							forceReplace1 = RatioString

							if not HasAccessLevel(playerID, ConvertVictoryTypeToInfoType(victoryType)) then
								-- Faith
								secondTiebreakSummary = Locale.Lookup(secondTiebreaker.GetText(pPlayer), hseUnknown)
							end
						else
							if not HasAccessLevel(playerID, ConvertVictoryTypeToInfoType(victoryType)) then
								firstTiebreakSummary = Locale.Lookup(firstTiebreaker.GetText(pPlayer), hseUnknown)
								secondTiebreakSummary = Locale.Lookup(secondTiebreaker.GetText(pPlayer), hseUnknown)
								
								if victoryType == "VICTORY_DIPLOMATIC" then
									-- We have to regex-replace since the local lookup embed the value in the text.
									firstTiebreakSummary = string.gsub(firstTiebreakSummary, "%d+/", hseUnknown..'/')
									secondTiebreakSummary = string.gsub(firstTiebreakSummary, "%d+/", hseUnknown..'/')
								end
							end
						end
						
						playerData[playerID] = {
							Player = pPlayer,
							GenericScore = genericScore,
							FirstTiebreakScore = primaryScore,
							SecondTiebreakScore = secondaryScore,
							FirstTiebreakSummary = firstTiebreakSummary,
							SecondTiebreakSummary = secondTiebreakSummary,
							ForceShow1 = forceShow1, -- Display value even if it has not access
							ForceShow2 = forceShow2,
							forceReplace1 = forceReplace1,
							forceReplace2 = forceReplace2,
						};

						playerCount = playerCount + 1;
					end
				end

				firstTeamTiebreakScore = averageScores(playerData, playerCount, "FirstTiebreakScore")
				secondTeamTiebreakScore = averageScores(playerData, playerCount, "SecondTiebreakScore")
				
				if not HasAccessLevelTeam(teamID, ConvertVictoryTypeToInfoType(victoryType)) then
					progress = 0
					teamGenericScore = 0
					firstTeamTiebreakScore = 0
					secondTeamTiebreakScore = 0
				end
				
				-- Team Data
				table.insert(teamData, {
					TeamID = teamID,
					TeamScore = progress,
					TeamProgress = progress,
					TeamGenericScore = teamGenericScore,
					PlayerData = playerData,
					PlayerCount = playerCount,
					FirstTeamTiebreakScore = firstTeamTiebreakScore,
					SecondTeamTiebreakScore = secondTeamTiebreakScore,
				});
			end
		end
	end
	
	-- Set all scores for sorting to zero for unavailable information
	teamDataOriginal = deepcopy(teamData)

	for i, d in ipairs(teamData) do
		if not HasAccessLevelTeam(d.TeamID, ConvertVictoryTypeToInfoType(victoryType)) then
			teamData[i].TeamScore = 0
			teamData[i].TeamProgress = 0
			teamData[i].FirstTeamTiebreakScore = 0
			teamData[i].SecondTeamTiebreakScore = 0
			teamData[i].TeamGenericScore = 0
		end
	end
	
	-- Sort teams by score
 	table.sort(teamData, function(a, b)
		if (a.TeamProgress ~= b.TeamProgress) then
			return a.TeamProgress > b.TeamProgress;
		elseif(a.FirstTeamTiebreakScore ~= b.FirstTeamTiebreakScore) then
			return a.FirstTeamTiebreakScore > b.FirstTeamTiebreakScore;
		elseif(a.SecondTeamTiebreakScore ~= b.SecondTeamTiebreakScore) then
			return a.SecondTeamTiebreakScore > b.SecondTeamTiebreakScore;
		elseif(a.TeamGenericScore ~= b.TeamGenericScore) then
			return a.TeamGenericScore > b.TeamGenericScore;
		else
			return a.TeamID < b.TeamID;
		end
	end);
	
	-- Handle case where this victory type is not completable by any team.
	-- This can happen with Global Thermonuclear War's Proxy War victory if there are no city states to conquer.
	if(#teamData < 1) then
			instance.VictoryPlayer:SetText("");
			instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_VICTORY_DISABLED"));
			-- Make the whole box look plain, since the victory is out of reach
			instance.TeamRibbon:SetHide(true);
			instance.TopPlayer:SetHide(true);
			instance.CivIcon:SetHide(true);
			instance.CivIconFaded:SetHide(true);
			instance.CivIconBacking:SetHide(true);
			instance.CivIconBackingRing:SetHide(true);
			instance.CivIconBackingFaded:SetHide(true);
			instance.VictoryLabelGradient:SetHide(true); 
			instance.VictoryBanner:SetHide(true); 
			instance.VictoryIcon:SetHide(true); 
		return;
	end

	-- Ensure we have Instance Managers for the player meters
	local playersIM:table = instance[DATA_FIELD_OVERALL_PLAYERS_IM];
	if(playersIM == nil) then
		playersIM = InstanceManager:new("OverallPlayerInstance", "CivIconBackingFaded", instance.PlayerStack);
		instance[DATA_FIELD_OVERALL_PLAYERS_IM] = playersIM;
	end
	playersIM:ResetInstances();

	-- Populate top team/player icon
	if teamData[1].PlayerCount > 1 or debugTeams then
		if isBWRActive then
			PopulateOverallTeamIconInstance(instance, teamData[1], TEAM_ICON_SIZE_TOP_TEAM, TEAM_RIBBON_SIZE_TOP_TEAM, victoryType);
		else
			PopulateOverallTeamIconInstance(instance, teamData[1], TEAM_ICON_SIZE_TOP_TEAM, TEAM_RIBBON_SIZE_TOP_TEAM);
		end
	else
		PopulateOverallPlayerIconInstance(instance, victoryType, teamData[1], SIZE_OVERALL_TOP_PLAYER_ICON);
	end
	numIcons = numIcons + 1;

	-- Populate other team/player icons
	if #teamData > 1 then
		for i = 2, #teamData, 1 do
			local playerInstance:table = playersIM:GetInstance();
			if teamData[i].PlayerCount > 1 then
				if isBWRActive then
					PopulateOverallTeamIconInstance(playerInstance, teamData[i], TEAM_ICON_SIZE, TEAM_RIBBON_SIZE, victoryType);
				else
					PopulateOverallTeamIconInstance(playerInstance, teamData[i], TEAM_ICON_SIZE, TEAM_RIBBON_SIZE);
				end
			else
				PopulateOverallPlayerIconInstance(playerInstance, victoryType, teamData[i], SIZE_OVERALL_PLAYER_ICON);
			end
			numIcons = numIcons + 1;
		end
	end

	-- Determine if local player is leading
	local isLocalPlayerLeading:boolean = false;
	local leadingTeam:table = teamData[1];
	for playerID, data in pairs(teamData[1].PlayerData) do
		if playerID == g_LocalPlayerID then
			isLocalPlayerLeading = true;
		end
	end

	-- Populate leading and local player labels
	if isLocalPlayerLeading then
		-- You or your team is leading
		instance.VictoryPlayer:SetText("");
		if teamData[1].PlayerCount > 1 or debugTeams then
			instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_TEAM_SIMPLE"));
		else
			instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_YOU_SIMPLE"));
		end
	else
		-- Set top team/player text
		local topName:string = "";
		if teamData[1].PlayerCount > 1 or debugTeams then
			topName = Locale.Lookup("LOC_WORLD_RANKINGS_TEAM", GameConfiguration.GetTeamName(teamData[1].TeamID));
		else
			local topPlayerID:number = Teams[teamData[1].TeamID][1];
			if(g_LocalPlayer == nil or g_LocalPlayer:GetDiplomacy():HasMet(topPlayerID))then
				topName = Locale.Lookup(GameInfo.Civilizations[PlayerConfigurations[Teams[teamData[1].TeamID][1]]:GetCivilizationTypeID()].Name);
			else
				topName = LOC_UNKNOWN_CIV;
			end
		end
		
		instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_OTHER_SIMPLE", topName));

		-- Set local team/player text
		local isVictoryPlayerSet:boolean = false;
		for teamPosition, team in ipairs(teamData) do
			for playerID, data in pairs(team.PlayerData) do
				if playerID == m_LocalPlayerID then
					local localPlayerPositionText:string = Locale.Lookup("LOC_WORLD_RANKINGS_" .. teamPosition .. "_PLACE");
					local localPlayerDescription:string = "";

					if team.PlayerCount > 1 then
						localPlayerDescription = Locale.Lookup("LOC_WORLD_RANKINGS_OTHER_PLACE_TEAM_SIMPLE", localPlayerPositionText);
					else
						localPlayerDescription = Locale.Lookup("LOC_WORLD_RANKINGS_OTHER_PLACE_SIMPLE", localPlayerPositionText);
					end

					instance.VictoryPlayer:SetText(localPlayerDescription);
					isVictoryPlayerSet = true;
				end
			end
		end
		if (not isVictoryPlayerSet) then
			instance.VictoryPlayer:SetText("");		
		end
	end

	instance.ButtonBG:SetSizeY(SIZE_OVERALL_BG_HEIGHT + math.max(instance.PlayerStack:GetSizeY(), SIZE_OVERALL_INSTANCE * ((numIcons / 9) + 1)));
	
	-- Restore original
	teamData = teamDataOriginal
end

function PopulateOverallTeamIconInstance(instance:table, teamData:table, iconSize:number, ribbonSize:number)
	-- Update team icon
	local teamColor:number = GetTeamColor(teamData.TeamID);
	local teamIconName:string = TEAM_ICON_PREFIX .. iconSize;
	instance.CivIcon:SetSizeVal(iconSize, iconSize);
	instance.CivIcon:SetTexture(teamIconName);
	instance.CivIconFaded:SetSizeVal(iconSize, iconSize);
	instance.CivIconFaded:SetTexture(teamIconName);
	instance.CivIcon:SetPercent(teamData.TeamScore);
	instance.CivIcon:SetColor(teamColor);
	instance.CivIconBacking:SetPercent(teamData.TeamScore);
	instance.CivIconBacking:SetColor(teamColor);

	-- Determine if this is the local players team
	instance.LocalPlayer:SetHide(true);
	for playerID, data in pairs(teamData.PlayerData) do
		if playerID == g_LocalPlayerID then
			instance.LocalPlayer:SetHide(false);
		end
	end

	-- Update team ribbon
	local teamRibbonName = TEAM_RIBBON_PREFIX .. tostring(teamData.TeamID);
	instance.TeamRibbon:SetIcon(teamRibbonName, ribbonSize);
	instance.TeamRibbon:SetHide(false);
	instance.TeamRibbon:SetColor(teamColor);

	-- Update tooltip
	SetTeamTooltip(instance.CivIcon, teamData);
	return instance;
end

-- ===========================================================================
function PopulateOverallPlayerIconInstance(instance:table, victoryType:string, teamData:table, iconSize:number)
	-- Take the player ID from the first team member who should be the only team member
	local playerID:number = Teams[teamData.TeamID][1];
	local playerData:table = teamData.PlayerData[playerID];
	if(playerData ~= nil) then
		local civIconManager = CivilizationIcon:AttachInstance(instance);
		local details:string = playerData.FirstTiebreakSummary;
		if playerData.FirstTiebreakSummary ~= playerData.SecondTiebreakSummary then
			details = details .. "[NEWLINE]" .. playerData.SecondTiebreakSummary;
		end
		civIconManager:SetLeaderTooltip(playerID, details);
		civIconManager:UpdateIconFromPlayerID(playerID);

		local _, civIcon:string = GetCivNameAndIcon(playerID);
		instance.CivIconFaded:SetIcon(civIcon);
		instance.CivIcon:SetPercent(teamData.TeamScore);
		instance.CivIconBacking:SetPercent(teamData.TeamScore);
		instance.TeamRibbon:SetHide(true);
		return instance;
	end
end

function SetTeamTooltip(control:table, teamData)
	control:SetToolTipType("TeamTooltip");
	control:SetToolTipCallback(function() UpdateTeamTooltip(control, teamData); end);
end

function UpdateTeamTooltip(control, teamData)
	if m_TeamTooltip.TooltipIM == nil then
		m_TeamTooltip.TooltipIM = InstanceManager:new("TeamTooltipInstance", "BG", m_TeamTooltip.CivStack);
	end
	
	m_TeamTooltip.TooltipIM:ResetInstances();
	
	-- Tracks the widest instance
	local maxWidth:number = 0;

	-- Create an instance for each met player on this team
	for playerID, playerData in pairs(teamData.PlayerData) do
		if g_LocalPlayerID == playerID or g_LocalPlayer:GetDiplomacy():HasMet(playerID) then
			local civInstance:table = m_TeamTooltip.TooltipIM:GetInstance();

			-- Hide/show necessary controls
			civInstance.LeaderIcon:SetHide(false);
			civInstance.YouIndicator:SetHide(false);
			civInstance.LeaderName:SetHide(false);
			civInstance.UnmetLabel:SetHide(true);

			-- Update local player indicator
			civInstance.YouIndicator:SetHide(playerID ~= g_LocalPlayerID);
		
			local playerConfig:table = PlayerConfigurations[playerID];
			local leaderTypeName:string = playerConfig:GetLeaderTypeName();
			if(leaderTypeName ~= nil) then
				-- Update player icon
				local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas("ICON_"..leaderTypeName, SIZE_LEADER_ICON);
				if(textureSheet == nil or textureSheet == "") then
					UI.DataError("Could not find icon in UpdateLeaderTooltip: icon=\"".."ICON_"..leaderTypeName.."\", iconSize="..tostring(SIZE_LEADER_ICON));
				else
					civInstance.LeaderIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
				end

				-- Update description string
				local desc:string;
				local leaderDesc:string = playerConfig:GetLeaderName();
				local civDesc:string = playerConfig:GetCivilizationDescription();
				if GameConfiguration.IsAnyMultiplayer() and playerData.Player:IsHuman() then
					local name = Locale.Lookup(playerConfig:GetPlayerName());
					desc = Locale.Lookup("LOC_DIPLOMACY_DEAL_PLAYER_PANEL_TITLE", leaderDesc, civDesc) .. " (" .. name .. ")";
				else
					desc = Locale.Lookup("LOC_DIPLOMACY_DEAL_PLAYER_PANEL_TITLE", leaderDesc, civDesc);
				end
								
				if playerData.FirstTiebreakSummary and playerData.FirstTiebreakSummary ~= "" then
					desc = desc .. "[NEWLINE]" .. playerData.FirstTiebreakSummary;
				end
				
				if playerData.SecondTiebreakSummary and playerData.SecondTiebreakSummary ~= "" and playerData.SecondTiebreakSummary ~= playerData.FirstTiebreakSummary then
					desc = desc .. "[NEWLINE]" .. playerData.SecondTiebreakSummary;
				end
				
				civInstance.LeaderName:SetText(desc);
			
				-- Track the most wide instance so we can widen smaller instances to match
				if civInstance.Content:GetSizeX() > maxWidth then
					maxWidth = civInstance.Content:GetSizeX();
				end
			end
		end
	end

	-- Create an unmet instance for each unmet player on this team	
	for playerID, playerData in pairs(teamData.PlayerData) do
		if g_LocalPlayerID ~= playerID and not g_LocalPlayer:GetDiplomacy():HasMet(playerID)  then
			local civInstance:table = m_TeamTooltip.TooltipIM:GetInstance();
			
			-- Hide/show necessary controls
			civInstance.LeaderIcon:SetHide(true);
			civInstance.YouIndicator:SetHide(true);
			civInstance.LeaderName:SetHide(true);
			civInstance.UnmetLabel:SetHide(false);

			-- Set the unmet text based on whether this is human or AI
			local playerConfig:table = PlayerConfigurations[playerID];
			if GameConfiguration.IsAnyMultiplayer() and playerData.Player:IsHuman() then
				civInstance.UnmetLabel:SetText(Locale.Lookup("LOC_DIPLOPANEL_UNMET_PLAYER") .. " (" .. playerConfig:GetPlayerName() .. ")");
			else
				civInstance.UnmetLabel:SetText(Locale.Lookup("LOC_DIPLOPANEL_UNMET_PLAYER"));
			end

			-- Track the most wide instance so we can widen smaller instances to match
			if civInstance.Content:GetSizeX() > maxWidth then
				maxWidth = civInstance.Content:GetSizeX();
			end
		end
	end
	
	-- Widen all instances to match up
	for i=1,m_TeamTooltip.TooltipIM.m_iCount,1 do
		local instance:table = m_TeamTooltip.TooltipIM:GetAllocatedInstance(i);
		if instance and instance.BG:GetSizeX() ~= maxWidth then
			instance.BG:SetSizeX(maxWidth);
		end
	end
end

--============= Adriaman: helpers =============--

-- Adriaman sort functions with access level support
-- Returns true iff score a > score b
function CompareScoreAccessLevel(scoreA, scoreB, hasAccessA, hasAccessB)
	return (hasAccessA and scoreA or 0) > (hasAccessB and scoreB or 0)
end

-- Compare between players
function CompareScorePlayers(playerID_A, playerID_B, scoreA, scoreB, infoType)
	return CompareScoreAccessLevel(scoreA, scoreB, HasAccessLevel(playerID_A, infoType), HasAccessLevel(playerID_B, infoType))
end

-- Compare between teams
function CompareScoreTeams(teamID_A, teamID_B, scoreA, scoreB, infoType)
	return CompareScoreAccessLevel(scoreA, scoreB, HasAccessLevelTeam(teamID_A, infoType), HasAccessLevelTeam(teamID_B, infoType))
end

function SortPlayerScore(PlayerDataA, PlayerDataB)
	return CompareScorePlayers(
		PlayerDataA.PlayerID,
		PlayerDataB.PlayerID,
		
		PlayerDataA.PlayerScore, 
		PlayerDataB.PlayerScore, 
		
		"score")
end

function SortTeamScore(TeamDataA, TeamDataB)
	return 	CompareScoreTeams(			
				TeamDataA.TeamID,
				TeamDataB.TeamID,
				
				TeamDataA.TeamScore, 
				TeamDataB.TeamScore,
				
				"score")
end

function SortPlayersMilitary(PlayerDataA, PlayerDataB)
	return 	CompareScorePlayers(			
				PlayerDataA.PlayerID,
				PlayerDataB.PlayerID,
				
				#PlayerDataA.CapturedCapitals, 
				#PlayerDataB.CapturedCapitals,
				
				"military")
end

function SortTeamsMilitary(TeamDataA, TeamDataB)
	return 	CompareScoreTeams(			
				TeamDataA.TeamID,
				TeamDataB.TeamID,
				
				TeamDataA.TotalCapturedCapitals, 
				TeamDataB.TotalCapturedCapitals,
				
				"military")
end

function SortTeamCulture(TeamDataA, TeamDataB)
	return CompareScoreTeams(
		TeamDataA.TeamID, 
		TeamDataB.TeamID, 
		
		TeamDataA.BestNumVisitingUs / TeamDataA.BestNumRequiredTourists, 
		TeamDataB.BestNumVisitingUs / TeamDataB.BestNumRequiredTourists,

		"culture")
end


function SortTeamsReligion(TeamDataA, TeamDataB)
	return CompareScoreTeams(
		TeamDataA.TeamID, 
		TeamDataB.TeamID, 
		
		#TeamDataA.ConvertedCivs, 
		#TeamDataB.ConvertedCivs,

		"religion")
end

-- For Expansion 2
function SortTeamsDiplomacy(TeamDataA, TeamDataB)
	return CompareScoreTeams(
		TeamDataA.teamData.TeamID, 
		TeamDataB.teamData.TeamID, 
		
		TeamDataA.score, 
		TeamDataB.score,

		"diplomacy")
end


-- ===========================================================================
--	Called when Score tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewScore()
	ResetState(ViewScore);
	Controls.ScoreView:SetHide(false);

	ChangeActiveHeader("VICTORY_SCORE", m_GenericHeaderIM, Controls.ScoreViewHeader);
	local subTitle:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_CONDITION", Game.GetMaxGameTurns());
	PopulateGenericHeader(RealizeScoreStackSize, SCORE_TITLE, subTitle, SCORE_DETAILS, ICON_GENERIC);

	-- Gather data
	local scoreData:table = GatherScoreData();

	-- Sort teams
	-- table.sort(scoreData, function(a, b) return (a.TeamScore > b.TeamScore); end);
	table.sort(scoreData, SortTeamScore);

	g_ScoreIM:ResetInstances();
	g_ScoreTeamIM:ResetInstances();

	for i, teamData in ipairs(scoreData) do
		if #teamData.PlayerData > 1 or debugTeams then
			-- Sort players before displaying
			-- table.sort(teamData.PlayerData, function(a, b) return a.PlayerScore> b.PlayerScore; end
			table.sort(teamData.PlayerData, SortPlayerScore);
			-- Display as team
			PopulateScoreTeamInstance(g_ScoreTeamIM:GetInstance(), teamData);
		elseif #teamData.PlayerData > 0 then
			-- Display as single civ
			PopulateScoreInstance(g_ScoreIM:GetInstance(), teamData.PlayerData[1]);
		end
	end

	RealizeScoreStackSize();
end

function GatherScoreData()
	local data:table = {};

	local teamIDs = GetAliveMajorTeamIDs();
	for _, teamID in ipairs(teamIDs) do
		local team = Teams[teamID];
		if (team ~= nil) then
			local teamData:table = { TeamID = teamID, PlayerData = {}, TeamScore = 0 };

			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer:table = Players[playerID];
					local playerData:table = { PlayerID = playerID, PlayerScore = pPlayer:GetScore(), Categories = {} };

					-- Add player score to team score
					teamData.TeamScore = teamData.TeamScore + playerData.PlayerScore;

					-- Look up category scores
					local scoreCategories = GameInfo.ScoringCategories;
					local numCategories:number = #scoreCategories;
					for i = 0, numCategories - 1 do
						if scoreCategories[i].Multiplier > 0 or m_isDebugForceShowAllScoreCategories then
							table.insert(playerData.Categories, { CategoryID = i, CategoryScore = pPlayer:GetCategoryScore(i) });
						end
					end

					table.insert(teamData.PlayerData, playerData);
				end
			end

			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data;
end

function PopulateScoreTeamInstance(instance:table, teamData:table)
	
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("ScoreInstance", "ButtonBG", instance.ScorePlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateScoreInstance(instance.PlayerStackIM:GetInstance(), playerData);
	end

	-- Update combined team score
	if HasAccessLevelTeam(teamData.TeamID, "score") then
		instance.TeamScore:SetText(tostring(teamData.TeamScore));
	else
		instance.TeamScore:SetText(hseUnknown);
	end
end

function PopulateScoreInstance(instance:table, playerData:table)
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);
	
	local hasAccess = HasAccessLevel(playerData.PlayerID, "score");
	
	if hasAccess then
		instance.Score:SetText(playerData.PlayerScore);
	else
		instance.Score:SetText(hseUnknown);
	end


	if(m_ShowScoreDetails) then
		instance.ButtonBG:SetSizeY(SIZE_SCORE_ITEM_DETAILS);
		ResizeLocalPlayerBorder(instance, SIZE_SCORE_ITEM_DETAILS + SIZE_LOCAL_PLAYER_BORDER_PADDING);

		local detailsText:string = "";
		
		for i, category in ipairs(playerData.Categories) do
			local categoryInfo:table = GameInfo.ScoringCategories[category.CategoryID];
				newText = Locale.Lookup(categoryInfo.Name) .. ": "
				
				if HasAccessLevel(playerData.PlayerID, ConvertCategoryToInfoType(category.CategoryID)) then
					newText = newText .. category.CategoryScore;
				else
					newText = newText .. hseUnknown
				end
				
				detailsText = detailsText .. newText

				-- Add new lines between categories but not at the end
				if i <= #playerData.Categories then
					detailsText = detailsText .. "[NEWLINE]";
				end
		end
		

		instance.Details:SetText(detailsText);
		instance.Details:SetHide(false);
	else
		instance.ButtonBG:SetSizeY(SIZE_SCORE_ITEM_DEFAULT);
		ResizeLocalPlayerBorder(instance, SIZE_SCORE_ITEM_DEFAULT + SIZE_LOCAL_PLAYER_BORDER_PADDING);
		instance.Details:SetHide(true);
	end
end

function ResizeLocalPlayerBorder(instance:table, size:number)
	local localPlayerBorder:table = instance.CivilizationIcon.LocalPlayer;
	if localPlayerBorder and not localPlayerBorder:IsHidden() then
		localPlayerBorder:SetSizeY(size);
	end
end

function RealizeScoreStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = g_activeheader[DATA_FIELD_HEADER_HEIGHT];
		Controls.ScoreViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.ScoreViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.ScoreViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.ScoreViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
	end

	RealizeStackAndScrollbar(Controls.ScoreViewStack, Controls.ScoreViewScrollbar, true);

	local textSize:number = Controls.ScoreDetailsButton:GetTextControl():GetSizeX();
	Controls.ScoreDetailsButton:SetSizeX(textSize + PADDING_SCORE_DETAILS_BUTTON_WIDTH);
end

function ToggleScoreDetails()
	m_ShowScoreDetails = not m_ShowScoreDetails;
	Controls.ScoreDetailsCheck:SetCheck(m_ShowScoreDetails);
	ViewScore();
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
	local progressResults:table = { 0, 0, 0 }; -- initialize with 3 elements
	local finishedProjects:table = { {}, {}, {} };
	
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
			-- 1st milestone - satelite launch
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(EARTH_SATELLITE_PROJECT_INFOS) do
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
			for i, projectInfo in ipairs(MOON_LANDING_PROJECT_INFOS) do
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
			for i, projectInfo in ipairs(MARS_COLONY_PROJECT_INFOS) do
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
		end
	end

	local nextStep:string = "";
	for i, result in ipairs(progressResults) do
		if(result < 1) then
			progressText = progressText .. "[ICON_Bolt]";
			if(nextStep == "") then
				nextStep = GetNextStepForScienceProject(g_LocalPlayer, SCIENCE_PROJECTS[i], bHasSpaceport, finishedProjects[i]);
			end
		else
			progressText = progressText .. "[ICON_CheckmarkBlue] ";
		end
		progressText = progressText .. SCIENCE_REQUIREMENTS[i];
		if(i < 3) then progressText = progressText .. "[NEWLINE]"; end
	end

	g_activeheader.AdvisorTextCentered:SetText(progressText);
	g_activeheader.AdvisorTextNextStep:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP", nextStep));

	m_ScienceIM:ResetInstances();
	m_ScienceTeamIM:ResetInstances();

	local teamIDs = GetAliveMajorTeamIDs();
	for _, teamID in ipairs(teamIDs) do
	local team = Teams[teamID];
		if (team ~= nil) then
			if #team > 1 then
				if HasAccessLevelTeam(teamID, "science") then
					PopulateScienceTeamInstance(m_ScienceTeamIM:GetInstance(), teamID);
				else
					-- Stays grayed out
				end
			else
				local pPlayer = Players[team[1]];
				if (pPlayer:IsAlive() == true and pPlayer:IsMajor() == true) then
					if HasAccessLevel(team[1], "science") then
						PopulateScienceInstance(m_ScienceIM:GetInstance(), pPlayer);
					else
						-- Stays grayed out
					end
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

function PopulateTeamInstanceShared(instance, teamID)
	-- Update team color
	local teamColor:number = GetTeamColor(teamID);
	instance.TeamButton:SetColor(teamColor);
	instance.TeamIconBacking:SetColor(teamColor);
	instance.TeamIcon:SetColor(teamColor);
	
	-- Update team ribbon
	local teamRibbonName:string = TEAM_RIBBON_PREFIX .. tostring(teamID);
	instance.TeamRibbon:SetIcon(teamRibbonName, TEAM_RIBBON_SIZE);
	instance.TeamRibbon:SetColor(teamColor);

	-- Update team name
	instance.TeamName:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_TEAM", GameConfiguration.GetTeamName(teamID)));

	-- Update Team Tooltip
	local teamData:table = { PlayerData = {} };
	for i, playerID in ipairs(Teams[teamID]) do
		if IsAliveAndMajor(playerID) then
			teamData.PlayerData[playerID] = { Player = Players[playerID] };
		end
	end
	SetTeamTooltip(instance.TeamIcon, teamData);
end

function PopulatePlayerInstanceShared(instance:table, playerID:number, civNameOffsetY:number)
	UpdateCivilizationIcon(instance, playerID);

	-- Update player name
	if instance.CivilizationIcon.CivName then
		instance.CivilizationIcon.CivName:SetText(GetCivNameAndIcon(playerID, true));
		if civNameOffsetY then
			instance.CivilizationIcon.CivName:SetOffsetY(civNameOffsetY);
		end
	end
end

function PopulateScienceTeamInstance(instance:table, teamID:number)

	PopulateTeamInstanceShared(instance, teamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("ScienceInstance", "ButtonBG", instance.SciencePlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	local teamProgressData:table = {};
	for i, playerID in ipairs(Teams[teamID]) do
		if IsAliveAndMajor(playerID) then
			local pPlayer:table = Players[playerID];
			local progressData = PopulateScienceInstance(instance.PlayerStackIM:GetInstance(), pPlayer);
			if progressData then
				table.insert(teamProgressData, progressData);
			end
		end
	end

	-- Sort team progress data
	table.sort(teamProgressData, function(a, b)
		-- Compare stage 1 progress
		local aScore = a.projectProgresses[1] / a.projectTotals[1];
		local bScore = b.projectProgresses[1] / b.projectTotals[1];
		if aScore == bScore then
			-- Compare stage 2 progress
			aScore = a.projectProgresses[2] / a.projectTotals[2];
			bScore = b.projectProgresses[2] / b.projectTotals[2];
			if aScore == bScore then
				-- Compare stage 3 progress
				aScore = a.projectProgresses[3] / a.projectTotals[3];
				bScore = b.projectProgresses[3] / b.projectTotals[3];
				if aScore == bScore then
					return a.playerID < b.playerID;
				end
			end
		end
		return aScore > bScore;
	end);

	-- Populate the team progress with the progress of the furthest player
	if teamProgressData and #teamProgressData > 0 then
		if HasAccessLevelTeam(teamID, "science") then
			PopulateScienceProgressMeters(instance, teamProgressData[1]);
		end
	end
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
	local projectTotals:table = { 0, 0, 0 };
	local projectProgresses:table = { 0, 0, 0 };
	local finishedProjects:table = { {}, {}, {} };
	for _, city in pPlayerCities:Members() do
		local pBuildQueue:table = city:GetBuildQueue();

		-- 1st milestone - satelite launch
		for i, projectInfo in ipairs(EARTH_SATELLITE_PROJECT_INFOS) do
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
		for i, projectInfo in ipairs(MOON_LANDING_PROJECT_INFOS) do
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
		for i, projectInfo in ipairs(MARS_COLONY_PROJECT_INFOS) do
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
	end

	-- Save data to be returned
	progressData = {};
	progressData.playerID = playerID;
	progressData.projectTotals = projectTotals;
	progressData.projectProgresses = projectProgresses;
	progressData.bHasSpaceport = bHasSpaceport;
	progressData.finishedProjects = finishedProjects;

	PopulateScienceProgressMeters(instance, progressData);

	return progressData;
end

function PopulateScienceProgressMeters(instance:table, progressData:table)
	for i = 1, 3 do
		instance["ObjHidden_" .. i]:SetHide(true);
		instance["ObjFill_" .. i]:SetHide(progressData.projectProgresses[i] == 0);
		instance["ObjBar_" .. i]:SetPercent(progressData.projectProgresses[i] / progressData.projectTotals[i]);
		instance["ObjToggle_ON_" .. i]:SetHide(progressData.projectTotals[i] == 0 or progressData.projectProgresses[i] ~= progressData.projectTotals[i]);
	end
		
	local pPlayer = Players[progressData.playerID];
	instance.ObjBG_1:SetToolTipString(GetTooltipForScienceProject(pPlayer, EARTH_SATELLITE_PROJECT_INFOS, progressData.bHasSpaceport, progressData.finishedProjects[1]));
	instance.ObjBG_2:SetToolTipString(GetTooltipForScienceProject(pPlayer, MOON_LANDING_PROJECT_INFOS, nil, progressData.finishedProjects[2]));
	instance.ObjBG_3:SetToolTipString(GetTooltipForScienceProject(pPlayer, MARS_COLONY_PROJECT_INFOS, nil, progressData.finishedProjects[3]));
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

function RealizeScienceStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = g_activeheader[DATA_FIELD_HEADER_HEIGHT];
		headerHeight = headerHeight + g_activeheader.AdvisorTextCentered:GetSizeY() + g_activeheader.AdvisorTextNextStep:GetSizeY() + (PADDING_HEADER * 2);
		g_activeheader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + headerHeight);
		g_activeheader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + headerHeight);
		g_activeheader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + headerHeight);
		Controls.ScienceViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.ScienceViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
		g_activeheader.AdvisorTextCentered:SetHide(false);
		g_activeheader.AdvisorTextNextStep:SetHide(false);
	else
		Controls.ScienceViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.ScienceViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
		g_activeheader.AdvisorTextCentered:SetHide(true);
		g_activeheader.AdvisorTextNextStep:SetHide(true);
	end

	RealizeStackAndScrollbar(Controls.ScienceViewStack, Controls.ScienceViewScrollbar, true);

	--local textSize:number = Controls.ScienceDetailsButton:GetTextControl():GetSizeX();
	--Controls.ScienceDetailsButton:SetSizeX(textSize + PADDING_SCORE_DETAILS_BUTTON_WIDTH);
end

-- ===========================================================================
function ResetTourismLens()
	if UILens.IsLensActive("TourismWithUnits") then
		UILens.SetActive("Default");
	end
end

-- ===========================================================================
--	Called when Culture tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function SetCultureHeaderState(state:number)
	m_CultureHeaderState = state;
	ViewCulture();
end

function ViewCulture()
	ResetState(ViewCulture);
	Controls.CultureView:SetHide(false);

	ChangeActiveHeader("VICTORY_CULTURE", m_CultureHeaderIM, Controls.CultureViewHeader);

	-- Active the Tourism lens if it isn't already
	if not UILens.IsLensActive("TourismWithUnits") then
		UILens.SetActive("TourismWithUnits");
	end

	local detailsText:string;
	if(m_CultureHeaderState == CULTURE_HEADER_STATES.WHAT_IS_CULTURE_VICTORY) then
		detailsText = CULTURE_VICTORY_DETAILS;
		g_activeheader.DomesticTourism:SetText(CULTURE_DOMESTIC_TOURISTS);
		g_activeheader.VisitingTourism:SetText(CULTURE_VISITING_TOURISTS);
	else
		UI.DataError("Unknown m_CultureHeaderState in ViewCulture: " .. tostring(m_CultureHeaderState));
	end

	PopulateGenericHeader(RealizeCultureStackSize, CULTURE_TITLE, "", detailsText, CULTURE_ICON);

	-- Gather data
	local cultureData:table = GatherCultureData();

	-- Sort by team
	-- table.sort(cultureData, function(a, b) return a.BestNumVisitingUs / a.BestNumRequiredTourists > b.BestNumVisitingUs / b.BestNumRequiredTourists; end);
	table.sort(cultureData, SortTeamCulture);

	m_CultureIM:ResetInstances();
	m_CultureTeamIM:ResetInstances();

	for i, teamData in ipairs(cultureData) do
		if #teamData.PlayerData > 1 or debugTeams then
			-- Display as team
			PopulateCultureTeamInstance(m_CultureTeamIM:GetInstance(), teamData);
		elseif #teamData.PlayerData > 0 then
			-- Display as single civ
			PopulateCultureInstance(m_CultureIM:GetInstance(), teamData.PlayerData[1]);
		end
	end

	RealizeCultureStackSize();
end

function GatherCultureData()
	local data:table = {};

	local teamIDs = GetAliveMajorTeamIDs();
	for _, teamID in ipairs(teamIDs) do
		local team = Teams[teamID];
		if (team ~= nil) then
			local teamData:table = { TeamID = teamID, PlayerData = {}, BestNumVisitingUs = 0, BestNumRequiredTourists = 1 };

			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer:table = Players[playerID];
					local pPlayerCulture:table = pPlayer:GetCulture();

					local playerData:table = { 
						PlayerID = playerID, 
						NumRequiredTourists = 0,
						NumStaycationers = pPlayerCulture:GetStaycationers(),
						NumVisitingUs = pPlayerCulture:GetTouristsTo() };

					-- Determine if this player is the closest to cultural victory
					playerData.TurnsTillCulturalVictory = pPlayerCulture.GetTurnsUntilVictory and pPlayerCulture:GetTurnsUntilVictory() or -1;
					if m_iTurnsTillCulturalVictory == -1 or m_iTurnsTillCulturalVictory > playerData.TurnsTillCulturalVictory then
						m_iTurnsTillCulturalVictory = playerData.TurnsTillCulturalVictory;
					end

					-- Determine number of tourist needed for victory
					-- Has to be one more than every other players number of domestic tourists
					for i, player in ipairs(Players) do
						if i ~= playerID and IsAliveAndMajor(i)  and player:GetTeam() ~= teamID then
							local iStaycationers = player:GetCulture():GetStaycationers();
							if iStaycationers >= playerData.NumRequiredTourists then
								playerData.NumRequiredTourists = iStaycationers + 1;
							end
						end
					end

					-- See if this player has the best score for this team
					local currentTeamScore:number = teamData.BestNumVisitingUs / teamData.BestNumRequiredTourists;
					local playerScore:number = playerData.NumVisitingUs / playerData.NumRequiredTourists;
					if currentTeamScore < playerScore or (currentTeamScore == playerScore and teamData.BestNumRequiredTourists < playerData.NumRequiredTourists) then
						teamData.BestNumVisitingUs = playerData.NumVisitingUs;
						teamData.BestNumRequiredTourists = playerData.NumRequiredTourists;
					end

					table.insert(teamData.PlayerData, playerData);
				end
			end

			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data;
end

function PopulateCultureTeamInstance(instance:table, teamData:table)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("CultureInstance", "ButtonBG", instance.CulturePlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateCultureInstance(instance.PlayerStackIM:GetInstance(), playerData);
	end
	
	local bestNumRequiredTourists = teamData.BestNumRequiredTourists
	local bestNumVisitingUs = teamData.BestNumVisitingUs
	local percentProgress = teamData.BestNumVisitingUs / teamData.BestNumRequiredTourists

	-- Show score for player closest to winning
	if not HasAccessLevelTeam(teamData.TeamID, "culture") then
		bestNumVisitingUs = hseUnknown
		percentProgress = 0
	end
	
	-- We need culture access to all players to know the required number of visiting tourists to win.
	for i,v in ipairs(PlayerManager.GetAliveMajors()) do
		if not HasAccessLevel(v:GetID(), "culture") then
			bestNumRequiredTourists = hseUnknown
			percentProgress = 0
			break
		end
	end

	instance.VisitingTourists:SetText(bestNumVisitingUs .. "/" .. bestNumRequiredTourists);
	instance.TouristsFill:SetPercent(percentProgress);
end

function PopulateCultureInstance(instance:table, playerData:table)
	local pPlayer:table = Players[playerData.PlayerID];
	hasAccess = HasAccessLevel(playerData.PlayerID, "culture")
	
	-- We need culture access to all players to know the required number of visiting tourists to win.
	local numVisitingUs = playerData.NumVisitingUs
	local numRequiredTourists = playerData.NumRequiredTourists
	local percentProgress = playerData.NumVisitingUs / playerData.NumRequiredTourists
	
	if not hasAccess then
		numVisitingUs = hseUnknown
	end
	
	for i,v in ipairs(PlayerManager.GetAliveMajors()) do
		if not HasAccessLevel(v:GetID(), "culture") then
			numRequiredTourists = hseUnknown
			percentProgress = 0
			break
		end
	end
	
	PopulatePlayerInstanceShared(instance, playerData.PlayerID, 7)
	instance.VisitingTourists:SetText(numVisitingUs .. "/" .. numRequiredTourists);
	instance.TouristsFill:SetPercent(percentProgress);
	
	instance.VisitingUsContainer:SetHide(playerData.PlayerID == g_LocalPlayerID);

	local backColor, _ = UI.GetPlayerColors(playerData.PlayerID);
	local brighterBackColor = UI.DarkenLightenColor(backColor,35,255);
	if(playerData.PlayerID == g_LocalPlayerID or g_LocalPlayer == nil or g_LocalPlayer:GetDiplomacy():HasMet(playerData.PlayerID)) then
		if hasAccess then
			instance.DomesticTouristsIcon:SetColor(brighterBackColor);
		else
			instance.DomesticTouristsIcon:SetColor(UI.GetColorValue(1, 1, 1, 0.35));
		end
	else
		instance.DomesticTouristsIcon:SetColor(UI.GetColorValue(1, 1, 1, 0.35));
	end
	
	if hasAccess then
		instance.DomesticTourists:SetText(playerData.NumStaycationers);
	else
		instance.DomesticTourists:SetText(hseUnknown);
	end
	if(instance.TurnsTillVictory) then
		local iTurnsTillVictory:number = playerData.TurnsTillCulturalVictory;
		if(iTurnsTillVictory > 0 and iTurnsTillVictory >= m_iTurnsTillCulturalVictory) then
			if hasAccess then
				instance.TurnsTillVictory:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_CULTURAL_VICTORY_TURNS", iTurnsTillVictory));
				instance.TurnsTillVictory:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_CULTURAL_VICTORY_TURNS_TT", iTurnsTillVictory));
			else
				instance.TurnsTillVictory:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_CULTURAL_VICTORY_TURNS", hseUnknown));
				instance.TurnsTillVictory:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_CULTURAL_VICTORY_TURNS_TT", hseUnknown));
			end
			
			instance.TurnsTillVictory:SetHide(false);
		else
			instance.TurnsTillVictory:SetHide(true);
		end
	end

	if (g_LocalPlayer ~= nil) then
		local pLocalPlayerCulture:table = g_LocalPlayer:GetCulture();
		tooltip = pLocalPlayerCulture:GetTouristsFromTooltip(playerData.PlayerID)
		
		-- Logic from Better World Ranking
		
		local sTrimmedTT:string = "";
		for i = 1, #tooltip do
			local ch:string = string.sub(tooltip, i, i);
			if string.byte(ch) < 128 then sTrimmedTT = sTrimmedTT..ch; end
		end
		--print("....TT:", sTrimmedTT);
		local sCurrentT:string, sLifetimeT:string = string.match(sTrimmedTT, "([%d%.,]+)%D+([%d%.,]+)"); -- detects first 2 numbers, number may contain . or ,
		--print("....tourism string to player", playerID, sCurrentT, sLifetimeT);
		if sCurrentT  == nil then sCurrentT  = "0"; playerData.ErrCurrent  = true; end
		if sLifetimeT == nil then sLifetimeT = "0"; playerData.ErrLifetime = true; end
		sCurrentT  = string.gsub(sCurrentT, "%D",""); -- remove all non-digits, it returns 2 values, so cannot use directly with tonumber()
		sLifetimeT = string.gsub(sLifetimeT,"%D","");
		--print("....tourism string to player", playerID, sCurrentT, sLifetimeT);
		local iCurrentT:number, iLifetimeT:number = tonumber(sCurrentT), tonumber(sLifetimeT);
		if iCurrentT  == nil then iCurrentT  = 0; playerData.ErrCurrent  = true; end
		if iLifetimeT == nil then iLifetimeT = 0; playerData.ErrLifetime = true; end
		--print("....tourism number to player", playerID, iCurrentT, iLifetimeT);
		if iLifetimeT < iCurrentT then playerData.ErrLifetime = true; end
		local iTotalT:number = Players[Game.GetLocalPlayer()]:GetStats():GetTourism();

		
		if hasAccess then
			instance.VisitingUsTourists:SetText(pLocalPlayerCulture:GetTouristsFrom(playerData.PlayerID));
		else
			-- Adriaman hide tourism info
			tooltip = string.gsub(tooltip, ' '..iCurrentT..' ', ' '..hseUnknown..' ')
			tooltip = string.gsub(tooltip, ' '..iTotalT..' ', ' '..hseUnknown..' ')
			instance.VisitingUsTourists:SetText(hseUnknown);
		end
		
		instance.VisitingUsTourists:SetToolTipString(tooltip);
		instance.VisitingUsIcon:SetToolTipString(tooltip);
	end
end

function RealizeCultureStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = g_activeheader.AdvisorText:GetSizeY() + PADDING_ADVISOR_TEXT_BG;

		if(m_CultureHeaderState == CULTURE_HEADER_STATES.WHAT_IS_CULTURE_VICTORY) then
			g_activeheader.HowToAttractTourists:SetOffsetY(headerHeight);
			headerHeight = headerHeight + math.max(g_activeheader.DomesticTourism:GetSizeY(), g_activeheader.DomesticTourismIcon:GetSizeY()) + (PADDING_HEADER * 2);
			headerHeight = headerHeight + math.max(g_activeheader.VisitingTourism:GetSizeY(), g_activeheader.VisitingTourismIcon:GetSizeY()) + PADDING_HEADER;
			g_activeheader.HowToAttractTourists:SetHide(false);
		else
			UI.DataError("Unknown m_CultureHeaderState in ViewCulture: " .. tostring(m_CultureHeaderState));
		end

		g_activeheader.AdvisorTextBG:SetSizeY(headerHeight);
		g_activeheader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + headerHeight);
		g_activeheader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + headerHeight);
		g_activeheader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + headerHeight);

		g_activeheader.StateBG:SetOffsetY(headerHeight + PADDING_CULTURE_HEADER);

		headerHeight = headerHeight + g_activeheader.StateBG:GetSizeY() + PADDING_HEADER;

		g_activeheader.NextState:SetOffsetX(g_activeheader.StateBG:GetSizeX());
		
		Controls.CultureViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.CultureViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.CultureViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.CultureViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
		g_activeheader.HowToAttractTourists:SetHide(true);
	end

	RealizeStackAndScrollbar(Controls.CultureViewStack, Controls.CultureViewScrollbar, true);
end

-- ===========================================================================
--	Called when Domination tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewDomination()
	ResetState(ViewDomination);
	Controls.DominationView:SetHide(false);

	ChangeActiveHeader("VICTORY_CONQUEST", m_GenericHeaderIM, Controls.DominationViewHeader);
	PopulateGenericHeader(RealizeDominationStackSize, DOMINATION_TITLE, "", DOMINATION_DETAILS, DOMINATION_ICON);

	local dominationData:table = {};

	local teamIDs = GetAliveMajorTeamIDs();
	for _, teamID in ipairs(teamIDs) do
		local team = Teams[teamID];
		if (team ~= nil) then
			local teamData:table = { TeamID = teamID, TotalCapturedCapitals = 0, TotalCapturedCapitalsVisible = 0, TotalCapturedCapitalsHidden = 0, PlayerData = {} };

			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer = Players[playerID];
					local pCities = pPlayer:GetCities();

					-- Don't show player if they haven't founded a capital city yet
					local pCapital = pCities:GetCapitalCity();
					if(pCapital ~= nil) then
						local playerData:table = {};
						playerData.PlayerID				= playerID;
						playerData.HasOriginalCapital	= false;
						playerData.CapturedCapitals		= {};
						playerData.CapitalCityID 		= nil;
						playerData.TotalCapturedCapitals = 0
						playerData.TotalCapturedCapitalsVisible = 0
						playerData.TotalCapturedCapitalsHidden = 0
 
						local data = {};
						for _, city in pCities:Members() do
							local originalOwnerID:number = city:GetOriginalOwner();
							local pOriginalOwner:table = Players[originalOwnerID];
							if(playerID ~= originalOwnerID and pOriginalOwner:IsMajor() and city:IsOriginalCapital()) then
								table.insert(playerData.CapturedCapitals, originalOwnerID);
								teamData.TotalCapturedCapitals = teamData.TotalCapturedCapitals + 1;
								playerData.TotalCapturedCapitals = playerData.TotalCapturedCapitals + 1
								
								if IsCityRevealed(city) or HasAccessLevel(playerID, "military") then
									playerData.TotalCapturedCapitalsVisible = playerData.TotalCapturedCapitalsVisible + 1
									
									teamData.TotalCapturedCapitalsVisible = teamData.TotalCapturedCapitalsVisible + 1
								else
									playerData.TotalCapturedCapitalsHidden = playerData.TotalCapturedCapitalsHidden + 1
									
									teamData.TotalCapturedCapitalsHidden = teamData.TotalCapturedCapitalsHidden + 1
								end
								
								playerData.CapitalCityID = city:GetID()
							elseif(playerID == originalOwnerID and pOriginalOwner:IsMajor() and city:IsOriginalCapital()) then
								playerData.HasOriginalCapital = true;
								playerData.CapitalCityID = city:GetID()
							end
						end

						table.insert(teamData.PlayerData, playerData);
					end
				end
			end

			table.insert(dominationData, teamData);
		end
	end
	m_DominationIM:ResetInstances();
	m_DominationTeamIM:ResetInstances();

	-- Sort players within teams by dominated capitals
	for i, teamData in ipairs(dominationData) do 
		-- table.sort(teamData.PlayerData, function(a, b) return #a.CapturedCapitals > #b.CapturedCapitals end);
		table.sort(teamData.PlayerData, SortPlayersMilitary);
	end

	-- Sort teams by most combined dominated capitals
	-- table.sort(dominationData, function(a, b) return a.TotalCapturedCapitals > b.TotalCapturedCapitals end);
	table.sort(dominationData, SortTeamsMilitary);

	-- Populate teams
	for i, teamData in ipairs(dominationData) do
		if #teamData.PlayerData > 1 or debugTeams then
			PopulateDominationTeamInstance(m_DominationTeamIM:GetInstance(), teamData);
		elseif #teamData.PlayerData == 1 then
			PopulateDominationInstance(m_DominationIM:GetInstance(), teamData.PlayerData[1]);
		end
	end

	RealizeDominationStackSize();
end

function PopulateDominationTeamInstance(instance:table, teamData:table)
	
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Update captured capitals icon stack
	local dominatedCitiesIM:table = instance[DATA_FIELD_DOMINATED_CITIES_IM];
	if(dominatedCitiesIM == nil) then
		dominatedCitiesIM = InstanceManager:new("DominatedCapitalInstance", "Root", instance.CapitalsCapturedStack);
		instance[DATA_FIELD_DOMINATED_CITIES_IM] = dominatedCitiesIM;
	end
	dominatedCitiesIM:ResetInstances();

	if HasAccessLevelTeam(teamData.TeamID, "military") then
		for i, playerData in ipairs(teamData.PlayerData) do
			for _, dominatedPlayerID in pairs(playerData.CapturedCapitals) do
				UpdateCivilizationIcon(dominatedCitiesIM:GetInstance(), dominatedPlayerID);
			end
		end
	end

	local capitalStr = nil
	
	-- Update captured capitals label
	if HasAccessLevelTeam(teamData.TeamID, "military") then
		capitalStr = teamData.TotalCapturedCapitals
	else
		local visibleOriginalCapitals, hiddenOriginalCapitals = GetOriginalCapitalsCount()
		print(visibleOriginalCapitals, hiddenOriginalCapitals)
		if teamData.TotalCapturedCapitalsVisible ~= teamData.TotalCapturedCapitalsVisible + hiddenOriginalCapitals then
			capitalStr = teamData.TotalCapturedCapitalsVisible .. "~" .. (teamData.TotalCapturedCapitalsVisible + hiddenOriginalCapitals)
		else
			capitalStr = teamData.TotalCapturedCapitalsVisible
		end
	end
	
	instance.CapitalsCaptured:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_SUMMARY", capitalStr));

	
	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("DominationInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateDominationInstance(instance.PlayerStackIM:GetInstance(), playerData);
	end
end

function PopulateDominationInstance(instance:table, playerData:table)
	local pPlayer:table = Players[playerData.PlayerID];

	instance.ButtonBG:RegisterSizeChanged( function() OnDominationButtonSizeChanged(instance); end );

	PopulatePlayerInstanceShared(instance, playerData.PlayerID);
	
	_, canViewCapital = GetOriginalCapitalCityInfo(playerData.PlayerID)
	
	if canViewCapital then
		instance.HasCapital:SetHide(not playerData.HasOriginalCapital);
		instance.HasCapital:SetToolTipString(DOMINATION_HAS_ORIGINAL_CAPITAL);
		instance.HasCapitalUnknown:SetHide(true);
	else
		instance.HasCapital:SetHide(true);
		instance.HasCapitalUnknown:SetHide(false);
		-- No "unknown" icon is available :(
		instance.HasCapitalUnknown:SetText("[ICON_Exclamation]");
		instance.HasCapitalUnknown:SetToolTipString(hseUnknown);
	end
	
	
	local dominatedCitiesIM:table = instance[DATA_FIELD_DOMINATED_CITIES_IM];
	if(dominatedCitiesIM == nil) then
		dominatedCitiesIM = InstanceManager:new("DominatedCapitalInstance", "Root", instance.CapitalsCapturedStack);
		instance[DATA_FIELD_DOMINATED_CITIES_IM] = dominatedCitiesIM;
	end
	dominatedCitiesIM:ResetInstances();

	local visibleOriginalCapitals, hiddenOriginalCapitals = GetOriginalCapitalsCount()

	for _, dominatedPlayerID in pairs(playerData.CapturedCapitals) do		
		if IsCityIDRevealed(playerData.CapitalCityID, playerData.PlayerID) or HasAccessLevel(playerData.PlayerID, "military") then
			UpdateCivilizationIcon(dominatedCitiesIM:GetInstance(), dominatedPlayerID);
		end
	end
	
	local capitalStr = nil
	
	if HasAccessLevel(playerData.PlayerID, "military") then
		capitalStr = playerData.TotalCapturedCapitals
	else
		if playerData.TotalCapturedCapitalsVisible ~= playerData.TotalCapturedCapitalsVisible + hiddenOriginalCapitals then
			capitalStr = playerData.TotalCapturedCapitalsVisible .. "~" .. (playerData.TotalCapturedCapitalsVisible + hiddenOriginalCapitals)
		else
			capitalStr = playerData.TotalCapturedCapitalsVisible
		end
	end	
	
	-- instance.CapitalsCaptured:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_SUMMARY", #playerData.CapturedCapitals));
	instance.CapitalsCaptured:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_SUMMARY", capitalStr));

	--Resize with padding; border starts higher and must end lower than rest of instance
	ResizeLocalPlayerBorder(instance, SIZE_SCORE_ITEM_DEFAULT + SIZE_LOCAL_PLAYER_BORDER_PADDING);
end

-- ===========================================================================
function OnDominationButtonSizeChanged( instance:table )
	instance.CivilizationIcon.LocalPlayer:SetSizeY(instance.ButtonBG:GetSizeY() + SIZE_LOCAL_PLAYER_BORDER_PADDING);
end

-- ===========================================================================
function RealizeDominationStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = g_activeheader[DATA_FIELD_HEADER_HEIGHT];
		Controls.DominationViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.DominationViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.DominationViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.DominationViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
	end

	RealizeStackAndScrollbar(Controls.DominationViewStack, Controls.DominationViewScrollbar, true);
end

-- ===========================================================================
--	Called when Religion tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewReligion()
	ResetState(ViewReligion);
	Controls.ReligionView:SetHide(false);
	
	ActivateReligionLens();

	ChangeActiveHeader("VICTORY_RELIGIOUS", m_GenericHeaderIM, Controls.ReligionViewHeader);
	PopulateGenericHeader(RealizeReligionStackSize, RELIGION_TITLE, "", RELIGION_DETAILS, RELIGION_ICON);

	-- Gather data
	local religionData:table, totalCivs:number = GatherReligionData();

	-- Sort teams
	--table.sort(religionData, function(a, b) return #a.ConvertedCivs > #b.ConvertedCivs; end);
	table.sort(religionData, SortTeamsReligion);
	m_ReligionIM:ResetInstances();
	m_ReligionTeamIM:ResetInstances();

	for i, teamData in ipairs(religionData) do
		if #teamData.PlayerData > 1 or debugTeams then
			-- Display as team
			PopulateReligionTeamInstance(m_ReligionTeamIM:GetInstance(), teamData, totalCivs);
		elseif #teamData.PlayerData > 0 then
			-- Display as single civ
			if teamData.PlayerData[1].ReligionType > 0 then
				PopulateReligionInstance(m_ReligionIM:GetInstance(), teamData.PlayerData[1], totalCivs);
			end
		end
	end

	RealizeReligionStackSize();
end

function GatherReligionData()
	local data:table = {};
	local totalCivs:number = 0;

	local teamIDs = GetAliveMajorTeamIDs();
	for _, teamID in ipairs(teamIDs) do
		local team = Teams[teamID];
		if (team ~= nil) then
			-- ConvertedCivsMaybe is always the same
			-- ConvertedCivsYes is cumulative
			local teamData:table = { TeamID = teamID, PlayerData = {}, ConvertedCivs = {}, ConvertedCivsYes = 0, ConvertedCivsMaybe = 0, ConvertedCivsNo = 0 };
 
			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					totalCivs = totalCivs + 1;
					local pPlayer:table = Players[playerID];
					local playerData:table = { PlayerID = playerID, ReligiousDetails = nil, ConvertedCivs = {} };
					      
					local pReligion = pPlayer:GetReligion();
					if pReligion ~= nil then
						playerData.ReligionType = pReligion:GetReligionTypeCreated();
						       
						if playerData.ReligionType ~= -1 then
							playerData.ReligiousData = GetReligiousDetails(playerData.ReligionType)
							teamData.ConvertedCivsYes = teamData.ConvertedCivsYes + playerData.ReligiousData.ConvertedCivsYes
							teamData.ConvertedCivsMaybe = playerData.ReligiousData.ConvertedCivsMaybe
							
							for _, civID in ipairs(playerData.ReligiousData.ConvertedCivs) do
								table.insert(teamData.ConvertedCivs, civID);
								table.insert(playerData.ConvertedCivs, civID);
							end
						end
					end

					table.insert(teamData.PlayerData, playerData);
				end
			end
			
			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data, totalCivs;	
end

function PopulateReligionTeamInstance(instance:table, teamData:table, totalCivs:number)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("ReligionInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		if playerData.ReligionType > 0 then
			PopulateReligionInstance(instance.PlayerStackIM:GetInstance(), playerData, totalCivs);
		end
	end

	local convertedCivsIM:table = instance[DATA_FIELD_RELIGION_CONVERTED_CIVS_IM];
	if(convertedCivsIM == nil) then
		convertedCivsIM = InstanceManager:new("ConvertedReligionInstance", "Root", instance.CivsConvertedStack);
		instance[DATA_FIELD_RELIGION_CONVERTED_CIVS_IM] = convertedCivsIM;
	end

	convertedCivsIM:ResetInstances();

	for i, convertedCivID in ipairs(teamData.ConvertedCivs) do
		UpdateCivilizationIcon(convertedCivsIM:GetInstance(), convertedCivID);
	end
	
	
	local yes = teamData.ConvertedCivsYes
	local maybe = teamData.ConvertedCivsMaybe

	instance.CivsConverted:SetText(
	Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_CONVERT_SUMMARY", (maybe == 0) and (yes) or (yes .. '~' .. (yes+maybe)).. "/" .. totalCivs, "LOC_WORLD_RANKINGS_RELIGION_TEAMS_RELIGIONS"));
end

function PopulateReligionInstance(instance:table, playerData:table, totalCivs:number)

	PopulatePlayerInstanceShared(instance, playerData.PlayerID, 7);

	local religionData = GameInfo.Religions[playerData.ReligionType];
	local religionColor:number = UI.GetColorValue(religionData.Color);
	
	instance.ReligionName:SetColor(religionColor);
	instance.ReligionName:SetText(Game.GetReligion():GetName(playerData.ReligionType));
	instance.ReligionBG:SetSizeX(instance.ReligionName:GetSizeX() + PADDING_RELIGION_NAME_BG);
	instance.ReligionBG:SetColor(religionColor);
	
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas("ICON_" .. religionData.ReligionType, SIZE_RELIGION_ICON_SMALL);
	if(textureSheet == nil or textureSheet == "") then
		UI.DataError("Could not find icon in PopulateReligionInstance: icon=\"".."ICON_" .. religionData.ReligionType.."\", iconSize="..tostring(SIZE_RELIGION_ICON_SMALL) );
	else
		instance.ReligionIcon:SetColor(religionColor);
		instance.ReligionIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
	end
	
	local convertedCivsIM:table = instance[DATA_FIELD_RELIGION_CONVERTED_CIVS_IM];
	if(convertedCivsIM == nil) then
		convertedCivsIM = InstanceManager:new("ConvertedReligionInstance", "Root", instance.CivsConvertedStack);
		instance[DATA_FIELD_RELIGION_CONVERTED_CIVS_IM] = convertedCivsIM;
	end
	
	convertedCivsIM:ResetInstances();
	--print_table(playerData.ReligiousData)
	--print_table(playerData.ConvertedCivs)
	for i, convertedCivID in ipairs(playerData.ConvertedCivs) do		
		UpdateCivilizationIcon(convertedCivsIM:GetInstance(), convertedCivID)
	end
	
	if #playerData.ConvertedCivs == 0 then
	--	instance.ButtonBG:SetSizeY(SIZE_RELIGION_BG_HEIGHT + instance.CivsConvertedStack:GetSizeY());
	else
	--	instance.ButtonBG:SetSizeY(PADDING_RELIGION_BG_HEIGHT + instance.CivsConvertedStack:GetSizeY());
	end
	
	local yes = playerData.ReligiousData.ConvertedCivsYes
	local maybe = playerData.ReligiousData.ConvertedCivsMaybe

	instance.CivsConverted:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_CONVERT_SUMMARY", 
	(maybe == 0) and (yes) or (yes .. '~' .. (yes+maybe)).. "/" .. totalCivs, Game.GetReligion():GetName(playerData.ReligionType)));
end 

function RealizeReligionStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = g_activeheader[DATA_FIELD_HEADER_HEIGHT];
		Controls.ReligionViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.ReligionViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.ReligionViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.ReligionViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
	end

	RealizeStackAndScrollbar(Controls.ReligionViewStack, Controls.ReligionViewScrollbar, true);
end

-- ===========================================================================
--	Called when Generic (custom victory type) tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewGeneric(victoryType:string)
	ResetState(function() ViewGeneric(victoryType); end);
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

	for i, teamData in ipairs(genericData) do
		if #teamData.PlayerData > 1 or debugTeams then
			PopulateGenericTeamInstance(g_GenericTeamIM:GetInstance(), teamData, victoryType);
		else
			local uiGenericInstance:table = g_GenericIM:GetInstance();
			PopulateGenericInstance(uiGenericInstance, teamData.PlayerData[1], victoryType, true);
		end
	end

	RealizeGenericStackSize();
end

function GatherGenericData()
	local data:table = {};

	local teamIDs = GetAliveMajorTeamIDs();
	for _, teamID in ipairs(teamIDs) do
		local team = Teams[teamID];
		if (team ~= nil) then
			local teamData:table = { TeamID = teamID, PlayerData = {} };

			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer:table = Players[playerID];
					local playerData:table = { PlayerID = playerID };

					table.insert(teamData.PlayerData, playerData);
				end
			end

			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data;
end

function PopulateGenericTeamInstance(instance:table, teamData:table, victoryType:string)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("GenericInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateGenericInstance(instance.PlayerStackIM:GetInstance(), playerData, victoryType, false);
	end

	local requirementSetID:number = Game.GetVictoryRequirements(teamData.TeamID, victoryType);
	if requirementSetID ~= nil and requirementSetID ~= -1 then

		local detailsText:string = "";
		local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
		for _, requirementID in ipairs(innerRequirements) do

			if detailsText ~= "" then
				detailsText = detailsText .. "[NEWLINE]";
			end

			local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, REQUIREMENT_CONTEXT);
			local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

			if requirementText ~= nil then
				detailsText = detailsText .. requirementText;
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
		instance.Details:SetText(detailsText);
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
	
			for _, requirementID in ipairs(innerRequirements) do

				if detailsText ~= "" then
					detailsText = detailsText .. "[NEWLINE]";
				end

				local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, REQUIREMENT_CONTEXT);
				local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

				if requirementText ~= nil then
					detailsText = detailsText .. requirementText;
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
			instance.Details:SetText(detailsText);
		else
			instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
		end
	else
		instance.Details:SetText("");
	end
	if instance.Details and instance.CivilizationIcon.CivName then
		local detailWidth:number = instance.Details:GetSizeX();
		local parentWidth:number = instance.ButtonBG:GetSizeX();
		local textOffset:number   = instance.CivilizationIcon.CivName:GetOffsetX();
		local detailOffset:number = instance.Details:GetOffsetX();
		instance.CivilizationIcon.CivName:SetSizeX(parentWidth - detailWidth - textOffset - detailOffset - SIZE_DETAILS_SPACING);
	elseif instance.CivilizationIcon.CivName then
		instance.CivilizationIcon.CivName:SetSizeX(SIZE_DEFAULT_CIVNAME);
	end


	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonBG:SetSizeY(itemSize);
end

function RealizeGenericStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = g_activeheader[DATA_FIELD_HEADER_HEIGHT];
		Controls.GenericViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.GenericViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.GenericViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.GenericViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
	end

	RealizeStackAndScrollbar(Controls.GenericViewStack, Controls.GenericViewScrollbar, true);
end

-- ===========================================================================
--	Logic that governs extra tabs
-- ===========================================================================
function ToggleExtraTabs()
	local shouldHide:boolean = not Controls.ExtraTabs:IsHidden();
	Controls.ExtraTabs:SetHide(shouldHide);
	Controls.ExpandExtraTabs:SetSelected(not shouldHide);
end

function CloseExtraTabs()
	Controls.ExtraTabs:SetHide(true);
	Controls.ExpandExtraTabs:SetSelected(false);
	for _,tabInst in pairs(m_ExtraTabs) do
		tabInst.Button:SetSelected(false);
	end
end

-- ===========================================================================
--	Update player data and refresh the display state
-- ===========================================================================
function UpdatePlayerData()
	if (Game.GetLocalPlayer() ~= -1) then
		g_LocalPlayer = Players[Game.GetLocalPlayer()];
		g_LocalPlayerID = g_LocalPlayer:GetID();
	else
		g_LocalPlayer = nil;
		g_LocalPlayerID = -1;
	end
end

function UpdateData()
	UpdatePlayerData();
	if(g_LocalPlayer ~= nil and m_ActiveViewUpdate ~= nil) then
		m_ActiveViewUpdate();
	end
end

-- ===========================================================================
--	Update CivilizationIcon instance (CivilizationIcon.lua)
-- ===========================================================================
function UpdateCivilizationIcon(instance:table, playerID:number)
	local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
	civIconClass:UpdateIconFromPlayerID(playerID);
	civIconClass:SetLeaderTooltip(playerID);
end

-- ===========================================================================
--	SCREEN EVENTS
-- ===========================================================================
function Open()
	-- dont show panel if there is no local player
	local localPlayerID = Game.GetLocalPlayer();
	if (localPlayerID == -1) then
		return
	end

	UpdateData();
	m_AnimSupport.Show();
	UI.PlaySound("CityStates_Panel_Open");
	-- Ensure we're the only partial screen currenly up
	LuaEvents.WorldRankings_CloseCityStates();
end

-- ===========================================================================
function Close()	
	m_AnimSupport.Hide();
    if not ContextPtr:IsHidden() then
        UI.PlaySound("CityStates_Panel_Close");
    end
	LuaEvents.WorldRankings_Close();

	-- Don't reset lens if activating a modal lens. MinimapPanel will handle activating the proper lens.
	if UI.GetInterfaceMode() ~= InterfaceModeTypes.VIEW_MODAL_LENS then
		ResetTourismLens();
	end

	DeactivateReligionLens();
end

-- ===========================================================================
function ActivateReligionLens()
	if not UILens.IsLensActive("Religion") then
		UILens.SetActive("Religion");
	end
end

-- ===========================================================================
function DeactivateReligionLens()
	if UILens.IsLensActive("Religion") then
		UILens.SetActive("Default");
	end
end

-- ===========================================================================
function Toggle()	
	if(m_AnimSupport.IsVisible()) then
		Close();
	else
		Open();
	end
end

-- ===========================================================================
--	HOT-RELOADING EVENTS
-- ===========================================================================
function OnShutdown()
	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "isHidden", ContextPtr:IsHidden());
	if(g_TabSupport ~= nil and g_TabSupport.selectedControl ~= nil) then
		LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "selectedTabText", g_TabSupport.selectedControl:GetTextControl():GetText());
	end
	if(g_activeheader ~= nil) then
		LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "activeHeaderExpanded", g_activeheader[DATA_FIELD_HEADER_EXPANDED]);
	end
end
function OnGameDebugReturn(context:string, contextTable:table)
	if context == RELOAD_CACHE_ID and contextTable["isHidden"] ~= nil and not contextTable["isHidden"] then
		Open();
		-- Select previously selected tab
		local selectedTabText:string = contextTable["selectedTabText"];
		for _, tab in pairs(g_TabSupport.tabControls) do
			if tab:GetTextControl():GetText() == selectedTabText then
				g_TabSupport.SelectTab(tab);
			end
		end

		if(g_activeheader ~= nil) then
			g_activeheader[DATA_FIELD_HEADER_EXPANDED] = contextTable["activeHeaderExpanded"];
			if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
				OnExpandHeader(0, 0, g_activeheader.ExpandHeaderButton);
			else
				OnContractHeader(0, 0, g_activeheader.ContractHeaderButton);
			end
		end
	end
end

-- ===========================================================================
--	Hot-seat functionality
-- ===========================================================================
function OnLocalPlayerTurnEnd()
	if(GameConfiguration.IsHotseat()) then
		Close();
	end
end

-- ===========================================================================
--	Game Events
-- ===========================================================================
function OnCapitalCityChanged()
	if(m_AnimSupport.IsVisible()) then
		m_AnimSupport.Hide();
	end
end

-- ===========================================================================
--	Game Engine Event
-- ===========================================================================
function OnInterfaceModeChanged(eOldMode:number, eNewMode:number)
	if m_AnimSupport.IsVisible() and eNewMode == InterfaceModeTypes.VIEW_MODAL_LENS then
		Close();
	end
end

-- ===========================================================================
--	LUA Event
--	Explicit close (from partial screen hooks), part of closing everything,
-- ===========================================================================
function OnCloseAllExcept( contextToStayOpen:string )
	if contextToStayOpen == ContextPtr:GetID() then return; end
	Close();
end

-- ===========================================================================
--	LUA Event
--	Open to the Culture page.
-- ===========================================================================
function OpenCulture()
    Open();
	if g_TabSupport ~= nil then
		-- deselect previous selected tab
		g_TabSupport.SelectTab(nil);
		DeselectPreviousTab();
		DeselectExtraTabs();

		-- select Culture
		g_TabSupport.SelectTab(g_CultureInst);
	end
end

-- ===========================================================================
-- FOR OVERRIDE
-- ===========================================================================
-- Overridden in scenarios where we don't want to show world rankings for custom victories (AlexanderScenario)
function ShouldCheckCustomVictories()
	return true;
end

-- ===========================================================================
-- FOR OVERRIDE
-- ===========================================================================
-- Overridden in scenarios where we don't want an Overall tab (NubiaScenario)
function ShouldShowOverall()
	return true;
end

-- ===========================================================================
-- FOR OVERRIDE
-- ===========================================================================
-- Overridden in scenarios where we want to show Score tab despite not having score victory capabilities (NubiaScenario)
function ForceShowScore()
	return false;
end

-- ===========================================================================
--	INIT (Generic)
-- ===========================================================================
function OnInit(isReload:boolean)
	LateInitialize();
	if isReload then
		LuaEvents.GameDebug_GetValues(RELOAD_CACHE_ID);
	end
end

function GetDefaultStackSize()
    return 225;
end

function LateInitialize()

    SIZE_STACK_DEFAULT = GetDefaultStackSize();

	-- Animation Controller
	m_AnimSupport = CreateScreenAnimation(Controls.SlideAnim, Close);

	-- Hot-Reload Events
	
	ContextPtr:SetShutdown(OnShutdown);
	LuaEvents.GameDebug_Return.Add(OnGameDebugReturn);

	-- UI Callbacks
	ContextPtr:SetInputHandler(m_AnimSupport.OnInputHandler, true);

	Controls.CloseButton:SetOffsetY(50);		-- Move close button down to account for TabHeader
	Controls.CloseButton:RegisterCallback(Mouse.eLClick, Close);
	Controls.CloseButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ExpandExtraTabs:RegisterCallback(Mouse.eLClick, ToggleExtraTabs);
	Controls.ScoreDetailsCheck:RegisterCallback(Mouse.eLClick, ToggleScoreDetails);
	Controls.ScoreDetailsButton:RegisterCallback(Mouse.eLClick, ToggleScoreDetails);
	Controls.ScoreDetailsButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.Title:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_TITLE"));
	Controls.TabHeader:ChangeParent(Controls.Background);		-- To make it render beneath the banner image

	-- Game Events
	Events.CapitalCityChanged.Add(OnCapitalCityChanged);
	Events.InterfaceModeChanged.Add( OnInterfaceModeChanged );
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd);
	Events.SystemUpdateUI.Add(m_AnimSupport.OnUpdateUI);	

	-- Lua Events
	LuaEvents.PartialScreenHooks_ToggleWorldRankings.Add(Toggle);
	LuaEvents.PartialScreenHooks_OpenWorldRankings.Add(Open);
	LuaEvents.PartialScreenHooks_OpenWorldRankingsCulture.Add(OpenCulture);
	LuaEvents.PartialScreenHooks_CloseWorldRankings.Add(Close);
	LuaEvents.PartialScreenHooks_CloseAllExcept.Add(OnCloseAllExcept);

	UpdatePlayerData();
	PopulateTabs();
end

-- Prevent recursive inclusions!
if not isGatheringStormActive then
	if isBWRActive then 
		include("WorldRanking_BWR_HSE")
	end
end

ContextPtr:SetInitHandler(OnInit);
