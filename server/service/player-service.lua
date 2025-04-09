-- Define the PlayerService class
PlayerService = setmetatable({}, GenericService)
PlayerService.__index = PlayerService

function PlayerService:new()
    local playerService = GenericService.new(self, Player, 'licenseId', false, true)
    return playerService
end

function PlayerService:existByLicense(licenseId)
    local isExist
    Database.exists(Player, { license_id = licenseId }, function(exist)
        if Config.debug then
            if exist then
                print('Player with license ID ' .. licenseId .. ' does exist.')
            else
                print('Player with license ID ' .. licenseId .. ' does not exist.')
            end
        end
        isExist = exist
    end)

    while isExist == nil do
        Citizen.Wait(50)
    end

    return isExist
end

playerService = PlayerService:new()