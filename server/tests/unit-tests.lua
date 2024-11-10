function PlayerJoiningTest()
    local licenseId = "3e42rotylj34ojyio6jhjyi89"

    playerService:existByLicense(licenseId, function(playerExist)
        if not playerExist then
            print('Player ' .. GetPlayerName(user) .. ' does not exist.')
            playerService:register(licenseId, function() playerExist = true end)
        end

        Citizen.CreateThread(function()
            while not playerExist do
                Citizen.Wait(10)
            end
            playerService:load(licenseId)
        end)
    end)
end

AddEventHandler('onResourceStart', function(name, setKickReason, deferrals)
    print("============================")
print("-----------TESTS------------")
    print("============================")
    print('')
    print("PlayerJoiningTest()")
    PlayerJoiningTest()
end)