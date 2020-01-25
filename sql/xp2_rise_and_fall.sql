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
-- Mapuche
--==================
-- Malon Raiders become Courser replacement and territory bonus replaced with +1 movement
UPDATE Units SET Combat=44 , Cost=200 , Maintenance=3 , BaseMoves=6 , PrereqTech='TECH_CASTLES' , MandatoryObsoleteTech='TECH_SYNTHETIC_MATERIALS' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';
DELETE FROM UnitReplaces WHERE CivUniqueUnitType='UNIT_MAPUCHE_MALON_RAIDER';
INSERT INTO UnitReplaces (CivUniqueUnitType , ReplacesUnitType)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER' , 'UNIT_COURSER');
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_CAVALRY' WHERE Unit='UNIT_MAPUCHE_MALON_RAIDER';
DELETE FROM UnitAbilityModifiers WHERE ModifierId='MALON_RAIDER_TERRITORY_COMBAT_BONUS';
-- Malons cost Horses
INSERT INTO Units_XP2 (UnitType , ResourceCost)
	VALUES ('UNIT_MAPUCHE_MALON_RAIDER' , 20);
UPDATE Units SET StrategicResource='RESOURCE_HORSES' WHERE UnitType='UNIT_MAPUCHE_MALON_RAIDER';
