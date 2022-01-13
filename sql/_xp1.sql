-- --==============================================================
-- --******			C I V I L I Z A T I O N S			  ******
-- --==============================================================

--==============================================================
--******			  	B U I L D I N G S	 		  	  ******
--==============================================================
UPDATE Building_YieldChanges SET YieldChange=2 WHERE BuildingType='BUILDING_ORDU';
UPDATE ModifierArguments SET Value='6' WHERE ModifierId='SHOPPING_MALL_TOURISM';

--==============================================================
--******			 	  CITY-STATES		 		  	  ******
--==============================================================
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_UNIQUE_INFLUENCE_ARMORY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_ARMORY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_UNIQUE_INFLUENCE_MILITARY_ACADEMY_IDENTITY_BONUS';
DELETE FROM Modifiers WHERE ModifierId='MINOR_CIV_PRESLAV_MILITARY_ACADEMY_IDENTITY_BONUS';
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='MINOR_CIV_PRESLAV_BARRACKS_STABLE_IDENTITY_BONUS';
UPDATE ModifierArguments SET Value='40' WHERE ModifierId='MINOR_CIV_PRESLAV_BARRACKS_STABLE_IDENTITY_BONUS' AND Name='Amount';

--==============================================================
--******			  D E D I C A T I O N S				  ******
--==============================================================
-- To Arms +10 vs cities
INSERT INTO CommemorationModifiers (CommemorationType, ModifierId)
    VALUES ('COMMEMORATION_MILITARY', 'COMMEMORATION_MILITARY_GA_ATTACK_CITIES');
INSERT INTO Modifiers (ModifierId , ModifierType , OwnerRequirementSetId)
    VALUES ('COMMEMORATION_MILITARY_GA_ATTACK_CITIES' , 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY' , 'PLAYER_HAS_GOLDEN_AGE');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('COMMEMORATION_MILITARY_GA_ATTACK_CITIES' , 'AbilityType' , 'ABILITY_MILITARY_GA_BUFF');
INSERT INTO Types (Type, Kind) VALUES ('ABILITY_MILITARY_GA_BUFF', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_NAVAL_MELEE'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_NAVAL_RANGED'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_NAVAL_RAIDER'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_NAVAL_CARRIER'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_RECON'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_MELEE'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_RANGED'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_SIEGE'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_HEAVY_CAVALRY'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_LIGHT_CAVALRY'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_RANGED_CAVALRY'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_ANTI_CAVALRY'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_HEAVY_CHARIOT'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_LIGHT_CHARIOT'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_WARRIOR_MONK'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_WAR_CART'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_AIRCRAFT'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_AIR_BOMBER'),
	('ABILITY_MILITARY_GA_BUFF', 'CLASS_AIR_FIGHTER');
INSERT INTO UnitAbilities (UnitAbilityType, Name, Description, Inactive) VALUES
	('ABILITY_MILITARY_GA_BUFF', 'LOC_ABILITY_MILITARY_GA_BUFF_NAME', 'LOC_ABILITY_MILITARY_GA_BUFF_DESCRIPTION', 1);
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
	('ABILITY_MILITARY_GA_BUFF', 'MOD_MILITARY_GA_BUFF');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('MOD_MILITARY_GA_BUFF', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'UNIT_ATTACKING_DISTRICT_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('MOD_MILITARY_GA_BUFF', 'Amount', '10');
INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES
('MOD_MILITARY_GA_BUFF', 'Preview', 'LOC_MILITARY_GA_BUFF_DESCRIPTION');
-- Sic Hunt Dracones works on all new cities, not just diff continent
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_CITIES_ADD_POPULATION', NewOnly=1, Permanent=1 WHERE ModifierId='COMMEMORATION_EXPLORATION_GA_NEW_CITY_POPULATION';
-- Monumentality discount reduced from 30% to 10%
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='COMMEMORATION_INFRASTRUCTURE_BUILDER_DISCOUNT_MODIFIER' AND Name='Amount';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='COMMEMORATION_INFRASTRUCTURE_SETTLER_DISCOUNT_MODIFIER' AND Name='Amount';
-- Pen and Brush gives +2 Culture and +1 Gold per District
INSERT INTO Modifiers (ModifierId , ModifierType , OwnerRequirementSetId)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT' , 'PLAYER_HAS_GOLDEN_AGE');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'YieldType' , 'YIELD_GOLD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'Amount' , '1');
INSERT INTO CommemorationModifiers (CommemorationType, ModifierId)
	VALUES ('COMMEMORATION_CULTURAL', 'COMMEMORATION_CULTURAL_DISTRICTGOLD');
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='COMMEMORATION_CULTURAL_DISTRICTCULTURE' and Name='Amount';

--==============================================================
--******				G O V E R N M E N T				  ******
--==============================================================
-- Audience Hall gets +3 Food and +3 Housing instead of +4 Housing
INSERT INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_GOV_TALL' , 'GOV_TALL_FOOD_BUFF');
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='GOV_TALL_HOUSING_BUFF';
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE' , 'CITY_HAS_GOVERNOR_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'YieldType' , 'YIELD_FOOD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'Amount' , '3');
--Warlord's Throne gives +25% production to naval and land military units... also reduces unit maintenance by 1
DELETE FROM BuildingModifiers WHERE ModifierId='GOV_PRODUCTION_BOOST_FROM_CAPTURE';
DELETE FROM ModifierArguments WHERE ModifierId='GOV_PRODUCTION_BOOST_FROM_CAPTURE';
DELETE FROM Modifiers WHERE ModifierId='GOV_PRODUCTION_BOOST_FROM_CAPTURE';
INSERT INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES
	('BUILDING_GOV_CONQUEST' , 'GOV_CONQUEST_PRODUCTION_BONUS'),
	('BUILDING_GOV_CONQUEST' , 'GOV_CONQUEST_REDUCED_MAINTENANCE');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION'),
	('GOV_CONQUEST_REDUCED_MAINTENANCE' , 'MODIFIER_PLAYER_ADJUST_UNIT_MAINTENANCE_DISCOUNT'       );
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'Amount'   , '25'             ),
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'StartEra' , 'ERA_ANCIENT'    ),
	('GOV_CONQUEST_PRODUCTION_BONUS'    , 'EndEra'   , 'ERA_INFORMATION'),
	('GOV_CONQUEST_REDUCED_MAINTENANCE' , 'Amount'   , '1'              );
