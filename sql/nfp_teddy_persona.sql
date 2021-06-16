--==================
-- America
--==================
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_ANTIQUES_AND_PARKS_CULTURE_FORESTS_OR_WONDERS' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_ANTIQUES_AND_PARKS_SCIENCE_NATIONAL_WONDERS_OR_MOUNTAINS' AND Name='Amount';

INSERT INTO TraitModifiers VALUES ('TRAIT_LEADER_ANTIQUES_AND_PARKS', 'TRAIT_ANTIQUES_AND_PARKS_CULTURE_FORESTS_OR_WONDERS_BBG');
INSERT INTO TraitModifiers VALUES ('TRAIT_LEADER_ANTIQUES_AND_PARKS', 'TRAIT_ANTIQUES_AND_PARKS_SCIENCE_NATIONAL_WONDERS_OR_MOUNTAINS_BBG');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('TRAIT_ANTIQUES_AND_PARKS_CULTURE_FORESTS_OR_WONDERS_BBG', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'REQUIREMENTS_PLOT_ADJACENT_FORESTS_OR_WONDERS_BREATHTAKING_BBG'),
    ('TRAIT_ANTIQUES_AND_PARKS_SCIENCE_NATIONAL_WONDERS_OR_MOUNTAINS_BBG', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'REQUIREMENTS_PLOT_ADJACENT_NATURAL_WONDERS_OR_MOUNTAINS_BREATHTAKING_BBG');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TRAIT_ANTIQUES_AND_PARKS_CULTURE_FORESTS_OR_WONDERS_BBG', 'YieldType' , 'YIELD_CULTURE'),
    ('TRAIT_ANTIQUES_AND_PARKS_CULTURE_FORESTS_OR_WONDERS_BBG', 'Amount' , '1'),
    ('TRAIT_ANTIQUES_AND_PARKS_SCIENCE_NATIONAL_WONDERS_OR_MOUNTAINS_BBG', 'YieldType' , 'YIELD_SCIENCE'),
    ('TRAIT_ANTIQUES_AND_PARKS_SCIENCE_NATIONAL_WONDERS_OR_MOUNTAINS_BBG', 'Amount' , '1');
INSERT INTO RequirementSets VALUES
    ('REQUIREMENTS_PLOT_ADJACENT_FORESTS_OR_WONDERS_BREATHTAKING_BBG', 'REQUIREMENTSET_TEST_ALL'),
    ('REQUIREMENTS_PLOT_ADJACENT_NATURAL_WONDERS_OR_MOUNTAINS_BREATHTAKING_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements VALUES
    ('REQUIREMENTS_PLOT_ADJACENT_FORESTS_OR_WONDERS_BREATHTAKING_BBG', 'PLOT_ADJACENT_FORESTS_OR_WONDERS_REQUIREMENTS_MET'),
    ('REQUIREMENTS_PLOT_ADJACENT_FORESTS_OR_WONDERS_BREATHTAKING_BBG', 'REQUIRES_PLOT_BREATHTAKING_APPEAL_ROOSEVELT'),
    ('REQUIREMENTS_PLOT_ADJACENT_FORESTS_OR_WONDERS_BREATHTAKING_BBG', 'REQUIRES_PLAYER_HAS_THE_ENLIGHTENMENT_BBG'),
    ('REQUIREMENTS_PLOT_ADJACENT_NATURAL_WONDERS_OR_MOUNTAINS_BREATHTAKING_BBG', 'PLOT_ADJACENT_NATURAL_WONDERS_OR_MOUNTAINS_MET'),
    ('REQUIREMENTS_PLOT_ADJACENT_NATURAL_WONDERS_OR_MOUNTAINS_BREATHTAKING_BBG', 'REQUIRES_PLOT_BREATHTAKING_APPEAL_ROOSEVELT'),
    ('REQUIREMENTS_PLOT_ADJACENT_NATURAL_WONDERS_OR_MOUNTAINS_BREATHTAKING_BBG', 'REQUIRES_PLAYER_HAS_ASTRONOMY_BBG');
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQUIRES_PLAYER_HAS_THE_ENLIGHTENMENT_BBG', 'REQUIREMENT_PLAYER_HAS_CIVIC'),
    ('REQUIRES_PLAYER_HAS_ASTRONOMY_BBG', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQUIRES_PLAYER_HAS_THE_ENLIGHTENMENT_BBG', 'CivicType', 'CIVIC_THE_ENLIGHTENMENT'),
    ('REQUIRES_PLAYER_HAS_ASTRONOMY_BBG', 'TechnologyType', 'TECH_ASTRONOMY');