
function ModifiedCommand_Condemn(eOwner : number, iUnitID : number)

	local pPlayer = Players[eOwner];
	if (pPlayer == nil) then
		return;
	end

	local pUnit = pPlayer:GetUnits():FindID(iUnitID);
	if (pUnit == nil) then
		return;
	end
	
	local unitsInPlot = Units.GetUnitsInPlotLayerID(pUnit:GetX(), pUnit:GetY(), 3); --religiousLayerID = 3
	if unitsInPlot ~= nil then
		for _,targetUnit in ipairs(unitsInPlot) do
			local religiousStrength = targetUnit:GetReligion():GetReligiousStrength();
			if religiousStrength > 0 then 
				
				--VERSION REDUCE HEALTH:
				local maxDamage = targetUnit:GetMaxDamage();
				local currentDamage = targetUnit:GetDamage();
				if maxDamage - currentDamage > 50 then
					targetUnit:ChangeDamage(50);
				else
					UnitManager.Kill(targetUnit);
				end
				
				--VERSION REMOVE CHARGE:
				--local chargesRemaining = targetUnit:GetReligion():GetSpreadCharges();
				--if chargesRemaining > 1 then
					--targetUnit:GetReligion():ChangeSpreadCharges(-1);
				--else
					--UnitManager.Kill(targetUnit);
				--end
				
			end
		end
	end
	
	UnitManager.ReportActivation(pUnit, "CONDEMN_MOD");
	UnitManager.FinishMoves(pUnit);
end

function Initialize()
	GameEvents.ModifiedCommand_Condemn.Add(ModifiedCommand_Condemn);
	print ("Initialized!");
end

Initialize();