-- Foreign Ministry gets +2 influence per turn and 2 envoys
INSERT INTO BuildingModifiers
    (BuildingType            , ModifierId)
    VALUES
    ('BUILDING_GOV_CITYSTATES' , 'GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'),
	('BUILDING_GOV_CITYSTATES' , 'FOREIGN_MINISTRY_ENVOYS');
INSERT INTO Modifiers
    (ModifierId                                 , ModifierType)
    VALUES
    ('GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'   , 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN'),
	('FOREIGN_MINISTRY_ENVOYS'					, 'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN');
INSERT INTO ModifierArguments
    (ModifierId                                 , Name                      , Value)
    VALUES
    ('GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'   , 'Amount'                  , '2'),
	('FOREIGN_MINISTRY_ENVOYS'					, 'Amount'					, '2');

--==============================================================
--******				G O V E R N O R S				  ******
--==============================================================
-- Victor combat bonus reduced to +3
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='GARRISON_COMMANDER_ADJUST_CITY_COMBAT_BONUS' AND Name='Amount';
-- Magnus' Surplus Logistics gives +2 production in addition to the food
INSERT INTO Modifiers
	(ModifierId , ModifierType)
	VALUES
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD' , 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments
	(ModifierId , Name , Value)
	VALUES
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'Amount', '2'),
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'Domestic', '1'),
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'YieldType', 'YIELD_PRODUCTION');
INSERT INTO GovernorPromotionModifiers
	(GovernorPromotionType, ModifierId)
	VALUES
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS', 'SURPLUS_LOGISTICS_TRADE_ROUTE_PROD');
-- switch Magnus' level 2 promos
UPDATE GovernorPromotions SET Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
UPDATE GovernorPromotions SET Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';

--==============================================================
--******				PANTHEONS					  ******
--==============================================================
-- Lady of the Reeds and Marshes now applies ubsunur
INSERT INTO RequirementSetRequirements
    (RequirementSetId              , RequirementId)
    VALUES
    ('PLOT_HAS_REEDS_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'    );
INSERT INTO Requirements
    (RequirementId                          , RequirementType)
    VALUES
    ('REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'     , 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT INTO RequirementArguments
    (RequirementId                          , Name          , Value)
    VALUES
    ('REQUIRES_PLOT_HAS_UBSUNUR_HOLLOW'     , 'FeatureType' , 'FEATURE_UBSUNUR_HOLLOW'       );

	--==============================================================
--******				S  C  O  R  E				  	  ******
--==============================================================
-- no double counting for era points
UPDATE ScoringLineItems SET Multiplier=0 WHERE LineItemType='LINE_ITEM_ERA_SCORE';

--==============================================================
--******				START BIASES					  ******
--==============================================================

--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- scott research station can be built and works in tundra
INSERT INTO Building_ValidTerrains (BuildingType, TerrainType) VALUES
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'TERRAIN_TUNDRA'),
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'TERRAIN_TUNDRA_HILLS');
UPDATE RequirementArguments SET Value='TERRAIN_TUNDRA' WHERE RequirementId='REQUIRES_CITY_HAS_5_SNOW' AND Name='TerrainType';
-- St. Basil gives 1 relic
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_ST_BASILS_CATHEDRAL', 'WONDER_GRANT_RELIC_BBG');

--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- Eye of the Sahara gets 2 Food, 2 Production, and 2 Science
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='EYESAHARA_PRODUCTION_ATOMIC' AND Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='EYESAHARA_SCIENCE_ATOMIC' AND Name='Amount';
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
		VALUES ('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_PRODUCTION';
-- need insert OR IGNORE since they added science in GS
INSERT OR IGNORE INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_SCIENCE', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_SCIENCE';
-- lake retba
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_LAKE_RETBA', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_UBSUNUR_HOLLOW' AND YieldType='YIELD_PRODUCTION';
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_UBSUNUR_HOLLOW' AND YieldType='YIELD_FOOD';

--==============================================================
--******				    O T H E R					  ******
--==============================================================
-- Amani Abuse Fix... can immediately re-declare war when an enemy suzerian removes Amani
UPDATE GlobalParameters SET Value='1' WHERE Name='DIPLOMACY_PEACE_MIN_TURNS';
-- citizen yields
UPDATE District_CitizenYieldChanges SET YieldChange=2 WHERE YieldType='YIELD_PRODUCTION' 	AND DistrictType="DISTRICT_IKANDA";
UPDATE District_CitizenYieldChanges SET YieldChange=3 WHERE YieldType='YIELD_SCIENCE' 		AND DistrictType="DISTRICT_SEOWON";
-- Offshore Oil can be improved at Plastics
UPDATE Improvements SET PrereqTech='TECH_PLASTICS' WHERE ImprovementType='IMPROVEMENT_OFFSHORE_OIL_RIG';
