--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Australia
--==================
/*
INSERT INTO Types (Type, Kind) VALUES
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'KIND_IMPROVEMENT');
CREATE TEMPORARY TABLE tmp AS SELECT * FROM Improvements WHERE ImprovementType='IMPROVEMENT_MINE';
UPDATE tmp SET ImprovementType='IMPROVEMENT_DOWN_UNDER_MINE_BBG', Appeal=0;
INSERT INTO Improvements SELECT * from tmp;
DROP TABLE tmp;
INSERT INTO Improvement_ValidBuildUnits VALUES ('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'UNIT_BUILDER', 1, 0);
INSERT INTO Improvement_ValidResources (ImprovementType, ResourceType, MustRemoveFeature)
	SELECT 'IMPROVEMENT_DOWN_UNDER_MINE_BBG', ResourceType, MustRemoveFeature
	FROM Improvement_ValidResources
	WHERE ImprovementType='IMPROVEMENT_MINE';
INSERT INTO Improvement_ValidTerrains (ImprovementType, TerrainType) VALUES
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'TERRAIN_GRASS_HILLS'),
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'TERRAIN_PLAINS_HILLS'),
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'TERRAIN_DESERT_HILLS'),
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'TERRAIN_TUNDRA_HILLS'),
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'TERRAIN_SNOW_HILLS');
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'YIELD_PRODUCTION', 1),
	('IMPROVEMENT_MINE', 'YIELD_CULTURE', 0);
INSERT INTO Improvement_BonusYieldChanges (Id, ImprovementType, YieldType, BonusYieldChange, PrereqTech) VALUES
	(924, 'IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'YIELD_PRODUCTION', 1, 'TECH_APPRENTICESHIP'),
	(925, 'IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'YIELD_PRODUCTION', 1, 'TECH_INDUSTRIALIZATION');
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement) VALUES
	('DownUnderMine_Production'     , 'LOC_DISTRICT_MINE_PRODUCTION', 'YIELD_PRODUCTION', 1, 1, 'IMPROVEMENT_DOWN_UNDER_MINE_BBG'),
	('DownUnderMine_HalfProduction' , 'LOC_DISTRICT_MINE_PRODUCTION', 'YIELD_PRODUCTION', 1, 2, 'IMPROVEMENT_DOWN_UNDER_MINE_BBG');
INSERT INTO District_Adjacencies VALUES ('DISTRICT_INDUSTRIAL_ZONE', 'DownUnderMine_HalfProduction');
-- boost
CREATE TEMPORARY TABLE tmp AS SELECT * FROM Boosts WHERE TechnologyType='TECH_APPRENTICESHIP';
UPDATE tmp SET BoostID=976, ImprovementType='IMPROVEMENT_DOWN_UNDER_MINE_BBG';
INSERT INTO Boosts SELECT * FROM tmp;
DROP TABLE tmp;
-- create modifier and requirements
UPDATE Improvements SET TraitType='TRAIT_CIVILIZATION_NO_PLAYER' WHERE ImprovementType='IMPROVEMENT_MINE';
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('PLAYER_IS_JOHN_CURTIN_BBG'		, 'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_IS_NOT_JOHN_CURTIN_BBG'	, 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('PLAYER_IS_JOHN_CURTIN_BBG'		, 'REQUIREMENT_PLAYER_IS_JOHN_CURTIN_BBG'),
	('PLAYER_IS_NOT_JOHN_CURTIN_BBG'	, 'REQUIREMENT_PLAYER_IS_NOT_JOHN_CURTIN_BBG');
INSERT INTO Requirements(RequirementId , RequirementType, Inverse) VALUES
	('REQUIREMENT_PLAYER_IS_JOHN_CURTIN_BBG'		, 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES', 0),
	('REQUIREMENT_PLAYER_IS_NOT_JOHN_CURTIN_BBG'	, 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES', 1);
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('REQUIREMENT_PLAYER_IS_JOHN_CURTIN_BBG' 		, 'LeaderType', 'LEADER_JOHN_CURTIN'),
	('REQUIREMENT_PLAYER_IS_NOT_JOHN_CURTIN_BBG' 	, 'LeaderType', 'LEADER_JOHN_CURTIN');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('ATTACH_ENABLE_DOWN_UNDER_MINES_BBG'	, 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'PLAYER_IS_JOHN_CURTIN_BBG'),
	('ATTACH_ENABLE_MINES_BBG'	            , 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'PLAYER_IS_NOT_JOHN_CURTIN_BBG'),
	('ENABLE_DOWN_UNDER_MINES_BBG'			, 'MODIFIER_CITY_ADJUST_ALLOWED_IMPROVEMENT', NULL),
	('ENABLE_MINES_BBG'			            , 'MODIFIER_CITY_ADJUST_ALLOWED_IMPROVEMENT', NULL);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('ATTACH_ENABLE_DOWN_UNDER_MINES_BBG'	, 'ModifierId'		, 'ENABLE_DOWN_UNDER_MINES_BBG'),
	('ATTACH_ENABLE_MINES_BBG'	            , 'ModifierId'		, 'ENABLE_MINES_BBG'),
	('ENABLE_DOWN_UNDER_MINES_BBG'			, 'ImprovementType'	, 'IMPROVEMENT_DOWN_UNDER_MINE_BBG'),
	('ENABLE_MINES_BBG'			            , 'ImprovementType'	, 'IMPROVEMENT_MINE');
INSERT INTO TechnologyModifiers VALUES ('TECH_MINING', 'ATTACH_ENABLE_DOWN_UNDER_MINES_BBG');
INSERT INTO TechnologyModifiers VALUES ('TECH_MINING', 'ATTACH_ENABLE_MINES_BBG');
*/
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
