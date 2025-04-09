OutfitManager = {}

RegisterNetEvent('SyncV:OutfitManager.create')
AddEventHandler('SyncV:OutfitManager.create', function(personageId, name, clothes)
    TriggerClientEvent('SyncV:OutfitManager.create::receiver', source, OutfitManager.create(personageId, name, clothes))
end)

function OutfitManager.create(personageId, name, clothes)
    return outfitService:register(function()
        return Outfit:new(nil, personageId, name, clothes)
    end)
end

RegisterNetEvent('SyncV:OutfitManager.update')
AddEventHandler('SyncV:OutfitManager.update', function(outfitId, attributes)
    TriggerClientEvent('SyncV:OutfitManager.update::receiver', source, OutfitManager.update(outfitId, attributes))
end)

function OutfitManager.update(outfitId, attributes)
    local outfitEntity = personageService:load({ ["id"] = outfitId })

    for key, value in pairs(attributes) do
        outfitEntity[key] = value
    end

    personageService:update(outfitEntity)
end

RegisterNetEvent('SyncV:OutfitManager.getByPersonageId')
AddEventHandler('SyncV:OutfitManager.getByPersonageId', function(personageId)
    TriggerClientEvent('SyncV:OutfitManager.getByPersonageId::receiver', source, OutfitManager.getByPersonageId(personageId))
end)

function OutfitManager.getByPersonageId(personageId)
    if Config.Dev.debug then
        print("OutfitManager.getByPersonageId("..personageId..")")
    end
    return outfitService:get(personageId)
end