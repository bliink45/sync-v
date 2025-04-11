PlayerManager = {}

local operation = false
local result

RegisterNetEvent('SyncV:PlayerManager.update::receiver')
AddEventHandler('SyncV:PlayerManager.update::receiver', function(value) updateOperation(value) end)

function PlayerManager.update(playerId, attributes)
    TriggerServerEvent('SyncV:PlayerManager.update', playerId, attributes)
    return executeOperation()
end

RegisterNetEvent('SyncV:PlayerManager.getLicenseId::receiver')
AddEventHandler('SyncV:PlayerManager.getLicenseId::receiver', function(value) updateOperation(value) end)

function PlayerManager.getLicenseId()
    TriggerServerEvent('SyncV:PlayerManager.getLicenseId')
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