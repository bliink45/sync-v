PersonageManager = {}

RegisterNetEvent('SyncV:PersonageManager.create')
AddEventHandler('SyncV:PersonageManager.create', function(identity, model, currentOutfitId)
    TriggerClientEvent('SyncV:PersonageManager.create::receiver', source, PersonageManager.create(identity, model, currentOutfitId))
end)

function PersonageManager.create(identity, model, currentOutfitId)
    local playerId = playerService:get(GetLicenseId(source)).id

    local personageId = personageService:register(function()
        return Personage:new(nil, playerId, identity, model, currentOutfitId, Config.Core.PersonageManager.DEFAULT_PLAYER_MAX_OUTFIT)
    end)

    return personageId
end

RegisterNetEvent('SyncV:PersonageManager.update')
AddEventHandler('SyncV:PersonageManager.update', function(personageId, attributes)
    TriggerClientEvent('SyncV:PersonageManager.update::receiver', source, PersonageManager.update(personageId, attributes))
end)

function PersonageManager.update(personageId, attributes)
    local personageEntity = personageService:load({ ["id"] = personageId })

    for key, value in pairs(attributes) do
        personageEntity[key] = value
    end

    personageService:update(personageEntity)
end