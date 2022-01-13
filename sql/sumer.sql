UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_SUMERIA';
delete
from TraitModifiers
where TraitType = 'TRAIT_CIVILIZATION_FIRST_CIVILIZATION';
-- Farms adjacent to a River yield +1 food, Farms adjacent to a River get + 1 prop if next to Zigurat
insert into TraitModifiers
( TraitType, ModifierId )
values ( 'TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'FIRST_CIVILIZATION_FARM_FOOD' ),
       ( 'TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'FIRST_CIVILIZATION_WAR_CART_PREMIUM' ),
       ( 'TRAIT_CIVILIZATION_FIRST_CIVILIZATION', 'FIRST_CIVILIZATION_FARM_PROD' );
insert into Modifiers
( ModifierId, ModifierType, SubjectRequirementSetId, SubjectStackLimit )
values ( 'FIRST_CIVILIZATION_FARM_FOOD',
         'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
         'FIRST_CIVILIZATION_FARM_FOOD_REQUIREMENTS',
         null ),
       ( 'FIRST_CIVILIZATION_WAR_CART_PREMIUM', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST', null, 1 ),
       ( 'FIRST_CIVILIZATION_FARM_PROD',
         'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
         'FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS',
         null );
insert into ModifierArguments
( ModifierId, Name, Value )
values ( 'FIRST_CIVILIZATION_FARM_FOOD', 'YieldType', 'YIELD_FOOD' ),
       ( 'FIRST_CIVILIZATION_FARM_FOOD', 'Amount', 1 ),

       ( 'FIRST_CIVILIZATION_FARM_PROD', 'YieldType', 'YIELD_PRODUCTION' ),
       ( 'FIRST_CIVILIZATION_FARM_PROD', 'Amount', 1 ),
-- This makes War Carts cost 120 gold in Online speed		Increase premium to 40->50
       ( 'FIRST_CIVILIZATION_WAR_CART_PREMIUM', 'UnitType', 'UNIT_SUMERIAN_WAR_CART' ),
       ( 'FIRST_CIVILIZATION_WAR_CART_PREMIUM', 'Amount', -50 );
insert into RequirementSets
( RequirementSetId, RequirementSetType )
values ( 'FIRST_CIVILIZATION_FARM_FOOD_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' ),
       ( 'FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' );
insert into RequirementSetRequirements
( RequirementSetId, RequirementId )
values ( 'FIRST_CIVILIZATION_FARM_FOOD_REQUIREMENTS', 'REQUIRES_PLOT_HAS_FARM' ),
       ( 'FIRST_CIVILIZATION_FARM_FOOD_REQUIREMENTS', 'REQUIRES_PLOT_ADJACENT_TO_RIVER' ),

       ( 'FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', 'REQUIRES_PLOT_HAS_FARM' ),
       ( 'FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', 'REQUIRES_PLOT_ADJACENT_TO_ZIGGURAT' ),
       ( 'FIRST_CIVILIZATION_FARM_PROD_REQUIREMENTS', 'REQUIRES_PLAYER_HAS_EARLY_EMPIRE' );
insert into Requirements
( RequirementId, RequirementType )
values ( 'REQUIRES_CITY_HAS_WATER_MILL', 'REQUIREMENT_CITY_HAS_BUILDING' ),
       ( 'REQUIRES_PLOT_ADJACENT_TO_ZIGGURAT', 'REQUIREMENT_PLOT_ADJACENT_IMPROVEMENT_TYPE_MATCHES' ),
       ( 'REQUIRES_PLAYER_HAS_EARLY_EMPIRE', 'REQUIREMENT_PLAYER_HAS_CIVIC' );
insert into RequirementArguments
( RequirementId, Name, Value )
values ( 'REQUIRES_CITY_HAS_WATER_MILL', 'BuildingType', 'BUILDING_WATER_MILL' ),
       ( 'REQUIRES_PLOT_ADJACENT_TO_ZIGGURAT', 'ImprovementType', 'IMPROVEMENT_ZIGGURAT' ),
       ( 'REQUIRES_PLAYER_HAS_EARLY_EMPIRE', 'CivicType', 'CIVIC_EARLY_EMPIRE' );
-- Ziggurat buff
update Improvements
set SameAdjacentValid = 0,
    Housing           = 1,
    TilesRequired     = 1
where ImprovementType = 'IMPROVEMENT_ZIGGURAT';
insert into Improvement_YieldChanges
( ImprovementType, YieldType, YieldChange )
values ( 'IMPROVEMENT_ZIGGURAT', 'YIELD_FAITH', 0 );
insert into Improvement_YieldChanges
( ImprovementType, YieldType, YieldChange )
values ( 'IMPROVEMENT_ZIGGURAT', 'YIELD_FOOD', 1 );
-- +1 faith for every 2 adjacent farms. +1 faith for each adjacent District.
insert into Improvement_Adjacencies
( ImprovementType, YieldChangeId )
values ( 'IMPROVEMENT_ZIGGURAT', 'Ziggurat_Faith_Farm' ),
       ( 'IMPROVEMENT_ZIGGURAT', 'Ziggurat_Faith_District' );
insert into Adjacency_YieldChanges
( ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement, OtherDistrictAdjacent )
values ( 'Ziggurat_Faith_Farm', 'Placeholder', 'YIELD_FAITH', 1, 2, 'IMPROVEMENT_FARM', 0 ),
       ( 'Ziggurat_Faith_District', 'Placeholder', 'YIELD_FAITH', 1, 1, null, 1 );
update Improvement_Tourism set TourismSource = 'TOURISMSOURCE_FAITH' where ImprovementType = 'IMPROVEMENT_ZIGGURAT';
-- Sumerian War Carts are nerfed to 26 (BASE = 30)
-- 20-12-07 Hotfix: Nerf from 28->26-->27 (Devries)
update Units
set Combat=27
where UnitType = 'UNIT_SUMERIAN_WAR_CART';
-- Sumerian War Carts are cost is dimished to 45 (BASE = 55)
-- 20-12-07 Hotfix: Revert to 55 cost
-- Beta Buff: Revert to 45 cost
update Units
set Cost=45
where UnitType = 'UNIT_SUMERIAN_WAR_CART';
-- 20-12-07 Hotfix: Increase war-cart strength vs. barbs
insert or ignore into Types ( Type, Kind )
values ( 'ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG', 'KIND_ABILITY' );
insert or ignore into TypeTags
values ( 'ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG', 'CLASS_WAR_CART' );
insert or ignore into UnitAbilities ( UnitAbilityType, Name, Description, Inactive )
values ( 'ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG',
         'LOC_ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_NAME_BBG',
         'LOC_ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_DESCRIPTION_BBG',
         0 );
insert or ignore into UnitAbilityModifiers
values ( 'ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG', 'WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG' );
insert or ignore into Modifiers
    ( ModifierId, ModifierType, SubjectRequirementSetId )
values ( 'WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG',
         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
         'REQUIREMENTS_OPPONENT_IS_BARBARIAN' );
insert or ignore into ModifierStrings
    ( ModifierId, Context, Text )
values ( 'WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG',
         'Preview',
         'LOC_ABILITY_WAR_CART_COMBAT_STRENGTH_VS_BARBS_DESCRIPTION_BBG' );
insert into ModifierArguments
( ModifierId, Name, Value )
values ( 'WAR_CART_COMBAT_STRENGTH_VS_BARBS_BBG', 'Amount', 4 );
-- Sumerian War Carts as a starting unit in Ancient is coded on the lua front
-- 23/04/2021: Delete +5 when war common foe
delete
from TraitModifiers
where TraitType = 'TRAIT_LEADER_ADVENTURES_ENKIDU'
  and ModifierId = 'TRAIT_ATTACH_ALLIANCE_COMBAT_ADJUSTMENT';-- 16/05/2021: +1 military power per alliance level (on better alliance)
INSERT INTO Modifiers(ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
('BBG_SUMMER_COMBAT_ALLY_1', 'MODIFIER_PLAYER_UNITS_ADJUST_COMBAT_STRENGTH', 'BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_1', NULL),
('BBG_SUMMER_COMBAT_ALLY_2', 'MODIFIER_PLAYER_UNITS_ADJUST_COMBAT_STRENGTH', 'BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_2', NULL),
('BBG_SUMMER_COMBAT_ALLY_3', 'MODIFIER_PLAYER_UNITS_ADJUST_COMBAT_STRENGTH', 'BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_3', NULL);
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
('BBG_SUMMER_COMBAT_ALLY_1', 'Amount', 1),
('BBG_SUMMER_COMBAT_ALLY_2', 'Amount', 2),
('BBG_SUMMER_COMBAT_ALLY_3', 'Amount', 3);
INSERT INTO ModifierStrings(ModifierId, Context, Text) VALUES
('BBG_SUMMER_COMBAT_ALLY_1', 'Preview', 'LOC_BBG_SUMMER_COMBAT_ALLY_1'),
('BBG_SUMMER_COMBAT_ALLY_2', 'Preview', 'LOC_BBG_SUMMER_COMBAT_ALLY_2'),
('BBG_SUMMER_COMBAT_ALLY_3', 'Preview', 'LOC_BBG_SUMMER_COMBAT_ALLY_3');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
('TRAIT_LEADER_ADVENTURES_ENKIDU', 'BBG_SUMMER_COMBAT_ALLY_1'),
('TRAIT_LEADER_ADVENTURES_ENKIDU', 'BBG_SUMMER_COMBAT_ALLY_2'),
('TRAIT_LEADER_ADVENTURES_ENKIDU', 'BBG_SUMMER_COMBAT_ALLY_3');
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
('BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_1', 'REQUIREMENTSET_TEST_ALL'),
('BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_2', 'REQUIREMENTSET_TEST_ALL'),
('BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_3', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
('BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_1', 'REQUIRES_PLAYER_IS_ALLY_LEVEL_1'),
('BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_1', 'BBG_PLAYER_IS_NOT_ALLY_LEVEL_2'),
('BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_2', 'REQUIRES_PLAYER_IS_ALLY_LEVEL_2'),
('BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_2', 'BBG_PLAYER_IS_NOT_ALLY_LEVEL_3'),
('BBG_PLAYER_IS_ALLY_EXCLUSIVE_LEVEL_3', 'REQUIRES_PLAYER_IS_ALLY_LEVEL_3');
INSERT INTO Requirements(RequirementId , RequirementType, Inverse) VALUES
('BBG_PLAYER_IS_NOT_ALLY_LEVEL_2' , 'REQUIREMENT_PLAYER_HAS_ACTIVE_ALLIANCE_OF_AT_LEAST_LEVEL', 1),
('BBG_PLAYER_IS_NOT_ALLY_LEVEL_3' , 'REQUIREMENT_PLAYER_HAS_ACTIVE_ALLIANCE_OF_AT_LEAST_LEVEL', 1);
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
('BBG_PLAYER_IS_NOT_ALLY_LEVEL_2' , 'Level', '2'),
('BBG_PLAYER_IS_NOT_ALLY_LEVEL_3' , 'Level', '3');
