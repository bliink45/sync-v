-- Define the GenericService class
GenericService = {}
GenericService.__index = GenericService

function GenericService:new(Type, indexKey)
    local genericService = setmetatable({}, self)
    genericService.list = {}
    genericService.entityType = Type
    genericService.indexKey = indexKey
    return genericService
end

function GenericService:get(index)
    local genericEntity = self.list[index]
    print(self.entityType.getTypeName() .. ' ID ' .. genericEntity.id .. ' has been retreived from ' .. self.indexKey .. ' ' .. index .. '.')
    return genericEntity
end

function GenericService:load(conditions, callback)
    Database.fetchOne(self.entityType, conditions, function(genericEntity)
        if (genericEntity ~= nil) then
            addGenericEntity(genericEntity)
            print(self.entityType.getTypeName() .. ' ID ' .. genericEntity.id .. ' has been loaded.')
            if callback ~= nil then
                callback()
            end
        end
    end)
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