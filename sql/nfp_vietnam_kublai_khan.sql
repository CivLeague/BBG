-- Unique district will now only get +1 culture from other adjacent district (from +2)
UPDATE District_Adjacencies SET YieldChangeId='District_Culture_Standard' WHERE DistrictType='DISTRICT_THANH';

-- Default movement point for unique unit is 2 (from 3)
UPDATE Units SET BaseMoves=2 WHERE UnitType='UNIT_VIETNAMESE_VOI_CHIEN';

--Combat strength on feature reduce to +2 (+4 in Vietnam territory)
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='TRIEU_FRIENDLY_COMBAT' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRIEU_UNFRIENDLY_COMBAT' AND Name='Amount';
