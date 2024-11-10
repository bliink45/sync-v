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
    print(query)
    MySQL.Async.fetchAll(query, variables, function(queryResult)
        if queryResult then
            local rawPlayerObject = queryResult[1]
            print(Type.getTypeName() .. ' object with ID ' .. rawPlayerObject.id .. ' has been found.')
            local result = Type.fromRawObject(Type, rawPlayerObject)
            if callback ~= nil then
                callback(result)
            end
        else
            -- Handle case where no result is found
            print(Type.getTypeName() .. ' object has not been found.')
            if callback ~= nil then
                callback(nil)
            end
        end
    end)
end

function Database.insertOne(object, callback)
    local query, variables = QueryBuilder.buildInsertOneQuery(object)
    print(query)
    MySQL.Async.execute(
        query,
        variables,
        function(rowsChanged)
            if rowsChanged > 0 then
                print(object:getTypeName() .. ' object inserted successfully!')
                if callback ~= nil then
                    callback()
                end
            else
                print('Failed to insert ' .. object:getTypeName() .. ' object.')
            end
        end
    )
end

function Database.updateOne(object, attributes, callback)
    local query, variables = QueryBuilder.buildUpdateOneQuery(object, attributes)
    print(query)
    MySQL.Async.transaction(
        { query },
        variables,
        function(success) 
            if success then
                print(print(object:getTypeName() .. ' object udpated successfully!'))
                if callback ~= nil then
                    callback()
                end
            else
                print('Failed to update ' .. object:getTypeName() .. ' object.')
            end
        end
    )
end

function Database.deleteOne(object, callback)
    MySQL.Async.execute(
        'DELETE FROM ' .. object:getTypeName():lower() .. ' WHERE id=@id',
        { ["@id"] = object.id },
        function(rowsChanged)
            if rowsChanged > 0 then
                print(object:getTypeName() .. ' object deleted successfully!')
                if callback ~= nil then
                    callback()
                end
            else
                print('Failed to delete ' .. object:getTypeName() .. ' object.')
            end
        end
    )
end

function Database.exists(Type, attributes, callback)
    local query, variables = QueryBuilder.buildExistsQuery(Type, attributes)
    print(query)
    Utility.printTable(variables)
    MySQL.Async.fetchScalar(query, variables, function(result)
        if callback ~= nil then
            callback(result > 0)
        end
    end)
end