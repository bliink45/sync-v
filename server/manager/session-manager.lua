SessionManager = {}

function registerPlayerIfNecessary(licenseId, userName)
    if not playerService:existByLicense(licenseId) then
        return playerService:register(function()
            return Player:new(nil, licenseId, userName, 0, 0, 0, nil, 1, false, nil)
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

RegisterNetEvent('SyncV:SessionManager.savePlayerCurrentLocation')
AddEventHandler('SyncV:SessionManager.savePlayerCurrentLocation', function(location)
    print("SyncV:SessionManager: ["..GetPlayerName(source).."] save player current location requested.")
    SessionManager.savePlayerCurrentLocation(location)
end)

function SessionManager.savePlayerCurrentLocation(location)
    playerService:updateById(playerService:get(GetLicenseId(source)).id, {lastLocation =  SyncV.Utility.encodeJson(location)})
end

AddEventHandler('playerJoining', function()
    SessionManager.loadPlayer(GetLicenseId(source), GetPlayerName(source))
end)

AddEventHandler('playerDropped', function()
    TriggerClientEvent("SyncV:SessionManager.saveClientCurrentLocation::request", source)
    playerService:unload(playerService:get(GetLicenseId(source)))
end)

Citizen.CreateThread(function()
    while true do
        TriggerClientEvent("SyncV:SessionManager.saveClientCurrentLocation::request", -1)
        Citizen.Wait(10000)
    end
end)