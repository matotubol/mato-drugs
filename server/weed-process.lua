RegisterServerEvent('mato-drugs:completeProccess')

local function calculateLevel(xp)
    local startLevel = 10
    local table = {level = 0, nextlevel = 0}
    for i = 1, xp do
      if startLevel > xp then
        table.nextLevel = startLevel
        break
      else
        startLevel *= 2
        table.level += 1
      end
    end  
        return table
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

    if inventoryScissors.slot ~= nil then
        if inventoryScissors.metadata.durability - 5 * plantCount > 0 then
            inventoryScissors.metadata.durability -= 5 * plantCount
            exports.ox_inventory:SetMetadata(source, inventoryScissors.slot, inventoryScissors.metadata)
        else
            rewardCount -= math.abs(inventoryScissors.metadata.durability - (5 * plantCount))
            if exports.ox_inventory:RemoveItem(source, 'trimming_scissors', 1, inventoryScissors.metadata, inventoryScissors.slot) then
                freeWeight += exports.ox_inventory:GetItem(source, 'trimming_scissors', nil, false).weight
            end
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

    local xpLevel = MySQL.single.await('SELECT weed_xp FROM mato_drugs WHERE identifier = ?', {player.userid})
    if xpLevel then
        print('Level '..calculateLevel(xpLevel.weed_xp).level, 'Next level XP = '..calculateLevel(xpLevel.weed_xp).nextLevel)
        MySQL.update.await('UPDATE mato_drugs SET weed_xp = weed_xp + ? WHERE identifier = ?', {plantCount, player.userid})
    else
        MySQL.insert.await('INSERT INTO mato_drugs (identifier, weed_xp) VALUES (?, ?)', {player.userid, 0})
    end
end)