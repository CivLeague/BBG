--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Georgia
--==================
-- Georgian Khevsur unit becomes sword replacement
UPDATE Units SET Combat=35, Cost=100, Maintenance=2, PrereqTech='TECH_IRON_WORKING' WHERE UnitType='UNIT_GEORGIAN_KHEVSURETI';
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='KHEVSURETI_HILLS_BUFF' AND Name='Amount';
INSERT INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
	VALUES ('UNIT_GEORGIAN_KHEVSURETI', 'UNIT_SWORDSMAN');
-- Georgia Tsikhe changed to a stronger Ancient Wall replacement instead of a Renaissance Wall replacement
DELETE FROM BuildingPrereqs WHERE Building='BUILDING_TSIKHE';
UPDATE BuildingReplaces SET ReplacesBuildingType='BUILDING_WALLS' WHERE CivUniqueBuildingType='BUILDING_TSIKHE';
UPDATE Buildings SET Cost=80 , PrereqTech='TECH_MASONRY' , OuterDefenseHitPoints=150 WHERE BuildingType='BUILDING_TSIKHE';
-- Georgia gets 50% faith kills instead of Protectorate War Bonus
INSERT INTO Modifiers (ModifierId, ModifierType)
	VALUES ('TRAIT_FAITH_KILLS_MODIFIER_CPLMOD' , 'MODIFIER_PLAYER_UNITS_ADJUST_POST_COMBAT_YIELD');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('TRAIT_FAITH_KILLS_MODIFIER_CPLMOD' , 'PercentDefeatedStrength' , '50');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	VALUES ('TRAIT_FAITH_KILLS_MODIFIER_CPLMOD' , 'YieldType' , 'YIELD_FAITH');
UPDATE TraitModifiers SET ModifierId='TRAIT_FAITH_KILLS_MODIFIER_CPLMOD' WHERE ModifierId='TRAIT_PROTECTORATE_WAR_FAITH';


--==================
-- India (Chandra)
--==================
-- replace Territorial Expansion Declaration Bonus with +1 movement
DELETE FROM TraitModifiers WHERE TraitType='TRAIT_LEADER_ARTHASHASTRA';

INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_ARTHASHASTRA' , 'TRAIT_EXPANSION_MOVEMENT_BONUS_CPLMOD');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('TRAIT_EXPANSION_MOVEMENT_BONUS_CPLMOD' , 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TRAIT_EXPANSION_MOVEMENT_BONUS_CPLMOD' , 'ModifierId', 'EXPANSION_MOVEMENT_BONUS_MODIFIER_CPLMOD');

