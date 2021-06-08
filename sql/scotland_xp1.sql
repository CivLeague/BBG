-- T1 to hills
insert into StartBiasTerrains (CivilizationType, TerrainType, Tier)
values ('CIVILIZATION_SCOTLAND', 'TERRAIN_DESERT_HILLS', '1'),
       ('CIVILIZATION_SCOTLAND', 'TERRAIN_GRASS_HILLS', '1'),
       ('CIVILIZATION_SCOTLAND', 'TERRAIN_PLAINS_HILLS', '1'),
       ('CIVILIZATION_SCOTLAND', 'TERRAIN_TUNDRA_HILLS', '1');

-- Civilization Ability
/*
  - Happy Cities gain +10% [+5%] Science and +10% [+5%] Procuktion,
  - Ecstatic Cities gain +15% [+10%] Science and +15% [+10%] Production
 */
update ModifierArguments set Value='10' where ModifierId = 'TRAIT_SCIENCE_HAPPY' and Name = 'Amount';
update ModifierArguments set Value='15' where ModifierId = 'TRAIT_SCIENCE_ECSTATIC' and Name = 'Amount';
update ModifierArguments set Value='10' where ModifierId = 'TRAIT_PRODUCTION_HAPPY' and Name = 'Amount';
update ModifierArguments set Value='15' where ModifierId = 'TRAIT_PRODUCTION_ECSTATIC' and Name = 'Amount';

-- Golf Course
/*
 (1) Golf courts are now available at Games and Recreation [Reform church].
 (2) New base yields: +1 [+2] Amusement, +1 [0] Culture, +2 Gold [+2].
 (3) If next to City Center, Entertainment Complex or Water Park they yield +1 Culture, +1 Gold [City Center and Entertainment Complex]
 (4) +1 Gold and +1 Culture with Enlightment [0].
 (5) 1 Housing with Urbanisation [Globalisation]
 (6) After inventing Civil Engineering Golf courts can be constructed on Desert and Desert Hills [0].
 */
-- (1)
update Improvements set PrereqCivic = 'CIVIC_GAMES_RECREATION' where ImprovementType = 'IMPROVEMENT_GOLF_COURSE';
-- (2)
update Improvement_YieldChanges set YieldChange = 1 where ImprovementType = 'IMPROVEMENT_GOLF_COURSE' and YieldType = 'YIELD_CULTURE';
-- (3)
insert into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) values ('GOLF_COURSE_ADJACENCY_CITY_CENTER_GOLD', 'Placeholder', 'YIELD_GOLD', 1, 1, 'DISTRICT_CITY_CENTER');
insert into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) values ('GOLF_COURSE_ADJACENCY_ENTERTAINMENT_COMPLEX_GOLD', 'Placeholder', 'YIELD_GOLD', 1, 1, 'DISTRICT_ENTERTAINMENT_COMPLEX');
insert into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) values ('GOLF_COURSE_ADJACENCY_WATER_PARK_GOLD', 'Placeholder', 'YIELD_GOLD', 1, 1, 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX');
insert into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) values ('GOLF_COURSE_ADJACENCY_WATER_PARK_CULTURE', 'Placeholder', 'YIELD_CULTURE', 1, 1, 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX');
insert into Improvement_Adjacencies (ImprovementType, YieldChangeId)
values ('IMPROVEMENT_GOLF_COURSE', 'GOLF_COURSE_ADJACENCY_CITY_CENTER_GOLD'),
       ('IMPROVEMENT_GOLF_COURSE', 'GOLF_COURSE_ADJACENCY_ENTERTAINMENT_COMPLEX_GOLD'),
       ('IMPROVEMENT_GOLF_COURSE', 'GOLF_COURSE_ADJACENCY_WATER_PARK_GOLD'),
       ('IMPROVEMENT_GOLF_COURSE', 'GOLF_COURSE_ADJACENCY_WATER_PARK_CULTURE');
-- (4)
insert into Improvement_BonusYieldChanges (ImprovementType, YieldType, BonusYieldChange, PrereqCivic)
values ('IMPROVEMENT_GOLF_COURSE', 'YIELD_GOLD', 1, 'CIVIC_THE_ENLIGHTENMENT'),
       ('IMPROVEMENT_GOLF_COURSE', 'YIELD_CULTURE', 1, 'CIVIC_THE_ENLIGHTENMENT');
-- (5)
update Modifiers set SubjectRequirementSetId = 'PLAYER_HAS_URBANIZATION_REQUIREMENTS' where ModifierId = 'GOLFCOURSE_HOUSING_WITHGLOBLIZATION';
-- (6)
insert into Improvement_ValidTerrains (ImprovementType, TerrainType, PrereqCivic)
values ('IMPROVEMENT_GOLF_COURSE', 'TERRAIN_DESERT', 'CIVIC_CIVIL_ENGINEERING'),
       ('IMPROVEMENT_GOLF_COURSE', 'TERRAIN_DESERT_HILLS', 'CIVIC_CIVIL_ENGINEERING');
-- (7)
insert into Requirements (RequirementId, RequirementType) values ('PLAYER_HAS_CIVIC_PROFESSIONAL_SPORTS_REQUIREMENT', 'REQUIREMENT_PLAYER_HAS_CIVIC');
insert into RequirementArguments (RequirementId, Name, Value) values ('PLAYER_HAS_CIVIC_PROFESSIONAL_SPORTS_REQUIREMENT', 'CivicType', 'CIVIC_PROFESSIONAL_SPORTS');
insert into RequirementSetRequirements (RequirementSetId, RequirementId) values ('PLAYER_HAS_CIVIC_PROFESSIONAL_SPORTS', 'PLAYER_HAS_CIVIC_PROFESSIONAL_SPORTS_REQUIREMENT');
update Modifiers set SubjectRequirementSetId = 'PLAYER_HAS_CIVIC_PROFESSIONAL_SPORTS' where ModifierId = 'GOLFCOURSE_AMENITIES';
