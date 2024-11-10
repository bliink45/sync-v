-- Define the PlayerService class
PlayerService = setmetatable({}, GenericService)
PlayerService.__index = PlayerService

function PlayerService:new()
    local playerService = GenericService.new(Player, 'licenseId')
    return playerService
end

function PlayerService:existByLicense(licenseId, callback)
    Database.exists(Player, { license_id = licenseId }, function(found)
        if found then
            print('Player with license ID ' .. licenseId .. ' does exist.')
        else
            print('Player with license ID ' .. licenseId .. ' does not exist.')
        end
        callback(found)
    end)
end

function PlayerService:helloWorld()
    print('PlayerService says hello!')
end