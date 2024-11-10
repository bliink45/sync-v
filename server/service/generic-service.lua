-- Define the GenericService class
GenericService = {}
GenericService.__index = GenericService

function GenericService:new(Type, indexKey, cached)
    local genericService = setmetatable({}, self)
    genericService.list = {}
    genericService.entityType = Type
    genericService.indexKey = indexKey
    genericService.cached = cached
    return genericService
end

function GenericService:get(index)
    local genericEntity = nil

    if self.cached then
        genericEntity = self.list[index]
        print(self.entityType.getTypeName() .. ' ID ' .. genericEntity.id .. ' has been retreived from ' .. self.indexKey .. ' ' .. index .. '.')
    else
        local error = false
        getOneFromDatabase({ [self.indexKey] = index }, function(entity)
            if entity ~= nil then
                genericEntity = entity
            else
                error = true
            end
        end)

        while genericEntity == nil and not error do
            Citizen.Wait(10)
        end
    end

    return genericEntity
end

function GenericService:load(conditions, callback)
    local genericEntity = nil
    local error = false

    getOneFromDatabase(conditions, function(entity)
        if (entity ~= nil) then
            genericEntity = entity
            if self.cached then
                addGenericEntity(genericEntity)
            end
            if callback ~= nil then
                callback(genericEntity)
            end
        else
            error = true
        end
    end)

    while genericEntity == nil and not error do
        Citizen.Wait(50)
    end

    return genericEntity
end

function GenericService:register(builder, callback)
    local newEntity = builder()
    Database.insertOne(newEntity, callback)
end

function GenericService:unload(genericEntity)
    removeGenericEntity(genericEntity[self.indexKey])
    print(self.entityType.getTypeName() .. ' ID ' .. genericEntity.id .. ' has been unloaded.')
end

function removeGenericEntity(index)
    self.list[index] = nil
end

function addGenericEntity(genericEntity)
    self.list[genericEntity[self.indexKey]] = genericEntity
end

function getOneFromDatabase(conditions, callback) {
    Database.fetchOne(self.entityType, conditions, function(entity)
        if (entity ~= nil) then
            print(self.entityType.getTypeName() .. ' ID ' .. genericEntity.id .. ' has been loaded.')
        else
            print(self.entityType.getTypeName() .. ' object with ' .. self.indexKey .. ' ' .. index .. ' could not be fetched from database.')
        end
        callback(entity)
    end)
}