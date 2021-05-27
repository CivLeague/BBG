--==================
-- Colombia
--==================
-- only light cav get promote before attack
UPDATE Modifiers SET SubjectRequirementSetId='EJERCITO_PATRIOTA_PROMOTE_SRS_BBG' WHERE ModifierId='TRAIT_PROMOTE_NO_FINISH_MOVES';
INSERT INTO RequirementSetRequirements VALUES
    ('EJERCITO_PATRIOTA_PROMOTE_SRS_BBG', 'UNIT_IS_LIGHT_CAVALRY');
INSERT INTO RequirementSets VALUES
    ('EJERCITO_PATRIOTA_PROMOTE_SRS_BBG', 'REQUIREMENTSET_TEST_ALL');
-- sight instead of movement
--DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_EJERCITO_PATRIOTA_EXTRA_MOVEMENT';
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_UNIT_ADJUST_SIGHT' WHERE ModifierId='EJERCITO_PATRIOTA_EXTRA_MOVEMENT';
-- cannot produce great generals
INSERT INTO ExcludedGreatPersonClasses (GreatPersonClassType, TraitType) VALUES
    ( 'GREAT_PERSON_CLASS_GENERAL', 'TRAIT_LEADER_CAMPANA_ADMIRABLE' );
-- hacienda comes sooner, but can only be built on flat tiles
UPDATE Improvements SET PrereqCivic='CIVIC_MEDIEVAL_FAIRES' WHERE ImprovementType='IMPROVEMENT_HACIENDA';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_HACIENDA' AND TerrainType='TERRAIN_PLAINS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_HACIENDA' AND TerrainType='TERRAIN_GRASS_HILLS';
-- add movement back to commandantes
INSERT INTO GreatPersonIndividualBirthModifiers VALUES
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_JOSE_DE_SUCRE', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_PAULA_SANTANDER', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_ANTONIO_PAEZ', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_URDANETA', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MARINO', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MACGREGOR', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_PIAR', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_NARINO', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MONTILLA', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG'),
    ('GREAT_PERSON_INDIVIDUAL_COMMANDANTE_RIBAS', 'GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY', 'AOE_LAND_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('GREATPERSON_COMANDANTE_MOVEMENT_AOE_LAND_BBG', 'AbilityType', 'ABILITY_GREAT_GENERAL_MOVEMENT');


--==================
-- Maya
--==================
-- farm production does not require observatory
DELETE FROM Adjacency_YieldChanges WHERE ID='Farm_FoodObservatoryAdjacency';
UPDATE ModifierArguments SET Value='YIELD_PRODUCTION' WHERE ModifierId='TRAIT_MAYA_FARMS_PRODUCTION' AND Name='YieldType' AND Value='YIELD_GOLD';
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES ('TRAIT_MAYA_FARMS_GOLD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD_GRANCOLOMBIA_MAYA', 'PLOT_HAS_FARMS_GRANCOLOMBIA_MAYA_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    VALUES
    ('TRAIT_MAYA_FARMS_GOLD', 'YieldType', 'YIELD_GOLD'),
    ('TRAIT_MAYA_FARMS_GOLD', 'Amount', '1');
INSERT INTO TraitModifiers VALUES ('TRAIT_CIVILIZATION_MAYAB', 'TRAIT_MAYA_FARMS_GOLD');
-- delete free builders
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_MUTAL' AND ModifierId='TRAIT_LEADER_NEARBY_CITIES_GAIN_BUILDER';
-- reduce combat bonus to 3 from 5
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='MUTAL_NEAR_CAPITAL_COMBAT' AND Name='Amount';
-- set citizen yields to same as other campuses
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' AND DistrictType="DISTRICT_OBSERVATORY";
-- start biases: after coastals and tundra and desert; delete non-plantation lux biases; add banana bias; make flat land bias last priority
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_CITRUS';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_COFFEE';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_COCOA';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_COTTON';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_DYES';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_SILK';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_SPICES';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_SUGAR';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_TEA';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_TOBACCO';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_WINE';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_INCENSE';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_OLIVES';
UPDATE StartBiasResources SET Tier=4 WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_BANANAS';
UPDATE StartBiasTerrains  SET Tier=5 WHERE CivilizationType='CIVILIZATION_MAYA' AND TerrainType='TERRAIN_GRASS';
UPDATE StartBiasTerrains  SET Tier=5 WHERE CivilizationType='CIVILIZATION_MAYA' AND TerrainType='TERRAIN_PLAINS';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_MAYA' AND TIER=1;
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_MAYA' AND TIER=3;
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_GYPSUM';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_JADE';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_MARBLE';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_MERCURY';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_SALT';
DELETE FROM StartBiasResources WHERE CivilizationType='CIVILIZATION_MAYA' AND ResourceType='RESOURCE_IVORY';



--==================
-- City-States
--==================


--==================
-- Other
--==================
INSERT INTO TypeTags (Type, Tag) VALUES
	('RESOURCE_MAIZE'  , 'CLASS_FERTILITY_RITES_FOOD');


--==================
-- Wonders
--==================
UPDATE Feature_AdjacentYields SET YieldChange=1 WHERE FeatureType='FEATURE_PAITITI' AND YieldType='YIELD_GOLD';
UPDATE Feature_AdjacentYields SET YieldChange=1 WHERE FeatureType='FEATURE_PAITITI' AND YieldType='YIELD_CULTURE';
DELETE FROM Feature_AdjacentYields WHERE FeatureType='FEATURE_BERMUDA_TRIANGLE';