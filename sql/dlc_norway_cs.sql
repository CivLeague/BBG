--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Norway
--==================
-- Berserker no longer gets +10 on attack and -5 on defense... simplified to be base on defense and +15 on attack
UPDATE ModifierArguments SET Value='15' WHERE ModifierId='UNIT_STRONG_WHEN_ATTACKING';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='UNIT_WEAK_WHEN_DEFENDING';
-- Berserker unit now gets unlocked at Feudalism instead of Military Tactics, and can be purchased with Faith
UPDATE Units SET Combat=35 , PrereqTech=NULL , PrereqCivic='CIVIC_FEUDALISM' WHERE UnitType='UNIT_NORWEGIAN_BERSERKER';
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_CIVILIZATION_UNIT_NORWEGIAN_BERSERKER' , 'BERSERKER_FAITH_PURCHASE_CPLMOD');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('BERSERKER_FAITH_PURCHASE_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('BERSERKER_FAITH_PURCHASE_CPLMOD' , 'Tag' , 'CLASS_MELEE_BERSERKER');
--Berserker Movement bonus extended to all water tiles	
UPDATE RequirementSets SET RequirementSetType='REQUIREMENTSET_TEST_ANY' WHERE RequirementSetId='BERSERKER_PLOT_IS_ENEMY_TERRITORY';
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES 
	('BERSERKER_PLOT_IS_ENEMY_TERRITORY' , 'REQUIRES_PLOT_HAS_COAST'),
	('BERSERKER_PLOT_IS_ENEMY_TERRITORY' , 'REQUIRES_TERRAIN_OCEAN' );
-- Melee Naval production reduced to 25% from 50%
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_ANCIENT_NAVAL_MELEE_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_CLASSICAL_NAVAL_MELEE_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_MEDIEVAL_NAVAL_MELEE_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RENAISSANCE_NAVAL_MELEE_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_INDUSTRIAL_NAVAL_MELEE_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_MODERN_NAVAL_MELEE_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_ATOMIC_NAVAL_MELEE_PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_INFORMATION_NAVAL_MELEE_PRODUCTION' AND Name='Amount';
-- Stave Church now gives +1 Faith to resource tiles in the city, instead of standard adjacency bonus for woods
INSERT INTO Modifiers (ModifierID , ModifierType , SubjectRequirementSetId)
	VALUES ('STAVECHURCH_RESOURCE_FAITH' , 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD' , 'STAVE_CHURCH_RESOURCE_REQUIREMENTS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('STAVECHURCH_RESOURCE_FAITH' , 'YieldType' , 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('STAVECHURCH_RESOURCE_FAITH' , 'Amount' , '1');
INSERT INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_STAVE_CHURCH' , 'STAVECHURCH_RESOURCE_FAITH');
INSERT INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('STAVE_CHURCH_RESOURCE_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('STAVE_CHURCH_RESOURCE_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='STAVE_CHURCH_FAITHWOODSADJACENCY' AND Name='Amount';
-- +2 gold harbor adjacency if adjacent to holy sites
INSERT INTO ExcludedAdjacencies (YieldChangeId , TraitType)
    VALUES
    ('District_HS_Gold_Negative' , 'TRAIT_LEADER_MELEE_COASTAL_RAIDS');
INSERT INTO District_Adjacencies (DistrictType , YieldChangeId)
    VALUES
    ('DISTRICT_HARBOR' , 'District_HS_Gold_Positive'),
    ('DISTRICT_HARBOR' , 'District_HS_Gold_Negative');
INSERT INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
    VALUES
    ('District_HS_Gold_Positive' , 'LOC_HOLY_SITE_HARBOR_ADJACENCY_DESCRIPTION' , 'YIELD_GOLD' , '2'  , '1' , 'DISTRICT_HOLY_SITE'),
    ('District_HS_Gold_Negative' , 'LOC_HOLY_SITE_HARBOR_ADJACENCY_DESCRIPTION' , 'YIELD_GOLD' , '-2' , '1' , 'DISTRICT_HOLY_SITE');
-- Holy Sites coastal adjacency
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'DistrictType' , 'DISTRICT_HOLY_SITE'             			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'TerrainType'  , 'TERRAIN_COAST'                  			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'YieldType'    , 'YIELD_FAITH'                    			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'Amount'       , '1'                              			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'TilesRequired', '1'                              			 ),
	('TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY' , 'Description'  , 'LOC_DISTRICT_HOLY_SITE_NORWAY_COAST_FAITH');
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES
	('TRAIT_LEADER_MELEE_COASTAL_RAIDS' , 'TRAIT_LEADER_THUNDERBOLT_HOLYSITE_COASTAL_ADJACENCY');
-- +50% production towards Holy Sites and associated Buildings
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES 
	('TRAIT_LEADER_MELEE_COASTAL_RAIDS'          , 'THUNDERBOLT_HOLY_SITE_DISTRICT_BOOST'              ),
	('TRAIT_LEADER_MELEE_COASTAL_RAIDS'          , 'THUNDERBOLT_HOLY_SITE_BUILDING_BOOST'              );
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
	VALUES 
	('THUNDERBOLT_HOLY_SITE_DISTRICT_BOOST'               , 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION'                 , null                               ),
	('THUNDERBOLT_HOLY_SITE_BUILDING_BOOST'               , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION'                 , null                               );
INSERT INTO ModifierArguments (ModifierId , Name , Value , Extra , SecondExtra)
	VALUES 
	('THUNDERBOLT_HOLY_SITE_DISTRICT_BOOST'               , 'DistrictType' , 'DISTRICT_HOLY_SITE' , null , null),
	('THUNDERBOLT_HOLY_SITE_DISTRICT_BOOST'               , 'Amount'       , '50'                 , null , null),
	('THUNDERBOLT_HOLY_SITE_BUILDING_BOOST'               , 'DistrictType' , 'DISTRICT_HOLY_SITE' , null , null),
	('THUNDERBOLT_HOLY_SITE_BUILDING_BOOST'               , 'Amount'       , '50'                 , null , null);


--==============================================================
--******				START BIASES					  ******
--==============================================================
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_NORWAY' AND TerrainType='TERRAIN_COAST';




