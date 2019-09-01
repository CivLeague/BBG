--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================
--==================
-- Khmer
--==================
-- Domrey Unique Unit will now be a Catapult replacement that has a higher melee strength and bombard strength
UPDATE Units SET Combat=28, Bombard=40, Cost=140, Maintenance=2, PrereqTech='TECH_ENGINEERING', MandatoryObsoleteTech='TECH_STEEL' WHERE UnitType='UNIT_KHMER_DOMREY';
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_BOMBARD' WHERE Unit='UNIT_KHMER_DOMREY';
INSERT INTO UnitReplaces (CivUniqueUnitType, ReplacesUnitType)
	VALUES ('UNIT_KHMER_DOMREY', 'UNIT_CATAPULT');
-- Prasat gives a free Missionary when built
INSERT INTO Modifiers (ModifierId , ModifierType , RunOnce , Permanent)
    VALUES ('PRASAT_GRANT_MISSIONARY_CPLMOD' , 'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY' , 1 , 1);
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('PRASAT_GRANT_MISSIONARY_CPLMOD' , 'UnitType' , 'UNIT_MISSIONARY');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('PRASAT_GRANT_MISSIONARY_CPLMOD' , 'Amount' , '1');
INSERT INTO BuildingModifiers (BuildingType , ModifierId)
    VALUES ('BUILDING_PRASAT' , 'PRASAT_GRANT_MISSIONARY_CPLMOD');
-- Trade routes to or from other civilizations give +2 Faith to both parties
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('TRAIT_INCOMING_TRADE_FAITH_FOR_SENDER', 'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_INCOMING_TRADE_FAITH_FOR_SENDER' , 'YieldType' , 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_INCOMING_TRADE_FAITH_FOR_SENDER' , 'Amount' , '2');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('TRAIT_FAITH_FROM_INCOMING_TRADE_ROUTES', 'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_FROM_OTHERS');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_FAITH_FROM_INCOMING_TRADE_ROUTES' , 'YieldType' , 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_FAITH_FROM_INCOMING_TRADE_ROUTES' , 'Amount' , '2');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('TRAIT_FAITH_FROM_INTERNATIONAL_TRADE_ROUTES', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_FAITH_FROM_INTERNATIONAL_TRADE_ROUTES' , 'YieldType' , 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
    VALUES ('TRAIT_FAITH_FROM_INTERNATIONAL_TRADE_ROUTES' , 'Amount' , '2');
INSERT INTO TraitModifiers (TraitType, ModifierId)
	VALUES ('TRAIT_CIVILIZATION_KHMER_BARAYS', 'TRAIT_INCOMING_TRADE_FAITH_FOR_SENDER');
INSERT INTO TraitModifiers (TraitType, ModifierId)
	VALUES ('TRAIT_CIVILIZATION_KHMER_BARAYS', 'TRAIT_FAITH_FROM_INCOMING_TRADE_ROUTES');
INSERT INTO TraitModifiers (TraitType, ModifierId)
	VALUES ('TRAIT_CIVILIZATION_KHMER_BARAYS', 'TRAIT_FAITH_FROM_INTERNATIONAL_TRADE_ROUTES');
-- Holy Sites +2 faith for an adjacent river
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES ('TRAIT_LEADER_MONASTERIES_KING' , 'TRAIT_HOLY_SITE_RIVER_FAITH_CPLMOD');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES ('TRAIT_HOLY_SITE_RIVER_FAITH_CPLMOD' , 'MODIFIER_PLAYER_CITIES_RIVER_ADJACENCY');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TRAIT_HOLY_SITE_RIVER_FAITH_CPLMOD' , 'Amount' , '2');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TRAIT_HOLY_SITE_RIVER_FAITH_CPLMOD' , 'DistrictType' , 'DISTRICT_HOLY_SITE');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TRAIT_HOLY_SITE_RIVER_FAITH_CPLMOD' , 'YieldType' , 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('TRAIT_HOLY_SITE_RIVER_FAITH_CPLMOD' , 'Description' , 'LOC_DISTRICT_HOLY_SITE_RIVER_FAITH');
-- +100% production to aquaducts
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES
	('TRAIT_LEADER_MONASTERIES_KING' , 'TRAIT_BOOST_AQUEDUCT_PRODUCTION_CPLMOD');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId , OwnerRequirementSetId)
	VALUES
	('TRAIT_BOOST_AQUEDUCT_PRODUCTION_CPLMOD' , 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION' , NULL , NULL);
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES
	('TRAIT_BOOST_AQUEDUCT_PRODUCTION_CPLMOD' , 'DistrictType' , 'DISTRICT_AQUEDUCT' ),
	('TRAIT_BOOST_AQUEDUCT_PRODUCTION_CPLMOD' , 'Amount'       , '100'               );


--==============================================================
--******				START BIASES					  ******
--==============================================================
UPDATE StartBiasTerrains SET Tier=1 WHERE CivilizationType='CIVILIZATION_INDONESIA' AND TerrainType='TERRAIN_COAST';
UPDATE StartBiasRivers SET Tier=4 WHERE CivilizationType='CIVILIZATION_KHMER';





