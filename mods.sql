-- Amani Abuse Fix... can immediately re-declare war when an enemy suzerian removes Amani --
UPDATE GlobalParameters SET Value='1' WHERE Name='DIPLOMACY_PEACE_MIN_TURNS';


-- Combat Religions Nerfs (+5 from +10 for Defender and Crusader) --
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='DEFENDER_OF_FAITH_COMBAT_BONUS_MODIFIER';
UPDATE ModifierArguments SET Value='7' WHERE ModifierId='JUST_WAR_COMBAT_BONUS_MODIFIER';


-- Pantheons Nerfs --
-- God of the Forge is +15% production to ancient and classical units instead of +25 --
UPDATE ModifierArguments SET Value='15' WHERE ModifierId='GOD_OF_THE_FORGE_UNIT_ANCIENT_CLASSICAL_PRODUCTION_MODIFIER' and Name='Amount';
UPDATE ModifierArguments SET Value='75' WHERE ModifierId='GODDESS_OF_THE_HARVEST_HARVEST_MODIFIER' and Name='Amount';
UPDATE ModifierArguments SET Value='75' WHERE ModifierId='GODDESS_OF_THE_HARVEST_REMOVE_FEATURE_MODIFIER' and Name='Amount';


-- Great General Nerfs --
-- Remove movement bonus from Classical Great Generals --
UPDATE ModifierArguments SET Value='NULL' WHERE ModifierId='GREATPERSON_MOVEMENT_AOE_CLASSICAL_LAND';


-- Civ Nerfs --
-- Mapuche combat bonus against Golden Age Civs set to 5 instead of 10 -- 
UPDATE ModifierArguments SET Value='5' WHERE ModifierId='TRAIT_TOQUI_COMBAT_BONUS_VS_GOLDEN_AGE_CIV';

-- No extra light cavalry for Scythia --
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_EXTRASAKAHORSEARCHER' and NAME='Amount';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_EXTRALIGHTCAVALRY' and NAME='Amount';

-- Sumerian War Carts are no longer free to maintain so that you cannot have unlimited and have 25 combat strength instead of 30 --
UPDATE Units SET Maintenance=1 WHERE UnitType='UNIT_SUMERIAN_WAR_CART';
UPDATE Units SET Combat=28 WHERE UnitType='UNIT_SUMERIAN_WAR_CART';

-- Zulu get corps/armies a little later, but still earlier than everyone else and no extra combat bonuses for corps/armies --
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TRAIT_LAND_CORPS_COMBAT_STRENGTH' and Name='Amount';
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='TRAIT_LAND_ARMIES_COMBAT_STRENGTH' and Name='Amount';
UPDATE ModifierArguments SET Value='CIVIC_DIPLOMATIC_SERVICE' WHERE ModifierId='TRAIT_LAND_CORPS_EARLY' and Name='CivicType';
UPDATE ModifierArguments SET Value='CIVIC_URBANIZATION' WHERE ModifierId='TRAIT_LAND_ARMIES_EARLY' and Name='CivicType';

-- Persia surprise war bonuses of domestic trade gold and unit movement set to +1 instead of +2 --
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_FALLBABYLON_SURPRISE_MOVEMENT' and Name='Amount';

-- Nubia ranged production and experience cut to 25% (from %50) and ranged experience cut in half to 25%... Also, Pitati Archers have same ranged strength as regular Archers (25 instead of 30) --
UPDATE Units SET RangedCombat=25 WHERE UnitType='UNIT_NUBIAN_PITATI';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_ANCIENT_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_CLASSICAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_MEDIEVAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RENAISSANCE_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_INDUSTRIAL_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_MODERN_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_ATOMIC_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_INFORMATION_RANGED_UNIT_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='TRAIT_RANGED_EXPERIENCE_MODIFIER' and Name='Amount';

-- Russia gets 4 tiles when founding a new city instead of 8 and Cossacks have same base strength as cavalry instead of +5 --
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='TRAIT_INCREASED_TILES';
UPDATE Units SET Combat=62 WHERE UnitType='UNIT_RUSSIAN_COSSACK';

-- Australia's war production bonus reduced to 0% from 100%, liberation bonus reduced to +50% (from +100%) for 10 turns (from 20 turns) and +2 bonus for breathtaking district instead of +3 --
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_BREATHTAKING_CAMPUS' and Name='YieldChange';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_BREATHTAKING_COMMERCIAL_HUB' and Name='YieldChange';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_BREATHTAKING_HOLY_SITE' and Name='YieldChange';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='TRAIT_BREATHTAKING_THEATER_DISTRICT' and Name='YieldChange';
UPDATE ModifierArguments SET Value='50' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION' and Name='Amount';
UPDATE ModifierArguments SET Value='10' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_LIBERATION_PRODUCTION' and Name='TurnsActive';
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_CITADELCIVILIZATION_DEFENSIVE_PRODUCTION' and Name='Amount';

-- German Hansas need 2 adjacent resources for +1 production instead of 1 to 1 and combat bonus against city-states nerfed to +3 from +7
UPDATE Adjacency_YieldChanges SET TilesRequired=2 WHERE ID='Resource_Production';
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='COMBAT_BONUS_VS_CITY_STATES_MODIFIER' and Name='Amount'; 

-- Korea Campus gets +2 science base yield instead of 4, +1 for every 2 mines adjacent instead of 1 to 1
UPDATE Adjacency_YieldChanges SET YieldChange=2 WHERE ID='BaseDistrict_Science';

INSERT INTO Adjacency_YieldChanges
	(ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement)
	VALUES ('Mine_Science', 'LOC_DISTRICT_MINE_SCIENCE', 'YIELD_SCIENCE', 1, 2, 'IMPROVEMENT_MINE');

INSERT INTO District_Adjacencies
	(DistrictType , YieldChangeId)
	VALUES ('DISTRICT_SEOWON', 'Mine_Science');

-- Rome no longer gets free monuments when they found a city and Legions have same strength as Swordsmen (36 instead of 40)
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_ADJUST_NON_CAPITAL_FREE_CHEAPEST_BUILDING';	


-- Wonder Nerfs --
-- Wonders Provide +10 score instead of +15 --
UPDATE ScoringLineItems SET Multiplier=10 WHERE LineItemType='LINE_ITEM_WONDERS';
-- Apadana +1 envoy instead of 2 --
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='APADANA_AWARD_TWO_INFLUENCE_TOKEN_MODIFIER';
-- Mausoleum at Halicarnassus gives 1 extra retirement Admirals and Generals instead of Admirals and Engineers
UPDATE RequirementArguments SET Value='GREAT_PERSON_CLASS_GENERAL' WHERE RequirementId='REQUIREMENT_UNIT_IS_ENGINEER';
-- Venetian Arsenal gives 50% production boost to all naval units in all cities instead of an extra naval unit in its city each time you build one
DELETE FROM BuildingModifiers WHERE	BuildingType='BUILDING_VENETIAN_ARSENAL';

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '50');

INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_MELEE_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_MELEE_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_RANGED_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_RANGED_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_RAIDER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_RAIDER_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_CARRIER_PRODUCTION');
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_CARRIER_PRODUCTION');
