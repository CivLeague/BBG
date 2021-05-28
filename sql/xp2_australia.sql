-- allow custom mines on volcanic soil
INSERT INTO Improvement_ValidFeatures (ImprovementType, FeatureType) VALUES
	('IMPROVEMENT_DOWN_UNDER_MINE_BBG', 'FEATURE_VOLCANIC_SOIL');
-- diggers require niter 
UPDATE Units SET StrategicResource='RESOURCE_NITER' WHERE UnitType='UNIT_DIGGER';
-- diggers are niter maint 1
INSERT INTO Units_XP2 (UnitType , ResourceCost  , ResourceMaintenanceAmount , ResourceMaintenanceType)
	VALUES ('UNIT_DIGGER' , 1 , 1 , 'RESOURCE_NITER');
-- liberation bonus reduced to +50%
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION_XP2' and Name='Amount';

