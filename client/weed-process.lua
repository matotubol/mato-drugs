local model = `hei_prop_yah_table_03`
local options = {
    {
      name = 'ox:startproccess',
      event = 'mato-drugs:startProccessingWeed',
      icon = 'fa-sharp fa-solid fa-cannabis',
      distance = 1,
      label = 'Proccess weedplant',
    }
  }
  exports.ox_target:addModel(model, options)
  lib.locale()

  RegisterNetEvent('mato-drugs:startProccessingWeed', function(data)
    print(json.encode(data, {indent=true}))
    lib.registerContext({
        id = 'weed_proccessing',
        title = 'Weed Proccessing',
        menu = 'weed_proccessing_menu',
        onExit = lib.hideContext(onExit),
        options = {
            ['Proccess 1 plant'] = {
                icon = 'fa-sharp fa-solid fa-cannabis',
                description = 'Takes 8 seconds',
                onSelect = function()
                    TriggerEvent('mato-drugs:checkInventoryHasScissors', 1)
                  end,
                metadata = {
                    '1 x Weedplant',
                    '1 x Trimming scissors'
                }
            },
            ['Proccess 10 weedplants'] = {
                icon = 'fa-sharp fa-solid fa-cannabis',
                description = 'Takes 8 loops and 5 seconds',
                event = 'testevent',
                onSelect = function ()
                    TriggerEvent('mato-drugs:checkInventoryHasScissors', 2)
                end,
                metadata = {
                    '10 x Weedplant',
                    '2 x Trimming scissors'
                }
            }
        }
    })
    lib.showContext('weed_proccessing')
end)

AddEventHandler('mato-drugs:checkInventoryHasScissors', function (amount)
    local count = exports.ox_inventory:Search('count', 'trimming_scissors')
    if count >= amount then
        if amount == 2 then
            local skillCheck = lib.skillCheck({'easy', 'medium', 'easy', 'medium', 'easy','medium','medium','medium' ,{areaSize = 70, speedMultiplier = 1.1}, 'medium'})
            if skillCheck then 
                --TriggerServerEvent('mato-drugs:someEvent', )
            end
        lib.notify({
            title = '',
            description = 'Started trimming..',
            type = 'success'
          })
        end
        else
        lib.notify({
            title = '',
            description = 'You dont have the required items',
            type = 'error'
        })
    end
end)