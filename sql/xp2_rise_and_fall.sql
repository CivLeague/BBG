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



--==================
-- Cree
--==================
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_SKIRMISHER' WHERE Unit='UNIT_CREE_OKIHTCITAW';

--==================
-- Mapuche
--==================
-- chemamull can be placed on volcanic soil
INSERT INTO Improvement_ValidFeatures (ImprovementType, FeatureType)
	VALUES ('IMPROVEMENT_CHEMAMULL','FEATURE_VOLCANIC_SOIL');
-- Malon Raiders become Courser replacement
UPDATE Units SET Combat=48 , Cost=180 , Maintenance=3 , BaseMoves=6 , PrereqTech='TECH_CASTLES' , MandatoryObsoleteTech='TECH_SYNTHETIC_MATERIALS' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';
DELETE FROM UnitReplaces WHERE CivUniqueUnitType='UNIT_MAPUCHE_MALON_RAIDER';
INSERT OR IGNORE INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER' , 'UNIT_COURSER');
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CAVALRY' WHERE Unit='UNIT_MAPUCHE_MALON_RAIDER';
DELETE FROM UnitAbilityModifiers WHERE ModifierId='MALON_RAIDER_TERRITORY_COMBAT_BONUS';
-- Malons cost Horses
INSERT OR IGNORE INTO Units_XP2 (UnitType , ResourceCost)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER' , 20);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';