--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Australia
--==================
-- +1 food on coastal cities
INSERT INTO RequirementSets VALUES ('PLOT_IS_COASTAL_CITY_CENTER_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements VALUES
    ('PLOT_IS_COASTAL_CITY_CENTER_BBG', 'PLOT_IS_COASTAL_LAND'),
    ('PLOT_IS_COASTAL_CITY_CENTER_BBG', 'BBG_REQUIRES_PLOT_IS_CITY_CENTER');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('TRAIT_COASTAL_FOOD_BBG', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_IS_COASTAL_CITY_CENTER_BBG');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TRAIT_COASTAL_FOOD_BBG', 'YieldType', 'YIELD_FOOD'),
    ('TRAIT_COASTAL_FOOD_BBG', 'Amount', '1');
INSERT INTO TraitModifiers VALUES
    ('TRAIT_CIVILIZATION_LAND_DOWN_UNDER', 'TRAIT_COASTAL_FOOD_BBG');
-- outback moved to fuedalism
UPDATE Improvements SET PrereqCivic='CIVIC_FEUDALISM' WHERE ImprovementType='IMPROVEMENT_OUTBACK_STATION';
-- Digger gets additional movement
UPDATE Units SET BaseMoves=3 WHERE UnitType='UNIT_DIGGER';
-- war production bonus reduced to 0% from 100%, liberation bonus reduced to +50% (from +100%) and 10 turns instead of 20
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_DEFENSIVE_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION' and Name='TurnsActive';

--==============================================================
--******				START BIASES					  ******
--==============================================================
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_CATTLE';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_HORSES';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_SHEEP';
