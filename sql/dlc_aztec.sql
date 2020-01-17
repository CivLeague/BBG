--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Aztec
--==================
-- Aztec Tlachtli Unique Building is now slightly cheaper and is +3 Culture instead of +2 Faith/+1 Culture
DELETE FROM Building_YieldChanges WHERE BuildingType='BUILDING_TLACHTLI' AND YieldType='YIELD_FAITH';
UPDATE Building_YieldChanges SET YieldChange=3 WHERE BuildingType='BUILDING_TLACHTLI';
UPDATE Buildings SET Cost=100 WHERE BuildingType='BUILDING_TLACHTLI';


