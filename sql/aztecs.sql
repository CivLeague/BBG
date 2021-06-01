-- Tlachtli +3 Culture instead +2
update Building_YieldChanges set YieldChange = 3 where BuildingType = 'BUILDING_TLACHTLI' and YieldType = 'YIELD_CULTURE';

-- Aztecs have +50% production towards melee units
insert or ignore into Modifiers (ModifierId, ModifierType) values ('TRAIT_AZTECS_FIVE_SUNS_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
insert or ignore into ModifierArguments (ModifierId, Name, Value) values ('TRAIT_AZTECS_FIVE_SUNS_MELEE_PRODUCTION', 'UnitPromotionClass', 'PROMOTION_CLASS_MELEE'),
                                                                         ('TRAIT_AZTECS_FIVE_SUNS_MELEE_PRODUCTION', 'EraType', 'NO_ERA'),
                                                                         ('TRAIT_AZTECS_FIVE_SUNS_MELEE_PRODUCTION', 'Amount', '50');
insert or ignore into TraitModifiers values ('TRAIT_CIVILIZATION_LEGEND_FIVE_SUNS', 'TRAIT_AZTECS_FIVE_SUNS_MELEE_PRODUCTION');

-- Eagle warrior no longer replaces warrior but swordsman (with all its values)
update Units set Combat = 35, Cost = 90, Maintenance = 2, PrereqTech = 'TECH_IRON_WORKING', MandatoryObsoleteTech = 'TECH_REPLACEABLE_PARTS' where UnitType = 'UNIT_AZTEC_EAGLE_WARRIOR';
update UnitReplaces set ReplacesUnitType = 'UNIT_SWORDSMAN' where CivUniqueUnitType = 'UNIT_AZTEC_EAGLE_WARRIOR';
update UnitUpgrades set UpgradeUnit = 'UNIT_MAN_AT_ARMS' where Unit = 'UNIT_AZTEC_EAGLE_WARRIOR';

-- Eagle warrior can see through forest / jungle and has no movement penalty (ability of kongos nagao unit).
insert or ignore into Modifiers (ModifierId, ModifierType) values ('EAGLE_WARRIOR_FOREST_MOVEMENT', 'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST'),
                                                                  ('EAGLE_WARRIOR_FOREST_SIGHT', 'MODIFIER_PLAYER_UNIT_ADJUST_SEE_THROUGH_FEATURES');
insert or ignore into ModifierArguments (ModifierId, Name, Value) values ('EAGLE_WARRIOR_FOREST_MOVEMENT', 'Ignore', '1'),
                                                                         ('EAGLE_WARRIOR_FOREST_MOVEMENT', 'Type', 'FOREST'),
                                                                         ('EAGLE_WARRIOR_FOREST_SIGHT', 'CanSee', '1');
insert or ignore into UnitAbilities (UnitAbilityType, Name, Description, Permanent) values ('ABILITY_EAGLE_WARRIOR', 'LOC_ABILITY_EAGLE_WARRIOR_NAME', 'LOC_ABILITY_EAGLE_WARRIOR_DESCRIPTION', 1);
insert or ignore into UnitAbilityModifiers (UnitAbilityType, ModifierId) values ('ABILITY_EAGLE_WARRIOR', 'EAGLE_WARRIOR_FOREST_MOVEMENT'), ('ABILITY_EAGLE_WARRIOR', 'EAGLE_WARRIOR_FOREST_SIGHT');
insert or ignore into Types (Type, Kind) values ('ABILITY_EAGLE_WARRIOR', 'KIND_ABILITY');
insert or ignore into TypeTags (Type, Tag) values ('ABILITY_EAGLE_WARRIOR', 'CLASS_EAGLE_WARRIOR'), ('UNIT_AZTEC_EAGLE_WARRIOR', 'CLASS_EAGLE_WARRIOR');
insert or ignore into Tags (Tag, Vocabulary) values ('CLASS_EAGLE_WARRIOR', 'ABILITY_CLASS');