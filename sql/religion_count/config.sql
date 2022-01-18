INSERT INTO Parameters
(Key1, Key2, ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId,
 SortIndex)
VALUES ('Ruleset', 'RULESET_STANDARD', 'p0kReligions', 'LOC_P0K_RELIGIONS_NAME', 'LOC_P0K_RELIGIONS_DESCRIPTION',
        'p0kReligionsRange', 4, 'Game', 'P0K_RELIGIONS', 'BasicGameOptions', 90),
       ('Ruleset', 'RULESET_EXPANSION_1', 'p0kReligions_XP1', 'LOC_P0K_RELIGIONS_NAME', 'LOC_P0K_RELIGIONS_DESCRIPTION',
        'p0kReligionsRange', 4, 'Game', 'P0K_RELIGIONS', 'BasicGameOptions', 90),
       ('Ruleset', 'RULESET_EXPANSION_2', 'p0kReligions_XP2', 'LOC_P0K_RELIGIONS_NAME',
        'LOC_P0K_RELIGIONS_DESCRIPTION', 'p0kReligionsXP2Range', 4, 'Game', 'P0K_RELIGIONS', 'BasicGameOptions',
        90);
INSERT INTO DomainRanges
(Domain,					MinimumValue,	MaximumValue)
VALUES	('p0kReligionsRange',		2,				7),
          ('p0kReligionsXP2Range',	2,				7);