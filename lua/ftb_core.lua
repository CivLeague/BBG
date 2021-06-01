===========================================================================
Constants
===========================================================================
local iReligion_ScientificDecay = 0;
local iReligion_DecayTech = GameInfo.Technologies["TECH_SCIENTIFIC_THEORY"].Index

local iReligion_ByzantiumRange = 90; -- In tiles covered, 90 tiles covered = 5 tiles radius 
local iReligion_ByzantiumMultiplier = 5; -- multipler X unit base combat strength

local iTrait_GilgameshPillageRange = 6; -- In Radius 6 anything less than 6 excluding 6
local iTrait_GilgameshXPRange = 6; -- In Radius 6 anything less than 6 excluding 6

local iDomination_level = 0.60;

local NO_TEAM :number = -1;
local NO_PLAYER :number = -1;
local NO_PLOT :number = -1;
local NO_UNIT :number = -1;
local NO_DISTRICT :number = -1;
local NO_IMPROVEMENT :number = -1;
local NO_BUILDING :number = -1;

===========================================================================
Function
===========================================================================

function OnGameTurnStarted( turn:number )
	print ("BBG TURN STARTING: " .. turn);
	Check_DominationVictory()
end

function OnCombatOccurred(attackerPlayerID :number, attackerUnitID :number, defenderPlayerID :number, defenderUnitID :number, attackerDistrictID :number, defenderDistrictID :number)
	if(attackerPlayerID == NO_PLAYER 
		or defenderPlayerID == NO_PLAYER) then
		return;
	end

	local pAttackerPlayer = Players[attackerPlayerID];
	local pAttackerReligion = pAttackerPlayer:GetReligion()
	local pAttackerLeader = PlayerConfigurations[attackerPlayerID]:GetLeaderTypeName()
	local pDefenderPlayer = Players[defenderPlayerID];
	local pAttackingUnit :object = attackerUnitID ~= NO_UNIT and pAttackerPlayer:GetUnits():FindID(attackerUnitID) or nil;
	local pDefendingUnit :object = defenderUnitID ~= NO_UNIT and pDefenderPlayer:GetUnits():FindID(defenderUnitID) or nil;
	local pAttackingDistrict :object = attackerDistrictID ~= NO_DISTRICT and pAttackerPlayer:GetDistricts():FindID(attackerDistrictID) or nil;
	local pDefendingDistrict :object = defenderDistrictID ~= NO_DISTRICT and pDefenderPlayer:GetDistricts():FindID(defenderDistrictID) or nil;

	-- Gilga XP Sharing, Gilga is not attacker or defender
	local pDiplomacyAttacker:table = pAttackerPlayer:GetDiplomacy();
	local pDiplomacyDefender:table = pDefenderPlayer:GetDiplomacy();

	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		local pCheckedPlayer = Players[iPlayerID]
		if iPlayerID ~= attackerUnitID and iPlayerID ~= defenderPlayerID then
			if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
				-- Attacker is allied with Gilgamesh
				if pDiplomacyAttacker:HasAllied(iPlayerID) == true and pAttackingUnit ~= nil then
					local plot = Map.GetPlot(pAttackingUnit:GetX(), pAttackingUnit:GetY())
					if plot ~= nil then
					local iPlotIndex = plot:GetIndex()
					-- Is Gilga also at war with Defender ?
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(defenderPlayerID) == true) then

					-- does Gilgamesh has one his unit nearby ?
					local playerGilgaUnits;
					playerGilgaUnits = pCheckedPlayer:GetUnits();
					for k, unit in playerGilgaUnits:Members() do
						local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
						local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
						local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
						print("OnCombat - distance_check ",distance_check, UnitManager.GetTypeName(unit))
						if distance_check ~= nil and distance_check > -1 then
							if distance_check < iTrait_GilgameshXPRange then
								ApplyGilgameshTrait_XP(iPlayerID,unit,unitGilgaPlot,false)
							end
						end
					end
					end
					end
				end

				-- Defender is allied with Gilgamesh
				if pDiplomacyDefender:HasAllied(iPlayerID) == true and pDefendingUnit ~= nil then
					local plot = Map.GetPlot(pDefendingUnit:GetX(), pDefendingUnit:GetY())
					if plot ~= nil then
					local iPlotIndex = plot:GetIndex()
					-- Is Gilga also at war with Defender ?
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(attackerPlayerID) == true) then

					-- does Gilgamesh has one his unit nearby ?
					local playerGilgaUnits;
					playerGilgaUnits = pCheckedPlayer:GetUnits();
					for k, unit in playerGilgaUnits:Members() do
						local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
						local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
						local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
						print("OnCombat - distance_check ",distance_check, UnitManager.GetTypeName(unit))
						if distance_check ~= nil and distance_check > -1 then
							if distance_check < iTrait_GilgameshXPRange then
								ApplyGilgameshTrait_XP(iPlayerID,unit,unitGilgaPlot,false)
							end
						end
					end
					end
					end
				end
			end
		end
	end

	-- Gilga XP Sharing, Gilga is attacker or defender
	if PlayerConfigurations[attackerPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
		for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
			local pCheckedPlayer = Players[iPlayerID]
			if iPlayerID ~= attackerPlayerID and iPlayerID ~= defenderPlayerID then
				if pDiplomacyAttacker:HasAllied(iPlayerID) == true and pAttackingUnit ~= nil then
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(defenderPlayerID) == true) then
						local plot = Map.GetPlot(pAttackingUnit:GetX(), pAttackingUnit:GetY())
						if plot ~= nil then
						local iPlotIndex = plot:GetIndex()
					-- has the ally some unit nearby
						local playerGilgaUnits;
						playerGilgaUnits = pCheckedPlayer:GetUnits();
						for k, unit in playerGilgaUnits:Members() do
							local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
							local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
							local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
							print("OnCombat - distance_check ",distance_check, UnitManager.GetTypeName(unit))
							if distance_check ~= nil and distance_check > -1 then
								if distance_check < iTrait_GilgameshXPRange then
									ApplyGilgameshTrait_XP(iPlayerID,unit,unitGilgaPlot,true)
								end
							end
						end
						end
					end
				end
			end
		end
	end

	if PlayerConfigurations[defenderPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
		for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
			local pCheckedPlayer = Players[iPlayerID]
			if iPlayerID ~= attackerPlayerID and iPlayerID ~= defenderPlayerID then
				if pDiplomacyDefender:HasAllied(iPlayerID) == true and pDefendingUnit ~= nil then
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(attackerPlayerID) == true) then
						local plot = Map.GetPlot(pDefendingUnit:GetX(), pDefendingUnit:GetY())
						if plot ~= nil then
						local iPlotIndex = plot:GetIndex()
					-- has the ally some unit nearby
						local playerGilgaUnits;
						playerGilgaUnits = pCheckedPlayer:GetUnits();
						for k, unit in playerGilgaUnits:Members() do
							local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
							local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
							local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
							print("OnCombat - distance_check ",distance_check, UnitManager.GetTypeName(unit))
							if distance_check ~= nil and distance_check > -1 then
								if distance_check < iTrait_GilgameshXPRange then
									ApplyGilgameshTrait_XP(iPlayerID,unit,unitGilgaPlot,true)
								end
							end
						end
						end
					end
				end
			end
		end
	end

