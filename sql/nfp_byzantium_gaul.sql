--==================
-- Byzantium
--==================
-- reduce combat bonus for holy cities
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='BYZANTIUM_COMBAT_HOLY_CITIES' AND Name='Amount';
-- remove dromon combat bonus
DELETE FROM UnitAbilityModifiers WHERE ModifierId='DROMON_COMBAT_STRENGTH_AGAINST_UNITS';


--==================
-- Gaul
--==================
-- remove culture from unit production
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_GRANT_CULTURE_UNIT_TRAINED';
-- reduce king's combat bonus for adj units
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='AMBIORIX_NEIGHBOR_COMBAT' and Name='Amount';
-- remove ranged units from having kings combat bonus
DELETE FROM TypeTags WHERE Type='ABILITY_AMBIORIX_NEIGHBOR_COMBAT_BONUS' AND Tag='CLASS_RANGED';