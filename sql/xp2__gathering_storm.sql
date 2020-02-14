--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================
--==================
-- America
--==================
-- Reduce combat strength of mustangs due to them already having many extra combat bonuses over biplanes
UPDATE Units SET Combat=90 , RangedCombat=90 WHERE UnitType='UNIT_AMERICAN_P51';
-- rough rider is a cav replacement, so should cost horses
INSERT INTO Units_XP2 (UnitType , ResourceCost)
	VALUES ('UNIT_AMERICAN_ROUGH_RIDER' , 10);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_AMERICAN_ROUGH_RIDER';


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
-- no combat bonus for levied units
DELETE FROM ModifierArguments WHERE ModifierId='RAVEN_LEVY_COMBAT' AND Name='Amount' AND Value='5';
-- Huszars only +2 combat strength from each alliance instead of 3
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='HUSZAR_ALLIES_COMBAT_BONUS';
-- Black Army only +2 combat strength from adjacent levied units
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='BLACK_ARMY_ADJACENT_LEVY';
-- Only 1 extra movement for levied units
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='RAVEN_LEVY_MOVEMENT';



--==========
-- Inca
--==========
UPDATE Units SET RangedCombat=30 WHERE UnitType='UNIT_INCA_WARAKAQ';



--==========
-- India
--==========
-- Varu upgrades to 
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CUIRASSIER' WHERE Unit='UNIT_INDIAN_VARU';



--==================
-- Kongo
--==================
UPDATE Units_XP2 SET ResourceCost=10 WHERE UnitType='UNIT_KONGO_SHIELD_BEARER';


--==========
-- Mali
--==========



--==================
-- Maori
--==================
UPDATE Units SET Maintenance=2, Combat=40 WHERE UnitType='UNIT_MAORI_TOA';



--==================
-- Ottoman
--==================
-- Great Bazaar is now a Market replacement
DELETE FROM BuildingPrereqs WHERE Building='BUILDING_GRAND_BAZAAR';
UPDATE BuildingReplaces SET ReplacesBuildingType='BUILDING_MARKET' WHERE CivUniqueBuildingType='BUILDING_GRAND_BAZAAR'; 
UPDATE Building_YieldChanges SET YieldChange=3 WHERE BuildingType='BUILDING_GRAND_BAZAAR';
UPDATE Buildings SET PrereqTech='TECH_CURRENCY', Cost=100 WHERE BuildingType='BUILDING_GRAND_BAZAAR';
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
	VALUES ('BUILDING_GRAND_BAZAAR', 'MARKET_TRADE_ROUTE_CAPACITY');



