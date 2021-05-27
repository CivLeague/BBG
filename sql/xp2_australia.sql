-- diggers require niter 
UPDATE Units SET StrategicResource='RESOURCE_NITER' WHERE UnitType='UNIT_DIGGER';
-- diggers are niter maint 1
INSERT INTO Units_XP2 (UnitType , ResourceCost  , ResourceMaintenanceAmount , ResourceMaintenanceType)
	VALUES ('UNIT_DIGGER' , 1 , 1 , 'RESOURCE_NITER');
-- liberation bonus reduced to +50%
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION_XP2' and Name='Amount';

