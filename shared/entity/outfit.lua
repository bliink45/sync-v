-- Define the Outfit class
Outfit = setmetatable({}, GenericEntity)
Outfit.__index = Outfit

function Outfit:new(id, personageId, name, clothes)
    local outfit = GenericEntity.new(self, id)

    -- Set outfit fields
    outfit.personageId = personageId
    outfit.name = name
    outfit.clothes = clothes

    return outfit
end

function Outfit:getType()
    return Outfit
end

function Outfit.getTypeName()
    return "Outfit"
end