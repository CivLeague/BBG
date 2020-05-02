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
UPDATE Improvements SET PrereqCivic='CIVIC_DIPLOMATIC_SERVICE' WHERE ImprovementType='IMPROVEMENT_ICE_HOCKEY_RINK';
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
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='HUSZAR_ALLIES_COMBAT_BONUS';
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
UPDATE Modifiers SET SubjectRequirementSetId='UNIT_IS_DOMAIN_LAND' WHERE ModifierId='TRAIT_MAORI_MANA_OCEAN';
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
	('VARU_ADJACENT_AT_WAR_REQUIREMENTS', 'REQUIRES_UNIT_IS_DOMAIN_LAND');
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
--******				  BUILDINGS						  ******
--==============================================================
UPDATE Building_YieldChanges SET YieldChange=6 WHERE BuildingType='BUILDING_FOSSIL_FUEL_POWER_PLANT' AND YieldType='YIELD_PRODUCTION';
UPDATE Building_YieldChanges SET YieldChange=8 WHERE BuildingType='BUILDING_POWER_PLANT' AND YieldType='YIELD_PRODUCTION';
UPDATE Building_YieldChanges SET YieldChange=6 WHERE BuildingType='BUILDING_POWER_PLANT' AND YieldType='YIELD_SCIENCE';



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
UPDATE Units_XP2 SET ResourceMaintenanceAmount=2 WHERE UnitType='UNIT_GIANT_DEATH_ROBOT';
UPDATE Units_XP2 SET StrategicResource='RESOURCE_OIL' WHERE UnitType='UNIT_HELICOPTER';
UPDATE Units SET ResourceMaintenanceAmount=0, ResourceCost=4, ResourceMaintenanceType=NULL WHERE UnitType='UNIT_HELICOPTER';
UPDATE Units SET Cost=200 WHERE UnitType='UNIT_KNIGHT';
UPDATE Units SET Cost=180 WHERE UnitType='UNIT_COURSER';
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
-- +2 oil from mil acadamies
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_MILITARY_ACADEMY', 'OIL_FROM_MIL_ACAD_BBG');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('OIL_FROM_MIL_ACAD_BBG', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_OIL_CPLMOD');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('OIL_FROM_MIL_ACAD_BBG', 'ResourceType', 'RESOURCE_OIL'),
	('OIL_FROM_MIL_ACAD_BBG', 'Amount', '2');
-- +2 alum from airports
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_AIRPORT', 'ALUM_FROM_AIRPORT_BBG');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('ALUM_FROM_AIRPORT_BBG', 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_ALUMINUM_CPLMOD');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('ALUM_FROM_AIRPORT_BBG', 'ResourceType', 'RESOURCE_ALUMINUM'),
	('ALUM_FROM_AIRPORT_BBG', 'Amount', '2');
-- Military Engineers get tunnels at military science
UPDATE Improvements SET PrereqTech='TECH_MILITARY_SCIENCE' WHERE ImprovementType='IMPROVEMENT_MOUNTAIN_TUNNEL';
-- Military Engineers can build roads without using charges
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_ANCIENT_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_INDUSTRIAL_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_MEDIEVAL_ROAD';
UPDATE Routes_XP2 SET BuildWithUnitChargeCost=0 WHERE RouteType='ROUTE_MODERN_ROAD';
-- fascism attack bonus working for GDR
INSERT INTO TypeTags (Type, Tag) VALUES ('ABILITY_FASCISM_ATTACK_BUFF', 'CLASS_GIANT_DEATH_ROBOT');
INSERT INTO TypeTags (Type, Tag) VALUES ('ABILITY_FASCISM_LEGACY_ATTACK_BUFF', 'CLASS_GIANT_DEATH_ROBOT');
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
-- delete moksha's scrapped abilities
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
-- 15% culture moved to moksha
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_BISHOP' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN' AND ModifierId='LIBRARIAN_CULTURE_YIELD_BONUS';
-- nerf bishop to +50% outgoing pressure
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='CARDINAL_BISHOP_PRESSURE' AND Name='Amount';
-- move Moksha's abilities
UPDATE GovernorPromotions SET Level=2, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT';
UPDATE GovernorPromotions SET Level=1, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
UPDATE GovernorPromotions SET Level=2, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
	('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD', 'GOVERNOR_PROMOTION_CARDINAL_BISHOP');
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';
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
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
	('GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR', 'GOVERNOR_PROMOTION_CARDINAL_BISHOP');
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT' AND PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';

