function beforeTests()
end

function afterTests()
end

function runTests(tests)
    local testCount = 0
    local succeeded = 0
    local failed = 0

    print("============================")
    print("-----------TESTS------------")
    print("============================")
    print('')

    for _, test in pairs(tests) do
        local success = test:runTest() and 'SUCCESS' or 'FAILED'
        print(success, test.name)

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

function runUnitTests()
    beforeTests()
    runTests({
        BasicTest:new(
                "SessionManagerTest",
                function()
                    local player =  SessionManager.loadPlayer(
                            "fake_license_id",
                            "TestUser"
                    )
                    return player ~= nil
                end,
                nil,
                function()
                    local player = playerService:get("fake_license_id")
                    Database.deleteOne(Player, player.id)
                    playerService:unload(player)
                end
        )
    })
    afterTests()
end