-- Highlander gets +10 combat strength (defense)
UPDATE Units
SET Combat=60
WHERE UnitType = 'UNIT_SCOTTISH_HIGHLANDER';
-- happy and ecstatic percentages increased
UPDATE ModifierArguments
SET Value='10'
WHERE ModifierId = 'TRAIT_SCIENCE_HAPPY'
  AND Name = 'Amount';
UPDATE ModifierArguments
SET Value='15'
WHERE ModifierId = 'TRAIT_SCIENCE_ECSTATIC'
  AND Name = 'Amount';
UPDATE ModifierArguments
SET Value='10'
WHERE ModifierId = 'TRAIT_PRODUCTION_HAPPY'
  AND Name = 'Amount';
UPDATE ModifierArguments
SET Value='15'
WHERE ModifierId = 'TRAIT_PRODUCTION_ECSTATIC'
  AND Name = 'Amount';
-- Golf Course moved to Games and Recreation
-- UPDATE Improvements SET PrereqCivic='CIVIC_GAMES_RECREATION' WHERE ImprovementType='IMPROVEMENT_GOLF_COURSE';
-- Golf Course base yields are 1 Culture and 2 Gold... +1 to each if next to City Center
UPDATE Improvement_YieldChanges
SET YieldChange=1
WHERE ImprovementType = 'IMPROVEMENT_GOLF_COURSE'
  AND YieldType = 'YIELD_CULTURE';
-- Golf Course extra housing moved to Urbanization
UPDATE RequirementArguments
SET Value='CIVIC_URBANIZATION'
WHERE RequirementId = 'REQUIRES_PLAYER_HAS_GLOBALIZATION'
  AND Name = 'CivicType';
INSERT
OR IGNORE INTO Adjacency_YieldChanges (ID , Description , YieldType , YieldChange , TilesRequired , AdjacentDistrict)
	VALUES ('GOLFCOURSE_CITYCENTERADJACENCY_GOLD' , 'Placeholder' , 'YIELD_GOLD' , 1 , 1 , 'DISTRICT_CITY_CENTER');
INSERT
OR IGNORE INTO Improvement_Adjacencies (ImprovementType , YieldChangeId)
	VALUES ('IMPROVEMENT_GOLF_COURSE' , 'GOLFCOURSE_CITYCENTERADJACENCY_GOLD');
-- Golf Course gets extra yields a bit earlier
INSERT
OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('204' , 'IMPROVEMENT_GOLF_COURSE' , 'YIELD_GOLD' , '1' , 'CIVIC_THE_ENLIGHTENMENT');
INSERT
OR IGNORE INTO Improvement_BonusYieldChanges (Id , ImprovementType , YieldType , BonusYieldChange , PrereqCivic)
	VALUES ('205' , 'IMPROVEMENT_GOLF_COURSE' , 'YIELD_CULTURE' , '1' , 'CIVIC_THE_ENLIGHTENMENT');