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

function GenericService:get(indexValue)
    local object

    if self.cached then
        object = self.list[indexValue]
    end

    if (object == nil) then
        if Config.Dev.debug and self.cached then
            print(self.entityType.getTypeName().." with "..self.indexKey..": "..indexValue.. " is not in cache")
        end
        object = self:fetch({ [Utility.toSnakeCase(self.indexKey)] = indexValue })
    elseif Config.Dev.debug then
        print(self.entityType.getTypeName() ..' ID '.. object.id..' has been loaded from cache with index: '
                ..self.indexKey..' -> '..indexValue..'.')
    end

    return object
end

function GenericService:updateById(id, attributes)
    local genericEntity = self:fetch({ id = id })

    for key, value in pairs(attributes) do
        genericEntity[key] = value
    end

    self:update(genericEntity)
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

function GenericService:fetch(conditions)
    local out
    local error = false

    local shouldBeSingleResult = conditions.id ~= nil

    getFromDatabase(self, shouldBeSingleResult, conditions, function(result)
        out = result

        if (result ~= nil) then
            if self.cached then
                if self.hasToManyRelation and not shouldBeSingleResult then
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
    if Config.Dev.debug then
        print(self.entityType.getTypeName() .. ' ID ' .. genericEntity.id .. ' has been unloaded.')
    end
end

function GenericService:deleteById(Type, id)
    local success
    Database.deleteOne(Type, id, function(result)
        success = result

        if success then
            print(Type.getTypeName().." object with id: "..id.." deleted.")
        else
            print(Type.getTypeName()..": nothing has been deleted.")
        end
    end)

    while success == nil do
        Citizen.Wait(1)
    end

    return success
end

function GenericService:deleteAll(Type, genericEntityList)
    local success
    Database.deleteMany(Type, genericEntityList, function(result)
        success = result

        if success then
            for _, genericEntity in ipairs(genericEntityList) do
                print(Type.getTypeName().." object with id: "..genericEntity.id.." deleted.")
            end
        else
            print(Type.getTypeName()..": nothing has been deleted.")
        end
    end)

    while success == nil do
        Citizen.Wait(1)
    end

    return success
end

function removeGenericEntity(self, index)
    self.list[index] = nil
end

function addGenericEntity(self, genericEntity)
    self.list[genericEntity[self.indexKey]] = genericEntity
end

function getFromDatabase(self, shouldBeSingleResult, conditions, callback)
    local databaseFunction = Database.fetchOne

    if self.hasToManyRelation and not shouldBeSingleResult then
        databaseFunction = Database.fetchAll
    end

    databaseFunction(self.entityType, conditions, function(result)
        if Config.Dev.debug then
            local debugSingleEntity = function(entity)
                if entity ~= nil then
                    print(self.entityType.getTypeName() .. ' ID ' .. entity.id .. ' has been fetched.')
                else
                    print(self.entityType.getTypeName() .. ' object could not be fetched from database.')
                end
            end

            local debugFunc = debugSingleEntity

            if self.hasToManyRelation and not shouldBeSingleResult then
                debugFunc = function(entities)
                    if entities ~= nil then
                        for _, entity in ipairs(entities) do
                            debugSingleEntity(entity)
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