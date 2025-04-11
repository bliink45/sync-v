OutfitManager = {}

RegisterNetEvent('SyncV:OutfitManager.deleteById')
AddEventHandler('SyncV:OutfitManager.deleteById', function(outfitId)
    print("SyncV:OutfitManager: ["..GetPlayerName(source).."] delete Outfit with ID: "..outfitId.." requested.")
    TriggerClientEvent('SyncV:OutfitManager.deleteById::receiver', source, OutfitManager.deleteById(outfitId))
end)

function OutfitManager.deleteById(outfitId)
    if Config.Dev.debug then
        print("OutfitManager.deleteById("..outfitId..")")
    end
    return outfitService:deleteById(Outfit, outfitId)
end

RegisterNetEvent('SyncV:OutfitManager.deleteAll')
AddEventHandler('SyncV:OutfitManager.deleteAll',function(outfitList)
    print("SyncV:OutfitManager: ["..GetPlayerName(source).."] delete all Outfits requested.")
    TriggerClientEvent('SyncV:OutfitManager.deleteAll::receiver', source, OutfitManager.deleteAll(outfitList))
end)

function OutfitManager.deleteAll(outfitList)
    if Config.Dev.debug then
        print("OutfitManager.deleteAll([outfitList])")
    end
    return outfitService:deleteAll(Outfit, outfitList)
end