end

function OnPillage(iUnitPlayerID :number, iUnitID :number, eImprovement :number, eBuilding :number, eDistrict :number, iPlotIndex :number)
	print("OnPillage",iUnitPlayerID)
	if(iUnitPlayerID == NO_PLAYER) then
		return;
	end

	local pUnitPlayer :object = Players[iUnitPlayerID];
	if(pUnitPlayer == nil) then
		return;
	end

	local pUnit :object = UnitManager.GetUnit(iUnitPlayerID, iUnitID);
	if (pUnit == nil) then
		return;
	end
	
	local pUnitPlayerConfig = PlayerConfigurations[iUnitPlayerID]
	if (pUnitPlayerConfig == nil) then
		return;
	end
			
	-- Check if an allied Gilga Unit is next to the plunderer
	local pDiplomacy:table = pUnitPlayer:GetDiplomacy();
	if (pDiplomacy == nil) then
		return;
	end
	
	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		local pCheckedPlayer = Players[iPlayerID]
		if pCheckedPlayer ~= nil and iPlayerID ~= iUnitPlayerID then
			if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
				-- plundered is allied with Gilgamesh
				if pDiplomacy:HasAllied(iPlayerID) == true then
					-- Is Gilga also at war ?
					local pPlot = Map.GetPlotByIndex(iPlotIndex)
					local iVictim = pPlot:GetOwner()
					local pDiploGilga = pCheckedPlayer:GetDiplomacy()
					if (pDiploGilga:IsAtWarWith(iVictim) == true) then
					
					-- does Gilgamesh has one his unit nearby ?
					local playerGilgaUnits;
					playerGilgaUnits = pCheckedPlayer:GetUnits();	
					for k, unit in playerGilgaUnits:Members() do
						local unitGilgaPlot = Map.GetPlot(unit:GetX(), unit:GetY())
						local iGilgaPlotIndex = unitGilgaPlot:GetIndex()
						local distance_check =  Map.GetPlotDistance(iPlotIndex, iGilgaPlotIndex);
						print("OnPillage - distance_check ",distance_check, UnitManager.GetTypeName(unit))
						if distance_check ~= nil and distance_check > -1 then
							if distance_check < iTrait_GilgameshPillageRange then
								ApplyGilgameshTrait_Pillage(iPlayerID,iUnitID,unitGilgaPlot,eImprovement,eBuilding,eDistrict)
								break
							end
						end
					end	
					end
				end
			end
		end
	end		
