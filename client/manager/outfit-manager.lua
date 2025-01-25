OutfitManager = {}

local operation = false
local result = nil

RegisterNetEvent('SyncV:OutfitManager.create::receiver')
AddEventHandler('SyncV:OutfitManager.create::receiver', function(value) updateOperation(value) end)


function OutfitManager.create(personageId, name, clothes)
    TriggerServerEvent('SyncV:OutfitManager.create', personageId, name, clothes)
    return executeOperation()
end

RegisterNetEvent('SyncV:OutfitManager.update::receiver')
AddEventHandler('SyncV:OutfitManager.update::receiver', function(value) updateOperation(value) end)

function OutfitManager.update(outfitId, attributes)
    TriggerServerEvent('SyncV:OutfitManager.update', outfitId, attributes)
    return executeOperation()
end

function updateOperation(value)
    result = value
    operation = false
end

function executeOperation()
    operation = true
    while operation == true do
        Citizen.Wait(1)
    end
    return result
end