PersonageManager = {}

RegisterNetEvent('SyncV:PersonageManager.getListByPlayerId')
AddEventHandler('SyncV:PersonageManager.getListByPlayerId', function(playerId)
    print("SyncV:PersonageManager: ["..GetPlayerName(source).."] get personage list by Player with ID: "..playerId.." requested.")
    TriggerClientEvent('SyncV:PersonageManager.getListByPlayerId::receiver', source,
            PersonageManager.getListByPlayerId(playerId))
end)

function PersonageManager.getListByPlayerId(playerId)
    if Config.Dev.debug then
        print("PersonageManager.getListByPlayerId("..playerId..")")
    end
    return personageService:get(playerId)
end

RegisterNetEvent('SyncV:PersonageManager.create')
AddEventHandler('SyncV:PersonageManager.create', function(PersonageData)
    print("SyncV:PersonageManager: ["..GetPlayerName(source).."] create Personage requested.")
    TriggerClientEvent('SyncV:PersonageManager.create::receiver', source, PersonageManager.create(PersonageData))
end)

function PersonageManager.create(PersonageData)
    local player = playerService:get(GetLicenseId(source))

    local personageId = personageService:register(function()
        return Personage:new(nil, player.id, SyncV.Utility.encodeJson(PersonageData.Identity),
                SyncV.Utility.encodeJson(PersonageData.Model),
                currentOutfitId, Config.Core.PersonageManager.DEFAULT_PLAYER_MAX_OUTFIT)
    end)

    local outfitId = outfitService:register(function()
        return Outfit:new(nil, personageId, PersonageData.Outfit.name,
                SyncV.Utility.encodeJson(PersonageData.Outfit.clothes))
    end)

    personageService:updateById(personageId, { ["currentOutfit"]=outfitId })
end

RegisterNetEvent('SyncV:PersonageManager.save')
AddEventHandler('SyncV:PersonageManager.save', function(personageId, PersonageData)
    print("SyncV:PersonageManager: ["..GetPlayerName(source).."] save Personage ID: " .. personageId .. " requested.")
    TriggerClientEvent('SyncV:PersonageManager.save::receiver', source, PersonageManager.save(personageId, PersonageData))
end)

function PersonageManager.save(personageId, PersonageData)
    local attributes = {
        identity = SyncV.Utility.encodeJson(PersonageData.Identity),
        model = SyncV.Utility.encodeJson(PersonageData.Model)
    }
    personageService:updateById(personageId, attributes)
end

RegisterNetEvent('SyncV:PersonageManager.getById')
AddEventHandler('SyncV:PersonageManager.getById', function(personageId)
    print("SyncV:PersonageManager: ["..GetPlayerName(source).."] get Personage with id: "..personageId.." requested.")
    TriggerClientEvent('SyncV:PersonageManager.getById::receiver', source, PersonageManager.getById(personageId))
end)

function PersonageManager.getById(personageId)
    return personageService:fetch({ id = personageId })
end

RegisterNetEvent('SyncV:PersonageManager.deleteById')
AddEventHandler('SyncV:PersonageManager.deleteById', function(personageId)
    print("SyncV:PersonageManager: ["..GetPlayerName(source).."] delete Personage with id: "..personageId.." requested.")
    TriggerClientEvent('SyncV:PersonageManager.deleteById::receiver', source, PersonageManager.deleteById(personageId))
end)

function PersonageManager.deleteById(personageId)
    -- Store 'source' before it gets erased after synchronous call (e.g: )
    local _source = source

    if Config.Dev.debug then
        print("PersonageManager.deleteById("..personageId..")")
    end

    local personage = personageService:fetch({ id = personageId })
    local player = playerService:get(GetLicenseId(_source))
    local outfitList = outfitService:get(personageId)

    if player.currentPersonageId == personage.id then
        if Config.Dev.debug then
            print("PersonageManager.deleteById: player.currentPersonageId is equal to personage.id")
            print("PersonageManager.deleteById: Updating player with id: "..player.id)
        end
        playerService:updateById(player.id, { currentPersonageId = nil })
    end

    if Config.Dev.debug then
        print("PersonageManager.deleteById: delete all related outfits for Personage with id: "..personage.id)
    end

    outfitService:deleteAll(Outfit, outfitList)

    if Config.Dev.debug then
        print("PersonageManager.deleteById: delete Personage with id: "..personage.id)
    end

    personageService:deleteById(Personage, personage.id)
end