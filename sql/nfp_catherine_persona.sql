--==============
-- Magnificence
--==============
-- reduce culture and tourism from special project
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='PROJECT_COMPLETION_GRANT_CULTURE_BASED_ON_EXCESS_LUXURIES' AND Name='Amount';
UPDATE ModifierArguments SET Value='25' WHERE ModifierId='PROJECT_COMPLETION_GRANT_TOURISM_BASED_ON_EXCESS_LUXURIES' AND Name='Amount';
-- excess luxes provide amenities
INSERT INTO TraitModifiers VALUES ('TRAIT_LEADER_MAGNIFICENCES', 'NO_CAP_LUXURY_RESOURCE');