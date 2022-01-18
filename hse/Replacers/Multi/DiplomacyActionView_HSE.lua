print("HSE: loading DiplomacyActionView (HSE compatibility mode)")

include("HSE_utils")

if isCUIActive then
	include("cui_shared_HSE")
end

if isEDRActive then
	include("ExtendedDiplomacyRibbon_Core_HSE")
end

if isCUIActive and not isBLIActive then
	include("cui_leader_icon_support"); -- CUI
	include("cui_leader_icon_tt"); -- CUI
end

if isExpandedAlliancesActive then
	include("DiplomacyActionView_ALLY_HSE")
end

if isSimplifiedGossipActive then
	include("DiplomacyActionView_SG_HSE")
end

if isQuickDealsActive then
	include("DiplomacyActionView_QD_HSE")
end

-- ===========================================================================
function PopulateLeader(leaderIcon : table, player : table, isUniqueLeader : boolean)
	if (player ~= nil and player:IsMajor()) then
		local playerID = player:GetID();
		local playerConfig = PlayerConfigurations[playerID];
		if (playerConfig ~= nil) then
			local leaderTypeName = playerConfig:GetLeaderTypeName();
			if (leaderTypeName ~= nil) then

				local iconName = "ICON_" .. leaderTypeName;
				leaderIcon:UpdateIcon(iconName, playerID, isUniqueLeader);

				-- Configure button
				leaderIcon.Controls.SelectButton:SetVoid1(playerID);
				leaderIcon:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
				leaderIcon:RegisterCallback(Mouse.eLClick, OnPlayerSelected);

				-- The selection background
				leaderIcon.Controls.SelectedBackground:SetHide(playerID ~= ms_SelectedPlayerID);
				
				if (isBLIActive or isCUIActive) and isEDRActive then
					-- Propagate tooltip only if using CUI or BLI (that already do it)
					UpdateLeaderIcon(leaderIcon, nil, playerID, nil, true)
				end
				
				if isCUIActive  then
					if not isBLIActive or isEDRActive then
						-- CUI only, BLI has its own era icon
						SetEraIcon(leaderIcon, playerID)
					end
					
					if not isBLIActive and not isEDRActive then
						-- CUI >> use advanced tooltip
						local allianceData = CuiGetAllianceData(playerID);
						LuaEvents.CuiLeaderIconToolTip(leaderIcon.Controls.Portrait, playerID);
						LuaEvents.CuiRelationshipToolTip(leaderIcon.Controls.Relationship, playerID, allianceData);
						-- << CUI
					end
				end
			end
		end
	end
end