end

===========================================================================
Sumer
===========================================================================

function ApplyGilgameshTrait()
	local iStartEra = GameInfo.Eras[ GameConfiguration.GetStartEra() ];
	local iStartIndex = 0
	if iStartEra ~= nil then
		iStartIndex = iStartEra.ChronologyIndex;
		else
		return
	end
	if iStartIndex ~= 1 then
		return
	end
	
	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		local pPlayer = Players[iPlayerID]
		if pPlayer ~= nil then
			if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_GILGAMESH" then
				local playerUnits;
				playerUnits = Players[iPlayerID]:GetUnits();
				for k, unit in playerUnits:Members() do
					local unitTypeName = UnitManager.GetTypeName(unit)
					if "LOC_UNIT_WARRIOR_NAME" == unitTypeName then
						local unitX = unit:GetX()
						local unitY = unit:GetY()
						playerUnits:Destroy(unit)
						local iWarCart = GameInfo.Units["UNIT_SUMERIAN_WAR_CART"].Index
						playerUnits:Create(iWarCart, unitX, unitY)
					end
				end
			end
		end
	end	
end

function ApplyGilgameshTrait_Pillage(iPlayer,refunit,pPlot,eImprovement,eBuilding,eDistrict)
	local pillageAwards;
	local pillageAmount;
	local pPlayer = Players[iPlayer]
	
	if (pPlayer == nil) then
		return
	end
	
	if eImprovement ~= nil and eImprovement > -1 then
		pillageAwards = GameInfo.Improvements[eImprovement].PlunderType
		pillageAmount = GameInfo.Improvements[eImprovement].PlunderAmount
	end
	if eBuilding ~= nil and eBuilding > -1 then
		pillageAwards = GameInfo.Buildings[eBuilding].PlunderType
		pillageAmount = GameInfo.Buildings[eBuilding].PlunderAmount
	end
	if eDistrict ~= nil and eDistrict > -1 then
		pillageAwards = GameInfo.Districts[eDistrict].PlunderType
		pillageAmount = GameInfo.Districts[eDistrict].PlunderAmount
	end
	
	local playerEra = pPlayer:GetEras();
	
	if playerEra == nil then 
		return; 
	end
	local eraNum = 0
	for era in GameInfo.Eras() do
		if(playerEra:GetEra() == era.Index) then
			eraNum = era.ChronologyIndex
		end
	end
	eraNum = eraNum - 1
	local eraBonus = math.floor(pillageAmount / 3) * tonumber(eraNum)	
	local playerTechs = pPlayer:GetTechs();		
	if playerTechs == nil then 
		return; 
	end
	local techNum = 0
	for tech in GameInfo.Technologies() do
		if(playerTechs:HasTech(tech.Index)) then
			techNum = techNum + 1
		end
	end
	
	local playerCulture = pPlayer:GetCulture();
	if playerCulture == nil then 
		return; 
	end
	local civicNum = 0
	for civic in GameInfo.Civics() do
		if(playerCulture:HasCivic(civic.Index)) then
			civicNum = civicNum + 1
		end
	end
	local researchBonus = math.max(techNum,civicNum,0)
	researchBonus = researchBonus * (math.floor(pillageAmount/10))
	
	local iSpeedCostMultiplier = GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier
	if iSpeedCostMultiplier ~= nil and iSpeedCostMultiplier > -1 then
		pillageAmount = math.floor( (pillageAmount + researchBonus + eraBonus) * iSpeedCostMultiplier /100)
		else
		return
	end

	local message:string  = "+"..tostring(pillageAmount)
	if pillageAwards == "PLUNDER_CULTURE" then
		pPlayer:GetCulture():ChangeCurrentCulturalProgress(pillageAmount)
		message = message.."[ICON_Culture]"
		elseif pillageAwards == "PLUNDER_SCIENCE" then
		pPlayer:GetTechs():ChangeCurrentResearchProgress(pillageAmount)
		message = message.."[ICON_Science]"
		elseif pillageAwards == "PLUNDER_FAITH" then
		pPlayer:GetReligion():ChangeFaithBalance(pillageAmount)		
		message = message.."[ICON_Faith]"
		elseif pillageAwards == "PLUNDER_GOLD" then
		pPlayer:GetTreasury():ChangeGoldBalance(pillageAmount)		
		message = message.."[ICON_Gold]"
		elseif pillageAwards == "PLUNDER_HEAL" then
		pPlayer:GetReligion():ChangeFaithBalance(pillageAmount)	
		message = message.."[ICON_Faith]"
	end

	
	local messageData : table = {
		MessageType = 0;
		MessageText = message;
		PlotX = pPlot:GetX();
		PlotY = pPlot:GetY();
		Visibility = RevealedState.VISIBLE;
	}
	Game.AddWorldViewText(messageData);
