PlayerManager = {}

RegisterNetEvent('SyncV:PlayerManager.getClientLicenseId')
AddEventHandler('SyncV:PlayerManager.getClientLicenseId', function()
    print("SyncV:PlayerManager: ["..GetPlayerName(source).."] get client license id requested.")
    TriggerClientEvent('SyncV:PlayerManager.getClientLicenseId::receiver', source, PlayerManager.getClientLicenseId())
end)

function PlayerManager.getClientLicenseId()
    print("PlayerManager.getClientLicenseId", source)
    if Config.Dev.debug then
        print("PlayerManager.getClientLicenseId()")
    end
    return GetLicenseId(source)
end

RegisterNetEvent('SyncV:PlayerManager.getClientPlayerData')
AddEventHandler('SyncV:PlayerManager.getClientPlayerData', function()
    print("SyncV:PlayerManager: ["..GetPlayerName(source).."] get client player data requested.")
    TriggerClientEvent('SyncV:PlayerManager.getClientPlayerData::receiver', source, PlayerManager.getClientPlayerData())
end)

function PlayerManager.getClientPlayerData()
    if Config.Dev.debug then
        print("PlayerManager.getClientPlayerData()")
    end
    return playerService:get(GetLicenseId(source))
end

RegisterNetEvent('SyncV:PlayerManager.getPlayerByLicenseId')
AddEventHandler('SyncV:PlayerManager.getPlayerByLicenseId', function(licenseId)
    print("SyncV:PlayerManager: ["..GetPlayerName(source).."] get Player by license id: "..licenseId.." requested.")
    TriggerClientEvent('SyncV:PlayerManager.getPlayerByLicenseId::receiver', source, PlayerManager.getPlayerByLicenseId(licenseId))
end)

function PlayerManager.getPlayerByLicenseId(licenseId)
    if Config.Dev.debug then
        print("PlayerManager.getPlayerByLicenseId("..licenseId..")")
    end
    return playerService:get(licenseId)
end

RegisterNetEvent('SyncV:PlayerManager.setCurrentPersonageId')
AddEventHandler('SyncV:PlayerManager.setCurrentPersonageId', function(personageId)
    print("SyncV:PlayerManager: ["..GetPlayerName(source).."] set current personage id: "..personageId.." requested.")
    TriggerClientEvent('SyncV:PlayerManager.setCurrentPersonageId::receiver', source, PlayerManager.setCurrentPersonageId(personageId))
end)

function PlayerManager.setCurrentPersonageId(personageId)
    if Config.Dev.debug then
        print("PlayerManager.setCurrentPersonageId("..personageId..")")
    end

    playerService:updateById(playerService:get(GetLicenseId(source)).id, {currentPersonageId = personageId})
end