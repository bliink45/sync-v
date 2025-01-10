SessionManager = {}

local operation = false
local result = nil

RegisterNetEvent('SyncV:SessionManager.getPlayerList::receiver')
AddEventHandler('SyncV:SessionManager.getPlayerList::receiver', function(value)
    result = value
    operation = false
end)

function SessionManager.getPlayerList()
    TriggerServerEvent('SyncV:SessionManager.getPlayerList')
    
    operation = true
    while operation == true do
        Citizen.Wait(1)
    end
        
    return result
end

RegisterNetEvent('SyncV:SessionManager.getPlayerCount::receiver')
AddEventHandler('SyncV:SessionManager.getPlayerCount::receiver', function(value)
    result = value
    operation = false
end)

function SessionManager.getPlayerCount()
    TriggerServerEvent('SyncV:SessionManager.getPlayerCount')

    operation = true
    while operation == true do
        Citizen.Wait(1)
    end
        
    return result
end

RegisterNetEvent('SyncV:SessionManager.getPlayerByLicenseId::receiver')
AddEventHandler('SyncV:SessionManager.getPlayerByLicenseId::receiver', function(value)
    result = value
    operation = false
end)

function SessionManager.getPlayerByLicenseId(licenseId)
    TriggerServerEvent('SyncV:SessionManager.getPlayerByLicenseId', licenseId)

    operation = true
    while operation == true do
        Citizen.Wait(1)
    end
        
    return result
end