end

function ApplyGilgameshTrait_XP(iPlayer,pUnit,pPlot,isGilgaUnit)
	local XPAmount = 2
	local pPlayer = Players[iPlayer]
	
	if (pPlayer == nil) or (pUnit == nil) then
		return
	end
		
	local unitXP = pUnit:GetExperience()
	unitXP:ChangeExperience(XPAmount)

		
	local message:string  = "+"..tostring(XPAmount)
	message = message.."XP"
	
	if isGilgaUnit == false then
		return
	end
	
	local messageData : table = {
		MessageType = 0;
		MessageText = message;
		PlotX = pPlot:GetX();
		PlotY = pPlot:GetY();
		Visibility = RevealedState.VISIBLE;
	}
	--Game.AddWorldViewText(messageData);
end

===========================================================================
Domination
===========================================================================

function Check_DominationVictory()
	local teamIDs = GetAliveMajorTeamIDs();
	local hasWon = false
	local victoryTeam = -99
	local iDomination_level = 1
	print("TRADITIONAL_DOMINATION_LEVEL",GameConfiguration.GetValue("VICTORY_TRADITIONAL_DOMINATION"))
	if GameConfiguration.GetValue("VICTORY_TRADITIONAL_DOMINATION") == false or GameConfiguration.GetValue("VICTORY_TRADITIONAL_DOMINATION") == nil then
		return
    else
		if GameConfiguration.GetValue("TRADITIONAL_DOMINATION_LEVEL") ~= nil then
			iDomination_level = GameConfiguration.GetValue("TRADITIONAL_DOMINATION_LEVEL") / 100
		end
	end

	for _, teamID in ipairs(teamIDs) do
		if(teamID ~= nil) then
			--local progress = Game.GetVictoryProgressForTeam(victoryType, teamID);
			local progress = true
			if(progress ~= nil) then

				-- PlayerData
				local playerCount:number = 0;
				local teamGenericScore = 0;

				for i, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
					if Players[playerID]:GetTeam() == teamID then
						local pPlayer:table = Players[playerID];
						local genericScore = 0
						local land = 0
						for iPlotIndex = 0, Map.GetPlotCount()-1, 1 do
							local pPlot = Map.GetPlotByIndex(iPlotIndex)
							if (pPlot:IsWater() == false) then
								land = land + 1;
								if (pPlot:GetOwner() == playerID) then
									genericScore = genericScore + 1;
								end
							end
						end
						if land ~= 0 then
							genericScore = genericScore / land
							else
							genericScore = 0
						end
						teamGenericScore = teamGenericScore + genericScore
						if teamGenericScore > iDomination_level then
							hasWon = true
							victoryTeam = teamID
						end
						playerCount = playerCount + 1;
					end
				end
			end
		end
	end
	
	if hasWon == false or victoryTeam == -99 then
		return
	end

	for i, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if Players[playerID]:GetTeam() == victoryTeam then
			local pPlayer:table = Players[playerID];
			local pCapCity = pPlayer:GetCities():GetCapitalCity()
			if pCapCity ~= nil then
				-- Add Victory Flag
				print("Add Victory Flag",playerID)
				local flag = GameInfo.Buildings["BUILDING_TRADITIONAL_DOMINATION_VICTORY_FLAG"]
				if pCapCity:GetBuildings():HasBuilding(flag.Index) == false then
					pCapCity:GetBuildQueue():CreateBuilding(flag.Index)
				end
			end
		end
	end	

