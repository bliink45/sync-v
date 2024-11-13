    local licenseId = "3e42rotylj34ojyio6jhjyi89"

function SessionManagerOnPlayerJoining()
    return SessionManager.onPlayerJoining(licenseId)
end

function SessionManagerOnPlayerDroppedTest()
    return SessionManager.onPlayerDropped(licenseId)
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
    runTests({
        SessionManagerOnPlayerJoining = SessionManagerOnPlayerJoining,
        SessionManagerOnPlayerDroppedTest = SessionManagerOnPlayerDroppedTest
    })
end