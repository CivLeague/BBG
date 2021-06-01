-- Stolen from the mod Civilizations Expanded: Zulu by p0kiehl. Altered by masseelch.
--=============================================================================================================
-- CIVILIZATION UNIQUE ABILITY: ISIBONGO (ENHANCEMENT)
--=============================================================================================================
-- Cities with a garrisoned Corps / Army gain +1 / +2 Amenities.
--=============================================================================================================
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
values ('CITY_HAS_GARRISON_CORPS_REQUIREMENT', 'REQUIREMENTSET_TEST_ALL'),
       ('CITY_HAS_GARRISON_ARMY_REQUIREMENT', 'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
values ('CITY_HAS_GARRISON_CORPS_REQUIREMENT', 'REQUIRES_CITY_HAS_GARRISON_CORPS'),
       ('CITY_HAS_GARRISON_ARMY_REQUIREMENT', 'REQUIRES_CITY_HAS_GARRISON_ARMY');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
values ('TRAIT_GARRISON_CORPS_AMENITY', 'MODIFIER_PLAYER_CITIES_ADJUST_POLICY_AMENITY', 'CITY_HAS_GARRISON_CORPS_REQUIREMENT'),
       ('TRAIT_GARRISON_ARMY_AMENITY', 'MODIFIER_PLAYER_CITIES_ADJUST_POLICY_AMENITY', 'CITY_HAS_GARRISON_ARMY_REQUIREMENT');

insert or ignore into ModifierArguments (ModifierId, Name, Value)
values ('TRAIT_GARRISON_CORPS_AMENITY', 'Amount', 1),
       ('TRAIT_GARRISON_ARMY_AMENITY', 'Amount', 2);

insert or ignore into TraitModifiers (TraitType, ModifierId)
values ('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'TRAIT_GARRISON_CORPS_AMENITY'),
       ('TRAIT_CIVILIZATION_ZULU_ISIBONGO', 'TRAIT_GARRISON_ARMY_AMENITY');
