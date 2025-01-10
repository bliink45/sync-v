SessionManager = {}


RegisterNetEvent('SyncV:SessionManager.getPlayerList')
AddEventHandler('SyncV:SessionManager.getPlayerList', function()
    TriggerClientEvent('SyncV:SessionManager.getPlayerList::receiver', source, SessionManager.getPlayerList())
end)

function SessionManager.getPlayerList()
    return playerService.list
end

RegisterNetEvent('SyncV:SessionManager.getPlayerCount')
AddEventHandler('SyncV:SessionManager.getPlayerCount', function()
    TriggerClientEvent('SyncV:SessionManager.getPlayerCount::receiver', source, SessionManager.getPlayerCount())
end)


function SessionManager.getPlayerCount()
    local count = 0
    for _ in pairs(playerService.list) do
        count = count + 1
    end
    return count
end

RegisterNetEvent('SyncV:SessionManager.getPlayerByLicenseId')
AddEventHandler('SyncV:SessionManager.getPlayerByLicenseId', function(licenseId)
    TriggerClientEvent('SyncV:SessionManager.getPlayerByLicenseId::receiver', source, SessionManager.getPlayerByLicenseId(licenseId))
end)

function SessionManager.getPlayerByLicenseId(licenseId)
    return playerService:get(licenseId)
end

RegisterNetEvent('SyncV:SessionManager.getPlayerById')
AddEventHandler('SyncV:SessionManager.getPlayerById', function(playerId)
    TriggerClientEvent('SyncV:SessionManager.getPlayerById::receiver', source, SessionManager.getPlayerById(playerId))
end)


function SessionManager.getPlayerById(playerId)
    for _, player in pairs(playerService.list) do
        if player.id == playerId then
            return player
        end
    end
    return nil
end

function SessionManager.onPlayerJoining(licenseId)
    local success = false
    local registered = playerService:existByLicense(licenseId)

    if not registered  then
        registered = playerService:register(function()
            return Player:new(nil, licenseId, 0, 0, 0, nil, 1, false)
        end)
    end
    
    playerService:get(licenseId)
    success = true

    return success
end

function SessionManager.onPlayerDropped(licenseId)
    local player = playerService:get(licenseId)
    playerService:unload(player)
    return true
end

AddEventHandler('playerJoining', function(name, setKickReason, deferrals)
    SessionManager.onPlayerJoining(Utility.getPlayerLicense(source))
end)

AddEventHandler('playerDropped', function(reason)
    SessionManager.onPlayerDropped(Utility.getPlayerLicense(source))
end)