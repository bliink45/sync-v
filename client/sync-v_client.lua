SyncV = {
    Core = {
        SessionManager = SessionManager,
        PersonageManager = PersonageManager,
        OutfitManager = OutfitManager,
        PlayerManager = PlayerManager
    },
    Utility = Utility
}

exports("getSyncV", function()
    return SyncV
end)