SyncV = {
    Core = {
        SessionManager = SessionManager,
        PersonageManager = PersonageManager,
        OutfitManager = OutfitManager,
        PlayerManager = PlayerManager
    },
    Utility = Utility
}

Citizen.CreateThread(function()
    SessionManager.loadConnectedPlayers(GetPlayers())

    if Config.Dev.runTest then
        print('SyncV tests will start soon...')
        Citizen.Wait(5000)
        runUnitTests()
    end
end)