-- Define a static class (a table with only static methods)
Database = {}

-- Add static methods
-- Add static methods
function Database.fetchAll(Type, callback)
    -- Query to fetch all table information
    MySQL.Async.fetchAll('SELECT * FROM ' .. Type.getTypeName(), {}, function(queryResult)
        local out = {}
        for _, rawPlayerObject in ipairs(queryResult) do
            -- Convert the raw object to the desired type
            table.insert(out, Type.fromRawObject(rawPlayerObject))
        end
        if callback ~= nil then
            callback(out)
        end
    end)
end

function Database.fetchOne(Type, conditions, callback)
    local query, variables = QueryBuilder.buildFetchOneQuery(Type, conditions)
    if Config.Dev.debug then
        print(query)
    end
    MySQL.Async.fetchAll(query, variables, function(queryResult)
        if queryResult then
            local rawPlayerObject = queryResult[1]
            if Config.Dev.debug then
                print(Type.getTypeName() .. ' object with ID ' .. rawPlayerObject.id .. ' has been found.')
            end
            local result = Type.fromRawObject(Type, rawPlayerObject)
            if callback ~= nil then
                callback(result)
            end
        else
            -- Handle case where no result is found
            if Config.Dev.debug then
                print(Type.getTypeName() .. ' object has not been found.')
            end
            if callback ~= nil then
                callback(nil)
            end
        end
    end)
end

function Database.insertOne(object, callback)
    local query, variables = QueryBuilder.buildInsertOneQuery(object)
    if Config.Dev.debug then
        print(query)
    end
    MySQL.Async.insert(
        query,
        variables,
        function(insertId)
            if Config.Dev.debug then
                if insertId >= 0 then
                    print(object:getTypeName() .. ' object inserted successfully!')
                else
                    print('Failed to insert ' .. object:getTypeName() .. ' object.')
                end
            end
            if callback ~= nil then
                callback(insertId)
            end
        end
    )
end

function Database.updateOne(object, callback)
    object:updateDateOperation()

    local query, variables = QueryBuilder.buildUpdateOneQuery(object)
    if Config.Dev.debug then
        print(query)
    end
    MySQL.Async.transaction(
        { query },
        variables,
        function(success) 
            if success then
                if Config.Dev.debug then
                    print(print(object:getTypeName() .. ' object udpated successfully!'))
                end
                if callback ~= nil then
                    callback(success)
                end
            elseif Config.Dev.debug then
                print('Failed to update ' .. object:getTypeName() .. ' object.')
            end
        end
    )
end

function Database.deleteOne(object, callback)
    local query = 'DELETE FROM ' .. object:getTypeName():lower() .. ' WHERE id=@id'
    local variables = { ["@id"] = object.id }
    if Config.Dev.debug then
        print(query)
    end
    MySQL.Async.execute(
        query,
        variables,
        function(rowsChanged)
            if rowsChanged > 0 then
                if Config.Dev.debug then
                    print(object:getTypeName() .. ' object deleted successfully!')
                end
                if callback ~= nil then
                    callback()
                end
            elseif Config.Dev.debug then
                print('Failed to delete ' .. object:getTypeName() .. ' object.')
            end
        end
    )
end

function Database.exists(Type, attributes, callback)
    local query, variables = QueryBuilder.buildExistsQuery(Type, attributes)
    if Config.Dev.debug then
        print(query)
    end
    MySQL.Async.fetchScalar(query, variables, function(result)
        if callback ~= nil then
            callback(result > 0)
        end
    end)
end