--==================
-- Sweden
--==================
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES
	('TRAIT_CIVILIZATION_NOBEL_PRIZE' , 'NOBEL_PRIZE_UNIVERISTY_BOOST' ),
	('TRAIT_CIVILIZATION_NOBEL_PRIZE' , 'NOBEL_PRIZE_FACTORY_BOOST' );
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES
	('NOBEL_PRIZE_UNIVERISTY_BOOST' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION' , null),
	('NOBEL_PRIZE_FACTORY_BOOST' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION' , null);
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra , SecondExtra)
	VALUES 
	('NOBEL_PRIZE_UNIVERISTY_BOOST' , 'BuildingType' , 'BUILDING_UNIVERSITY' , null , null),
	('NOBEL_PRIZE_UNIVERISTY_BOOST' , 'Amount'       , '50'                  , null , null),
	('NOBEL_PRIZE_FACTORY_BOOST'    , 'BuildingType' , 'BUILDING_FACTORY'    , null , null),
	('NOBEL_PRIZE_FACTORY_BOOST'    , 'Amount'       , '50'                  , null , null);


--==============================================================
--******				  DIPLOMACY						  ******
--==============================================================
UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_DIPLOVICTORY';
UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_WORLD_IDEOLOGY';
UPDATE Resolutions SET EarliestEra='ERA_MEDIEVAL' WHERE ResolutionType='WC_RES_MIGRATION_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_GLOBAL_ENERGY_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_RENAISSANCE' WHERE ResolutionType='WC_RES_ESPIONAGE_PACT';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_HERITAGE_ORG';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_PUBLIC_WORKS';
UPDATE Resolutions SET EarliestEra='ERA_INDUSTRIAL' WHERE ResolutionType='WC_RES_DEFORESTATION_TREATY';
UPDATE Resolutions SET EarliestEra='ERA_MODERN' WHERE ResolutionType='WC_RES_ARMS_CONTROL';
DELETE FROM Resolutions WHERE ResolutionType='WC_RES_PUBLIC_RELATIONS';



--==============================================================
--******				G O V E R N M E N T				  ******
--==============================================================
UPDATE Governments SET OtherGovernmentIntolerance=0 WHERE GovernmentType='GOVERNMENT_DEMOCRACY';
UPDATE Governments SET OtherGovernmentIntolerance=0 WHERE GovernmentType='GOVERNMENT_DIGITAL_DEMOCRACY';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_FASCISM';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_COMMUNISM';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_CORPORATE_LIBERTARIANISM';
UPDATE Governments SET OtherGovernmentIntolerance=-40 WHERE GovernmentType='GOVERNMENT_SYNTHETIC_TECHNOCRACY';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='COLLECTIVIZATION_INTERNAL_TRADE_PRODUCTION' AND Name='Amount';



--==============================================================
--******				  PANTHEONS						  ******
--==============================================================
-- reeds and marshes works with all floodplains (see egypt for ReqArgs)
INSERT INTO RequirementSetRequirements 
    (RequirementSetId, RequirementId)
    VALUES
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_FLOODPLAINS_GRASSLAND'),
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_FLOODPLAINS_PLAINS');
-- more faith for fire goddess and no district dmg from eruptions
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='GODDESS_OF_FIRE_FEATURES_FAITH_MODIFIER' AND Name='Amount';



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
UPDATE StartBiasFeatures SET Tier=4 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS_PLAINS';
UPDATE StartBiasFeatures SET Tier=4 WHERE CivilizationType='CIVILIZATION_EGYPT' AND FeatureType='FEATURE_FLOODPLAINS_GRASSLAND';
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
	VALUES ('SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT', 'Preview', '{LOC_SIEGE_RANGED_DEFENSE_DESCRIPTION}');
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
	VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'LOC_PROMOTION_TORTOISE_NAME', 'LOC_PROMOTION_TORTOISE_DESCRIPTION');
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
	VALUES ('ABILITY_SIEGE_RANGED_DEFENSE', 'SIEGE_DEFENSE_BONUS_VS_RANGED_COMBAT');

-- -10 combat strength to all airplanes (P-51 change in America section)
UPDATE Units SET Combat=70,  RangedCombat=65  WHERE UnitType='UNIT_BIPLANE';
UPDATE Units SET Combat=90,  RangedCombat=90  WHERE UnitType='UNIT_FIGHTER';
UPDATE Units SET Combat=100, RangedCombat=100 WHERE UnitType='UNIT_JET_FIGHTER';
UPDATE Units SET Combat=75,  Bombard=100 	  WHERE UnitType='UNIT_BOMBER';
UPDATE Units SET Combat=80,  Bombard=110      WHERE UnitType='UNIT_JET_BOMBER';



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
-- statue of liberty text fix
UPDATE Buildings SET Description='LOC_BUILDING_STATUE_LIBERTY_EXPANSION2_DESCRIPTION' WHERE BuildingType='BUILDING_STATUE_LIBERTY';
-- oil available on all floodplains
INSERT INTO Resource_ValidFeatures (ResourceType , FeatureType)
	VALUES
	('RESOURCE_OIL' , 'FEATURE_FLOODPLAINS_GRASSLAND'),
	('RESOURCE_OIL' , 'FEATURE_FLOODPLAINS_PLAINS');
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



--==============================================================
--******				G O V E R N O R S				  ******
--==============================================================
-- delete scrapped abilities
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
-- 15% culture moved to moksha
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_BISHOP' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN' AND 'LIBRARIAN_CULTURE_YIELD_BONUS';
-- move Moksha's abilities
UPDATE GovernorPromotions SET Level=2, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT';
UPDATE GovernorPromotions SET Level=2, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';
-- Curator moved to last moksha ability
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_CARDINAL' WHERE GovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
UPDATE GovernorPromotions SET Column=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('GOVERNOR_PROMOTION_MERCHANT_CURATOR', 'GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT'),
		('GOVERNOR_PROMOTION_MERCHANT_CURATOR', 'GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT');
-- Move +1 Culture to Moksha
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_CARDINAL' WHERE GovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
UPDATE GovernorPromotions SET Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
UPDATE GovernorPromotionPrereqs SET GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_BISHOP' WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';

