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
    local genericEntity = self.cached and self.list[index] or self:load({ [Utility.toSnakeCase(self.indexKey)] = index })
    if Config.debug then
        print(self.entityType.getTypeName() .. ' ID ' .. genericEntity.id .. ' has been retreived from ' .. self.indexKey .. ' ' .. index .. '.')
    end
    return genericEntity
end

function GenericService:update(genericEntity)
    local error = nil

    Database.updateOne(genericEntity, function(success)
        error = false
        if not success then
            error = true
        end
    end)

    while error == nil do
        Citizen.Wait(1)
    end

    return error
end

function GenericService:load(conditions)
    local genericEntity = nil
    local error = false

    getOneFromDatabase(self, conditions, function(entity)
        if (entity ~= nil) then
            genericEntity = entity
            if self.cached then
                addGenericEntity(self, genericEntity)
            end
        else
            error = true
        end
    end)

    while genericEntity == nil and not error do
        Citizen.Wait(1)
    end

    return genericEntity
end

function GenericService:register(builder)
    local success = nil
    local returnId = nil
    local newEntity = builder()
    Database.insertOne(newEntity, function(insertId)
        if insertId >= 0 then
            print(newEntity:getTypeName() .. ' object inserted successfully!')
        else
            print('Failed to insert ' .. newEntity:getTypeName() .. ' object.')
        end

        returnId = insertId
        success = true
    end)

    while success == nil do
        Citizen.Wait(1)
    end

    return returnId
end

function GenericService:unload(genericEntity)
    removeGenericEntity(self, genericEntity[self.indexKey])
    if Config.debug then
        print(self.entityType.getTypeName() .. ' ID ' .. genericEntity.id .. ' has been unloaded.')
    end
end

function removeGenericEntity(self, index)
    self.list[index] = nil
end

function addGenericEntity(self, genericEntity)
    self.list[genericEntity[self.indexKey]] = genericEntity
end

function getOneFromDatabase(self, conditions, callback) 
    Database.fetchOne(self.entityType, conditions, function(entity)
        if Config.debug then
            if (entity ~= nil) then
                print(self.entityType.getTypeName() .. ' ID ' .. entity.id .. ' has been loaded.')
            else
                print(self.entityType.getTypeName() .. ' object could not be fetched from database.')
            end
        end
        callback(entity)
    end)
end