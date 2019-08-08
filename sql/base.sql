--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- America
--==================
-- American Rough Riders will now be a cav replacement
UPDATE Units SET Combat=62, Cost=340, PromotionClass='PROMOTION_CLASS_LIGHT_CAVALRY', PrereqTech='TECH_MILITARY_SCIENCE' WHERE UnitType='UNIT_AMERICAN_ROUGH_RIDER';
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_HELICOPTER' WHERE Unit='UNIT_AMERICAN_ROUGH_RIDER';
INSERT INTO UnitReplaces VALUES ('UNIT_AMERICAN_ROUGH_RIDER' , 'UNIT_CAVALRY');
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='ROUGH_RIDER_BONUS_ON_HILLS';


--==================
-- Arabia
--==================
-- Arabia's Worship Building Bonus increased from 10% to 20%
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='TRAIT_RELIGIOUS_BUILDING_MULTIPLIER_CULTURE' AND Name='Multiplier';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='TRAIT_RELIGIOUS_BUILDING_MULTIPLIER_FAITH' AND Name='Multiplier';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId='TRAIT_RELIGIOUS_BUILDING_MULTIPLIER_SCIENCE' AND Name='Multiplier';
-- Arabia gets +1 Great Prophet point per turn after researching astrology
INSERT INTO Modifiers (ModifierId , ModifierType, SubjectRequirementSetId)
    VALUES ('TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD' , 'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS' , 'PLAYER_HAS_ASTROLOGY_REQUIREMENTS_CPLMOD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_PROPHET');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD' , 'Amount' , '1');
--UPDATE TraitModifiers SET ModifierId='TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD' WHERE ModifierId='TRAIT_GUARANTEE_ONE_PROPHET';
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES ('TRAIT_CIVILIZATION_LAST_PROPHET', 'TRAIT_BONUS_GREAT_PROPHET_POINT_CPLMOD');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('PLAYER_HAS_ASTROLOGY_REQUIREMENTS_CPLMOD' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('PLAYER_HAS_ASTROLOGY_REQUIREMENTS_CPLMOD' , 'REQUIRES_PLAYER_HAS_ASTROLOGY_CPLMOD');
INSERT INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_PLAYER_HAS_ASTROLOGY_CPLMOD' , 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLAYER_HAS_ASTROLOGY_CPLMOD' , 'TechnologyType' , 'TECH_ASTROLOGY');



--==================
-- China
--==================
-- Great Wall gets it's adjacency gold and culture a little easier
UPDATE Improvement_YieldChanges SET YieldChange='1' WHERE ImprovementType='IMPROVEMENT_GREAT_WALL' AND YieldType='YIELD_GOLD';
INSERT INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqTech)
	VALUES ('202' , 'IMPROVEMENT_GREAT_WALL' , 'YIELD_CULTURE' , '1' , 'TECH_CASTLES');
	
DELETE FROM Adjacency_YieldChanges WHERE ID='GreatWall_Gold';
DELETE FROM Adjacency_YieldChanges WHERE ID='GreatWall_Culture';

INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GREATWALL_SELFADJACENCY_CULTURE_CPLMOD' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' , 'PLOT_ADJACENT_GREATWALL_CULTURE_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GREATWALL_SELFADJACENCY_CULTURE_CPLMOD' , 'YieldType' , 'YIELD_CULTURE');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GREATWALL_SELFADJACENCY_CULTURE_CPLMOD' , 'Amount' , '1');
INSERT INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_GREAT_WALL' , 'GREATWALL_SELFADJACENCY_CULTURE_CPLMOD');
	
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GREATWALL_SELFADJACENCY_GOLD_CPLMOD' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' , 'PLOT_ADJACENT_GREATWALL_GOLD_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GREATWALL_SELFADJACENCY_GOLD_CPLMOD' , 'YieldType' , 'YIELD_GOLD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GREATWALL_SELFADJACENCY_GOLD_CPLMOD' , 'Amount' , '1');
INSERT INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_GREAT_WALL' , 'GREATWALL_SELFADJACENCY_GOLD_CPLMOD');

INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('PLOT_ADJACENT_GREATWALL_GOLD_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('PLOT_ADJACENT_GREATWALL_GOLD_REQUIREMENTS' , 'REQUIRES_PLOT_ADJACENT_GREATWALL');
INSERT INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_PLOT_ADJACENT_GREATWALL' , 'REQUIREMENT_PLOT_ADJACENT_IMPROVEMENT_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_ADJACENT_GREATWALL' , 'ImprovementType' , 'IMPROVEMENT_GREAT_WALL');
	
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('PLOT_ADJACENT_GREATWALL_CULTURE_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');	
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('PLOT_ADJACENT_GREATWALL_CULTURE_REQUIREMENTS' , 'REQUIRES_PLOT_ADJACENT_GREATWALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('PLOT_ADJACENT_GREATWALL_CULTURE_REQUIREMENTS' , 'REQUIRES_TECHNOLOGY_CASTLES');

-- Crouching Tiger now a crossbowman replacement that gets +7 when adjacent to an enemy unit
INSERT INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
	VALUES ('UNIT_CHINESE_CROUCHING_TIGER' , 'UNIT_CROSSBOWMAN');
UPDATE Units SET Cost=190 , RangedCombat=40 , Range=2 WHERE UnitType='UNIT_CHINESE_CROUCHING_TIGER';

INSERT INTO Tags (Tag , Vocabulary)
	VALUES ('CLASS_CROUCHING_TIGER' , 'ABILITY_CLASS');
INSERT INTO TypeTags (Type , Tag)
	VALUES ('UNIT_CHINESE_CROUCHING_TIGER' , 'CLASS_CROUCHING_TIGER');
INSERT INTO Types (Type , Kind)
	VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'KIND_ABILITY');
INSERT INTO TypeTags (Type , Tag)
	VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'CLASS_CROUCHING_TIGER');
INSERT INTO UnitAbilities (UnitAbilityType , Name , Description)
	VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'LOC_ABILITY_TIGER_ADJACENCY_NAME' , 'LOC_ABILITY_TIGER_ADJACENCY_DESCRIPTION');
INSERT INTO UnitAbilityModifiers (UnitAbilityType , ModifierId)
	VALUES ('ABILITY_TIGER_ADJACENCY_DAMAGE_CPLMOD' , 'TIGER_ADJACENCY_DAMAGE');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('TIGER_ADJACENCY_DAMAGE' , 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH' , 'TIGER_ADJACENCY_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TIGER_ADJACENCY_DAMAGE', 'Amount' , '7'); 
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'PLAYER_IS_ATTACKER_REQUIREMENTS');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('TIGER_ADJACENCY_REQUIREMENTS' , 'ADJACENT_UNIT_REQUIREMENT');
INSERT INTO ModifierStrings (ModifierId , Context , Text)
    VALUES ('TIGER_ADJACENCY_DAMAGE' , 'Preview' , 'LOC_ABILITY_TIGER_ADJACENCY_DESCRIPTION');

