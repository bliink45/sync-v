OutfitManager = {}

local operation = false
local result

function OutfitManager.deleteById(outfitId)
    TriggerServerEvent('SyncV:OutfitManager.deleteById', outfitId)
    return outfitManagerExecuteOperation()
end

RegisterNetEvent('SyncV:OutfitManager.deleteAll::receiver')
AddEventHandler('SyncV:OutfitManager.deleteAll::receiver', function(value) outfitManagerUpdateOperation(value) end)

function OutfitManager.deleteAll(outfitList)
    TriggerServerEvent('SyncV:OutfitManager.deleteAll', outfitList)
    return outfitManagerExecuteOperation()
end

function outfitManagerUpdateOperation(value)
    result = value
    operation = false
end

function outfitManagerExecuteOperation()
    operation = true
    while operation == true do
        Citizen.Wait(1)
    end
    return result
end