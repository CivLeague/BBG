--==================
-- Ethiopia
--==================
-- fix resources faith
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_ADJUST_PLOT_YIELD', SubjectRequirementSetId='STAVE_CHURCH_RESOURCE_REQUIREMENTS' WHERE ModifierId='TRAIT_FAITH_RESOURCES';
-- +4 on hills only for Oromo
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_MENELIK' AND ModifierId='TRAIT_HILLS_COMBAT';
INSERT OR IGNORE INTO RequirementSets VALUES
    ('OROMO_HILLS_BUFF_REQUIREMENTS_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements VALUES
    ('OROMO_HILLS_BUFF_REQUIREMENTS_BBG', 'PLOT_IS_HILLS_REQUIREMENT');
INSERT OR IGNORE INTO Modifiers ( ModifierId, ModifierType, SubjectRequirementSetId ) VALUES
    ('OROMO_HILLS_COMBAT_BBG', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'OROMO_HILLS_BUFF_REQUIREMENTS_BBG');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('OROMO_HILLS_COMBAT_BBG', 'Amount', '4');
INSERT OR IGNORE INTO ModifierStrings (ModifierId, Context, Text) VALUES
    ('OROMO_HILLS_COMBAT_BBG', 'Preview', 'LOC_ABILITY_MENELIK_HILLS_COMBAT_STRENGTH_DESCRIPTION');
INSERT OR IGNORE INTO UnitAbilityModifiers VALUES
    ('ABILITY_ETHIOPIAN_OROMO_CAVALRY', 'OROMO_HILLS_COMBAT_BBG');


--==================
-- Sweden
--==================
-- +50% prod to uiniversity replacement in secret societies
INSERT OR IGNORE INTO TraitModifiers (TraitType , ModifierId)
        VALUES
        ('TRAIT_CIVILIZATION_NOBEL_PRIZE' , 'NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' );
 INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
        VALUES
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION' , null);
 INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
        VALUES
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'BuildingType' , 'BUILDING_ALCHEMICAL_SOCIETY'),
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'Amount'       , '50');