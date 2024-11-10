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

AddEventHandler('playerJoining', function(name, setKickReason, deferrals)
    local user = source
    print('Player ' .. GetPlayerName(user) .. ' is joining.')

    local licenseId = Utility.getPlayerLicense(user)
    playerService:existByLicense(licenseId, function(playerExist)
        if not playerExist then
            print('Player ' .. GetPlayerName(user) .. ' does not exist.')
            playerService:register(function()
                local currentDate = os.date('%Y-%m-%d %H:%M:%S')
                return Player:new(nil, licenseId, 0, 0, 0, nil, 1, false)
            end, function() playerExist = true end)
        end

        Citizen.CreateThread(function()
            while not playerExist do
                Citizen.Wait(10)
            end
            playerService:load(licenseId)
        end)
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local user = source
    local licenseId = Utility.getPlayerLicense(user)

    print('Player ' .. GetPlayerName(user) .. ' dropped (reason: ' .. reason .. ').')
    playerService:remove(licenseId)
end)