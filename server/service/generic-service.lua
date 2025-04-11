-- Define the GenericService class
GenericService = {}
GenericService.__index = GenericService

function GenericService:new(Type, indexKey, hasToManyRelation, cached)
    local genericService = setmetatable({}, self)
    genericService.list = {}
    genericService.entityType = Type
    genericService.indexKey = indexKey
    genericService.hasToManyRelation = hasToManyRelation
    genericService.cached = cached

    if cached and hasToManyRelation then
        print("SyncV: IMPORTANT WARNING -> " .. Type.entityType.getTypeName() .. " Service: cached and hasToManyRelation cannot be both set to true")
    end

    return genericService
end

function GenericService:get(index)
    local object = self.cached and self.list[index] or self:load({ [Utility.toSnakeCase(self.indexKey)] = index })
    if Config.debug then
        print(self.entityType.getTypeName() .. ' ID ' .. object.id .. ' has been retreived from ' .. self.indexKey .. ' ' .. index .. '.')
    end
    return object
end

function GenericService:update(genericEntity)
    local error
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
    local out
    local error = false

    getFromDatabase(self, conditions, function(result)
        if (result ~= nil) then
            out = result
            if self.cached then
                if self.hasToManyRelation then
                    for _, value in ipairs(result) do
                        addGenericEntity(self, value)
                    end
                else
                    addGenericEntity(self, result)
                end
            end
        else
            error = true
        end
    end)

    while out == nil and not error do
        Citizen.Wait(1)
    end

    return out
end

function GenericService:register(builder)
    local success
    local returnId
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

function getFromDatabase(self, conditions, callback)
    local databaseFunction = Database.fetchOne

    if self.hasToManyRelation then
        databaseFunction = Database.fetchAll
    end

    databaseFunction(self.entityType, conditions, function(result)
        if Config.debug then
            local debugFunc = function(entity)
                if entity ~= nil then
                    print(self.entityType.getTypeName() .. ' ID ' .. entity.id .. ' has been loaded.')
                else
                    print(self.entityType.getTypeName() .. ' object could not be fetched from database.')
                end
            end

            if self.hasToManyRelation then
                debugFunc = function(entities)
                    if entities ~= nil then
                        for _, entity in pairs(myArray) do
                            debugFunc(entity)
                        end
                    else
                        print(self.entityType.getTypeName() .. ' object list could not be fetched from database.')
                    end
                end
            end
            debugFunc(result)
        end
        callback(result)
    end)
end