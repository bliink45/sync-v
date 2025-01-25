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

RegisterNetEvent('SyncV:PlayerManager.getPlayerLicenseId')
AddEventHandler('SyncV:PlayerManager.getPlayerLicenseId', function()
    TriggerClientEvent('SyncV:PlayerManager.getPlayerLicenseId::receiver', source, PlayerManager.getPlayerLicenseId())
end)

function PlayerManager.getPlayerLicenseId()
    return GetLicenseId(source)
end