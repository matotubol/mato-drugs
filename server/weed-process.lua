RegisterServerEvent('mato-drugs:completeProccess')

function calculateLevel(xp)
    -- Use a logarithmic formula to calculate the player's level
    local level = math.floor(math.log(xp / 10) / math.log(2)) + 1
    
    -- Calculate the xp needed for the next level
    local nextLevel = 10 * 2^(level - 1)
    
    return {level = level, nextLevel = nextLevel}
    end
  
  function getLevelPercentage(xp)
    local level = calculateLevel(xp)
    return (xp - level.nextLevel) / (level.nextLevel * 2 - level.nextLevel) * 100
  end

AddEventHandler('mato-drugs:completeProccess', function (rewardCount, plantCount)
    local inventory = exports.ox_inventory:GetInventory(source, true)
    local freeWeight = inventory.maxWeight - inventory.weight + (exports.ox_inventory:GetItem(source, 'cannabis', nil, false).weight * plantCount)
    local inventoryScissors = exports.ox_inventory:Search(source, 'slots', 'trimming_scissors')
    local weedBagsAmount = 0 -- 3.5 oz bag
    local player = Ox.GetPlayer(source)

    for k, v in pairs(inventoryScissors) do
        inventoryScissors = v
        break
    end

-- Check if the scissors are in the inventory
if inventoryScissors.slot ~= nil then
    -- Calculate the amount to subtract from the durability
    local subtractAmount = 5 * plantCount

    if inventoryScissors.metadata.durability >= subtractAmount then
        inventoryScissors.metadata.durability -= subtractAmount
        exports.ox_inventory:SetMetadata(source, inventoryScissors.slot, inventoryScissors.metadata)
    else
        rewardCount -= math.abs(inventoryScissors.metadata.durability - subtractAmount)
        if exports.ox_inventory:RemoveItem(source, 'trimming_scissors', 1, inventoryScissors.metadata, inventoryScissors.slot) then
            local scissorsWeight = exports.ox_inventory:GetItem(source, 'trimming_scissors', nil, false).weight
            freeWeight += scissorsWeight
        end
    end
end
    if rewardCount > freeWeight then rewardCount = freeWeight end
        weedBagsAmount = math.floor(rewardCount / 100)
        -- Get the reminder
        rewardCount    = rewardCount % 100
        exports.ox_inventory:RemoveItem(source, 'cannabis', plantCount)

    if rewardCount > 0 then exports.ox_inventory:AddItem(source, 'weed_1g', rewardCount) end
    if weedBagsAmount > 0 then
        exports.ox_inventory:AddItem(source, 'weed_3.5', weedBagsAmount)
    end
    local xpLevel = MySQL.single.await('SELECT weed_xp FROM mato_drugs WHERE identifier = ? FOR UPDATE', {player.userid})
        if xpLevel then print('level', calculateLevel(xpLevel.weed_xp).level, '%'.. getLevelPercentage(xpLevel.weed_xp)) end
        MySQL.prepare.await('INSERT INTO mato_drugs (identifier, weed_xp) VALUES (?, ?) ON DUPLICATE KEY UPDATE weed_xp = weed_xp + ?', {player.userid, 10, plantCount})
    end)