INSERT INTO Modifiers (ModifierId , ModifierType , OwnerRequirementSetId)
	VALUES ('EXPANSION_MOVEMENT_BONUS_MODIFIER_CPLMOD' , 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT' , 'REQUIREMENTSET_LAND_MILITARY_CPLMOD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('EXPANSION_MOVEMENT_BONUS_MODIFIER_CPLMOD' , 'Amount' , '1');

INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('REQUIREMENTSET_LAND_MILITARY_CPLMOD' , 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('REQUIREMENTSET_LAND_MILITARY_CPLMOD' , 'REQUIREMENTS_LAND_MILITARY_CPLMOD');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('REQUIREMENTSET_LAND_MILITARY_CPLMOD' , 'REQUIRES_UNIT_IS_RELIGIOUS_ALL');
INSERT INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIREMENTS_LAND_MILITARY_CPLMOD', 'REQUIREMENT_UNIT_FORMATION_CLASS_MATCHES');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIREMENTS_LAND_MILITARY_CPLMOD' , 'UnitFormationClass' , 'FORMATION_CLASS_LAND_COMBAT');


--==================
-- Korea
--==================
-- Seowon gets +2 science base yield instead of 4, +1 for every 2 mines adjacent instead of 1 to 1
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='BaseDistrict_Science';
INSERT INTO Adjacency_YieldChanges
	(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement)
	VALUES ('Mine_Science', 'LOC_DISTRICT_MINE_SCIENCE', 'YIELD_SCIENCE', 1, 2, 'IMPROVEMENT_MINE');
INSERT INTO District_Adjacencies
	(DistrictType , YieldChangeId)
	VALUES ('DISTRICT_SEOWON', 'Mine_Science');
-- seowon gets +1 adjacency from theater squares instead of -1
INSERT INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
	VALUES
	('Theater_Science' , 'LOC_DISTRICT_SEOWON_THEATER_BONUS' , 'YIELD_SCIENCE' , '1' , '1' , 'DISTRICT_THEATER'),
	('Seowon_Culture'  , 'LOC_DISTRICT_THEATER_SEOWON_BONUS' , 'YIELD_CULTURE' , '1' , '1' , 'DISTRICT_SEOWON' );
INSERT INTO District_Adjacencies (DistrictType , YieldChangeId)
	VALUES
	('DISTRICT_SEOWON'  , 'Theater_Science'),
	('DISTRICT_THEATER' , 'Seowon_Culture' );


--==================
-- Mapuche
--==================
-- Combat bonus against Golden Age Civs set to 5 instead of 10
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='TRAIT_TOQUI_COMBAT_BONUS_VS_GOLDEN_AGE_CIV';
-- Malon Raiders become Horseman replacement and territory bonus replaced with +1 movement
UPDATE Units SET Combat=36 , Cost=90 , Maintenance=2 , BaseMoves=5 , PrereqTech='TECH_HORSEBACK_RIDING' , MandatoryObsoleteTech='TECH_SYNTHETIC_MATERIALS' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';
INSERT INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER' , 'UNIT_HORSEMAN');
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CAVALRY' WHERE Unit='UNIT_MAPUCHE_MALON_RAIDER';
DELETE FROM UnitAbilityModifiers WHERE ModifierId='MALON_RAIDER_TERRITORY_COMBAT_BONUS';
-- Chemamull Unique Improvement gets +1 Production (another at Civil Service Civic)
INSERT INTO Improvement_YieldChanges (ImprovementType , YieldType , YieldChange)
	VALUES ('IMPROVEMENT_CHEMAMULL' , 'YIELD_PRODUCTION' , 1);
INSERT INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('203' , 'IMPROVEMENT_CHEMAMULL' , 'YIELD_PRODUCTION' , '1' , 'CIVIC_CIVIL_SERVICE');


--=========
--Mongolia
--=========
-- No longer receives +1 diplo visibility for trading post
DELETE FROM TraitModifiers WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
DELETE FROM DiplomaticVisibilitySources WHERE VisibilitySourceType='SOURCE_TRADING_POST_TRAIT';
DELETE FROM DiplomaticVisibilitySources_XP1 WHERE VisibilitySourceType='SOURCE_TRADING_POST_TRAIT';
DELETE FROM ModifierArguments WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
DELETE FROM Modifiers WHERE ModifierId='TRAIT_TRADING_POST_DIPLO_VISIBILITY';
-- +100% production to Ordu
UPDATE Buildings SET Cost=60 WHERE BuildingType='BUILDING_ORDU';


--==================
-- Scotland
--==================
-- Golf Course moved to Games and Recreation
UPDATE Improvements SET PrereqCivic='CIVIC_GAMES_RECREATION' WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE';
-- Golf Course base yields are 1 Culture and 2 Gold... +1 to each if next to City Center (+1 Culture at Civil Service and +1 Gold at Guilds)
UPDATE Improvement_YieldChanges SET YieldChange=1 WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE' AND YieldType='YIELD_CULTURE';
-- Golf Course extra housing moved to Urbanization
UPDATE RequirementArguments SET Value='CIVIC_URBANIZATION' WHERE RequirementId='REQUIRES_PLAYER_HAS_GLOBALIZATION' AND Name='CivicType';
INSERT INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
	VALUES ('GOLFCOURSE_CITYCENTERADJACENCY_GOLD' , 'Placeholder' , 'YIELD_GOLD' , 1 , 1 , 'DISTRICT_CITY_CENTER');
INSERT INTO Improvement_Adjacencies (ImprovementType , YieldChangeId)
	VALUES ('IMPROVEMENT_GOLF_COURSE' , 'GOLFCOURSE_CITYCENTERADJACENCY_GOLD');
-- Golf Course gets extra yields a bit earlier
INSERT INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('204' , 'IMPROVEMENT_GOLF_COURSE' , 'YIELD_GOLD' , '1' , 'CIVIC_GUILDS');
INSERT INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('205' , 'IMPROVEMENT_GOLF_COURSE' , 'YIELD_CULTURE' , '1' , 'CIVIC_DIPLOMATIC_SERVICE');


--==================
-- Zulu
--==================
-- Zulu get corps/armies bonus at mobilization
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
    VALUES ('PLAYER_HAS_MOBILIZATION_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO Requirements (RequirementId, RequirementType)
    VALUES ('REQUIRES_PLAYER_HAS_MOBILIZATION' , 'REQUIREMENT_PLAYER_HAS_CIVIC');
INSERT INTO RequirementArguments (RequirementId , Name , Value)
    VALUES ('REQUIRES_PLAYER_HAS_MOBILIZATION' , 'CivicType' , 'CIVIC_MOBILIZATION');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
    VALUES ('PLAYER_HAS_MOBILIZATION_REQUIREMENTS' , 'REQUIRES_PLAYER_HAS_MOBILIZATION');
UPDATE Modifiers SET SubjectRequirementSetId='PLAYER_HAS_MOBILIZATION_REQUIREMENTS' WHERE ModifierId='TRAIT_LAND_CORPS_COMBAT_STRENGTH';
UPDATE Modifiers SET SubjectRequirementSetId='PLAYER_HAS_MOBILIZATION_REQUIREMENTS' WHERE ModifierId='TRAIT_LAND_ARMIES_COMBAT_STRENGTH';



--==============================================================
--******			  D E D I C A T I O N S				  ******
--==============================================================
-- Pen and Brush gives +2 Culture and +2 Gold per District
INSERT INTO Modifiers (ModifierId , ModifierType , OwnerRequirementSetId)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT' , 'PLAYER_HAS_GOLDEN_AGE');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'YieldType' , 'YIELD_GOLD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('COMMEMORATION_CULTURAL_DISTRICTGOLD' , 'Amount' , '2');
INSERT INTO CommemorationModifiers (CommemorationType, ModifierId)
	VALUES ('COMMEMORATION_CULTURAL', 'COMMEMORATION_CULTURAL_DISTRICTGOLD');
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='COMMEMORATION_CULTURAL_DISTRICTCULTURE' and Name='Amount';



--==============================================================
--******				G O V E R N M E N T				  ******
--==============================================================
-- Audience Hall gets +3 Food and +3 Housing instead of +4 Housing, and an extra gov title
INSERT INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_GOV_TALL' , 'GOV_TALL_FOOD_BUFF');
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='GOV_TALL_HOUSING_BUFF';
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE' , 'CITY_HAS_GOVERNOR_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'YieldType' , 'YIELD_FOOD');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('GOV_TALL_FOOD_BUFF' , 'Amount' , '3');
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='GOV_BUILDING_TALL_GRANT_GOVERNOR_POINTS' AND Name='Delta';
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
-- Foreign Ministry gets +2 influence per turn
INSERT INTO BuildingModifiers 
    (BuildingType            , ModifierId)
    VALUES 
    ('BUILDING_GOV_CITYSTATES' , 'GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD');
INSERT INTO Modifiers 
    (ModifierId                                 , ModifierType)
    VALUES 
    ('GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'   , 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN');
    
INSERT INTO ModifierArguments 
    (ModifierId                                 , Name                      , Value)
    VALUES 
    ('GOV_BUILDING_CS_BONUS_INFLUENCE_CPLMOD'   , 'Amount'                  , '2');



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
--******				START BIASES					  ******
--==============================================================
UPDATE StartBiasTerrains SET Tier=2 WHERE CivilizationType='CIVILIZATION_NETHERLANDS' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasResources SET Tier=3 WHERE CivilizationType='CIVILIZATION_MONGOLIA' AND ResourceType='RESOURCE_HORSES';
UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_NETHERLANDS';
INSERT INTO StartBiasTerrains (CivilizationType , TerrainType , Tier)
	VALUES
	('CIVILIZATION_GEORGIA' , 'TERRAIN_PLAINS_HILLS' , 4),
	('CIVILIZATION_GEORGIA' , 'TERRAIN_GRASS_HILLS' , 4);
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType='TERRAIN_GRASS_HILLS';
UPDATE StartBiasTerrains SET Tier=4 WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType='TERRAIN_PLAINS_HILLS';
UPDATE StartBiasTerrains SET Tier=5 WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE StartBiasTerrains SET Tier=5 WHERE CivilizationType='CIVILIZATION_KOREA' AND TerrainType='TERRAIN_DESERT_HILLS';
UPDATE StartBiasTerrains SET Tier=5 WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType='TERRAIN_PLAINS_MOUNTAIN';
UPDATE StartBiasTerrains SET Tier=5 WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType='TERRAIN_GRASS_MOUNTAIN';
UPDATE StartBiasTerrains SET Tier=5 WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType='TERRAIN_DESERT_MOUNTAIN';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_MAPUCHE' AND TerrainType='TERRAIN_TUNDRA_MOUNTAIN';



--==============================================================
--******			W O N D E R S  (NATURAL)			  ******
--==============================================================
-- Eye of the Sahara gets 2 Food, 2 Production, and 2 Science
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='EYESAHARA_PRODUCTION_ATOMIC' AND Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='EYESAHARA_SCIENCE_ATOMIC' AND Name='Amount';
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_FOOD', 2);
UPDATE Feature_YieldChanges SET YieldChange=2 WHERE FeatureType='FEATURE_EYE_OF_THE_SAHARA' AND YieldType='YIELD_PRODUCTION';
INSERT INTO Feature_YieldChanges (FeatureType, YieldType, YieldChange)
	VALUES ('FEATURE_EYE_OF_THE_SAHARA', 'YIELD_SCIENCE', 2);
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



