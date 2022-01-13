-- Delay heavy chariot on meteors
-- REQUIRE DLC Gran Colombia to boot !
INSERT INTO GoodyHutSubTypes(GoodyHut, SubTypeGoodyHut, Description, Weight, ModifierID) VALUES
    ('METEOR_GOODIES', 'METEOR_GRANT_TWO_TECH_BOOSTS', 'LOC_BBG_METOR_GOODIES_FREE_TECH_DESC', 1, 'GOODY_SCIENCE_GRANT_TWO_TECH_BOOSTS');
UPDATE GoodyHutSubTypes SET Weight=99, Turn=30 WHERE GoodyHut='METEOR_GOODIES' AND SubTypeGoodyHut='METEOR_GRANT_GOODIES';