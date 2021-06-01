-- Warlord's Throne extra resource stockpile
INSERT INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES
	('BUILDING_GOV_CONQUEST' , 'BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE');
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId , OwnerRequirementSetId)
	VALUES
	('BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE' , 'MODIFIER_PLAYER_ADJUST_RESOURCE_STOCKPILE_CAP' , NULL , NULL);
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES
	('BUILDING_GOV_CONQUEST_RESOURCE_STOCKPILE' , 'Amount' , '30');



-- --==================
-- -- Cree
-- --==================
-- UPDATE UnitUpgrades SET UpgradeUnit='UNIT_SKIRMISHER' WHERE Unit='UNIT_CREE_OKIHTCITAW';
--
-- --==================
-- -- Mapuche
-- --==================
-- -- chemamull can be placed on volcanic soil
-- INSERT INTO Improvement_ValidFeatures (ImprovementType, FeatureType)
-- 	VALUES ('IMPROVEMENT_CHEMAMULL','FEATURE_VOLCANIC_SOIL');
