-- Define a static class (a table with only static methods)
Database = {}

-- Add static methods
function Database.fetchAll(Type, callback)
    MySQL.query("SELECT * FROM " .. Type.getTypeName(), {}, function(queryResult)
        if response then
            local out = {}
            for _, rawPlayerObject in ipairs(queryResult) do
                -- Convert the raw object to the desired type
                table.insert(out, Type.fromRawObject(rawPlayerObject))
            end
        else
            -- Handle case where no result is found
            if Config.Dev.debug then
                print(Type.getTypeName() .. ' objects have not been found.')
            end
        end

        if callback ~= nil then
            callback(out)
        end
    end)
end

function Database.fetchOne(Type, conditions, callback)
    local query, variables = QueryBuilder.buildFetchOneQuery(Type, conditions)
    MySQL.single(query, variables, function(rawObject)
        if rawObject then
            if Config.Dev.debug then
                print(Type.getTypeName() .. ' object with ID ' .. rawObject.id .. ' has been found.')
            end
            if callback ~= nil then
                callback(Type.fromRawObject(Type, rawObject))
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
    MySQL.insert(query, variables, function(insertId)
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
    end)
end

function Database.updateOne(object, callback)
    -- Update dates of the current object
    object:updateDateOperation()
    local query, variables = QueryBuilder.buildUpdateOneQuery(object)
    if Config.Dev.debug then
        print(query)
    end
    MySQL.update(query, variables, function(affectedRows)
        if affectedRows ~= nil then
            if Config.Dev.debug then
                print(object:getTypeName() .. ' object updated successfully!')
                print(affectedRows .. " rows affected.")
            end
            if callback ~= nil then
                callback(success)
            end
        elseif Config.Dev.debug then
            print('Failed to update ' .. object:getTypeName() .. ' object.')
        end
    end)
end

function Database.deleteOne(object, callback)
    local query = 'DELETE FROM ' .. object:getTypeName():lower() .. ' WHERE id=?'
    local variables = { object.id }
    if Config.Dev.debug then
        print(query)
    end
    MySQL.execute(
            query,
            variables,
            function(queryInfo)
                if queryInfo ~= nil then
                    if Config.Dev.debug then
                        print(object:getTypeName() .. ' object deleted successfully!')
                        print(queryInfo.affectedRows .. " rows affected.")
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
    MySQL.scalar(query, variables, function(result)
        if callback ~= nil then
            callback(result > 0)
        end
    end)
end