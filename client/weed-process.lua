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

  RegisterNetEvent('mato-drugs:startProccessingWeed', function()
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
                    TriggerEvent('mato-drugs:checkInventoryHasScissors', 1, 1)
                  end,
                metadata = {
                    '1 x Weedplant',
                    '1 x Trimming scissors'
                }
            },
            ['Proccess 10 weedplants'] = {
                icon = 'fa-sharp fa-solid fa-cannabis',
                description = 'Takes 8 loops and 20 seconds',
                event = 'testevent',
                onSelect = function ()
                    TriggerEvent('mato-drugs:checkInventoryHasScissors', 1, 10)
                end,
                metadata = {
                    '10 x Weedplant',
                    '1 x Trimming scissors'
                }
            }
        }
    })
    lib.showContext('weed_proccessing')
end)

local function StartTrimming(time)
    lib.progressBar
    ({
      duration = time,
      label = 'Trimming plant..',
      useWhileDead = false,
      canCancel = false,
      disable = {
        move = true,
        car = true,
        combat = true,
      },
      anim = {
        dict = 'amb@world_human_gardener_plant@male@base',
        clip = 'base',
      },
      prop = {
        model = `prop_cs_scissors`,
        pos = vec3(0.03, 0.03, 0.02),
        rot = vec3(0.0, 0.0, -1.5) 
    },
  })
end

AddEventHandler('mato-drugs:checkInventoryHasScissors', function (scissors, plantCount)
    local playerScissorCount = exports.ox_inventory:Search('count', 'trimming_scissors')
    local playerPlantCount   = exports.ox_inventory:Search('count', 'cannabis')
    if playerScissorCount >= scissors and playerPlantCount >= plantCount then
        local reward  = math.random(1, 20)
        if plantCount == 1 then
            StartTrimming(1000)
            TriggerServerEvent('mato-drugs:completeProccess', reward, plantCount)
        elseif plantCount == 10 then
            for i = 1, plantCount do
                reward += math.random(1, 50) -- max reward can be 500 gram
            end
            local skillCheck = lib.skillCheck({'easy', 'medium', 'easy', 'medium', 'easy','medium','medium','medium' ,{areaSize = 70, speedMultiplier = 1.1}, 'medium'})
        if skillCheck then
            StartTrimming(100)
            TriggerServerEvent('mato-drugs:completeProccess', reward, plantCount)
        end
    end
    else
        lib.notify({
            title = 'ERROR',
            description = 'You dont have the required items.',
            type = 'error'
        })
    end
end)
