--==============
-- Magnificence
--==============
-- reduce culture and tourism from special project
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='PROJECT_COMPLETION_GRANT_CULTURE_BASED_ON_EXCESS_LUXURIES' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='PROJECT_COMPLETION_GRANT_TOURISM_BASED_ON_EXCESS_LUXURIES' AND Name='Amount';
-- double amenities from unqie luxes
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('DOUBLE_AMENITIES_FROM_UNIQUE_LUXES_BBG', 'MODIFIER_PLAYER_OWNED_LUXURY_EXTRA_AMENITIES');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('DOUBLE_AMENITIES_FROM_UNIQUE_LUXES_BBG', 'Amount', '4');
INSERT INTO TraitModifiers VALUES ('TRAIT_LEADER_MAGNIFICENCES', 'DOUBLE_AMENITIES_FROM_UNIQUE_LUXES_BBG');