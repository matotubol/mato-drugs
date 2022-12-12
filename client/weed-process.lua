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
                description = 'Takes 7 seconds',
                metadata = {
                    '1 x Weedplant',
                    '1 x Trimming scissors'
                }
            },
            ['Proccess 10 weedplants'] = {
                description = 'Takes 60 seconds',
                metadata = {
                    '10 x Weedplants',
                    '2 x Trimming scissors'
                }
            }
        }
    })
    lib.showContext('weed_proccessing')
end)