-- Define the GenericEntity class
GenericEntity = {}
GenericEntity.__index = GenericEntity

function GenericEntity:new(id)
    -- Create a new object (table) and set its metatable to Player
    local genericEntity = setmetatable({}, self)

    -- Set player fields
    genericEntity.id = id
    genericEntity.createdAt = os.date("%Y/%m/%d-%H:%M:%S")
    genericEntity.updatedAt = os.date("%Y/%m/%d-%H:%M:%S")

    return genericEntity
end

function GenericEntity:toRawObject()
    local rawObject = {}
    for key, value in pairs(self) do
        rawObject[Utility.toSnakeCase(key)] = value
    end
    return rawObject
end

function GenericEntity:getType()
    return GenericEntity
end

function GenericEntity:getTypeName()
    return self:getType().getTypeName()
end

function GenericEntity.getTypeName()
    return "GenericEntity"
end

function GenericEntity.fromRawObject(Type, rawObject)
    local entity = Type:new()
    for key, value in pairs(rawObject) do
        entity[Utility.toCamelCase(key)] = value
    end
    return entity
end