    local licenseId = "3e42rotylj34ojyio6jhjyi89"

function PlayerJoiningTest()
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

function PlayerLeavingTest()
    local player = playerService:get(licenseId)
    playerService:unload(player)
    return true
end

function runTests(tests)
    print('SyncV tests will be starting in few seconds...')
    Citizen.Wait(5000)

    local testCount = 0
    local succeeded = 0
    local failed = 0

    print("============================")
    print("-----------TESTS------------")
    print("============================")
    print('')

    for key, value in pairs(tests) do
        local success = value() and 'SUCCESS' or 'FAILED'
        print(key, success)

        testCount = testCount + 1
        if success then
            succeeded = succeeded + 1
        else
            failed = failed + 1
        end
    end

    print('')
    print("--- Test: " .. testCount .. " --- Success: " .. succeeded .. " --- Failed: " .. failed .. " ---")
end

runTests({
    PlayerJoiningTest = PlayerJoiningTest,
    PlayerLeavingTest = PlayerLeavingTest
})