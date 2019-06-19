--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================
--==================
-- America
--==================
-- Reduce combat strength of mustangs due to them already having many extra combat bonuses over biplanes
UPDATE Units SET Combat=90 , RangedCombat=90 WHERE UnitType='UNIT_AMERICAN_P51';


--==================
-- Arabia
--==================
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CUIRASSIER' WHERE Unit='UNIT_ARABIAN_MAMLUK';


--==================
-- Canada
--==================
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES
	('TRAIT_LEADER_LAST_BEST_WEST'       , 'TUNDRA_EXTRA_FOOD_CPLMOD'           ),
	('TRAIT_LEADER_LAST_BEST_WEST'       , 'TUNDRA_HILLS_EXTRA_FOOD_CPLMOD'     ),
	('TRAIT_LEADER_LAST_BEST_WEST'       , 'NATIONAL_PARK_FOOD_YIELDS_CPLMOD'   ),
	('TRAIT_LEADER_LAST_BEST_WEST'       , 'NATIONAL_PARK_PROD_YIELDS_CPLMOD'   );
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId , OwnerRequirementSetId)
	VALUES
	('TUNDRA_EXTRA_FOOD_CPLMOD'            , 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'               , 'PLOT_HAS_TUNDRA_REQUIREMENTS'        , NULL),
	('TUNDRA_HILLS_EXTRA_FOOD_CPLMOD'      , 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD'               , 'PLOT_HAS_TUNDRA_HILLS_REQUIREMENTS'  , NULL),
	('NATIONAL_PARK_FOOD_YIELDS_CPLMOD'    , 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE' , 'CITY_HAS_NATIONAL_PARK_REQUREMENTS'  , NULL),
	('NATIONAL_PARK_PROD_YIELDS_CPLMOD'    , 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE' , 'CITY_HAS_NATIONAL_PARK_REQUREMENTS'  , NULL);
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES
	('TUNDRA_EXTRA_FOOD_CPLMOD'            , 'YieldType' , 'YIELD_FOOD'      ),
	('TUNDRA_EXTRA_FOOD_CPLMOD'            , 'Amount'    , '1'               ),
	('TUNDRA_HILLS_EXTRA_FOOD_CPLMOD'      , 'YieldType' , 'YIELD_FOOD'      ),
	('TUNDRA_HILLS_EXTRA_FOOD_CPLMOD'      , 'Amount'    , '1'               ),
	('NATIONAL_PARK_FOOD_YIELDS_CPLMOD'    , 'YieldType' , 'YIELD_FOOD'      ),
	('NATIONAL_PARK_FOOD_YIELDS_CPLMOD'    , 'Amount'    , '8'               ),
	('NATIONAL_PARK_PROD_YIELDS_CPLMOD'    , 'YieldType' , 'YIELD_PRODUCTION'),
	('NATIONAL_PARK_PROD_YIELDS_CPLMOD'    , 'Amount'    , '8'               );
-- Hockey rink at Civil Service
UPDATE Improvements SET PrereqCivic='CIVIC_CIVIL_SERVICE' WHERE ImprovementType='IMPROVEMENT_ICE_HOCKEY_RINK';
-- Mounties get a base combat buff and combat buff from nearby parks radius increased
UPDATE Units SET Combat=70 , Cost=360 WHERE UnitType='UNIT_CANADA_MOUNTIE';
UPDATE RequirementArguments SET Value='4' WHERE RequirementId='UNIT_PARK_REQUIREMENT'       AND Name='MaxDistance';
UPDATE RequirementArguments SET Value='4' WHERE RequirementId='UNIT_OWNER_PARK_REQUIREMENT' AND Name='MaxDistance';


--==========
-- EGYPT
--==========
INSERT INTO Requirements (RequirementId, RequirementType)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT INTO Requirements (RequirementId, RequirementType)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND', 'FeatureType', 'FEATURE_FLOODPLAINS_GRASSLAND');
INSERT INTO RequirementArguments (RequirementId, Name, Value)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS', 'FeatureType', 'FEATURE_FLOODPLAINS_PLAINS');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('REQUIRES_PLOT_HAS_FLOODPLAINS_CPL', 'REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS');


--==========
-- ELEANOR
--==========
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES
	('TRAIT_LEADER_ELEANOR_LOYALTY' , 'THEATER_BUILDING_PRODUCTION_BONUS_CPLMOD');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId , OwnerRequirementSetId)
	VALUES
	('THEATER_BUILDING_PRODUCTION_BONUS_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION' , NULL , NULL);
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES
	('THEATER_BUILDING_PRODUCTION_BONUS_CPLMOD' , 'DistrictType' , 'DISTRICT_THEATER'),
	('THEATER_BUILDING_PRODUCTION_BONUS_CPLMOD' , 'Amount'       , '100'                     );


--==========
-- FRANCE
--==========
UPDATE Units_XP2 SET ResourceCost=10 WHERE UnitType='UNIT_FRENCH_GARDE_IMPERIALE';


--==================
-- Hungary
--==================
-- only 1 envoy from levying city-states units
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='LEVY_MILITARY_TWO_FREE_ENVOYS';
-- huszars only +1 combat strength from each alliance instead of 3
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='HUSZAR_ALLIES_COMBAT_BONUS';
-- black army only +2 combat strength from adjacent levied units
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='BLACK_ARMY_ADJACENT_LEVY';
-- Remove extra movement from levied units
DELETE FROM UnitAbilityModifiers WHERE ModifierId='RAVEN_LEVY_MOVEMENT';



--==================
-- Kongo
--==================
UPDATE Units_XP2 SET ResourceCost=10 WHERE UnitType='UNIT_KONGO_SHIELD_BEARER';


--==========
-- Mali
--==========
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_LESS_BUILDING_PRODUCTION';
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_LESS_UNIT_PRODUCTION'    ;


--==================
-- Maori
--==================
UPDATE Units SET Maintenance=2, Combat=40 WHERE UnitType='UNIT_MAORI_TOA';



--==============================================================
--******				  DIPLOMACY						  ******
--==============================================================
--UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_DIPLOVICTORY';
--UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_WORLD_IDEOLOGY';
--UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_MIGRATION_TREATY';
--UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_GLOBAL_ENERGY_TREATY';
--UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_ARMS_CONTROL';
--UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_HERITAGE_ORG';
--UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_PUBLIC_WORKS';
--UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_DEFORESTATION_TREATY';



--==============================================================
--******				  PANTHEONS						  ******
--==============================================================
-- reeds and marshes works with all floodplains (see egypt for ReqArgs)
INSERT INTO RequirementSetRequirements 
    (RequirementSetId, RequirementId)
    VALUES
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND'),
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS');



--==============================================================
--******				START BIASES					  ******
--==============================================================
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_PHOENICIA' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_MALI' AND TerrainType='TERRAIN_DESERT_HILLS';
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_MALI' AND TerrainType='TERRAIN_DESERT';
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_CANADA' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_CANADA' AND TerrainType='TERRAIN_TUNDRA';
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_CANADA' AND TerrainType='TERRAIN_SNOW_HILLS';
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_CANADA' AND TerrainType='TERRAIN_SNOW';
UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_HUNGARY';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_INCA' AND TerrainType='TERRAIN_DESERT_MOUNTAIN';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_INCA' AND TerrainType='TERRAIN_GRASS_MOUNTAIN';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_INCA' AND TerrainType='TERRAIN_PLAINS_MOUNTAIN';



--==============================================================
--******			  U N I T S  (NON-UNIQUE)			  ******
--==============================================================
UPDATE Units SET StrategicResource='RESOURCE_NITER' WHERE UnitType='UNIT_INFANTRY';
UPDATE Units_XP2 SET ResourceMaintenanceType='RESOURCE_NITER' WHERE UnitType='UNIT_INFANTRY';
UPDATE Units SET PrereqTech='TECH_STEEL' WHERE UnitType='UNIT_ANTIAIR_GUN';
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	VALUES ('SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'SIEGE_DEFENSE_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT', 'Amount', '10');
INSERT INTO ModifierStrings (ModifierId, Context, Text)
	VALUES ('SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT', 'Preview', '+{1_Amount} Combat Strength against ranged attacks');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES ('SIEGE_DEFENSE_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('SIEGE_DEFENSE_REQUIREMENTS', 'RANGED_COMBAT_REQUIREMENTS');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES ('SIEGE_DEFENSE_REQUIREMENTS', 'PLAYER_IS_DEFENDER_REQUIREMENTS');
INSERT INTO Types (Type, Kind)
	VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'KIND_ABILITY');
INSERT INTO TypeTags (Type , Tag)
	VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'CLASS_SIEGE');
INSERT INTO UnitAbilities (UnitAbilityType , Name , Description)
	VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'LOC_ABILITY_SIEGE_RANGED_DEFENSE_NAME', 'LOC_ABILITY_SIEGE_RANGED_DEFENSE_DESCRIPTION');
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
	VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT');

-- -10 combat strength to all airplanes (P-51 change in America section)
UPDATE Units SET Combat=70,  RangedCombat=65  WHERE UnitType='UNIT_BIPLANE';
UPDATE Units SET Combat=90,  RangedCombat=90  WHERE UnitType='UNIT_FIGHTER';
UPDATE Units SET Combat=100, RangedCombat=100 WHERE UnitType='UNIT_JET_FIGHTER';
UPDATE Units SET Combat=75,  Bombard=100 	  WHERE UnitType='UNIT_BOMBER';
UPDATE Units SET Combat=80,  Bombard=110      WHERE UnitType='UNIT_JET_BOMBER';



--==============================================================
--******					W A L L S					  ******
--==============================================================
UPDATE Buildings SET OuterDefenseHitPoints=50 WHERE BuildingType = 'BUILDING_WALLS';
UPDATE Buildings SET OuterDefenseHitPoints=50 WHERE BuildingType = 'BUILDING_STAR_FORT';
UPDATE Buildings SET OuterDefenseHitPoints=50 WHERE BuildingType = 'BUILDING_CASTLE';
UPDATE Buildings SET OuterDefenseHitPoints=75 WHERE BuildingType = 'BUILDING_TSIKHE';
UPDATE ModifierArguments SET Value='200' WHERE ModifierId='STEEL_UNLOCK_URBAN_DEFENSES';



--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
UPDATE Feature_YieldChanges SET YieldChange='4' WHERE FeatureType='FEATURE_GOBUSTAN'       AND YieldType='YIELD_CULTURE'   ;
UPDATE Feature_YieldChanges SET YieldChange='4' WHERE FeatureType='FEATURE_GOBUSTAN'       AND YieldType='YIELD_PRODUCTION';
UPDATE Feature_YieldChanges SET YieldChange='2' WHERE FeatureType='FEATURE_WHITEDESERT'    AND YieldType='YIELD_CULTURE'   ;
UPDATE Feature_YieldChanges SET YieldChange='2' WHERE FeatureType='FEATURE_WHITEDESERT'    AND YieldType='YIELD_SCIENCE'   ;
UPDATE Feature_YieldChanges SET YieldChange='6' WHERE FeatureType='FEATURE_WHITEDESERT'    AND YieldType='YIELD_GOLD'      ;
UPDATE Feature_YieldChanges SET YieldChange='3' WHERE FeatureType='FEATURE_CHOCOLATEHILLS' AND YieldType='YIELD_FOOD'      ;
UPDATE Feature_YieldChanges SET YieldChange='3' WHERE FeatureType='FEATURE_CHOCOLATEHILLS' AND YieldType='YIELD_PRODUCTION';
UPDATE Feature_YieldChanges SET YieldChange='1' WHERE FeatureType='FEATURE_CHOCOLATEHILLS' AND YieldType='YIELD_SCIENCE'   ;
UPDATE Feature_AdjacentYields SET YieldChange='2' WHERE FeatureType='FEATURE_DEVILSTOWER' AND YieldType='YIELD_FAITH';



--==============================================================
--******				    O T H E R					  ******
--==============================================================
-- retinues policy card is 50% of resource cost for produced and upgrade units
INSERT INTO Modifiers (ModifierId, ModifierType)
	VALUES ('PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_MODIFIER_CPLMOD', 'MODIFIER_CITY_ADJUST_STRATEGIC_RESOURCE_REQUIREMENT_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_MODIFIER_CPLMOD', 'Amount', '50');
INSERT INTO Modifiers (ModifierId, ModifierType)
	VALUES ('PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_CPLMOD', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_CPLMOD', 'ModifierId', 'PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_MODIFIER_CPLMOD');
INSERT INTO PolicyModifiers (PolicyType, ModifierId)
	VALUES
	('POLICY_RETINUES', 'PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_CPLMOD'),
	('POLICY_FORCE_MODERNIZATION', 'PROFESSIONAL_ARMY_RESOURCE_DISCOUNT_CPLMOD');
-- get +1 resource when revealed (niter and above only)
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES
	('PLAYER_CAN_SEE_NITER_CPLMOD'		, 	'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_COAL_CPLMOD'		, 	'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_ALUMINUM_CPLMOD'	, 	'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_OIL_CPLMOD'		, 	'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_URANIUM_CPLMOD'	, 	'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES
	('PLAYER_CAN_SEE_NITER_CPLMOD'		, 'REQUIRES_PLAYER_CAN_SEE_NITER'),
	('PLAYER_CAN_SEE_COAL_CPLMOD'		, 'REQUIRES_PLAYER_CAN_SEE_COAL'),
	('PLAYER_CAN_SEE_ALUMINUM_CPLMOD'	, 'REQUIRES_PLAYER_CAN_SEE_ALUMINUM'),
	('PLAYER_CAN_SEE_OIL_CPLMOD'		, 'REQUIRES_PLAYER_CAN_SEE_OIL'),
	('PLAYER_CAN_SEE_URANIUM_CPLMOD'	, 'REQUIRES_PLAYER_CAN_SEE_URANIUM');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	VALUES
	('NITER_BASE_AMOUNT_MODIFIER'	, 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_NITER_CPLMOD'),
	('COAL_BASE_AMOUNT_MODIFIER'	, 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_COAL_CPLMOD'),
	('ALUMINUM_BASE_AMOUNT_MODIFIER', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_ALUMINUM_CPLMOD'),
	('OIL_BASE_AMOUNT_MODIFIER'		, 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_OIL_CPLMOD'),
	('URANIUM_BASE_AMOUNT_MODIFIER'	, 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_URANIUM_CPLMOD');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES
	('NITER_BASE_AMOUNT_MODIFIER'	, 'ResourceType', 'RESOURCE_NITER'),
	('NITER_BASE_AMOUNT_MODIFIER'	, 'Amount', '1'),
	('COAL_BASE_AMOUNT_MODIFIER'	, 'ResourceType', 'RESOURCE_COAL'),
	('COAL_BASE_AMOUNT_MODIFIER'	, 'Amount', '1'),
	('ALUMINUM_BASE_AMOUNT_MODIFIER', 'ResourceType', 'RESOURCE_ALUMINUM'),
	('ALUMINUM_BASE_AMOUNT_MODIFIER', 'Amount', '1'),
	('OIL_BASE_AMOUNT_MODIFIER'		, 'ResourceType', 'RESOURCE_OIL'),
	('OIL_BASE_AMOUNT_MODIFIER'		, 'Amount', '1'),
	('URANIUM_BASE_AMOUNT_MODIFIER'	, 'ResourceType', 'RESOURCE_URANIUM'),
	('URANIUM_BASE_AMOUNT_MODIFIER'	, 'Amount', '1');
INSERT INTO TraitModifiers (TraitType, ModifierId)
	VALUES
	('TRAIT_LEADER_MAJOR_CIV', 'NITER_BASE_AMOUNT_MODIFIER'),
	('TRAIT_LEADER_MAJOR_CIV', 'COAL_BASE_AMOUNT_MODIFIER'),
	('TRAIT_LEADER_MAJOR_CIV', 'ALUMINUM_BASE_AMOUNT_MODIFIER'),
	('TRAIT_LEADER_MAJOR_CIV', 'OIL_BASE_AMOUNT_MODIFIER'),
	('TRAIT_LEADER_MAJOR_CIV', 'URANIUM_BASE_AMOUNT_MODIFIER');
--can't go minus favor from grievances
UPDATE GlobalParameters SET Value='0' WHERE Name='FAVOR_GRIEVANCES_MINIMUM';
-- additional niter spawn locations
INSERT INTO Resource_ValidFeatures (ResourceType , FeatureType)
	VALUES ('RESOURCE_NITER' , 'FEATURE_FLOODPLAINS');
UPDATE Improvement_ValidResources SET MustRemoveFeature=0 WHERE ImprovementType='IMPROVEMENT_MINE' AND ResourceType='RESOURCE_ALUMINUM';
-- Research Labs give +5 base Science instead of +3
UPDATE Building_YieldChanges SET YieldChange=5 WHERE BuildingType='BUILDING_RESEARCH_LAB';

-- citizen yields
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_GOLD' AND DistrictType="DISTRICT_COTHON";
UPDATE District_CitizenYieldChanges SET YieldChange=4 WHERE YieldType='YIELD_GOLD' AND DistrictType="DISTRICT_SUGUBA";

-- GATHERING STORM WAR GOSSIP --
DELETE FROM Gossips WHERE GossipType='GOSSIP_MAKE_DOW';

-- Give production for Medieval Naval Units for all applicable policies
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES
	('MEDIEVAL_NAVAL_MELEE_PRODUCTION_CPLMOD'  , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('MEDIEVAL_NAVAL_RAIDER_PRODUCTION_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('MEDIEVAL_NAVAL_RANGED_PRODUCTION_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra)
	VALUES
	('MEDIEVAL_NAVAL_MELEE_PRODUCTION_CPLMOD'  , 'UnitPromotionClass' , 'PROMOTION_CLASS_NAVAL_MELEE'  , '-1'),
	('MEDIEVAL_NAVAL_MELEE_PRODUCTION_CPLMOD'  , 'EraType'            , 'ERA_MEDIEVAL'                 , '-1'),
	('MEDIEVAL_NAVAL_MELEE_PRODUCTION_CPLMOD'  , 'Amount'             , '100'                          , '-1'),
	('MEDIEVAL_NAVAL_RAIDER_PRODUCTION_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_NAVAL_RAIDER' , '-1'),
	('MEDIEVAL_NAVAL_RAIDER_PRODUCTION_CPLMOD' , 'EraType'            , 'ERA_MEDIEVAL'                 , '-1'),
	('MEDIEVAL_NAVAL_RAIDER_PRODUCTION_CPLMOD' , 'Amount'             , '100'                          , '-1'),
	('MEDIEVAL_NAVAL_RANGED_PRODUCTION_CPLMOD' , 'UnitPromotionClass' , 'PROMOTION_CLASS_NAVAL_RANGED' , '-1'),
	('MEDIEVAL_NAVAL_RANGED_PRODUCTION_CPLMOD' , 'EraType'            , 'ERA_MEDIEVAL'                 , '-1'),
	('MEDIEVAL_NAVAL_RANGED_PRODUCTION_CPLMOD' , 'Amount'             , '100'                          , '-1');
INSERT INTO PolicyModifiers (PolicyType , ModifierId)
	VALUES
	('POLICY_INTERNATIONAL_WATERS' , 'MEDIEVAL_NAVAL_MELEE_PRODUCTION_CPLMOD' ),
	('POLICY_INTERNATIONAL_WATERS' , 'MEDIEVAL_NAVAL_RAIDER_PRODUCTION_CPLMOD'),
	('POLICY_INTERNATIONAL_WATERS' , 'MEDIEVAL_NAVAL_RANGED_PRODUCTION_CPLMOD'),
	('POLICY_PRESS_GANGS'          , 'MEDIEVAL_NAVAL_MELEE_PRODUCTION_CPLMOD' ),
	('POLICY_PRESS_GANGS'          , 'MEDIEVAL_NAVAL_RAIDER_PRODUCTION_CPLMOD'),
	('POLICY_PRESS_GANGS'          , 'MEDIEVAL_NAVAL_RANGED_PRODUCTION_CPLMOD');

-- Offshore Oil can be improved at Refining
UPDATE Improvements SET PrereqTech='TECH_REFINING' WHERE ImprovementType='IMPROVEMENT_OFFSHORE_OIL_RIG';



