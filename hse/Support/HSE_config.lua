-- Optional config file. The values here are equal to default values.

-- Global parameter: set to 1 to activate stat masking, 0 to deactivate it.
maskingActive = 1

--[[
	Access levels:
	0: none
	1: limited
	2: open
	3: secret
	4: top secret
]]

-- Note that there must not be any value higher than minAccessLevelScore or accessLevelLocalPlayer (10), as some cumulative values (team score, for instance) are displayed only if all underlying components (culture, etc.) can be accessed.

minAccessLevelDiplomacy = 1
minAccessLevelEconomy = 1
minAccessLevelCulture = 2
minAccessLevelReligion = 2
minAccessLevelScience = 3
minAccessLevelMilitary = 4
minAccessLevelScore = 4