PersonageManager = {}

local operation = false
local result = nil

RegisterNetEvent('SyncV:PersonageManager.create::receiver')
AddEventHandler('SyncV:PersonageManager.create::receiver', function(value)
    print("SyncV: new personage created")
    result = value
    operation = false
end)

function PersonageManager.create(identity, model, currentOutfitId)
    TriggerServerEvent('SyncV:PersonageManager.create', identity, model, currentOutfitId)
    
    operation = true
    while operation == true do
        Citizen.Wait(1)
    end
        
    return result
end