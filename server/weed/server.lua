
lib.locale()
local objectTable = {}
local seedChance
local reward  = 'cannabis'
local canCarryType

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
    if exports.ox_inventory:CanCarryItem(source, 'cannabis', 1) and exports.ox_inventory:CanCarryItem(source, 'marijuana_seed', 1) then canCarryType = 'both'
        TriggerClientEvent('mato-drugs:startPickingWeed', source)
    elseif
       exports.ox_inventory:CanCarryItem(source, 'cannabis', 1) then canCarryType = 'cannabis'
        TriggerClientEvent('mato-drugs:startPickingWeed', source)
    else
        TriggerClientEvent('mato-drugs:inventoryFull', source)
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
        if method == 'reward' then
            seedChance = math.random(1, 4)
            if seedChance == 4  and canCarryType == 'both' then reward = 'marijuana_seed' end
        local success, response = exports.ox_inventory:AddItem(source, reward, 1)
        print(1111)
        if not success then
        -- if no slots are available, the value will be "inventory_full"
        return print(response)
        end
        GlobalState.plantIds = objectTable
    end
    else
        print("ERROR WHILE TRYING TO DELETE OBJECT ".. object)
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

        if GlobalState.plantsSpawned == 100 then
            GlobalState.spawnComplete = true
            GlobalState:set('plantIds', objectTable, true)
            return end        
end)

AddEventHandler('mato-drugs:changeStateOfPlantsCount', function (newValue)
    GlobalState.plantsSpawned = GlobalState.plantsSpawned + newValue
end)