--==================
-- Egypt
--==================
-- Sphinx now allowed to be adjacent to each other
UPDATE Improvements SET SameAdjacentValid=1 WHERE ImprovementType='IMPROVEMENT_SPHINX';
-- wonder and district on rivers bonus increased to 25%
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RIVER_FASTER_BUILDTIME_WONDER';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RIVER_FASTER_BUILDTIME_DISTRICT';
-- +1 food on floodplains
INSERT INTO TraitModifiers
    (TraitType                , ModifierId)
    VALUES
    ('TRAIT_CIVILIZATION_ITERU' , 'ITERU_FLOODPLAINS_FOOD_BONUS');
INSERT INTO Modifiers
    (ModifierId                   , ModifierType                            , SubjectRequirementSetId)
    VALUES 
    ('ITERU_FLOODPLAINS_FOOD_BONUS' , 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD' , 'REQUIRES_PLOT_HAS_FLOODPLAINS_CPL');
INSERT INTO ModifierArguments
    (ModifierId                    , Name      , Value)
    VALUES
    ('ITERU_FLOODPLAINS_FOOD_BONUS' , 'YieldType' , 'YIELD_FOOD'),
    ('ITERU_FLOODPLAINS_FOOD_BONUS' , 'Amount'    , '1'         );
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIRES_PLOT_HAS_FLOODPLAINS');
-- Sphinx base Faith Increased to 2 (from 1)
UPDATE Improvement_YieldChanges SET YieldChange=2 WHERE ImprovementType='IMPROVEMENT_SPHINX' AND YieldType='YIELD_FAITH';
-- +1 Faith and +1 Culture if adjacent to a wonder, instead of 2 Faith.
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='SPHINX_WONDERADJACENCY_FAITH' AND Name='Amount';
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' , 'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'YieldType' , 'YIELD_CULTURE');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_WONDERADJACENCY_CULTURE_CPLMOD' , 'Amount' , 1);
INSERT INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_WONDERADJACENCY_CULTURE_CPLMOD');
-- Increased +1 Culture moved to Diplomatic Service (Was Natural History)
UPDATE Improvement_BonusYieldChanges SET PrereqCivic = 'CIVIC_DIPLOMATIC_SERVICE' WHERE Id = 18;
-- Now grants 1 food and 1 production on desert tiles without floodplains. Go Go Gadget bad-start fixer.
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' ,'SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS' ,'SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'YieldType' , 'YIELD_FOOD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_FOOD_MODIFIER' , 'Amount' , '1');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'YieldType' , 'YIELD_FOOD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_FOOD_MODIFIER' , 'Amount' , '1');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'YieldType' , 'YIELD_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_PRODUCTION_MODIFIER' , 'Amount' , '1');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'YieldType' , 'YIELD_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER' , 'Amount' , '1');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_FOOD_MODIFIER');
INSERT INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_HILLS_FOOD_MODIFIER');
INSERT INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_PRODUCTION_MODIFIER');
INSERT INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_SPHINX' , 'SPHINX_DESERT_HILLS_PRODUCTION_MODIFIER');
-- No prod nor food bonus on Floodplains
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_NO_FLOODPLAINS');
-- Requires Desert or Desert Hills
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_FOOD_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT_HILLS');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('SPHINX_PRODUCTION_PLOT_HAS_DESERT_HILLS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_DESERT_HILLS');


--==================
-- England
--==================
-- Sea Dog available at Exploration now
UPDATE Units SET PrereqCivic='CIVIC_EXPLORATION' WHERE UnitType='UNIT_ENGLISH_SEADOG';


--==================
-- France
--==================
-- Chateau now gives 1 housing at Feudalism, and ajacent luxes now give stacking food in addition to stacking gold 
INSERT INTO Improvement_YieldChanges (ImprovementType , YieldType , YieldChange)
	VALUES ('IMPROVEMENT_CHATEAU' , 'YIELD_FOOD' , '0');

INSERT INTO Improvement_Adjacencies (ImprovementType , YieldChangeId)
	VALUES ('IMPROVEMENT_CHATEAU' , 'Chateau_Luxury_Food');

INSERT INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentResourceClass)
	VALUES ('Chateau_Luxury_Food' , 'Placeholder' , 'YIELD_FOOD' , '1' , '1' , 'RESOURCECLASS_LUXURY');

UPDATE Improvements SET Housing='1' , PreReqCivic='CIVIC_FEUDALISM' WHERE ImprovementType='IMPROVEMENT_CHATEAU';


