RegisterServerEvent('mato-drugs:completeProccess')

AddEventHandler('mato-drugs:completeProccess', function (rewardCount, plantCount)
    local inventory = exports.ox_inventory:GetInventory(source, true)
    local freeWeight = inventory.maxWeight - inventory.weight + (exports.ox_inventory:GetItem(source, 'cannabis', nil, false).weight * plantCount)
    local inventoryScissors = exports.ox_inventory:Search(source, 'slots', 'trimming_scissors')
    local weedBagsAmount = 0 -- 3.5 oz bag

    for k, v in pairs(inventoryScissors) do
        inventoryScissors = v
        break
    end

    if inventoryScissors.slot ~= nil then
        if inventoryScissors.metadata.durability - 5 * plantCount > 0 then
            inventoryScissors.metadata.durability -= 5 * plantCount
            exports.ox_inventory:SetMetadata(source, inventoryScissors.slot, inventoryScissors.metadata)
        else
            rewardCount -= math.abs(inventoryScissors.metadata.durability - (5 * plantCount))
            exports.ox_inventory:RemoveItem(source, 'trimming_scissors', 1, inventoryScissors.metadata, inventoryScissors.slot)
        end
    end
    if rewardCount > freeWeight then rewardCount = freeWeight end
        weedBagsAmount = math.floor(rewardCount / 100)
        rewardCount    = rewardCount % 100 -- gets the reminder
        exports.ox_inventory:RemoveItem(source, 'cannabis', plantCount)

    if rewardCount > 0 then exports.ox_inventory:AddItem(source, 'weed_1g', rewardCount) end

    if weedBagsAmount > 0 then
        exports.ox_inventory:AddItem(source, 'weed_3.5', weedBagsAmount)
    end

    print(weedBagsAmount, rewardCount)
end)