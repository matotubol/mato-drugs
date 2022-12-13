RegisterServerEvent('mato-drugs:completeProccess')

AddEventHandler('mato-drugs:completeProccess', function (rewardCount, plantCount)
    local weedBagsAmount = 0 -- 3.5 oz bag
    if rewardCount > 100 then
        for i = 1, rewardCount do
            if rewardCount - 100 > 0 then
                rewardCount -= 100
                weedBagsAmount += 1
            else
                break
            end
        end
        if weedBagsAmount > 0 then
           exports.ox_inventory:AddItem(source, 'weed_3.5', weedBagsAmount)
        end
    end
    exports.ox_inventory:RemoveItem(source, 'cannabis', plantCount)
    exports.ox_inventory:AddItem(source, 'weed_1g', rewardCount)
end)