end

===========================================================================
Tools
===========================================================================

function GetAliveMajorTeamIDs()
	print("GetAliveMajorTeamIDs()")
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

function GetShuffledCopyOfTable(incoming_table)
	-- Designed to operate on tables with no gaps. Does not affect original table.
	local len = table.maxn(incoming_table);
	local copy = {};
	local shuffledVersion = {};
	-- Make copy of table.
	for loop = 1, len do
		copy[loop] = incoming_table[loop];
	end
	-- One at a time, choose a random index from Copy to insert in to final table, then remove it from the copy.
	local left_to_do = table.maxn(copy);
	for loop = 1, len do
		local random_index = 1 + TerrainBuilder.GetRandomNumber(left_to_do, "Shuffling table entry - Lua");
		table.insert(shuffledVersion, copy[random_index]);
		table.remove(copy, random_index);
		left_to_do = left_to_do - 1;
	end
	return shuffledVersion
end

function GetAdjacentTiles(plot, index)
	-- This is an extended version of Firaxis, moving like a clockwise snail on the hexagon grids
	local gridWidth, gridHeight = Map.GetGridSize();
	local count = 0;
	local k = 0;
	local adjacentPlot = nil;
	local adjacentPlot2 = nil;
	local adjacentPlot3 = nil;
	local adjacentPlot4 = nil;
	local adjacentPlot5 = nil;


	-- Return Spawn if index < 0
	if(plot ~= nil and index ~= nil) then
		if (index < 0) then
			return plot;
		end

		else

		__Debug("GetAdjacentTiles: Invalid Arguments");
		return nil;
	end

	

	-- Return Starting City Circle if index between #0 to #5 (like Firaxis' GetAdjacentPlot) 
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			if (adjacentPlot ~= nil and index == i) then
				return adjacentPlot
			end
		end
	end

	-- Return Inner City Circle if index between #6 to #17

	count = 5;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot2 = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
		end

		for j = i, i+1 do
			--__Debug(i, j)
			k = j;
			count = count + 1;

			if (k == 6) then
				k = 0;
			end

			if (adjacentPlot2 ~= nil) then
				if(adjacentPlot2:GetX() >= 0 and adjacentPlot2:GetY() < gridHeight) then
					adjacentPlot = Map.GetAdjacentPlot(adjacentPlot2:GetX(), adjacentPlot2:GetY(), k);

					else

					adjacentPlot = nil;
				end
			end
		

			if (adjacentPlot ~=nil) then
				if(index == count) then
					return adjacentPlot
				end
			end

		end
	end

	-- #18 to #35 Outer city circle
	count = 0;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 1;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 2;
			if(index == count) then
				return adjacentPlot2;
			end
		end

	end

	--  #35 #59 These tiles are outside the workable radius of the city
	local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			terrainType = adjacentPlot2:GetTerrainType();
			if (adjacentPlot2 ~=nil) then
				count = 36 + i * 4;
				if(index == count) then
					return adjacentPlot2;
				end
			end

		end

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 1;
					if(index == count) then
						return adjacentPlot2;
					end
				end
			end


		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 2;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
					else
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
				end
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 3;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

	end

	--  > #60 to #90

