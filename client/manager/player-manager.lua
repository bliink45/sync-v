PlayerManager = {}

local operation = false
local result

RegisterNetEvent('SyncV:PlayerManager.getClientLicenseId::receiver')
AddEventHandler('SyncV:PlayerManager.getClientLicenseId::receiver', function(value) playerManagerUpdateOperation(value) end)

function PlayerManager.getClientLicenseId()
    TriggerServerEvent('SyncV:PlayerManager.getClientLicenseId')
    return playerManagerExecuteOperation()
end

RegisterNetEvent('SyncV:PlayerManager.getClientPlayerData::receiver')
AddEventHandler('SyncV:PlayerManager.getClientPlayerData::receiver', function(value) playerManagerUpdateOperation(value) end)

function PlayerManager.getClientPlayerData()
    TriggerServerEvent('SyncV:PlayerManager.getClientPlayerData')
    return playerManagerExecuteOperation()
end

RegisterNetEvent('SyncV:PlayerManager.getPlayerByLicenseId::receiver')
AddEventHandler('SyncV:PlayerManager.getPlayerByLicenseId::receiver', function(value) playerManagerUpdateOperation(value) end)

function PlayerManager.getPlayerByLicenseId(licenseId)
    TriggerServerEvent('SyncV:PlayerManager.getPlayerByLicenseId', licenseId)
    return playerManagerExecuteOperation()
end

function playerManagerUpdateOperation(value)
    result = value
    operation = false
end

function playerManagerExecuteOperation()
    operation = true
    while operation == true do
        Citizen.Wait(1)
    end
    return result
end