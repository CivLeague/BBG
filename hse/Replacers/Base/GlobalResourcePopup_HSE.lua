include("GlobalResourcePopup")
include("HSE_utils")

-- ===========================================================================
function ShouldPlayerBeAdded( pPlayer:table )
	if pPlayer == nil			then return false; end
	if pPlayer:IsBarbarian()	then return false; end
	if pPlayer.IsFreeCities and pPlayer:IsFreeCities()	then return false; end		-- Not avail in base game.
	if IsAliveMajorCiv(pPlayer)== false then return false; end
	if not HasAccessLevel(pPlayer:GetID(), "economy") then return false; end
	return true;
end
