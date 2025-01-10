PersonageManager = {}

RegisterNetEvent('SyncV:PersonageManager.create')
AddEventHandler('SyncV:PersonageManager.create', function(identity, model, currentOutfitId)
    TriggerClientEvent('SyncV:PersonageManager.create::receiver', source, PersonageManager.create(identity, model, currentOutfitId))
end)

function PersonageManager.create(identity, model, currentOutfitId)
    -- TODO
    print("licenseId", GetLicenseId())
    local playerId = playerService:get(GetLicenseId(source)).id
    print("playerId", playerId)

    registered = personageService:register(function()
        return Personage:new(nil, playerId, identity, model, currentOutfitId, Config.Core.PersonageManager.DEFAULT_PLAYER_MAX_OUTFIT)
    end)

    return registered
end

function GetLicenseId()
    -- Get all identifiers for the player
    local identifiers = GetPlayerIdentifiers(source)
    
    -- Loop through the identifiers to find the license
    for _, identifier in ipairs(identifiers) do
        if string.sub(identifier, 1, 8) == "license:" then
            return string.match(identifier, "license:(%w+)") -- Return the license ID
        end
    end
    
    -- Return nil if no license ID is found
    return nil
end