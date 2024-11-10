function PlayerJoiningTest()
    local licenseId = "3e42rotylj34ojyio6jhjyi89"
    local playerService = PlayerService:new()
    local player = Player:new(9, licenseId, 0, 0, 0, 12, 1, false)

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

print("============================")
print("-----------TESTS------------")
print("============================")
print('')
print("PlayerJoiningTest()")
PlayerJoiningTest()