-- move Pingala's 100% GPP to first on left ability
UPDATE GovernorPromotions SET Level=1, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('GOVERNOR_PROMOTION_EDUCATOR_GRANTS', 'GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN');
-- create Pingala's science from trade routes ability and apply to middle left ability
INSERT INTO Modifiers (ModifierId, ModifierType)
	VALUES
		('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES
		('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'Domestic', '1'),
		('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'Amount', '3'),
		('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'YieldType', 'YIELD_SCIENCE');
INSERT INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion)
	VALUES
		('GOVERNOR_THE_EDUCATOR', 'GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column, BaseAbility)
	VALUES
		('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_KNOWLEDGE_NAME', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_KNOWLEDGE_DESCRIPTION', 2, 2, 0);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
	VALUES
		('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG');
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
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_EUREKA_NAME', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_EUREKA_DESCRIPTION', 2, 0, 0);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
	VALUES
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG');
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'GOVERNOR_PROMOTION_EDUCATOR_GRANTS'),
		('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG');

-- Amani's changed 1st right ability
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE';
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
	VALUES
	('PLAYER_CAN_SEE_HORSES_CPLMOD'		, 	'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_IRON_CPLMOD'		, 	'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
	VALUES
	('PLAYER_CAN_SEE_HORSES_CPLMOD'	, 'REQUIRES_PLAYER_CAN_SEE_HORSES'),
	('PLAYER_CAN_SEE_IRON_CPLMOD'	, 'REQUIRES_PLAYER_CAN_SEE_IRON');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	VALUES
	('HORSES_BASE_AMOUNT_MODIFIER'	, 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_HORSES_CPLMOD'),
	('IRON_BASE_AMOUNT_MODIFIER'	, 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION', 'PLAYER_CAN_SEE_IRON_CPLMOD');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES
	('HORSES_BASE_AMOUNT_MODIFIER'	, 'ResourceType', 'RESOURCE_HORSES'),
	('HORSES_BASE_AMOUNT_MODIFIER'	, 'Amount', '1'),
	('IRON_BASE_AMOUNT_MODIFIER'	, 'ResourceType', 'RESOURCE_IRON'),
	('IRON_BASE_AMOUNT_MODIFIER'	, 'Amount', '1');
INSERT INTO GovernorPromotionModifiers VALUES
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'HORSES_BASE_AMOUNT_MODIFIER'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'IRON_BASE_AMOUNT_MODIFIER'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'NITER_BASE_AMOUNT_MODIFIER'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'COAL_BASE_AMOUNT_MODIFIER'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'ALUMINUM_BASE_AMOUNT_MODIFIER'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'OIL_BASE_AMOUNT_MODIFIER'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE', 'URANIUM_BASE_AMOUNT_MODIFIER');
-- new 1st on left promo for Amani
INSERT INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_AMBASSADOR', 'GOVERNOR_PROMOTION_NEGOTIATOR_BBG');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column)
	VALUES
		('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'LOC_GOVERNOR_PROMOTION_AMBASSADOR_NEGOTIATOR_NAME', 'LOC_GOVERNOR_PROMOTION_AMBASSADOR_NEGOTIATOR_DESCRIPTION', 1, 0);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
	VALUES
		('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH'),
		('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENSE_LOGISTICS_SIEGE_PROTECTION');
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES
		('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER');
-- move Amani's Emissary to 2nd on left
UPDATE GovernorPromotions SET Level=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER' WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_NEGOTIATOR_BBG' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
		('GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY', 'PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES');
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='EMISSARY_IDENTITY_PRESSURE_TO_FOREIGN_CITIES' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES' AND Name='Amount';
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
		('GOVERNOR_PROMOTION_MANAGER_BBG', 'LOC_GOVERNOR_PROMOTION_MERCHANT_INVESTOR_NAME', 'LOC_GOVERNOR_PROMOTION_MERCHANT_INVESTOR_DESCRIPTION', 3, 2);
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

-- Increase prod and power for Magnus Industrialist promo
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_COAL_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_OIL_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_NUCLEAR_POWER_PLANT_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='INDUSTRIALIST_RESOURCE_POWER_PROVIDED' AND Name='Amount';
-- Strategics required reduced to zero for Magnus Black Marketeer promo
UPDATE ModifierArguments SET Value='100' WHERE ModifierId='BLACK_MARKETEER_STRATEGIC_RESOURCE_COST_DISCOUNT' AND Name='Amount';

-- Liang
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='ZONING_COMMISSIONER_FASTER_DISTRICT_CONSTRUCTION' AND Name='Amount';
-- agriculture
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM Types WHERE Type='GOVERNOR_PROMOTION_AQUACULTURE';
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('AGRICULTURE_FOOD_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'AGRICULTURE_FOOD_BBG_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('AGRICULTURE_FOOD_BBG' , 'YieldType' , 'YIELD_FOOD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('AGRICULTURE_FOOD_BBG' , 'Amount' , '1');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('AGRICULTURE_FOOD_BBG_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('AGRICULTURE_FOOD_BBG_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
INSERT INTO Types (Type, Kind) VALUES ('AGRICULTURE_PROMOTION_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_BUILDER', 'AGRICULTURE_PROMOTION_BBG');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column)
	VALUES ('AGRICULTURE_PROMOTION_BBG', 'LOC_GOVERNOR_PROMOTION_AGRICULTURE_NAME', 'LOC_GOVERNOR_PROMOTION_AGRICULTURE_DESCRIPTION', 1, 2);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
	VALUES ('AGRICULTURE_PROMOTION_BBG', 'AGRICULTURE_FOOD_BBG');
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
	VALUES ('AGRICULTURE_PROMOTION_BBG', 'GOVERNOR_PROMOTION_BUILDER_GUILDMASTER');

-- +1 amenity and housing for districts
DELETE FROM Modifiers WHERE ModifierId='WATER_WORKS_NEIGHBORHOOD_HOUSING';
DELETE FROM ModifierArguments WHERE ModifierId='WATER_WORKS_NEIGHBORHOOD_HOUSING';
DELETE FROM Modifiers WHERE ModifierId='WATER_WORKS_CANAL_AMENITY';
DELETE FROM ModifierArguments WHERE ModifierId='WATER_WORKS_CANAL_AMENITY';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='WATER_WORKS_AQUEDUCT_HOUSING';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='WATER_WORKS_DAM_AMENITY';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='WATER_WORKS_AQUEDUCT_HOUSING' AND Name='Amount';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
	('GOVERNOR_PROMOTION_WATER_WORKS', 'AGRICULTURE_PROMOTION_BBG');
UPDATE GovernorPromotions SET Level=2, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_WATER_WORKS';

-- better parks
UPDATE Improvement_YieldChanges SET YieldChange=3 WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND YieldType='YIELD_CULTURE';
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
	('IMPROVEMENT_CITY_PARK', 'YIELD_SCIENCE', 3);
INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
	('IMPROVEMENT_CITY_PARK', 'YIELD_GOLD', 3);
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='CITY_PARK_WATER_AMENITY';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('CITY_PARK_HOUSING_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('CITY_PARK_HOUSING_BBG' , 'Amount' , '1');
INSERT INTO ImprovementModifiers (ImprovementType, ModifierID) VALUES
	('IMPROVEMENT_CITY_PARK', 'CITY_PARK_HOUSING_BBG');
DELETE FROM ImprovementModifiers WHERE ModifierID='CITY_PARK_GOVERNOR_CULTURE';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_DESERT_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_GRASS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_PLAINS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_SNOW_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE Improvements SET OnePerCity=1 WHERE ImprovementType='IMPROVEMENT_CITY_PARK';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_WATER_WORKS'
	WHERE GovernorPromotionType='GOVERNOR_PROMOTION_PARKS_RECREATION' AND PrereqGovernorPromotion='GOVERNOR_PROMOTION_WATER_WORKS';

-- add fishery to tech tree
UPDATE Improvements SET TraitType=NULL WHERE ImprovementType='IMPROVEMENT_FISHERY';
DELETE FROM ImprovementModifiers WHERE ImprovementType='IMPROVEMENT_FISHERY';
DELETE FROM Modifiers WHERE ModifierId='AQUACULTURE_CAN_BUILD_FISHERY';
DELETE FROM ModifierArguments WHERE ModifierId='AQUACULTURE_CAN_BUILD_FISHERY';
UPDATE Improvements SET PrereqTech='TECH_CARTOGRAPHY' WHERE ImprovementType='IMPROVEMENT_FISHERY';