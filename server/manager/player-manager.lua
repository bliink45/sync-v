PlayerManager = {}

RegisterNetEvent('SyncV:PlayerManager.update')
AddEventHandler('SyncV:PlayerManager.update', function(outfitId, attributes)
    TriggerClientEvent('SyncV:PlayerManager.update::receiver', source, PlayerManager.update(outfitId, attributes))
end)

function PlayerManager.update(playerId, attributes)
    local playerEntity = playerService:load({ ["id"] = playerId })

    for key, value in pairs(attributes) do
        playerEntity[key] = value
    end

    playerService:update(playerEntity)
end

RegisterNetEvent('SyncV:PlayerManager.getLicenseId')
AddEventHandler('SyncV:PlayerManager.getLicenseId', function()
    TriggerClientEvent('SyncV:PlayerManager.getLicenseId::receiver', source, PlayerManager.getLicenseId())
end)

function PlayerManager.GetLicenseId()
    return GetLicenseId(source)
end