-- move Pingala's 100% GPP to first on left ability
UPDATE GovernorPromotions SET Level=1, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('GOVERNOR_PROMOTION_EDUCATOR_GRANTS', 'GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN');
-- create Pingala's science from trade routes ability and apply to middle left ability
INSERT INTO Modifiers (ModifierId, ModifierType)
	VALUES
		('EDUCATOR_SCIENCE_FROM_INCOMING_TRADE_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FROM_OTHERS'),
		('EDUCATOR_SCIENCE_TO_OUTGOING_TRADE_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES
		('EDUCATOR_SCIENCE_FROM_INCOMING_TRADE_BBG', 'Amount', 2),
		('EDUCATOR_SCIENCE_FROM_INCOMING_TRADE_BBG', 'YieldType', 'YIELD_SCIENCE'),
		('EDUCATOR_SCIENCE_TO_OUTGOING_TRADE_BBG', 'Amount', 2),
		('EDUCATOR_SCIENCE_TO_OUTGOING_TRADE_BBG', 'YieldType', 'YIELD_SCIENCE');
INSERT INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion)
	VALUES
		('GOVERNOR_THE_EDUCATOR', 'GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column, BaseAbility)
	VALUES
		('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'Shared Knowledge', '+2 Science from foriegn trade routes for both parties', 2, 2, 0);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
	VALUES
		('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'EDUCATOR_SCIENCE_FROM_INCOMING_TRADE_BBG'),
		('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'EDUCATOR_SCIENCE_TO_OUTGOING_TRADE_BBG');
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';
UPDATE GovernorPromotions SET Column=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER'),
		('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG');
-- Pingala's double adajacency Promo
INSERT INTO Modifiers (ModifierId, ModifierType)
	VALUES
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'Amount', '100'),
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'YieldType', 'YIELD_SCIENCE');
INSERT INTO Types (Type, Kind) VALUES ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion)
	VALUES
		('GOVERNOR_THE_EDUCATOR', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column, BaseAbility)
	VALUES
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'Eureka', 'Double Campus Adjacency', 2, 0, 0);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
	VALUES
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG');
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'GOVERNOR_PROMOTION_EDUCATOR_GRANTS'),
		('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG');

-- Amani's changed 1st right ability
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE';
INSERT INTO GovernorPromotionModifiers VALUES
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'NITER_BASE_AMOUNT_MODIFIER'	  ),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'COAL_BASE_AMOUNT_MODIFIER'	  ),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'ALUMINUM_BASE_AMOUNT_MODIFIER'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'OIL_BASE_AMOUNT_MODIFIER'	  ),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'URANIUM_BASE_AMOUNT_MODIFIER' );
-- new 1st on left promo for Amani
INSERT INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_AMBASSADOR', 'GOVERNOR_PROMOTION_NEGOTIATOR_BBG');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column)
	VALUES
		('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'Negotiator', 'City cannot be put under Siege and gains +5 City Defense Strength', 1, 0);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
	VALUES
		('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'GARRISON_COMMANDER_ADJUST_CITY_COMBAT_BONUS'),
		('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENSE_LOGISTICS_SIEGE_PROTECTION');
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER');
-- move Amani's Emissary to 2nd on left
UPDATE GovernorPromotions SET Level=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER' WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_NEGOTIATOR_BBG' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES
		('EMISSARY_IDENTITY_PRESSURE_TO_FOREIGN_CITIES', 'DomesticCities', '1');
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='EMISSARY_IDENTITY_PRESSURE_TO_FOREIGN_CITIES' AND Name='Amount';
-- Delete Amani's Foreign Investor
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
-- Correct Amani's Spies promo
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
		('GOVERNOR_PROMOTION_LOCAL_INFORMANTS', 'GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE');
UPDATE GovernorPromotions SET Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_LOCAL_INFORMANTS';

-- Reyna's new 3rd level right ability
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('MANAGER_BUILDING_GOLD_DISCOUNT_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_ALL_BUILDINGS_PURCHASE_COST');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('MANAGER_BUILDING_GOLD_DISCOUNT_BBG', 'Amount', '50');
INSERT INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_MANAGER_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_MERCHANT', 'GOVERNOR_PROMOTION_MANAGER_BBG');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column)
	VALUES
		('GOVERNOR_PROMOTION_MANAGER_BBG', 'Foreign Investor', '50% Gold discount on building purchases', 3, 2);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
	VALUES
		('GOVERNOR_PROMOTION_MANAGER_BBG', 'MANAGER_BUILDING_GOLD_DISCOUNT_BBG');
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('GOVERNOR_PROMOTION_MANAGER_BBG', 'GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR');
-- Delete Reyna's old one
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';

-- Magnus
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_COAL_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_OIL_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_NUCLEAR_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_RESOURCE_POWER_PROVIDED' AND Name='Amount';