-- Copyright 2017-2019, Firaxis Games.

-- Base File
include("DiplomacyRibbon");
include("HSE_utils")

if isCUIActive then
	include("cui_leader_icon_support"); -- CUI
	include("cui_shared_HSE")
end


-- ===========================================================================
-- Cached Base Functions
-- ===========================================================================
local BASE_AddLeader = AddLeader;

-- ===========================================================================
function AddLeader(iconName : string, playerID : number, kProps: table)
	local oLeaderIcon	:object = BASE_AddLeader(iconName, playerID, kProps);
	local localPlayerID	:number = Game.GetLocalPlayer();
	
	if localPlayerID == PlayerTypes.NONE or localPlayerID == PlayerTypes.OBSERVER then
		return oLeaderIcon;
	end
	
	if isCUIActive then
		-- BLI has its own golden age icons, that are used only if EDR is not active.
		if not isBLIActive or isEDRActive then
			SetEraIcon(oLeaderIcon, playerID)
		end
 	
		-- EDR and BLI both overwrite alliance data.
		if not isEDRActive and not isBLIActive then
			local allianceData = CuiGetAllianceData(playerID);
			LuaEvents.CuiLeaderIconToolTip(oLeaderIcon.Portrait, playerID);
			LuaEvents.CuiRelationshipToolTip(oLeaderIcon.Relationship, playerID, allianceData);
		end
		-- << CUI
	elseif not isBLIActive then
		-- BLI replaces tooltips at leader level and does not use this menu.
		if GameCapabilities.HasCapability("CAPABILITY_DISPLAY_HUD_RIBBON_RELATIONSHIPS") then
			-- Update relationship pip tool with details about our alliance if we're in one
			local localPlayerDiplomacy:table = Players[localPlayerID]:GetDiplomacy();
			if localPlayerDiplomacy then
				local allianceType = localPlayerDiplomacy:GetAllianceType(playerID);
				if allianceType ~= -1 then
					local allianceName = Locale.Lookup(GameInfo.Alliances[allianceType].Name);
					local allianceLevel = localPlayerDiplomacy:GetAllianceLevel(playerID);
					oLeaderIcon.Controls.Relationship:SetToolTipString(Locale.Lookup("LOC_DIPLOMACY_ALLIANCE_FLAG_TT", allianceName, allianceLevel));
				end
			end
		end
    end
	
	return oLeaderIcon;
end

if not isGatheringStormActive then
	if isBLIActive then
		include("DiplomacyRibbon_BLI_HSE")
	end
	
	if isEDRActive then
		include("ExtendedDiplomacyRibbon_HSE")
	elseif isCQUIActive and not isCUIActive and not isBLIActive then
		include("DiplomacyRibbon_CQUI_HSE.lua")
	end
end