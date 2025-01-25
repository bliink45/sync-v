PersonageManager = {}

local operation = false
local result = nil

RegisterNetEvent('SyncV:PersonageManager.create::receiver')
AddEventHandler('SyncV:PersonageManager.create::receiver', function(value) updateOperation(value) end)

function PersonageManager.create(identity, model, currentOutfitId)
    TriggerServerEvent('SyncV:PersonageManager.create', identity, model, currentOutfitId)
    return executeOperation()
end

RegisterNetEvent('SyncV:PersonageManager.update::receiver')
AddEventHandler('SyncV:PersonageManager.update::receiver', function(value) updateOperation(value) end)

function PersonageManager.update(personageId, attributes)
    TriggerServerEvent('SyncV:PersonageManager.update', personageId, attributes)
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