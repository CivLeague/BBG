-- chancery science from captured spies increased
UPDATE ModifierArguments SET Value='200' WHERE ModifierId='CHANCERY_COUNTERYSPY_SCIENCE' AND Name='Amount';

--==================
-- Ethiopia
--==================
-- reduce yields
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='TRAIT_FAITH_INTO_SCIENCE_HILLS' AND Name='Amount';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='TRAIT_FAITH_INTO_CULTURE_HILLS' AND Name='Amount';
-- rock hewn church nerf
UPDATE Improvement_YieldChanges SET YieldChange=0 WHERE ImprovementType='IMPROVEMENT_ROCK_HEWN_CHURCH' AND YieldType='YIELD_FAITH';
DELETE FROM Improvement_Adjacencies WHERE ImprovementType='IMPROVEMENT_ROCK_HEWN_CHURCH' AND YieldChangeId='Mountain_Faith1';
DELETE FROM Improvement_Adjacencies WHERE ImprovementType='IMPROVEMENT_ROCK_HEWN_CHURCH' AND YieldChangeId='Mountain_Faith2';
DELETE FROM Improvement_Adjacencies WHERE ImprovementType='IMPROVEMENT_ROCK_HEWN_CHURCH' AND YieldChangeId='Mountain_Faith3';
DELETE FROM Improvement_Adjacencies WHERE ImprovementType='IMPROVEMENT_ROCK_HEWN_CHURCH' AND YieldChangeId='Mountain_Faith4';
DELETE FROM Improvement_Adjacencies WHERE ImprovementType='IMPROVEMENT_ROCK_HEWN_CHURCH' AND YieldChangeId='Mountain_Faith5';
-- fix resources faith, and add requirement to be only on improved resources
INSERT INTO Requirements (RequirementId, RequirementType)
    VALUES ('REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_BBG', 'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('IMPROVED_RESOURCE_REQUIREMENTS_BBG' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('IMPROVED_RESOURCE_REQUIREMENTS_BBG' , 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('IMPROVED_RESOURCE_REQUIREMENTS_BBG' , 'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_BBG');
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_ADJUST_PLOT_YIELD', SubjectRequirementSetId='IMPROVED_RESOURCE_REQUIREMENTS_BBG' WHERE ModifierId='TRAIT_FAITH_RESOURCES';
-- +4 on hills only for Oromo
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_MENELIK' AND ModifierId='TRAIT_HILLS_COMBAT';
INSERT INTO RequirementSets VALUES
    ('OROMO_HILLS_BUFF_REQUIREMENTS_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements VALUES
    ('OROMO_HILLS_BUFF_REQUIREMENTS_BBG', 'PLOT_IS_HILLS_REQUIREMENT');
INSERT INTO Modifiers ( ModifierId, ModifierType, SubjectRequirementSetId ) VALUES
    ('OROMO_HILLS_COMBAT_BBG', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'OROMO_HILLS_BUFF_REQUIREMENTS_BBG');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('OROMO_HILLS_COMBAT_BBG', 'Amount', '4');
INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES
    ('OROMO_HILLS_COMBAT_BBG', 'Preview', 'LOC_ABILITY_MENELIK_HILLS_COMBAT_STRENGTH_DESCRIPTION');
INSERT INTO UnitAbilityModifiers VALUES
    ('ABILITY_ETHIOPIAN_OROMO_CAVALRY', 'OROMO_HILLS_COMBAT_BBG');