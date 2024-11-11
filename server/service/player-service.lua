-- Define the PlayerService class
PlayerService = setmetatable({}, GenericService)
PlayerService.__index = PlayerService

function PlayerService:new()
    local playerService = GenericService.new(self, Player, 'licenseId', true)
    return playerService
end

function PlayerService:existByLicense(licenseId, callback)
    Database.exists(Player, { license_id = licenseId }, function(exist)
        if exist then
            print('Player with license ID ' .. licenseId .. ' does exist.')
        else
            print('Player with license ID ' .. licenseId .. ' does not exist.')
        end
        callback(exist)
    end)
end

playerService = PlayerService:new()