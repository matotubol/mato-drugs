Config = {}

Config.Debug = false

--WEED
Config.SpawnWeedAmount          = 10
Config.WeedRespawnTime          = 60000*10 -- every 10 min
Config.WeedPickDuration         = 10000
Config.WeedHedgeShearDamage     = 5 --how much durability will be taken every time

Config.WeedFieldCoords = {
    x = 2137.40,
    y = 5169.74,
    z = 99990.0 --can be invalid we will regenerate them client side.
}
Config.WeedRewards  = {
[1] = {
    item = 'cannabis',
    increment = 1,
    chance = 1
},
[2] = {
    item = 'marijuana_seed',
    increment = 2,
    chance = 10
    }
}

