--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Australia
--==================
-- outback moved to fuedalism
UPDATE Improvements SET PrereqCivic='CIVIC_FEUDALISM' WHERE ImprovementType='IMPROVEMENT_OUTBACK_STATION';
-- Digger gets additional combat strength
UPDATE Units SET BaseMoves=3 WHERE UnitType='UNIT_DIGGER';
-- war production bonus reduced to 0% from 100%, liberation bonus reduced to +50% (from +100%) and 10 turns instead of 20
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_DEFENSIVE_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION' and Name='TurnsActive';
-- custom mine that doesn't take away appeal
INSERT INTO Types (Type, Kind) VALUES
	('TRAIT_CIV_FAUX_MINE_TRAIT_BBG', 'KIND_TRAIT'),
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'KIND_IMPROVEMENT');
INSERT INTO Traits (TraitType) VALUES ('TRAIT_CIV_FAUX_MINE_TRAIT_BBG');
CREATE TEMPORARY TABLE tmp AS SELECT * FROM Improvements WHERE ImprovementType='IMPROVEMENT_MINE';
UPDATE tmp SET ImprovementType='IMPROVEMENT_DOWN_UNDER_MINE_BBG', Appeal=0, TraitType='TRAIT_CIV_FAUX_MINE_TRAIT_BBG';
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
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'YIELD_PRODUCTION', 1);
INSERT INTO Improvement_BonusYieldChanges (Id, ImprovementType, YieldType, BonusYieldChange, PrereqTech) VALUES
	(924, 'IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'YIELD_PRODUCTION', 1, 'TECH_APPRENTICESHIP'),
	(925, 'IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'YIELD_PRODUCTION', 1, 'TECH_INDUSTRIALIZATION');
-- boost
CREATE TEMPORARY TABLE tmp AS SELECT * FROM Boosts WHERE TechnologyType='TECH_APPRENTICESHIP';
UPDATE tmp SET BoostID=976, ImprovementType='IMPROVEMENT_DOWN_UNDER_MINE_BBG';
INSERT INTO Boosts SELECT * FROM tmp;
DROP TABLE tmp;
-- requirements and modifiers
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('PLAYER_IS_JOHN_CURTIN_AND_HAS_MINING_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('PLAYER_IS_JOHN_CURTIN_AND_HAS_MINING_BBG', 'REQUIREMENT_PLAYER_HAS_MINING_BBG'),
	('PLAYER_IS_JOHN_CURTIN_AND_HAS_MINING_BBG', 'REQUIREMENT_PLAYER_IS_JOHN_CURTIN_BBG');
INSERT INTO Requirements(RequirementId , RequirementType) VALUES
	('REQUIREMENT_PLAYER_HAS_MINING_BBG', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
	('REQUIREMENT_PLAYER_IS_JOHN_CURTIN_BBG', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('REQUIREMENT_PLAYER_HAS_MINING_BBG', 'TechnologyType', 'TECH_MINING'),
	('REQUIREMENT_PLAYER_IS_JOHN_CURTIN_BBG' , 'LeaderType', 'LEADER_JOHN_CURTIN');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('CAN_BUILD_IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'MODIFIER_PLAYER_ADJUST_VALID_IMPROVEMENT', 'PLAYER_IS_JOHN_CURTIN_AND_HAS_MINING_BBG');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('CAN_BUILD_IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'ImprovementType', 'IMPROVEMENT_DOWN_UNDER_MINE_BBG');
INSERT INTO TraitModifiers VALUES ('TRAIT_LEADER_MAJOR_CIV', 'CAN_BUILD_IMPROVEMENT_DOWN_UNDER_MINE_BBG');
-- add regular mines to everyone else only
UPDATE Improvements SET TraitType='TRAIT_CIV_FAUX_MINE_TRAIT_BBG' WHERE ImprovementType='IMPROVEMENT_MINE';
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('PLAYER_IS_NOT_JOHN_CURTIN_AND_HAS_MINING_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('PLAYER_IS_NOT_JOHN_CURTIN_AND_HAS_MINING_BBG', 'REQUIREMENT_PLAYER_HAS_MINING_BBG'),
	('PLAYER_IS_NOT_JOHN_CURTIN_AND_HAS_MINING_BBG', 'REQUIREMENT_PLAYER_IS_NOT_JOHN_CURTIN_BBG');
INSERT INTO Requirements(RequirementId , RequirementType, Inverse) VALUES
	('REQUIREMENT_PLAYER_IS_NOT_JOHN_CURTIN_BBG', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES', 1);
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('REQUIREMENT_PLAYER_IS_NOT_JOHN_CURTIN_BBG' , 'LeaderType', 'LEADER_JOHN_CURTIN');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('CAN_BUILD_IMPROVEMENT_MINE_BBG', 'MODIFIER_PLAYER_ADJUST_VALID_IMPROVEMENT', 'PLAYER_IS_NOT_JOHN_CURTIN_AND_HAS_MINING_BBG');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('CAN_BUILD_IMPROVEMENT_MINE_BBG', 'ImprovementType', 'IMPROVEMENT_MINE');
INSERT INTO TraitModifiers VALUES ('TRAIT_LEADER_MAJOR_CIV', 'CAN_BUILD_IMPROVEMENT_MINE_BBG');

--==============================================================
--******				START BIASES					  ******
--==============================================================
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_CATTLE';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_HORSES';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_AUSTRALIA' AND ResourceType='RESOURCE_SHEEP';