local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i); --first ring
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i); --2nd ring
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i); --3rd ring
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i); --4th ring
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5;
			if(index == count) then
				return adjacentPlot2; --5th ring
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot5 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
				end
				else
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i +1);
				end
			end
		end


		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 1;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1);
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 2;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 3;
			if(index == count) then
				return adjacentPlot2;
			end

		end
		
		adjacentPlot2 = nil

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0); --5th ring
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1); --5th ring
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 4;
			if(index == count) then
				return adjacentPlot2;
			end

		end

	end

end


===========================================================================
Tools
===========================================================================

function GetAliveMajorTeamIDs()
	print("GetAliveMajorTeamIDs()")
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

function GetShuffledCopyOfTable(incoming_table)
	-- Designed to operate on tables with no gaps. Does not affect original table.
	local len = table.maxn(incoming_table);
	local copy = {};
	local shuffledVersion = {};
	-- Make copy of table.
	for loop = 1, len do
		copy[loop] = incoming_table[loop];
	end
	-- One at a time, choose a random index from Copy to insert in to final table, then remove it from the copy.
	local left_to_do = table.maxn(copy);
	for loop = 1, len do
		local random_index = 1 + TerrainBuilder.GetRandomNumber(left_to_do, "Shuffling table entry - Lua");
		table.insert(shuffledVersion, copy[random_index]);
		table.remove(copy, random_index);
		left_to_do = left_to_do - 1;
	end
	return shuffledVersion
end

