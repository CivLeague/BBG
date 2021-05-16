-- reduce tech boost for babylon
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_TRAIT_BABYLON_EUREKA', 'MODIFIER_PLAYER_ADJUST_TECHNOLOGY_BOOST');

INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value, Extra) VALUES
    ('BBG_TRAIT_BABYLON_EUREKA', 'Amount', '45', '-1');

DELETE FROM TraitModifiers WHERE TraitType='TRAIT_CIVILIZATION_BABYLON' AND ModifierID='TRAIT_EUREKA_INCREASE';
INSERT OR IGNORE INTO TraitModifiers(TraitType, ModifierID) VALUES
    ('TRAIT_CIVILIZATION_BABYLON', 'BBG_TRAIT_BABYLON_EUREKA');



-- Babylon - Nalanda infinite technology re-suze fix.
-- Remove the trait modifier from the Nalanda Minor
--  This was the initial cause of the problem.  
--   The context was destroyed when suzerain was lost, and recreated when suzerain was gained.  
--   Moving the context to the Game instance solves this problem.
DELETE FROM TraitModifiers WHERE ModifierId="MINOR_CIV_NALANDA_FREE_TECHNOLOGY";

-- We don't care about these modifiers anymore, they are connected to the TraitModifier
DELETE FROM Modifiers WHERE ModifierId="MINOR_CIV_NALANDA_FREE_TECHNOLOGY_MODIFIER";
DELETE FROM Modifiers WHERE ModifierId="MINOR_CIV_NALANDA_FREE_TECHNOLOGY";

-- Attach the modifier to check for improvement to each player
INSERT OR IGNORE INTO Modifiers 
	(ModifierId, ModifierType)
	VALUES
	('MINOR_CIV_NALANDA_MAHAVIHARA', "MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER");

-- Modifier to actually check if the improvement is built, only done once
INSERT OR IGNORE INTO Modifiers 
	(ModifierId, ModifierType, OwnerRequirementSetId, RunOnce, Permanent)
	VALUES
	('MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD', "MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY", "PLAYER_HAS_MAHAVIHARA", 1, 1);

INSERT OR IGNORE INTO ModifierArguments
    (ModifierId, Name, Type, Value)
    VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA', 'ModifierId', 'ARGTYPE_IDENTITY', 'MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD'),
    ('MINOR_CIV_NALANDA_MAHAVIHARA_TECH_ON_FIRST_BUILD', 'Amount', 'ARGTYPE_IDENTITY', 1);

-- Modifier which triggers and attaches to all players when game is created 
INSERT OR IGNORE INTO GameModifiers
    (ModifierId)
    VALUES
    ('MINOR_CIV_NALANDA_MAHAVIHARA');


-- to keep consistent with CV changes to base game great works
-- Great Artist
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_BEHZAD_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_BEHZAD_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_BEHZAD_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_TOHAKU_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_TOHAKU_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_TOHAKU_3';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KANDINSKY_1';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KANDINSKY_2';
UPDATE GreatWork_YieldChanges SET YieldChange=4 WHERE GreatWorkType='GREATWORK_KANDINSKY_3';
-- Great Musician
UPDATE GreatWork_YieldChanges SET YieldChange=12 WHERE GreatWorkType='GREATWORK_BABYLON_CANTEMIR_1';
UPDATE GreatWork_YieldChanges SET YieldChange=12 WHERE GreatWorkType='GREATWORK_BABYLON_CANTEMIR_2';
UPDATE GreatWork_YieldChanges SET YieldChange=12 WHERE GreatWorkType='GREATWORK_BABYLON_CANTEMIR_3';
UPDATE GreatWork_YieldChanges SET YieldChange=12 WHERE GreatWorkType='GREATWORK_BABYLON_JOPLIN_1';
UPDATE GreatWork_YieldChanges SET YieldChange=12 WHERE GreatWorkType='GREATWORK_BABYLON_JOPLIN_2';
UPDATE GreatWork_YieldChanges SET YieldChange=12 WHERE GreatWorkType='GREATWORK_BABYLON_JOPLIN_3';

-- Reduce Imhotep to 1 charge
UPDATE GreatPersonIndividuals SET ActionCharges=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_IMHOTEP';