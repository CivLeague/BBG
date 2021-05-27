--==================
-- Sweden
--==================
-- +50% prod to uiniversity replacement in secret societies
INSERT INTO TraitModifiers (TraitType , ModifierId)
        VALUES
        ('TRAIT_CIVILIZATION_NOBEL_PRIZE' , 'NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' );
INSERT INTO Modifiers (ModifierId , ModifierType , SubjectRequirementSetId)
        VALUES
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION' , null);
INSERT INTO ModifierArguments (ModifierId , Name , Value)
        VALUES
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'BuildingType' , 'BUILDING_ALCHEMICAL_SOCIETY'),
        ('NOBEL_PRIZE_ALCHEMICAL_SOCIETY_BOOST' , 'Amount'       , '50');