--==================
-- Germany
--==================
-- Extra district comes at Guilds
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('PLAYER_HAS_GUILDS_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO Requirements (RequirementId, RequirementType)
    VALUES ('REQUIRES_PLAYER_HAS_GUILDS' , 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_PLAYER_HAS_GUILDS' , 'CivicType' , 'CIVIC_GUILDS');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('PLAYER_HAS_GUILDS_REQUIREMENTS' , 'REQUIRES_PLAYER_HAS_GUILDS');
UPDATE Modifiers SET SubjectRequirementSetId='PLAYER_HAS_GUILDS_REQUIREMENTS' WHERE ModifierId='TRAIT_EXTRA_DISTRICT_EACH_CITY';


--==================
-- Greece
--==================
-- Greece gets their extra envoy at amphitheater instead of acropolis
DELETE FROM DistrictModifiers WHERE DistrictType='DISTRICT_ACROPOLIS';
INSERT INTO TraitModifiers
	VALUES ('TRAIT_CIVILIZATION_PLATOS_REPUBLIC' , 'AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES ('AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN' , 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'BUILDING_IS_AMPHITHEATER');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN' , 'ModifierId' , 'AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN_MOD');
INSERT INTO Modifiers (ModifierId, ModifierType)
    VALUES ('AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN_MOD' , 'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('AMPHITHEATER_AWARD_1_INFLUENCE_TOKEN_MOD' , 'Amount' , '1');
--Wildcard delayed to Political Philosophy
UPDATE Modifiers SET OwnerRequirementSetId='PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD' WHERE ModifierId='TRAIT_WILDCARD_GOVERNMENT_SLOT';
INSERT INTO Requirements (RequirementId, RequirementType)
	VALUES ('REQUIRES_PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD', 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT INTO RequirementArguments (RequirementId, Name, Value)
	VALUES ('REQUIRES_PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD', 'CivicType', 'CIVIC_POLITICAL_PHILOSOPHY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD', 'REQUIRES_PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('PLAYER_HAS_POLITICAL_PHILOSOPHY_CPLMOD', 'REQUIREMENTSET_TEST_ALL');

--==================
-- Greece (Gorgo)
--==================
-- 25% culture from kills instead of 50%
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='UNIQUE_LEADER_CULTURE_KILLS' AND Name='PercentDefeatedStrength';


--==================
-- India
--==================
-- Varu upgrades to 
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CUIRASSIER' WHERE Unit='UNIT_INDIAN_VARU';
-- India Stepwell Unique Improvement gets +1 base Faith and +1 Food moved from Professional Sports to Feudalism
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_STEPWELL' AND YieldType='YIELD_FAITH'; 
UPDATE Improvement_BonusYieldChanges SET PrereqCivic='CIVIC_FEUDALISM' WHERE Id='20';


--==================
-- India (Gandhi)
--==================
-- Extra belief when founding a Religion
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES ('EXTRA_BELIEF_MODIFIER', 'MODIFIER_PLAYER_ADD_BELIEF', 'HAS_A_RELIGION');
INSERT INTO TraitModifiers (TraitType, ModifierId)
    VALUES ('TRAIT_LEADER_SATYAGRAHA', 'EXTRA_BELIEF_MODIFIER');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES ('HAS_A_RELIGION', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('HAS_A_RELIGION', 'REQUIRES_PLAYER_HAS_FOUNDED_A_RELIGION');
-- +1 movement to builders
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_SATYAGRAHA' , 'GANDHI_FAST_BUILDERS');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GANDHI_FAST_BUILDERS' , 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT' , 'UNIT_IS_BUILDER');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GANDHI_FAST_BUILDERS' , 'Amount' , '1');
-- +1 movement to settlers
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_SATYAGRAHA' , 'GANDHI_FAST_SETTLERS');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GANDHI_FAST_SETTLERS' , 'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT' , 'UNIT_IS_SETTLER');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GANDHI_FAST_SETTLERS' , 'Amount' , '1');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('UNIT_IS_SETTLER' , 'REQUIREMENT_UNIT_IS_SETTLER');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('UNIT_IS_SETTLER' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIREMENT_UNIT_IS_SETTLER' , 'REQUIREMENT_UNIT_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIREMENT_UNIT_IS_SETTLER' , 'UnitType' , 'UNIT_SETTLER');


--==================
-- Japan
--==================
-- Commercial Hubs no longer get adjacency from rivers
INSERT INTO ExcludedAdjacencies (TraitType , YieldChangeId)
    VALUES
    ('TRAIT_CIVILIZATION_ADJACENT_DISTRICTS' , 'River_Gold');
-- Samurai come at Feudalism now
UPDATE Units SET PrereqCivic='CIVIC_FEUDALISM' , PrereqTech=NULL WHERE UnitType='UNIT_JAPANESE_SAMURAI';


--==================
-- Russia
--==================
-- Lavra only gets 1 Great Prophet Point per turn
UPDATE District_GreatPersonPoints SET PointsPerTurn=1 WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_PROPHET';
-- Only gets 4 extra tiles when founding a new city instead of 8 
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='TRAIT_INCREASED_TILES';
-- Cossacks have same base strength as cavalry instead of +5
UPDATE Units SET Combat=62 WHERE UnitType='UNIT_RUSSIAN_COSSACK';
-- Lavra district does not acrue Great Person Points unless city has a theater
UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_ARTIST';
UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_MUSICIAN';
UPDATE District_GreatPersonPoints SET PointsPerTurn='0' WHERE DistrictType='DISTRICT_LAVRA' AND GreatPersonClassType='GREAT_PERSON_CLASS_WRITER';
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES
	('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIRES_DISTRICT_IS_LAVRA'),
	('DELAY_LAVRA_GPP_REQUIREMENTS' , 'REQUIRES_CITY_HAS_THEATER_DISTRICT');
INSERT INTO Requirements (RequirementId, RequirementType)
	VALUES ('REQUIRES_DISTRICT_IS_LAVRA' , 'REQUIREMENT_DISTRICT_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value)
	VALUES ('REQUIRES_DISTRICT_IS_LAVRA', 'DistrictType', 'DISTRICT_LAVRA');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
    VALUES
	('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS'),
    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS'),
	('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DELAY_LAVRA_GPP_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES
	('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_ARTIST'),
    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_MUSICIAN'),
	('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'GreatPersonClassType' , 'GREAT_PERSON_CLASS_WRITER'),
	('DELAY_LAVRA_ARTIST_GPP_MODIFIER' , 'Amount' , '1'),
    ('DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' , 'Amount' , '1'),
    ('DELAY_LAVRA_WRITER_GPP_MODIFIER' , 'Amount' , '1');
INSERT INTO DistrictModifiers ( DistrictType , ModifierId )
	VALUES
	( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_ARTIST_GPP_MODIFIER' ),
	( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_MUSICIAN_GPP_MODIFIER' ),
	( 'DISTRICT_LAVRA' , 'DELAY_LAVRA_WRITER_GPP_MODIFIER' );


--==================
-- Scythia
--==================
-- Scythia no longer gets an extra light cavalry unit when building/buying one
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_EXTRASAKAHORSEARCHER' and NAME='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_EXTRALIGHTCAVALRY' and NAME='Amount';
-- Scythian Horse Archer gets a little more offense and defense, less maintenance, and can upgrade to Crossbowman before Field Cannon now
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CROSSBOWMAN' WHERE Unit='UNIT_SCYTHIAN_HORSE_ARCHER';
UPDATE Units SET Range=2, Cost=70 WHERE UnitType='UNIT_SCYTHIAN_HORSE_ARCHER';
-- Adjacent Pastures now give +1 production in addition to faith
INSERT INTO Improvement_Adjacencies (ImprovementType , YieldChangeId)
	VALUES ('IMPROVEMENT_KURGAN' , 'KURGAN_PASTURE_PRODUCTION');
INSERT INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentImprovement)
	VALUES ('KURGAN_PASTURE_PRODUCTION' , 'Placeholder' , 'YIELD_PRODUCTION' , 1 , 1 , 'IMPROVEMENT_PASTURE');
INSERT INTO Improvement_YieldChanges (ImprovementType , YieldType , YieldChange)
	VALUES ('IMPROVEMENT_KURGAN' , 'YIELD_PRODUCTION' , 0);
-- Can now purchase cavalry units with faith
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_CIVILIZATION_EXTRA_LIGHT_CAVALRY' , 'SCYTHIA_FAITH_PURCHASE_LCAVALRY_CPLMOD');
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_CIVILIZATION_EXTRA_LIGHT_CAVALRY' , 'SCYTHIA_FAITH_PURCHASE_HCAVALRY_CPLMOD');
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_CIVILIZATION_EXTRA_LIGHT_CAVALRY' , 'SCYTHIA_FAITH_PURCHASE_RCAVALRY_CPLMOD');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('SCYTHIA_FAITH_PURCHASE_LCAVALRY_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('SCYTHIA_FAITH_PURCHASE_HCAVALRY_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('SCYTHIA_FAITH_PURCHASE_RCAVALRY_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SCYTHIA_FAITH_PURCHASE_LCAVALRY_CPLMOD' , 'Tag' , 'CLASS_LIGHT_CAVALRY'); 
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SCYTHIA_FAITH_PURCHASE_HCAVALRY_CPLMOD' , 'Tag' , 'CLASS_HEAVY_CAVALRY');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('SCYTHIA_FAITH_PURCHASE_RCAVALRY_CPLMOD' , 'Tag' , 'CLASS_RANGED_CAVALRY'); 


--==================
-- Spain
--==================
-- Missions moved to Theology
UPDATE Improvements SET PrereqCivic='CIVIC_THEOLOGY' WHERE ImprovementType='IMPROVEMENT_MISSION';
-- Missions get +1 housing at Exploration
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('MISSION_HOUSING_WITH_CIVIL_SERVICE' , 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING', 'PLAYER_HAS_CIVIL_SERVICE_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('MISSION_HOUSING_WITH_CIVIL_SERVICE' , 'Amount' , 1);
INSERT INTO ImprovementModifiers (ImprovementType , ModifierId)
	VALUES ('IMPROVEMENT_MISSION' , 'MISSION_HOUSING_WITH_CIVIL_SERVICE');
-- Missions get bonus yields at Enlightenment
UPDATE Improvement_BonusYieldChanges SET PrereqCivic='CIVIC_THE_ENLIGHTENMENT' WHERE Id='17';
-- Early Fleets moved to Mercenaries
UPDATE ModifierArguments SET Value='CIVIC_MERCENARIES' WHERE Name='CivicType' AND ModifierId='TRAIT_NAVAL_CORPS_EARLY';
-- 30% discount on missionaries
INSERT INTO TraitModifiers ( TraitType , ModifierId )
	VALUES ('TRAIT_LEADER_EL_ESCORIAL' , 'HOLY_ORDER_MISSIONARY_DISCOUNT_MODIFIER');

	
--==================
-- Sumeria
--==================
-- Sumerian War Carts are no longer free to maintain so that you cannot have unlimited and are heavy chariot replacement with 32 combat
UPDATE Units SET Maintenance=1, Combat=32, PrereqTech='TECH_THE_WHEEL', MandatoryObsoleteTech='TECH_BALLISTICS' WHERE UnitType='UNIT_SUMERIAN_WAR_CART';
INSERT INTO UnitReplaces (CivUniqueUnitType, ReplacesUnitType) VALUES ('UNIT_SUMERIAN_WAR_CART', 'UNIT_HEAVY_CHARIOT');
-- Sumeria's Ziggurat gets +1 Culture at Diplomatic Service instead of Natural History
UPDATE Improvement_BonusYieldChanges SET PrereqCivic='CIVIC_DIPLOMATIC_SERVICE' WHERE ImprovementType='IMPROVEMENT_ZIGGURAT';
-- zigg gets +1 science and culture at enlightenment
INSERT INTO Improvement_BonusYieldChanges (ImprovementType, YieldType, BonusYieldChange, PrereqCivic)
	VALUES
	('IMPROVEMENT_ZIGGURAT', 'YIELD_CULTURE', 1, 'CIVIC_THE_ENLIGHTENMENT'),
	('IMPROVEMENT_ZIGGURAT', 'YIELD_SCIENCE', 1, 'CIVIC_THE_ENLIGHTENMENT');



--==============================================================
--******			  C I T Y - S T A T E S				  ******
--==============================================================
-- nan-modal culture per district no longer applies to city center or wonders
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT' WHERE ModifierId='MINOR_CIV_NAN_MADOL_DISTRICTS_CULTURE_BONUS';



--==============================================================
--******		C U L T U R E   V I C T O R I E S		  ******
--==============================================================
-- moon landing worth 5x science in culture instead of 10x
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='PROJECT_COMPLETION_GRANT_CULTURE_BASED_ON_SCIENCE_RATE' AND Name='Multiplier';
-- computers and environmentalism tourism boosts to 50% (from 25%)
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='COMPUTERS_BOOST_ALL_TOURISM';
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='ENVIRONMENTALISM_BOOST_ALL_TOURISM'; 
-- base wonder tourism adjusted to 5
UPDATE GlobalParameters SET Value='5' WHERE Name='TOURISM_BASE_FROM_WONDER';
-- Reduce amount of tourism needed for foreign tourist from 200 to 150
UPDATE GlobalParameters SET Value='150' WHERE Name='TOURISM_TOURISM_TO_MOVE_CITIZEN';
-- no longer have to wait any number of turns to move greatworks between cities
UPDATE GlobalParameters SET Value='0' WHERE Name='GREATWORK_ART_LOCK_TIME';
-- relics give 6 tourism instead of 8
UPDATE GreatWorks SET Tourism=6 WHERE GreatWorkObjectType='GREATWORKOBJECT_RELIC';

-- fix same artist, same archelogist culture and tourism from bing 1 and 1 to being default numbers
UPDATE Building_GreatWorks SET NonUniquePersonYield=4 WHERE BuildingType='BUILDING_HERMITAGE';
UPDATE Building_GreatWorks SET NonUniquePersonTourism=4 WHERE BuildingType='BUILDING_HERMITAGE';
UPDATE Building_GreatWorks SET NonUniquePersonYield=4 WHERE BuildingType='BUILDING_MUSEUM_ART';
UPDATE Building_GreatWorks SET NonUniquePersonTourism=4 WHERE BuildingType='BUILDING_MUSEUM_ART';
UPDATE Building_GreatWorks SET NonUniquePersonYield=6 WHERE BuildingType='BUILDING_MUSEUM_ARTIFACT';
UPDATE Building_GreatWorks SET NonUniquePersonTourism=6 WHERE BuildingType='BUILDING_MUSEUM_ARTIFACT';

-- books give 4 culture and 2 tourism each (8 and 4 for each great person)
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE YieldChange=2;
-- artworks give 4 culture and 4 tourism instead of 3 and 2 ( 12/12 for each GP)
-- artifacts give 6 culture and 6 tourism instead of 3 and 3 ( 18/18 for each GP)
UPDATE GreatWorks SET Tourism=4 WHERE GreatWorkObjectType='GREATWORKOBJECT_RELIGIOUS';
UPDATE GreatWorks SET Tourism=4 WHERE GreatWorkObjectType='GREATWORKOBJECT_SCULPTURE';
UPDATE GreatWorks SET Tourism=4 WHERE GreatWorkObjectType='GREATWORKOBJECT_LANDSCAPE';
UPDATE GreatWorks SET Tourism=4 WHERE GreatWorkObjectType='GREATWORKOBJECT_PORTRAIT';
UPDATE GreatWorks SET Tourism=6 WHERE GreatWorkObjectType='GREATWORKOBJECT_ARTIFACT';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_RUBLEV_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_RUBLEV_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_RUBLEV_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_BOSCH_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_BOSCH_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_BOSCH_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_DONATELLO_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_DONATELLO_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_DONATELLO_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_MICHELANGELO_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_MICHELANGELO_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_MICHELANGELO_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_YING_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_YING_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_YING_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_TITIAN_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_TITIAN_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_TITIAN_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GRECO_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GRECO_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GRECO_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_REMBRANDT_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_REMBRANDT_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_REMBRANDT_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_ANGUISSOLA_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_ANGUISSOLA_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_ANGUISSOLA_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KAUFFMAN_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KAUFFMAN_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KAUFFMAN_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_HOKUSAI_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_HOKUSAI_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_HOKUSAI_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_EOP_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_EOP_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_EOP_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GOGH_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GOGH_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GOGH_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_LEWIS_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_LEWIS_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_LEWIS_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_COLLOT_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_COLLOT_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_COLLOT_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_MONET_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_MONET_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_MONET_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_ORLOVSKY_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_ORLOVSKY_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_ORLOVSKY_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KLIMT_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KLIMT_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KLIMT_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GIL_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GIL_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_GIL_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_CASSATT_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_CASSATT_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_CASSATT_3';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_1';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_2';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_3';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_4';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_5';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_6';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_7';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_8';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_9';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_10';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_11';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_12';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_13';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_14';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_15';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_16';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_17';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_18';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_19';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_20';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_21';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_22';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_23';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_24';
UPDATE GreatWork_YieldChanges SET YieldChange=6 WHERE GreatWorkType='GREATWORK_ARTIFACT_25';

-- music gives 12 culture and 8 tourism instead of 4 and 4 (24/16 per GP)
UPDATE GreatWorks SET Tourism=8 WHERE GreatWorkObjectType='GREATWORKOBJECT_MUSIC';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_BEETHOVEN_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_BEETHOVEN_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_BACH_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_BACH_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_MOZART_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_MOZART_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_VIVALDI_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_VIVALDI_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_KENGYO_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_KENGYO_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_GOMEZ_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_GOMEZ_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_LISZT_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_LISZT_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_CHOPIN_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_CHOPIN_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_TCHAIKOVSKY_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_TCHAIKOVSKY_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_TIANHUA_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_TIANHUA_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_DVORAK_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_DVORAK_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_SCHUMANN_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_SCHUMANN_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_ROSAS_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_ROSAS_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_LILIUOKALANI_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_LILIUOKALANI_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_JAAN_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_JAAN_2';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_LEONTOVYCH_1';
UPDATE GreatWork_YieldChanges SET YieldChange='12' WHERE GreatWorkType='GREATWORK_LEONTOVYCH_2';



--==============================================================
--******			  	G O V E R N M E N T S			  ******
--==============================================================
-- fascism attack bonus works on defense now too
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_ATTACK_BUFF';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='FASCISM_LEGACY_ATTACK_BUFF';


--==============================================================
--******				P A N T H E O N S				  ******
--==============================================================
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='STONE_CIRCLES_QUARRY_FAITH_MODIFIER' and Name='Amount';
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='RELIGIOUS_IDOLS_BONUS_MINE_FAITH_MODIFIER' and Name='Amount';
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='RELIGIOUS_IDOLS_LUXURY_MINE_FAITH_MODIFIER' and Name='Amount';
-- Goddess of the Harvest is +50% faith from chops instead of +100%
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='GODDESS_OF_THE_HARVEST_HARVEST_MODIFIER' and Name='Amount';
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='GODDESS_OF_THE_HARVEST_REMOVE_FEATURE_MODIFIER' and Name='Amount';
-- Monument to the Gods affects all wonders... not just Ancient and Classical Era
UPDATE ModifierArguments SET Value='ERA_INFORMATION' WHERE ModifierId='MONUMENT_TO_THE_GODS_ANCIENTCLASSICALWONDER_MODIFIER' AND Name='EndEra';
-- God of War now God of War and Plunder (similar to divine spark)
DELETE FROM BeliefModifiers WHERE BeliefType='BELIEF_GOD_OF_WAR';
INSERT INTO Modifiers  ( ModifierId , ModifierType , SubjectRequirementSetId )
	VALUES
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS' ),
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_COMMERCIAL_HUB' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_HARBOR' 		),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS' , 'DISTRICT_IS_ENCAMPMENT' 	);
INSERT INTO ModifierArguments ( ModifierId , Name , Type , Value )
	VALUES
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' ),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' , 'ModifierId' , 'ARGTYPE_IDENTITY' , 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' ),
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_MERCHANT' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_ADMIRAL'  ),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'GreatPersonClassType' , 'ARGTYPE_IDENTITY' , 'GREAT_PERSON_CLASS_GENERAL'  ),
	( 'GOD_OF_WAR_AND_PLUNDER_COMHUB_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' ),
	( 'GOD_OF_WAR_AND_PLUNDER_HARBOR_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' ),
	( 'GOD_OF_WAR_AND_PLUNDER_ENCAMP_MODIFIER' , 'Amount' , 'ARGTYPE_IDENTITY' , '1' );
INSERT INTO BeliefModifiers ( BeliefType , ModifierId )
	VALUES
	( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_COMHUB' ),
	( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_HARBOR' ),
	( 'BELIEF_GOD_OF_WAR' , 'GOD_OF_WAR_AND_PLUNDER_ENCAMP' );
-- Fertility Rites gives +1 food for rice and wheat, and +1 prod for sheep and cattle
INSERT INTO Tags 
	(Tag                                , Vocabulary)
	VALUES 
	('CLASS_FERTILITY_RITES_FOOD'       , 'RESOURCE_CLASS');
INSERT INTO TypeTags 
	(Type              , Tag)
	VALUES
	('RESOURCE_SHEEP'  , 'CLASS_FERTILITY_RITES_FOOD'),
	('RESOURCE_WHEAT'  , 'CLASS_FERTILITY_RITES_FOOD'),
	('RESOURCE_CATTLE' , 'CLASS_FERTILITY_RITES_FOOD'),
	('RESOURCE_RICE'   , 'CLASS_FERTILITY_RITES_FOOD');
INSERT INTO Modifiers 
	(ModifierId                                         , ModifierType                                                , SubjectRequirementSetId)
	VALUES
	('FERTILITY_RITES_TAG_FOOD'                         , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER'                       , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'      ),
	('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD'               , 'PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS');
INSERT INTO ModifierArguments 
	(ModifierId                                         , Name                       , Value)
	VALUES
	('FERTILITY_RITES_TAG_FOOD'                         , 'ModifierId'                , 'FERTILITY_RITES_TAG_FOOD_MODIFIER'             ),
	('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'YieldType'                 , 'YIELD_FOOD'                                    ),
	('FERTILITY_RITES_TAG_FOOD_MODIFIER'                , 'Amount'                    , '1'                                             );
INSERT INTO Requirements 
	(RequirementId                                , RequirementType)
	VALUES 
	('REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD'       , 'REQUIREMENT_PLOT_RESOURCE_TAG_MATCHES');
INSERT INTO RequirementArguments 
	(RequirementId                                , Name  , Value)
	VALUES 
	('REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD'       , 'Tag'         , 'CLASS_FERTILITY_RITES_FOOD');
INSERT INTO RequirementSets 
	(RequirementSetId                                 , RequirementSetType)
	VALUES 
	('PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS'       , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements 
	(RequirementSetId                                 , RequirementId)
	VALUES 
	('PLOT_HAS_FERTILITY_TAG_FOOD_REQUIREMENTS'       , 'REQUIRES_PLOT_HAS_TAG_FERTILITY_FOOD');
UPDATE BeliefModifiers SET ModifierID='FERTILITY_RITES_TAG_FOOD' WHERE BeliefType='BELIEF_FERTILITY_RITES' AND ModifierID='FERTILITY_RITES_GROWTH';
-- Initiation Rites gives 25% faith for each military land unit produced
INSERT INTO Modifiers 
	(ModifierId                                         , ModifierType                                                , SubjectRequirementSetId)
	VALUES
	('INITIATION_RITES_FAITH_YIELD_CPL_MOD'             , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER'                       , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
	('INITIATION_RITES_FAITH_YIELD_MODIFIER_CPL_MOD'    , 'MODIFIER_SINGLE_CITY_GRANT_YIELD_PER_UNIT_COST'            , NULL                                );
INSERT INTO ModifierArguments 
	(ModifierId                                         , Name                       , Value)
	VALUES
	('INITIATION_RITES_FAITH_YIELD_CPL_MOD'             , 'ModifierId'                , 'INITIATION_RITES_FAITH_YIELD_MODIFIER_CPL_MOD' ),
	('INITIATION_RITES_FAITH_YIELD_MODIFIER_CPL_MOD'    , 'YieldType'                 , 'YIELD_FAITH'                                   ),
	('INITIATION_RITES_FAITH_YIELD_MODIFIER_CPL_MOD'    , 'UnitProductionPercent'     , '25'                                            );
UPDATE BeliefModifiers SET ModifierID='INITIATION_RITES_FAITH_YIELD_CPL_MOD' WHERE BeliefType='BELIEF_INITIATION_RITES' AND ModifierID='INITIATION_RITES_FAITH_DISPERSAL';
-- Sacred Path +1 Faith Holy Site adjacency now applies to both Woods and Rainforest
INSERT INTO BeliefModifiers 
	(BeliefType                   , ModifierId)
	VALUES
	('BELIEF_SACRED_PATH'         , 'SACRED_PATH_WOODS_FAITH_ADJACENCY');
INSERT INTO Modifiers 
	(ModifierId                                         , ModifierType                                                , SubjectRequirementSetId)
	VALUES
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'MODIFIER_ALL_CITIES_FEATURE_ADJACENCY'                     , 'CITY_FOLLOWS_PANTHEON_REQUIREMENTS');
INSERT INTO ModifierArguments 
	(ModifierId                                         , Name                       , Value)
	VALUES
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'DistrictType'              , 'DISTRICT_HOLY_SITE'                            ),
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'FeatureType'               , 'FEATURE_FOREST'                                ),
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'YieldType'                 , 'YIELD_FAITH'                                   ),
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'Amount'                    , '1'                                             ),
	('SACRED_PATH_WOODS_FAITH_ADJACENCY'                , 'Description'               , 'LOC_DISTRICT_SACREDPATH_WOODS_FAITH'           );
-- Lady of the Reeds and Marshes now applies pantanal
INSERT INTO RequirementSetRequirements 
    (RequirementSetId              , RequirementId)
    VALUES 
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_PANTANAL'          );
INSERT INTO Requirements 
    (RequirementId                          , RequirementType)
    VALUES 
    ('REQUIRES_PLOT_HAS_PANTANAL'           , 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT INTO RequirementArguments 
    (RequirementId                          , Name          , Value)
    VALUES 
    ('REQUIRES_PLOT_HAS_PANTANAL'           , 'FeatureType' , 'FEATURE_PANTANAL'             );



--==============================================================
--******			P O L I C Y   C A R D S				  ******
--==============================================================
-- Limes should not become obselete
DELETE FROM ObsoletePolicies WHERE PolicyType='POLICY_LIMES';
-- Adds +100% Siege Unit Production to Limes Policy Card (the +100% to walls card)
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('LIMES_SIEGE_ANCIENT_ERA_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('LIMES_SIEGE_CLASSICAL_ERA_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('LIMES_SIEGE_MEDIEVAL_ERA_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('LIMES_SIEGE_RENAISSANCE_ERA_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('LIMES_SIEGE_INDUSTRIAL_ERA_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('LIMES_SIEGE_MODERN_ERA_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('LIMES_SIEGE_ATOMIC_ERA_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('LIMES_SIEGE_INFORMATION_ERA_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
--
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_ANCIENT_ERA_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_SIEGE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_ANCIENT_ERA_CPLMOD' , 'EraType' , 'ERA_ANCIENT' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_ANCIENT_ERA_CPLMOD' , 'Amount' , '100' , '-1');
	
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_CLASSICAL_ERA_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_SIEGE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_CLASSICAL_ERA_CPLMOD' , 'EraType' , 'ERA_CLASSICAL' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_CLASSICAL_ERA_CPLMOD' , 'Amount' , '100' , '-1');
	
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_MEDIEVAL_ERA_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_SIEGE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_MEDIEVAL_ERA_CPLMOD' , 'EraType' , 'ERA_MEDIEVAL' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_MEDIEVAL_ERA_CPLMOD' , 'Amount' , '100' , '-1');
	
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_RENAISSANCE_ERA_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_SIEGE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_RENAISSANCE_ERA_CPLMOD' , 'EraType' , 'ERA_RENAISSANCE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_RENAISSANCE_ERA_CPLMOD' , 'Amount' , '100' , '-1');
	
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_INDUSTRIAL_ERA_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_SIEGE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_INDUSTRIAL_ERA_CPLMOD' , 'EraType' , 'ERA_INDUSTRIAL' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_INDUSTRIAL_ERA_CPLMOD' , 'Amount' , '100' , '-1');
	
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_MODERN_ERA_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_SIEGE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_MODERN_ERA_CPLMOD' , 'EraType' , 'ERA_MODERN' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_MODERN_ERA_CPLMOD' , 'Amount' , '100' , '-1');
	
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_ATOMIC_ERA_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_SIEGE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_ATOMIC_ERA_CPLMOD' , 'EraType' , 'ERA_ATOMIC' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_ATOMIC_ERA_CPLMOD' , 'Amount' , '100' , '-1');
	
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_INFORMATION_ERA_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_SIEGE' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_INFORMATION_ERA_CPLMOD' , 'EraType' , 'ERA_INFORMATION' , '-1');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES ('LIMES_SIEGE_INFORMATION_ERA_CPLMOD' , 'Amount' , '100' , '-1');

INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES ('POLICY_LIMES' , 'LIMES_SIEGE_ANCIENT_ERA_CPLMOD');
INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES ('POLICY_LIMES' , 'LIMES_SIEGE_CLASSICAL_ERA_CPLMOD');
INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES ('POLICY_LIMES' , 'LIMES_SIEGE_MEDIEVAL_ERA_CPLMOD');
INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES ('POLICY_LIMES' , 'LIMES_SIEGE_RENAISSANCE_ERA_CPLMOD');
INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES ('POLICY_LIMES' , 'LIMES_SIEGE_INDUSTRIAL_ERA_CPLMOD');
INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES ('POLICY_LIMES' , 'LIMES_SIEGE_MODERN_ERA_CPLMOD');
INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES ('POLICY_LIMES' , 'LIMES_SIEGE_ATOMIC_ERA_CPLMOD');
INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES ('POLICY_LIMES' , 'LIMES_SIEGE_INFORMATION_ERA_CPLMOD');



--==============================================================
--******				R E L I G I O N					  ******
--==============================================================
-- Religious spread from trade routes increased
UPDATE GlobalParameters SET Value='3.0' WHERE Name='RELIGION_SPREAD_TRADE_ROUTE_PRESSURE_FOR_DESTINATION';
UPDATE GlobalParameters SET Value='3.0' WHERE Name='RELIGION_SPREAD_TRADE_ROUTE_PRESSURE_FOR_ORIGIN'     ;
-- Divine Inspiration yield increased
UPDATE ModifierArguments SET Value='6' WHERE ModifierId='DIVINE_INSPIRATION_WONDER_FAITH_MODIFIER' AND Name='Amount';
-- Crusader +7 instead of +10
UPDATE ModifierArguments SET Value='7' WHERE ModifierId='JUST_WAR_COMBAT_BONUS_MODIFIER';
-- Lay Ministry now +2 Culture and +2 Faith per Theater and Holy Site
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='LAY_MINISTRY_CULTURE_DISTRICTS_MODIFIER' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='LAY_MINISTRY_FAITH_DISTRICTS_MODIFIER' AND Name='Amount';
-- Itinerant Preachers now causes a Religion to spread 40% father away instead of only 30%
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='ITINERANT_PREACHERS_SPREAD_DISTANCE';
-- Cross-Cultural Dialogue is now +1 Science for every 3 foreign followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='CROSS_CULTURAL_DIALOGUE_SCIENCE_FOREIGN_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- Pilgrimmage now gives 3 Faith instead of 2 for each foreign city converted
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='PILGRIMAGE_FAITH_FOREIGN_CITY_MODIFIER' AND Name='Amount';
-- Tithe is now +1 Gold for every 3 followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TITHE_GOLD_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- World Church is now +1 Culture for every 3 foreign followers
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='WORLD_CHURCH_CULTURE_FOREIGN_FOLLOWER_MODIFIER' AND Name='PerXItems';
-- Zen Meditation now only requires 1 District to get the +1 Amentity
UPDATE RequirementArguments SET Value='1' WHERE RequirementId='REQUIRES_CITY_HAS_2_SPECIALTY_DISTRICTS' AND Name='Amount';
-- Religious Communities now gives +1 Housing to Holy Sites, like it does for Shines and Temples
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING' , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER' , 'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_HOUSING');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING' , 'ModifierId' , 'RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING_MODIFIER' , 'Amount' , '1');
INSERT INTO BeliefModifiers (BeliefType , ModifierId)
	VALUES ('BELIEF_RELIGIOUS_COMMUNITY' , 'RELIGIOUS_COMMUNITY_HOLY_SITE_HOUSING');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIRES_CITY_FOLLOWS_RELIGION');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('CITY_FOLLOWS_RELIGION_HAS_HOLY_SITE' , 'REQUIRES_CITY_HAS_HOLY_SITE');
-- Warrior Monks only require a shrine and now work with Classical Great Generals
UPDATE Units SET PrereqCivic='CIVIC_THEOLOGY' WHERE UnitType='UNIT_WARRIOR_MONK';
DELETE FROM Unit_BuildingPrereqs WHERE PrereqBuilding='BUILDING_STAVE_CHURCH' AND Unit='UNIT_WARRIOR_MONK';
DELETE FROM Unit_BuildingPrereqs WHERE PrereqBuilding='BUILDING_PRASAT' AND Unit='UNIT_WARRIOR_MONK';
UPDATE Unit_BuildingPrereqs SET PrereqBuilding='BUILDING_SHRINE' WHERE PrereqBuilding='BUILDING_TEMPLE' AND Unit='UNIT_WARRIOR_MONK';
-- Work Ethic now provides production equal to base yield for Shrine and Temple
DELETE From BeliefModifiers WHERE ModifierId='WORK_ETHIC_FOLLOWER_PRODUCTION';
INSERT INTO Modifiers 
	(ModifierId                              , ModifierType                          , SubjectRequirementSetId)
	VALUES 
	('WORK_ETHIC_SHRINE_PRODUCTION'          , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_SHRINE'),--<
	('WORK_ETHIC_TEMPLE_PRODUCTION'          , 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER' , 'CITY_FOLLOWS_RELIGION_HAS_TEMPLE'),
	('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'MODIFIER_BUILDING_YIELD_CHANGE'      , null                              ),--<
	('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'MODIFIER_BUILDING_YIELD_CHANGE'      , null                              );
INSERT INTO ModifierArguments 
	(ModifierId                              , Name           , Value)
	VALUES 
	('WORK_ETHIC_SHRINE_PRODUCTION'          , 'ModifierId'   , 'WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER'),--<
	('WORK_ETHIC_TEMPLE_PRODUCTION'          , 'ModifierId'   , 'WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER'),
	('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'BuildingType' , 'BUILDING_SHRINE'                      ),--<
	('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'YieldType'    , 'YIELD_PRODUCTION'                     ),
	('WORK_ETHIC_SHRINE_PRODUCTION_MODIFIER' , 'Amount'       , '2'                                    ),
	('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'BuildingType' , 'BUILDING_TEMPLE'                      ),--<
	('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'YieldType'    , 'YIELD_PRODUCTION'                     ),
	('WORK_ETHIC_TEMPLE_PRODUCTION_MODIFIER' , 'Amount'       , '4'                                    );
INSERT INTO BeliefModifiers 
	(BeliefType          , ModifierId)
	VALUES 
	('BELIEF_WORK_ETHIC' , 'WORK_ETHIC_TEMPLE_PRODUCTION'),
	('BELIEF_WORK_ETHIC' , 'WORK_ETHIC_SHRINE_PRODUCTION');
-- Dar E Mehr provides +2 culture instead of faith from eras
DELETE FROM Building_YieldsPerEra WHERE BuildingType='BUILDING_DAR_E_MEHR';
INSERT INTO Building_YieldChanges 
	(BuildingType          , YieldType       , YieldChange)
	VALUES 
	('BUILDING_DAR_E_MEHR' , 'YIELD_CULTURE' , '2');
-- All worship building production costs reduced	
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_CATHEDRAL'    ;
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_GURDWARA'     ;
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_MEETING_HOUSE';
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_MOSQUE'       ;
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_PAGODA'       ;
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_SYNAGOGUE'    ;
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_WAT'          ;
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_STUPA'        ;
UPDATE Buildings SET Cost='120' WHERE BuildingType='BUILDING_DAR_E_MEHR'   ;



--==============================================================
--******				S  C  O  R  E				  	  ******
--==============================================================
-- Wonders Provide +5 score instead of +15
UPDATE ScoringLineItems SET Multiplier=5 WHERE LineItemType='LINE_ITEM_WONDERS';
UPDATE ScoringLineItems SET Multiplier=1 WHERE LineItemType='LINE_ITEM_ERA_CONVERTED';



--==============================================================
--******				START BIASES					  ******
--==============================================================
-- t1 take up essential coastal spots first
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_ENGLAND' AND TerrainType='TERRAIN_COAST';
-- t2 must haves
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_SPAIN' AND TerrainType='TERRAIN_COAST';
INSERT INTO StartBiasTerrains (CivilizationType , TerrainType , Tier)
	VALUES ('CIVILIZATION_JAPAN' , 'TERRAIN_COAST' , 2);
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_RUSSIA' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_RUSSIA' AND TerrainType='TERRAIN_TUNDRA';
-- t3 identities
UPDATE StartBiasFeatures SET Tier=3 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_SCYTHIA' AND ResourceType='RESOURCE_HORSES';
-- t4 river mechanics
UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_SUMERIA';
UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_FRANCE';
-- t4 feature mechanics
UPDATE StartBiasFeatures SET Tier=4 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS_PLAINS';
UPDATE StartBiasFeatures SET Tier=4 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS_GRASSLAND';
UPDATE StartBiasFeatures SET Tier=4 WHERE CivilizationType='CIVILIZATION_BRAZIL' AND FeatureType='FEATURE_JUNGLE';
UPDATE StartBiasFeatures SET Tier=4 WHERE CivilizationType='CIVILIZATION_KONGO' AND FeatureType='FEATURE_JUNGLE';
-- t4 terrain mechanics
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType='TERRAIN_GRASS_HILLS';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType='TERRAIN_PLAINS_HILLS';
-- t4 resource mechanics
INSERT INTO StartBiasResources (CivilizationType , ResourceType , Tier)
	VALUES
	('CIVILIZATION_SCYTHIA' , 'RESOURCE_SHEEP'  , 4),
	('CIVILIZATION_SCYTHIA' , 'RESOURCE_CATTLE' , 4);
-- t5 last resorts
UPDATE StartBiasTerrains SET Tier=5 WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE StartBiasTerrains SET Tier=5 WHERE CivilizationType='CIVILIZATION_GREECE' AND TerrainType='TERRAIN_DESERT_HILLS';
UPDATE StartBiasFeatures SET Tier=5 WHERE CivilizationType='CIVILIZATION_KONGO' AND FeatureType='FEATURE_FOREST';



--==============================================================
--******			  U N I T S  (NON-UNIQUE)			  ******
--==============================================================
UPDATE Units SET Combat=72 , BaseMoves=3 WHERE UnitType='UNIT_INFANTRY';
UPDATE Units SET PrereqCivic='CIVIC_EXPLORATION' WHERE UnitType='UNIT_PRIVATEER';
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES
	('ARROW_STORM_ALL_REQUIREMENTS',	'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('ARROW_STORM_ALL_REQUIREMENTS', 	'ARROW_STORM_OPPONENT_REQUIREMENTS_MET'),
	('GRAPE_SHOT_REQUIREMENTS',			'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('SHRAPNEL_REQUIREMENTS',			'PLAYER_IS_ATTACKER_REQUIREMENTS');
INSERT INTO Requirements (RequirementId, RequirementType) VALUES ('ARROW_STORM_OPPONENT_REQUIREMENTS_MET', 'REQUIREMENT_REQUIREMENTSET_IS_MET');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES ('ARROW_STORM_OPPONENT_REQUIREMENTS_MET', 'RequirementSetId', 'ARROW_STORM_REQUIREMENTS');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('ARROW_STORM_ALL_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
UPDATE Modifiers SET SubjectRequirementSetId='ARROW_STORM_ALL_REQUIREMENTS' WHERE ModifierId='ARROW_STORM_BONUS_VS_LAND_AND_SEA_UNITS';

--==============================================================
--******					W A L L S					  ******
--==============================================================
UPDATE Buildings SET OuterDefenseHitPoints=75 WHERE BuildingType = 'BUILDING_WALLS';
UPDATE Buildings SET OuterDefenseHitPoints=75 WHERE BuildingType = 'BUILDING_STAR_FORT';
UPDATE Buildings SET OuterDefenseHitPoints=75 WHERE BuildingType = 'BUILDING_CASTLE';
UPDATE ModifierArguments SET Value='300' WHERE ModifierId='STEEL_UNLOCK_URBAN_DEFENSES';



--==============================================================
--******			W O N D E R S  (MAN-MADE)			  ******
--==============================================================
-- Huey gives +2 culture to lake tiles
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
	VALUES ('BUILDING_HUEY_TEOCALLI', 'HUEY_LAKE_CULTURE');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	VALUES
	('HUEY_LAKE_CULTURE', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'FOODHUEY_PLAYER_REQUIREMENTS'),
	('HUEY_LAKE_CULTURE_MODIFIER', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'FOODHUEY_PLOT_IS_LAKE_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES
	('HUEY_LAKE_CULTURE', 'ModifierId', 'HUEY_LAKE_CULTURE_MODIFIER'),
	('HUEY_LAKE_CULTURE_MODIFIER', 'Amount', '2'),
	('HUEY_LAKE_CULTURE_MODIFIER', 'YieldType', 'YIELD_CULTURE');
-- Hanging Gardens gives +1 housing to cities within 6 tiles
UPDATE Buildings SET Housing='1' WHERE BuildingType='BUILDING_HANGING_GARDENS';
INSERT INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_HANGING_GARDENS' , 'HANGING_GARDENS_REGIONAL_HOUSING');
INSERT INTO Modifiers (ModifierId , ModifierType, SubjectRequirementSetId)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_HOUSING' , 'HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING' , 'Amount' , '1');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6');
INSERT INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'BuildingType' ,'BUILDING_HANGING_GARDENS');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'MaxRange' ,'6');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'MinRange' ,'0');

-- Great Library unlocks at Drama & Poetry instead of Recorded History
UPDATE Buildings SET PrereqCivic='CIVIC_DRAMA_POETRY' WHERE BuildingType='BUILDING_GREAT_LIBRARY';

-- Venetian Arsenal gives 100% production boost to all naval units in all cities instead of an extra naval unit in its city each time you build one
DELETE FROM BuildingModifiers WHERE	BuildingType='BUILDING_VENETIAN_ARSENAL';

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '100');

INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_MELEE_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_RANGED_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_RAIDER_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_CARRIER_PRODUCTION');



--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- Several lack-luster wonders improved
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_PANTANAL', 'YIELD_SCIENCE', 2);
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_CLIFFS_DOVER', 'YIELD_FOOD', 2);
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_DEAD_SEA', 'YIELD_FOOD', 2);
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_CRATER_LAKE', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_CRATER_LAKE' AND YieldType='YIELD_SCIENCE'; 
INSERT INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_GALAPAGOS', 'YIELD_FOOD', 1);



--==============================================================
--******				    O T H E R					  ******
--==============================================================
INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange)
	VALUES ('RESOURCE_INCENSE', 'YIELD_FOOD', 1);
-- add 1 production to fishing boat improvement
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_FISHING_BOATS' AND YieldType='YIELD_PRODUCTION';

-- Citizen specialists give +1 main yield
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_CULTURE' 		AND DistrictType="DISTRICT_ACROPOLIS";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' 		AND DistrictType="DISTRICT_CAMPUS";
UPDATE District_CitizenYieldChanges SET YieldChange=4 WHERE YieldType='YIELD_GOLD' 			AND DistrictType="DISTRICT_COMMERCIAL_HUB";
UPDATE District_CitizenYieldChanges SET YieldChange=2 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType="DISTRICT_ENCAMPMENT";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType="DISTRICT_HANSA";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' 			AND DistrictType="DISTRICT_HARBOR";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_FAITH' 		AND DistrictType="DISTRICT_HOLY_SITE";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType="DISTRICT_INDUSTRIAL_ZONE";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_FAITH' 		AND DistrictType="DISTRICT_LAVRA";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' 			AND DistrictType="DISTRICT_ROYAL_NAVY_DOCKYARD";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_CULTURE' 		AND DistrictType="DISTRICT_THEATER";









