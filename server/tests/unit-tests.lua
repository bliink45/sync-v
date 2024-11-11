function PlayerJoiningTest()
    local licenseId = "3e42rotylj34ojyio6jhjyi89"

    playerService:existByLicense(licenseId, function(playerExist)
        if not playerExist then
            playerService:register(function()
                return Player:new(nil, licenseId, 0, 0, 0, nil, 1, false)
            end)
        end

        local player = playerService:load({ license_id = licenseId })
    end)
end

print("============================")
print("-----------TESTS------------")
print("============================")
print('')
print("PlayerJoiningTest()")
PlayerJoiningTest()