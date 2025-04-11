SessionManager = {}

function registerPlayerIfNecessary(licenseId, userName)
    if not playerService:existByLicense(licenseId) then
        return playerService:register(function()
            return Player:new(nil, licenseId, userName,0, 0, 0, nil, 1, false)
        end)
    else
        return false
    end
end

function SessionManager.loadPlayer(licenseId, userName)
    registerPlayerIfNecessary(licenseId, userName)
    return playerService:get(licenseId)
end

function SessionManager.loadConnectedPlayers(players)
    if players ~= nil and #players > 0 then
        print("SessionManager.loadConnectedPlayers: Loading connected players... ("..#players.." connected)")
        for _, player in ipairs(players) do
            SessionManager.loadPlayer(GetLicenseId(player), GetPlayerName(player))
        end
        print("SessionManager.loadConnectedPlayers: All connected players has been loaded.")
    end
end

AddEventHandler('playerJoining', function()
    SessionManager.loadPlayer(GetLicenseId(source), GetPlayerName(source))
end)

AddEventHandler('playerDropped', function()
    playerService:unload(playerService:get(GetLicenseId(source)))
end)