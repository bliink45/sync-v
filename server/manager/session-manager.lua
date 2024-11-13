SessionManager = {}

function SessionManager.getPlayerList()
    return playerService.list
end

function SessionManager.getPlayerByLicenseId(licenseId)
    return playerService:get(licenseId)
end

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

    if registered then
        playerService:get(licenseId)
        success = true
    end
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