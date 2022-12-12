local models = { `prop_weed_01` }
local tableBlueprint = {}
local insideZone = false
local nearPlant
local plantIndex

local options = {
  {
    name = 'ox:pickupweed',
    serverEvent = 'mato-drugs:checkInventory',
    icon = 'fa-sharp fa-solid fa-cannabis',
    distance = 0.9,
    label = 'Pickup Weedplant',
  }
}

exports.ox_target:addModel(models, options)
lib.locale()

function inside(self)
  insideZone = true
end

lib.zones.sphere({
	name = "WeedFarmZone",
	coords = vec3(2154.5, 5143.0, 30.0),
	radius = 130.0,
  debug = false,
  inside = inside
})

RegisterNetEvent('mato-drugs:receiveZCoord')
RegisterNetEvent('mato-drugs:deleteEntity')
RegisterNetEvent('mato-drugs:changeStateOfPlantsCount')
RegisterNetEvent('mato-drugs:receiveWeedPlant')
RegisterNetEvent('mato-drugs:startPickingWeed')
RegisterNetEvent('mato-drugs:inventoryFull')

-- GetGroundZFor_3dCoord only works when player is in render distance so we have to create a zone and only load when player is in zone so we get the correct Z coords.

CreateThread(function ()
  while true do
    Wait(1000)
    while GlobalState.plantsSpawned == 0 and not GlobalState.spawnComplete and insideZone do
      Wait(150)
      for i = 1, Config.SpawnWeedAmount do 
        local x_offset = math.random(-10.0, 20.0)
        local y_offset = math.random(-10.0, 30.0)
        local object_pos = vector3(Config.WeedFieldCoords.x + x_offset, Config.WeedFieldCoords.y + y_offset, Config.WeedFieldCoords.z)

        ground, newZ = GetGroundZFor_3dCoord(object_pos.x, object_pos.y, object_pos.z, true)
        tableBlueprint[i] = {
          coords = vector3(object_pos.x, object_pos.y, newZ)
      }
        Wait(100)
        TriggerServerEvent('mato-drugs:receiveZCoord', i, object_pos, newZ, tableBlueprint[i])
      end
    end
    Wait(Config.WeedRespawnTime)
  end
end)

local function isPicking()
  if GlobalState.spawnComplete then
  local playerPed = GetPlayerPed(-1)
  local PlayerPos = GetEntityCoords(playerPed)

  if lib.progressBar
  ({
    duration = 100,
    label = 'Cutting plant..',
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
}) then
  for i=1, #GlobalState.plantIds do
    local distance = Vdist2(PlayerPos, GlobalState.plantIds[i].coords)
    if distance < 2 then
      if GlobalState.plantIds[i].object ~= nil then
        nearPlant = GlobalState.plantIds[i].object
        plantIndex = i
      end
    end
  end
end
end
end

RegisterNetEvent('mato-drugs:pickWeed', function ()
  isPicking()
  if nearPlant ~= nil and plantIndex ~= nil then
      TriggerServerEvent('mato-drugs:deleteEntity', nearPlant, 'reward', plantIndex)

      lib.notify({
        title = '',
        description = 'Succesfully picked a plant',
        type = 'success'
      })
    else
      lib.notify({
        title = '',
        description = 'This plant is rotten.',
        type = 'error'
      })
    end
end)

AddEventHandler('mato-drugs:inventoryFull', function()
  lib.notify({
    title = 'Your inventory is full!',
    description = '',
    type = 'error'
  })
end)

AddEventHandler('mato-drugs:startPickingWeed', function(hasShear)
  if hasShear then
  TriggerEvent('mato-drugs:pickWeed')
  else
    lib.notify({
      title = 'You need a hedge shear!',
      description = '',
      type = 'error'
    })
  end
end)

AddEventHandler('onResourceStop', function(resource)
  if (GetCurrentResourceName() ~= resource) then
    return
  end
  if GlobalState.plantIds ~= nil then
  for i = 1, #GlobalState.plantIds do
    TriggerServerEvent('mato-drugs:deleteEntity',  GlobalState.plantIds[i].object, 'none')
  end
  end
    TriggerServerEvent('mato-drugs:changeStateOfPlantsCount', 0) -- set spawnObjectsCount to 0

end)
