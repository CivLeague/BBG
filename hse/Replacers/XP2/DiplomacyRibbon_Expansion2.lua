-- Copyright 2018-2019, Firaxis Games.

include("DiplomacyRibbon_Expansion1.lua");
include("CongressButton");
include("HSE_utils")

-- ===========================================================================
-- OVERRIDES
-- ===========================================================================
BASE_LateInitialize = LateInitialize;

BASE_UpdateLeaders = UpdateLeaders;
BASE_RealizeSize = RealizeSize;
BASE_FinishAddingLeader = FinishAddingLeader;
BASE_UpdateStatValues = UpdateStatValues;


-- ===========================================================================
--	MEMBERS
-- ===========================================================================
local m_kCongressButtonIM	:table = nil;
local m_oCongressButton		:object = nil;
local m_congressButtonWidth	:number = 0;


-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================

-- ===========================================================================
function UpdateLeaders()
	-- Create and add World Congress button if one was allocated (based on capabilities)
	if m_kCongressButtonIM then
		if Game.GetEras():GetCurrentEra() >= GlobalParameters.WORLD_CONGRESS_INITIAL_ERA then		
			m_kCongressButtonIM:ResetInstances();
			local pPlayer:table = PlayerConfigurations[Game.GetLocalPlayer()];
			if(pPlayer ~= nil and pPlayer:IsAlive())then
				m_oCongressButton = CongressButton:GetInstance( m_kCongressButtonIM );
				m_congressButtonWidth = m_oCongressButton.Top:GetSizeX();
			else
				m_congressButtonWidth = 0;
			end
		end
	end

	BASE_UpdateLeaders();	
end


-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
function RealizeSize( additionalElementsWidth:number )			
	BASE_RealizeSize( m_congressButtonWidth );
	--The Congress button takes up one leader slot, so the max num of leaders used to calculate scroll is reduced by one in XP2	
	g_maxNumLeaders = g_maxNumLeaders - 1;
end

-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
function FinishAddingLeader( playerID:number, uiLeader:table, kProps:table)	

	local isMasked:boolean = false;
	if kProps.isMasked then	isMasked = kProps.isMasked; end
	
	local isHideFavor	:boolean = isMasked or (not Game.IsVictoryEnabled("VICTORY_DIPLOMATIC"));		--TODO: Change to capability check when favor is added to capability system.
	uiLeader.Favor:SetHide( isHideFavor );

	BASE_FinishAddingLeader( playerID, uiLeader, kProps );
end

-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
function UpdateStatValues( playerID:number, uiLeader:table )	
	BASE_UpdateStatValues( playerID, uiLeader );
	local favor	:number = Round( Players[playerID]:GetFavor() );
	if uiLeader.Favor:IsVisible() then	
		-- "economy" as favor is a tradable resource
		if HasAccessLevel(playerID, "economy") then
			 uiLeader.Favor:SetText( " [ICON_Favor] "..tostring(favor)); 
		else
			-- Note the extra space as the favor icon is a bit smaller, so we add a space to make all values aligned.
			uiLeader.Favor:SetText( " [ICON_Favor]  "..hseUnknown);
		end
	end
end

-- ===========================================================================
function OnLeaderClicked(playerID : number )
	-- Send an event to open the leader in the diplomacy view (only if they met)
	local pWorldCongress:table = Game.GetWorldCongress();
	local localPlayerID:number = Game.GetLocalPlayer();

	if localPlayerID == -1 or localPlayerID == 1000 then
		return;
	end

	if playerID == localPlayerID or Players[localPlayerID]:GetDiplomacy():HasMet(playerID) then
		if pWorldCongress:IsInSession() then
			LuaEvents.DiplomacyActionView_OpenLite(playerID);
		else
			LuaEvents.DiplomacyRibbon_OpenDiplomacyActionView(playerID);
		end
	end
end

-- ===========================================================================

function LateInitialize()

	BASE_LateInitialize();

	if GameCapabilities.HasCapability("CAPABILITY_WORLD_CONGRESS") then
		m_kCongressButtonIM = InstanceManager:new("CongressButton", "Top", Controls.LeaderStack);
	end

	if not XP2_LateInitialize then	-- Only update leaders if this is the last in the call chain.
		UpdateLeaders();
	end
end

if isBLIActive then
	include("DiplomacyRibbon_BLI_HSE")
end

if isEDRActive then
	include("ExtendedDiplomacyRibbon_HSE")
elseif isCQUIActive and not isCUIActive and not isBLIActive then
	include("DiplomacyRibbon_CQUI_HSE.lua")
end