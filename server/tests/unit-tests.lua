local player = Player:new(nil, "477f63750c51035790ce4f1ed44cb4030048eb08", 0, 0, nil, 0, 2, false)

function SessionManagerOnPlayerJoining()
    return SessionManager.onPlayerJoining(player.licenseId)
end

function SessionManagerOnPlayerDroppedTest()
    return SessionManager.onPlayerDropped(player.licenseId)
end

function init()
    local inserted = false
    Database.insertOne(player, function()
        inserted = true
    end)

    while not inserted do
        Citizen.Wait(50)
    end

    return true
end

function afterTests()
    Database.fetchOne(Player, { license_id = player.licenseId }, function(result)
        Database.deleteOne(result)
    end)
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
        print(success, key)

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

if Config.Dev.runTest then
    if init() then
        runTests({
            SessionManagerOnPlayerJoining = SessionManagerOnPlayerJoining,
            SessionManagerOnPlayerDroppedTest = SessionManagerOnPlayerDroppedTest
        })

        afterTests()
    end
end