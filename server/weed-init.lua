
lib.locale()
objectTable = {}
canReceive = 0 -- 0 = inv full, 1 = cannabis only, 2 = weed_seed only , 3 is all | chance = 1 of ?
rewards  = {
[1] = 
    {
      item = 'cannabis',
      increment = 1,
      chance = 1
    },
[2] = 
    {
      item = 'marijuana_seed',
      increment = 2,
      chance = 10
    }
  }

CreateThread(function ()
    GlobalState.plantsSpawned = 0
    GlobalState.spawnComplete = false
    GlobalState.plantIds      = objectIdTable
    GlobalState.plantsBackup = {}
end)

RegisterServerEvent('mato-drugs:deleteEntity')
RegisterServerEvent('mato-drugs:checkInventory')
RegisterServerEvent('mato-drugs:receiveWeedPlant')
RegisterServerEvent('mato-drugs:changeStateOfPlantsCount')
RegisterServerEvent('mato-drugs:receiveZCoord')


AddEventHandler('mato-drugs:checkInventory', function()
    local hedgeShear = exports.ox_inventory:Search(source, 'slots', 'hedge_shear')
    local canExecute = false
    canReceive = 0

    for i = 1, #rewards do
      if exports.ox_inventory:CanCarryItem(source, rewards[i].item, 1) then
        canReceive =  canReceive + rewards[i].increment
      end
    end

    for k, v in pairs(hedgeShear) do
        hedgeShear = v
        break
    end
    if hedgeShear.slot ~= nil then canExecute = true end
        if canReceive > 0 and canExecute then 
            if hedgeShear.metadata.durability > 0 then
                hedgeShear.metadata.durability -= 5
                exports.ox_inventory:SetMetadata(source, hedgeShear.slot, hedgeShear.metadata)
                if hedgeShear.metadata.durability <= 0 then 
                    TriggerClientEvent('mato-drugs:startPickingWeed', source)
                    exports.ox_inventory:RemoveItem(source, 'hedge_shear', 1, hedgeShear.metadata, hedgeShear.slot)
                else
                    TriggerClientEvent('mato-drugs:startPickingWeed', source) 
                end
            end
        end
end)

AddEventHandler('mato-drugs:receiveItem', function (source)
    if canReceive > 0 then
    local reward  = 'cannabis'
    local weedSeedChance = math.random(1, rewards[2].chance)

    if canReceive == 3 and weedSeedChance == rewards[2].chance then reward = 'marijuana_seed' end

    exports.ox_inventory:AddItem(source, reward, 1)
    print(reward)
end
end)

AddEventHandler('mato-drugs:deleteEntity', function(object, method, index)
    if object ~= nil and DoesEntityExist(object) then
        DeleteEntity(object) 
        table.remove(objectTable, index) 
        collectgarbage()
        GlobalState:set('plantIds', objectTable, true)
        if GlobalState.plantsSpawned ~= 0 then GlobalState.plantsSpawned -= 1 end
        print(object..' WAS DELETED')

        GlobalState.plantIds = objectTable
        if method == 'reward' then 
            TriggerEvent('mato-drugs:receiveItem', source)
        end
    end
end)

AddEventHandler('mato-drugs:receiveZCoord', function (index, coords, coordZ, tableBlueprint)  
    local object = CreateObjectNoOffset(`prop_weed_01`, coords.x, coords.y, coordZ, true, false, true)

    table.insert(objectTable, index, tableBlueprint)
    objectTable[index].object = object

    GlobalState.plantsSpawned += 1

    GlobalState.plantIds = objectTable
    GlobalState.plantsBackup = objectTable
    print(object)

    if GlobalState.plantsSpawned == 10 then
        GlobalState.spawnComplete = true
        GlobalState:set('plantIds', objectTable, true)
        return end        
end)

AddEventHandler('mato-drugs:changeStateOfPlantsCount', function (newValue)
    GlobalState.plantsSpawned = GlobalState.plantsSpawned + newValue
end)
