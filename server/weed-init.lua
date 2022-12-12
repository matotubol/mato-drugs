
lib.locale()
objectTable = {}
canReceive = 0 -- 0 = inv full, 1 = cannabis only, 2 = weed_seed only , 3 is all | chance = 1 of ?

CreateThread(function ()
    GlobalState.plantsSpawned = 0
    GlobalState.spawnComplete = false
    GlobalState.plantIds      = objectIdTable
end)

RegisterServerEvent('mato-drugs:deleteEntity')
RegisterServerEvent('mato-drugs:checkInventory')
RegisterServerEvent('mato-drugs:changeStateOfPlantsCount')
RegisterServerEvent('mato-drugs:receiveZCoord')

AddEventHandler('mato-drugs:checkInventory', function()
    local hedgeShear = exports.ox_inventory:Search(source, 'slots', 'hedge_shear')
    local canExecute = false
    canReceive = 0

    for i = 1, #Config.WeedRewards do
      if exports.ox_inventory:CanCarryItem(source, Config.WeedRewards[i].item, 1) then
        canReceive += Config.WeedRewards[i].increment
      end
    end

    for k, v in pairs(hedgeShear) do
        hedgeShear = v
        break --when found, break loop and use this hedge_shear table
    end
    if hedgeShear.slot ~= nil then canExecute = true end
        if canReceive > 0 and canExecute then 
            if hedgeShear.metadata.durability > 0 then
                hedgeShear.metadata.durability -= Config.WeedHedgeShearDamage
                exports.ox_inventory:SetMetadata(source, hedgeShear.slot, hedgeShear.metadata)
                if hedgeShear.metadata.durability <= 0 then 
                    TriggerClientEvent('mato-drugs:startPickingWeed', source)
                    exports.ox_inventory:RemoveItem(source, 'hedge_shear', 1, hedgeShear.metadata, hedgeShear.slot)
                else
                    TriggerClientEvent('mato-drugs:startPickingWeed', source, true) -- true for has shear and false for no shear
                end
            end
                else
                    TriggerClientEvent('mato-drugs:startPickingWeed', source, false)
        end
end)

AddEventHandler('mato-drugs:receiveItem', function (source)
    if canReceive == 0 then return end -- 0 = inv full
    local reward  = 'cannabis'
    local weedSeedChance = math.random(1, Config.WeedRewards[2].chance)

    if canReceive == 3 and weedSeedChance == Config.WeedRewards[2].chance then
        reward = 'marijuana_seed'
    end

    exports.ox_inventory:AddItem(source, reward, 1)
    if Config.Debug then
        print(json.encode(Ox.GetPlayer(source).username, { indent = true }).. ' RECEIVED '.. reward)
    end
end)

AddEventHandler('mato-drugs:deleteEntity', function(object, method, index)
    if object ~= nil and DoesEntityExist(object) then
        DeleteEntity(object) 
        collectgarbage()

        table.remove(objectTable, index) 
        GlobalState:set('plantIds', objectTable, true)
        if GlobalState.plantsSpawned ~= 0 then GlobalState.plantsSpawned -= 1 end
        if GlobalState.plantsSpawned == 0 then GlobalState.spawnComplete = false end

        if Config.Debug then print(object..' WAS DELETED') end

        if method == 'reward' then 
            TriggerEvent('mato-drugs:receiveItem', source)
        end
    else
        if Config.Debug then print('ERROR DELETING '..object..' SEEMS LIKE IT DOES NOT EXSIST!') end
    end
end)

AddEventHandler('mato-drugs:receiveZCoord', function (index, coords, coordZ, tableBlueprint)  
    if coordZ > 1 then -- only create after valid Z is received
    local object = CreateObjectNoOffset(`prop_weed_01`, coords.x, coords.y, coordZ, true, false, true)
    table.insert(objectTable, index, tableBlueprint)
    objectTable[index].object = object

    GlobalState.plantsSpawned += 1
    if GlobalState.plantsSpawned == Config.SpawnWeedAmount then
       GlobalState.spawnComplete = true
       GlobalState:set('plantIds', objectTable, true)
    end
        if Config.Debug then print(index, object..' WEEDPLANT SPAWNED ') end  
    else
        if Config.Debug then print('INVALID Z COORD FOR WEED RECEIVED'.. coordZ) end
    end
end)

AddEventHandler('mato-drugs:changeStateOfPlantsCount', function (increment)
    GlobalState.plantsSpawned += increment
end)
