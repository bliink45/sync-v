PersonageManager = {}

local operation = false
local result

RegisterNetEvent('SyncV:PersonageManager.getListByPlayerId::receiver')
AddEventHandler('SyncV:PersonageManager.getListByPlayerId::receiver', function(values) personageManagerUpdateOperation(values) end)

function PersonageManager.getListByPlayerId(playerId)
    TriggerServerEvent('SyncV:PersonageManager.getListByPlayerId', playerId)
    return personageManagerExecuteOperation()
end

RegisterNetEvent('SyncV:PersonageManager.save::receiver')
AddEventHandler('SyncV:PersonageManager.save::receiver', function(value) personageManagerUpdateOperation(value) end)

function PersonageManager.save(PersonageData)
    TriggerServerEvent('SyncV:PersonageManager.save', PersonageData)
    return personageManagerExecuteOperation()
end

RegisterNetEvent('SyncV:PersonageManager.deleteById::receiver')
AddEventHandler('SyncV:PersonageManager.deleteById::receiver', function(value) personageManagerUpdateOperation(value) end)

function PersonageManager.deleteById(personageId)
    TriggerServerEvent('SyncV:PersonageManager.deleteById', personageId)
    return personageManagerExecuteOperation()
end

function personageManagerUpdateOperation(value)
    result = value
    operation = false
end

function personageManagerExecuteOperation()
    operation = true
    while operation == true do
        Citizen.Wait(1)
    end

    return result
end