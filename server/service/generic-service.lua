-- Define the GenericService class
GenericService = {
    list = {}
}

function GenericService.get(index)
    local genericEntity = self.list[index]
    print(GenericService.getEntityType().getTypeName() .. ' ID ' .. genericEntity.id .. ' has been retreived from ' .. GenericService.getIndexKey() .. ' ' .. index .. '.')
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