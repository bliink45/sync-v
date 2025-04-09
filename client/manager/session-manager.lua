SessionManager = {}

local operation = false
local result

RegisterNetEvent('SyncV:SessionManager.getPlayerList::receiver')
AddEventHandler('SyncV:SessionManager.getPlayerList::receiver', function(value) updateOperation(value) end)

function SessionManager.getPlayerList()
    TriggerServerEvent('SyncV:SessionManager.getPlayerList')
    return executeOperation()
end

RegisterNetEvent('SyncV:SessionManager.getPlayerCount::receiver')
AddEventHandler('SyncV:SessionManager.getPlayerCount::receiver', function(value) updateOperation(value) end)

function SessionManager.getPlayerCount()
    TriggerServerEvent('SyncV:SessionManager.getPlayerCount')
    return executeOperation()
end

RegisterNetEvent('SyncV:SessionManager.getPlayerByLicenseId::receiver')
AddEventHandler('SyncV:SessionManager.getPlayerByLicenseId::receiver', function(value) updateOperation(value) end)

function SessionManager.getPlayerByLicenseId(licenseId)
    TriggerServerEvent('SyncV:SessionManager.getPlayerByLicenseId', licenseId)
    return executeOperation()
end

RegisterNetEvent('SyncV:SessionManager.getPlayerById::receiver')
AddEventHandler('SyncV:SessionManager.getPlayerById::receiver', function(value) updateOperation(value) end)

function SessionManager.getPlayerById(personageId)
    TriggerServerEvent('SyncV:SessionManager.getPlayerById', personageId)
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