function GetAdjacentTiles(plot, index)
	-- This is an extended version of Firaxis, moving like a clockwise snail on the hexagon grids
	local gridWidth, gridHeight = Map.GetGridSize();
	local count = 0;
	local k = 0;
	local adjacentPlot = nil;
	local adjacentPlot2 = nil;
	local adjacentPlot3 = nil;
	local adjacentPlot4 = nil;
	local adjacentPlot5 = nil;


	-- Return Spawn if index < 0
	if(plot ~= nil and index ~= nil) then
		if (index < 0) then
			return plot;
		end

		else

		__Debug("GetAdjacentTiles: Invalid Arguments");
		return nil;
	end



	-- Return Starting City Circle if index between #0 to #5 (like Firaxis' GetAdjacentPlot)
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			if (adjacentPlot ~= nil and index == i) then
				return adjacentPlot
			end
		end
	end

	-- Return Inner City Circle if index between #6 to #17

	count = 5;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot2 = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
		end

		for j = i, i+1 do
			--__Debug(i, j)
			k = j;
			count = count + 1;

			if (k == 6) then
				k = 0;
			end

			if (adjacentPlot2 ~= nil) then
				if(adjacentPlot2:GetX() >= 0 and adjacentPlot2:GetY() < gridHeight) then
					adjacentPlot = Map.GetAdjacentPlot(adjacentPlot2:GetX(), adjacentPlot2:GetY(), k);

					else

					adjacentPlot = nil;
				end
			end


			if (adjacentPlot ~=nil) then
				if(index == count) then
					return adjacentPlot
				end
			end

		end
	end

	-- #18 to #35 Outer city circle
	count = 0;
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 1;
			if(index == count) then
				return adjacentPlot2
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 18 + i * 3 + 2;
			if(index == count) then
				return adjacentPlot2;
			end
		end

	end

	--  #35 #59 These tiles are outside the workable radius of the city
	local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i);
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			terrainType = adjacentPlot2:GetTerrainType();
			if (adjacentPlot2 ~=nil) then
				count = 36 + i * 4;
				if(index == count) then
					return adjacentPlot2;
				end
			end

		end

		if (adjacentPlot3 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
				end
				else
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i +1);
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 1;
					if(index == count) then
						return adjacentPlot2;
					end
				end
			end


		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i);
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 2;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

		adjacentPlot4 = nil;

		if (adjacentPlot ~= nil) then
			if (i+1 == 6) then
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0);
					end
				end
				else
				if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1);
				end
				if (adjacentPlot3 ~= nil) then
					if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1);
					end
				end
			end
		end

		if (adjacentPlot4 ~= nil) then
			if (adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
					else
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
				end
				if (adjacentPlot2 ~= nil) then
					count = 36 + i * 4 + 3;
					if(index == count) then
						return adjacentPlot2;
					end

				end
			end

		end

	end

	--  > #60 to #90

local count = 0
	for i = 0, 5 do
		if(plot:GetX() >= 0 and plot:GetY() < gridHeight) then
			adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), i); --first ring
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
			else
			adjacentPlot = nil;
			adjacentPlot2 = nil;
			adjacentPlot3 = nil;
			adjacentPlot4 = nil;
			adjacentPlot5 = nil;
		end
		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i); --2nd ring
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i); --3rd ring
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i); --4th ring
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5;
			if(index == count) then
				return adjacentPlot2; --5th ring
			end
		end

		adjacentPlot2 = nil;

		if (adjacentPlot5 ~= nil) then
			if (i + 1) == 6 then
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
				end
				else
				if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
					adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i +1);
				end
			end
		end


		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 1;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		adjacentPlot2 = nil;

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i);
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i);
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0);
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1);
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0);
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1);
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 2;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i); --5th ring
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 3;
			if(index == count) then
				return adjacentPlot2;
			end

		end

		adjacentPlot2 = nil

		if (adjacentPlot ~=nil) then
			if(adjacentPlot:GetX() >= 0 and adjacentPlot:GetY() < gridHeight) then
				if (i+1 == 6) then
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), 0); -- 2 ring
					else
					adjacentPlot3 = Map.GetAdjacentPlot(adjacentPlot:GetX(), adjacentPlot:GetY(), i+1); -- 2 ring
				end
			end
			if (adjacentPlot3 ~= nil) then
				if(adjacentPlot3:GetX() >= 0 and adjacentPlot3:GetY() < gridHeight) then
					if (i+1 == 6) then
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), 0); -- 3ring
						else
						adjacentPlot4 = Map.GetAdjacentPlot(adjacentPlot3:GetX(), adjacentPlot3:GetY(), i+1); -- 3ring

					end
					if (adjacentPlot4 ~= nil) then
						if(adjacentPlot4:GetX() >= 0 and adjacentPlot4:GetY() < gridHeight) then
							if (i+1 == 6) then
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), 0); --4th ring
								else
								adjacentPlot5 = Map.GetAdjacentPlot(adjacentPlot4:GetX(), adjacentPlot4:GetY(), i+1); --4th ring
							end
							if (adjacentPlot5 ~= nil) then
								if(adjacentPlot5:GetX() >= 0 and adjacentPlot5:GetY() < gridHeight) then
									if (i+1 == 6) then
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), 0); --5th ring
										else
										adjacentPlot2 = Map.GetAdjacentPlot(adjacentPlot5:GetX(), adjacentPlot5:GetY(), i+1); --5th ring
									end
								end
							end
						end
					end
				end
			end
		end

		if (adjacentPlot2 ~= nil) then
			count = 60 + i * 5 + 4;
			if(index == count) then
				return adjacentPlot2;
			end

		end

	end

end





===========================================================================
Initialize
===========================================================================

function Initialize()

	print("BBG - Gameplay Script Launched")
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
	
	
	-- turn 0 effects:
	if currentTurn == startTurn then
		ApplyGilgameshTrait()
	end
	
	-- turn checked effects:
	GameEvents.OnGameTurnStarted.Add(OnGameTurnStarted);

	-- combat effect:
	GameEvents.OnCombatOccurred.Add(OnCombatOccurred);
	
	-- pillage effect:
	GameEvents.OnPillage.Add(OnPillage)
	
	-- tech boost effect:
end

Initialize();