--==================
-- Kublai Khan
--==================
-- domestic trade routes get +1 food and +1 prod for each wonder in the destination city
INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
    VALUES
    ('DOMESTIC_TRADE_ROUTE_FOOD_PER_DEST_WONDER_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS', 'PLAYER_IS_KUBLAI_KHAN_BBG'),
	('DOMESTIC_TRADE_ROUTE_PROD_PER_DEST_WONDER_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS', 'PLAYER_IS_KUBLAI_KHAN_BBG');
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    VALUES
    ('DOMESTIC_TRADE_ROUTE_FOOD_PER_DEST_WONDER_BBG', 'YieldType', 'YIELD_FOOD'),
    ('DOMESTIC_TRADE_ROUTE_FOOD_PER_DEST_WONDER_BBG', 'Domestic', '1'),
    ('DOMESTIC_TRADE_ROUTE_FOOD_PER_DEST_WONDER_BBG', 'Amount', '1'),
    ('DOMESTIC_TRADE_ROUTE_PROD_PER_DEST_WONDER_BBG', 'YieldType', 'YIELD_PRODUCTION'),
    ('DOMESTIC_TRADE_ROUTE_PROD_PER_DEST_WONDER_BBG', 'Domestic', '1'),
    ('DOMESTIC_TRADE_ROUTE_PROD_PER_DEST_WONDER_BBG', 'Amount', '1');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
    SELECT BuildingType, 'DOMESTIC_TRADE_ROUTE_FOOD_PER_DEST_WONDER_BBG' FROM Buildings WHERE IsWonder=1;
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
    SELECT BuildingType, 'DOMESTIC_TRADE_ROUTE_PROD_PER_DEST_WONDER_BBG' FROM Buildings WHERE IsWonder=1;
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType) VALUES
	('PLAYER_IS_KUBLAI_KHAN_BBG', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId) VALUES
	('PLAYER_IS_KUBLAI_KHAN_BBG', 'REQUIRES_PLAYER_IS_KUBLAI_KHAN_CHINA_BBG'),
	('PLAYER_IS_KUBLAI_KHAN_BBG', 'REQUIRES_PLAYER_IS_KUBLAI_KHAN_MONGOLIA_BBG');
INSERT INTO Requirements(RequirementId , RequirementType) VALUES
	('REQUIRES_PLAYER_IS_KUBLAI_KHAN_CHINA_BBG'     , 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES'),
	('REQUIRES_PLAYER_IS_KUBLAI_KHAN_MONGOLIA_BBG'  , 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId , Name, Value) VALUES
	('REQUIRES_PLAYER_IS_KUBLAI_KHAN_CHINA_BBG'     , 'LeaderType', 'LEADER_KUBLAI_KHAN_CHINA'),
	('REQUIRES_PLAYER_IS_KUBLAI_KHAN_MONGOLIA_BBG'  , 'LeaderType', 'LEADER_KUBLAI_KHAN_MONGOLIA');



--==================
-- Vietnam
--==================
-- Unique district will now only get +1 culture from other adjacent district (from +2)
UPDATE District_Adjacencies SET YieldChangeId='District_Culture_Standard' WHERE DistrictType='DISTRICT_THANH';

-- Default movement point for unique unit is 2 (from 3)
UPDATE Units SET BaseMoves=2 WHERE UnitType='UNIT_VIETNAMESE_VOI_CHIEN';

--Combat strength on feature reduce to +2 (+4 in Vietnam territory)
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='TRIEU_FRIENDLY_COMBAT' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='TRIEU_UNFRIENDLY_COMBAT' AND Name='Amount';
