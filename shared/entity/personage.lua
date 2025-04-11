-- Define the Personage class
Personage = setmetatable({}, GenericEntity)
Personage.__index = Personage

function Personage:new(id, playerId, identity, model, currentOutfit, maxOutfit)
    local personage = GenericEntity.new(self, id)

    -- Set personage fields
    personage.playerId = playerId
    personage.identity = identity
    personage.model = model
    personage.currentOutfit = currentOutfit
    personage.maxOutfit = maxOutfit

    return personage
end

function Personage:getType()
    return Personage
end

function Personage.getTypeName()
    return "Personage"
end