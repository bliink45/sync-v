-- Define the Player class
Player = setmetatable({}, GenericEntity)
Player.__index = Player

function Player:new(id, licenseId, userName, groupId, xp, citizenLevel, currentPersonageId, maxPersonage, banned, lastLocation)
    local player = GenericEntity.new(self, id)

    -- Set player fields
    player.licenseId = licenseId
    player.userName = userName
    player.groupId = groupId
    player.xp = xp
    player.citizenLevel = citizenLevel
    player.currentPersonageId = currentPersonageId
    player.maxPersonage = maxPersonage
    player.banned = banned
    player.lastLocation = lastLocation

    return player
end

function Player:getType()
    return Player
end

function Player.getTypeName()
    return "Player"
end