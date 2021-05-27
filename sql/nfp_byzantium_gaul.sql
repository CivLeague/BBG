--==================
-- Byzantium
--==================
-- reduce combat bonus for holy cities
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='BYZANTIUM_COMBAT_HOLY_CITIES' AND Name='Amount';
-- tagma nerf from 4
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TAGMA_COMBAT_STRENGTH' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TAGMA_RELIGIOUS_COMBAT' AND Name='Amount';

--==================
-- Gaul
--==================
-- set start bias to 3
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_GAUL';
-- set citizen yields to same as other IZ
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' AND DistrictType='DISTRICT_OPPIDUM';
-- remove culture from unit production
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_GRANT_CULTURE_UNIT_TRAINED';
-- reduce king's combat bonus for adj units
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='AMBIORIX_NEIGHBOR_COMBAT' and Name='Amount';
-- remove ranged units from having kings combat bonus
DELETE FROM TypeTags WHERE Type='ABILITY_AMBIORIX_NEIGHBOR_COMBAT_BONUS' AND Tag='CLASS_RANGED';
-- Remove Apprenticeship free tech
DELETE FROM DistrictModifiers WHERE DistrictType='DISTRICT_OPPIDUM' AND ModifierId='OPPIDUM_GRANT_TECH_APPRENTICESHIP';
-- Delay culture to bronze working
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    VALUES ('BBG_GAUL_HAS_BRONZE_WORKING_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    VALUES ('BBG_GAUL_HAS_BRONZE_WORKING_REQUIREMENTS', 'BBG_GAUL_HAS_BRONZE_WORKING_REQUIREMENT');
INSERT INTO Requirements(RequirementId , RequirementType)
    VALUES ('BBG_GAUL_HAS_BRONZE_WORKING_REQUIREMENT', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    VALUES ('BBG_GAUL_HAS_BRONZE_WORKING_REQUIREMENT', 'TechnologyType', 'TECH_BRONZE_WORKING');
UPDATE Modifiers SET OwnerRequirementSetId='BBG_GAUL_HAS_BRONZE_WORKING_REQUIREMENTS' WHERE ModifierId='GAUL_MINE_CULTURE';