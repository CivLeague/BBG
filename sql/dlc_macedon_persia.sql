--==============================================================
--******			C I V I L I Z A T I O N S			  ******
--==============================================================

--==========
-- Macedon
--==========
-- +20% Production for 10 turns after conquering a city
INSERT INTO TraitModifiers (TraitType , ModifierId)
	VALUES
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION' , 'TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION_MODIFIER');
INSERT INTO Modifiers (ModifierId , ModifierType)
	VALUES
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION_MODIFIER' , 'MODIFIER_PLAYER_ADD_DIPLOMATIC_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId , Name , Value)
	VALUES 
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION_MODIFIER' , 'DiplomaticYieldSource' , 'CITY_CAPTURED'   ),
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION_MODIFIER' , 'TurnsActive'           , '10'              ),
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION_MODIFIER' , 'YieldType'             , 'YIELD_PRODUCTION'),
	('TRAIT_CIVILIZATION_HELLENISTIC_FUSION_PRODUCTION_MODIFIER' , 'Amount'                , '20'              );
-- Hetairoi no longer a Horseman replacement
DELETE FROM UnitReplaces WHERE CivUniqueUnitType='UNIT_MACEDONIAN_HETAIROI';
-- Now receives +1 Combat Strength for every Great General recruited this game <-- couldn't figure out


--==================
-- Persia
--==================
-- Persia surprise war movement bonus nullified
UPDATE ModifierArguments SET Value='0' WHERE ModifierId='TRAIT_FALLBABYLON_SURPRISE_MOVEMENT' and Name='Amount';
-- Immortals defense buffed and ranged nerfed (since it is affected by double oligarchy)
UPDATE Units SET Combat=35, RangedCombat=20 WHERE UnitType='UNIT_PERSIAN_IMMORTAL';



--==============================================================
--******			W O N D E R S  (MAN-MADE)			  ******
--==============================================================
-- Apadana +1 envoy instead of 2
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='APADANA_AWARD_TWO_INFLUENCE_TOKEN_MODIFIER';
-- Mausoleum at Halicarnassus gives 1 extra retirement Admirals and Generals instead of Admirals and Engineers
UPDATE RequirementArguments SET Value='GREAT_PERSON_CLASS_GENERAL' WHERE RequirementId='REQUIREMENT_UNIT_IS_ENGINEER';




