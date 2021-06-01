UPDATE StartBiasFeatures SET Tier=3 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS';

-- wonder and district on rivers bonus increased to 25%
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RIVER_FASTER_BUILDTIME_WONDER';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RIVER_FASTER_BUILDTIME_DISTRICT';
--
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIRES_PLOT_HAS_FLOODPLAINS');
-- Sphinx base Faith Increased to 2 (from 1)
UPDATE Improvement_YieldChanges SET YieldChange=2 WHERE ImprovementType='IMPROVEMENT_SPHINX' AND YieldType='YIELD_FAITH';
-- -- +1 Faith and +1 Culture if adjacent to a wonder, instead of 2 Faith.
-- UPDATE ModifierArguments SET Value='1' WHERE ModifierId='SPHINX_WONDERADJACENCY_FAITH' AND Name='Amount';
-- INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
-- 	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' , 'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS');
-- INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
-- 	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'YieldType' , 'YIELD_CULTURE');
-- INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
-- 	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'Amount' , 1);
-- INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
-- 	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_WONDERADJACENCY_CULTURE_CPLMOD');

-- Remove default +2 faith adjacency for a wonder.
delete from ImprovementModifiers where ModifierID = 'SPHINX_WONDERADJACENCY_FAITH';
delete from ModifierArguments WHERE ModifierId='SPHINX_WONDERADJACENCY_FAITH';

-- +1 Faith and +1 Culture per adjacent to wonder.
insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentWonder)
	values ('SPHINX_WONDERADJACENCY_CULTURE_FTB', 'Placeholder', 'YIELD_CULTURE', 1, 1, 1);
insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentWonder)
    values ('SPHINX_WONDERADJACENCY_FAITH_FTB', 'Placeholder', 'YIELD_FAITH', 1, 1, 1);
insert or ignore into Improvement_Adjacencies (ImprovementType, YieldChangeId)  values  ('IMPROVEMENT_SPHINX', 'SPHINX_WONDERADJACENCY_CULTURE_FTB');
insert or ignore into Improvement_Adjacencies (ImprovementType, YieldChangeId)  values  ('IMPROVEMENT_SPHINX', 'SPHINX_WONDERADJACENCY_FAITH_FTB');

-- Additional +1 culture when reaching 'Diplomatic Service'-civic
INSERT OR IGNORE INTO Improvement_BonusYieldChanges (ImprovementType, YieldType, BonusYieldChange, PrereqCivic)
    VALUES ('IMPROVEMENT_SPHINX' , 'YIELD_CULTURE' , 1, 'CIVIC_DIPLOMATIC_SERVICE');

-- Now grants 1 food and 1 production on desert tiles without floodplains. Go Go Gadget bad-start fixer.
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' ,'SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' ,'SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'YieldType' , 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'YieldType' , 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'YieldType' , 'YIELD_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'YieldType' , 'YIELD_PRODUCTION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'Amount' , '1');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_FOOD_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_HILLS_FOOD_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_PRODUCTION_MODIFIER');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER');
-- No prod nor food bonus on Floodplains
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
-- Requires Desert or Desert Hills
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT_HILLS');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT_HILLS');