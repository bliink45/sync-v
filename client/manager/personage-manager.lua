PersonageManager = {}

local operation = false
local result

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

RegisterNetEvent('SyncV:PersonageManager.getListByPlayerId::receiver')
AddEventHandler('SyncV:PersonageManager.getListByPlayerId::receiver', function(value) updateOperation(value) end)

function PersonageManager.getListByPlayerId(playerId)
    TriggerServerEvent('SyncV:PersonageManager.getListByPlayerId', playerId)
    return executeOperation()
end

RegisterNetEvent('SyncV:PersonageManager.getById::receiver')
AddEventHandler('SyncV:PersonageManager.getById::receiver', function(value) updateOperation(value) end)

function PersonageManager.getById(personageId)
    TriggerServerEvent('SyncV:PersonageManager.getById', personageId)
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