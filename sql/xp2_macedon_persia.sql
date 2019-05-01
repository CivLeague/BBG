-- Hypaspists cost 10 Iron instead of 5
UPDATE Units_XP2 SET ResourceCost=10 WHERE UnitType='UNIT_MACEDONIAN_HYPASPIST';

-- ranged combat back to 25
UPDATE Units SET RangedCombat=25 WHERE UnitType='UNIT_PERSIAN_IMMORTAL';


