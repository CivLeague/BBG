--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==================
-- Nubia
--==================
-- no extra Nubia ranged production
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_ANCIENT_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_CLASSICAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_MEDIEVAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_RENAISSANCE_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_INDUSTRIAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_MODERN_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_ATOMIC_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_INFORMATION_RANGED_UNIT_PRODUCTION' and Name='Amount';
-- Nubian Pyramid can also be built on flat plains, but not adjacent to each other
INSERT INTO Improvement_ValidTerrains (ImprovementType, TerrainType)
	VALUES
	('IMPROVEMENT_PYRAMID' , 'TERRAIN_PLAINS'),
	('IMPROVEMENT_PYRAMID' , 'TERRAIN_GRASS');
UPDATE Improvements SET SameAdjacentValid=0 WHERE ImprovementType='IMPROVEMENT_PYRAMID';
-- Nubian Pyramid gets double adjacency yields
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CityCenterAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CampusAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_CommercialHubAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_HarborAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_HolySiteAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_IndustrialZoneAdjacency';
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='Pyramid_TheaterAdjacency';



--==============================================================
--******				START BIASES					  ******
--==============================================================
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_NUBIA' AND TerrainType='TERRAIN_DESERT_HILLS';
DELETE FROM StartBiasTerrains WHERE CivilizationType='CIVILIZATION_NUBIA' AND TerrainType='TERRAIN_DESERT';
INSERT INTO StartBiasTerrains (CivilizationType , TerrainType , Tier)
	VALUES
	('CIVILIZATION_NUBIA' , 'TERRAIN_PLAINS'  , 3),
	('CIVILIZATION_NUBIA' , 'TERRAIN_PLAINS_HILLS' , 3);




