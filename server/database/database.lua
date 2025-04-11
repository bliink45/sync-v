-- Define a static class (a table with only static methods)
Database = {}

-- Add static methods
function Database.fetchAll(Type, conditions, callback)
    local query, variables = QueryBuilder.buildFetchQuery(Type, conditions)
    if Config.Dev.debug then
        print("Database.fetchAll("..Type.getTypeName()..")", query)
    end
    MySQL.query(query, variables, function(queryResult)
        local out = {}
        if queryResult then
            for _, rawObject in ipairs(queryResult) do
                -- Convert the raw object to the desired type
                if Config.Dev.debug then
                    print(Type.getTypeName() .. ' object with ID ' .. rawObject.id .. ' has been found.')
                end
                table.insert(out, Type.fromRawObject(Type, rawObject))
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
    local query, variables = QueryBuilder.buildFetchQuery(Type, conditions)
    if Config.Dev.debug then
        print("Database.fetchOne("..Type.getTypeName()..")", query)
    end
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
        print("Database.insertOne("..object:getTypeName()..")", query)
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
        print("Database.updateOne("..object:getTypeName()..")", query)
    end
    MySQL.update(query, variables, function(affectedRows)
        if affectedRows ~= nil then
            if Config.Dev.debug then
                print(object:getTypeName() .. ' object updated successfully!')
                print(affectedRows .. " row(s) affected.")
            end
            if callback ~= nil then
                callback(success)
            end
        elseif Config.Dev.debug then
            print('Failed to update ' .. object:getTypeName() .. ' object.')
        end
    end)
end

function Database.deleteOne(Type, objectId, callback)
    local query = 'DELETE FROM ' .. Type.getTypeName():lower() .. ' WHERE id=?'
    local variables = { objectId }
    if Config.Dev.debug then
        print("Database.deleteOne("..Type.getTypeName()..")", query)
    end
    MySQL.execute(
            query,
            variables,
            function(queryInfo)
                if queryInfo ~= nil then
                    if Config.Dev.debug then
                        print(queryInfo.affectedRows .. " row(s) affected.")
                    end
                    if callback ~= nil then
                        callback(queryInfo.affectedRows > 0)
                    end
                elseif Config.Dev.debug then
                    print('Failed to delete ' .. Type.getTypeName() .. ' object.')
                end
            end
    )
end

function Database.deleteMany(Type, objects, callback)
    if #objects == 0 then
        if Config.Dev.debug then
            print(Type.getTypeName() .. ": Object list empty.")
        end
        if callback then callback(false) end
        return
    end

    local query, variables = QueryBuilder.buildDeleteManyQuery(Type, objects)

    if Config.Dev.debug then
        print("Database.deleteMany("..Type.getTypeName()..")", query)
    end

    MySQL.execute(
            query,
            variables,
            function(queryInfo)
                if queryInfo ~= nil then
                    if Config.Dev.debug then
                        print(queryInfo.affectedRows .. " rows affected.")
                    end
                    if callback ~= nil then
                        callback(queryInfo.affectedRows > 0)
                    end
                elseif Config.Dev.debug then
                    print('Failed to delete ' .. typeName .. ' objects.')
                end
            end
    )
end

function Database.exists(Type, attributes, callback)
    local query, variables = QueryBuilder.buildExistsQuery(Type, attributes)
    if Config.Dev.debug then
        print("Database.exists("..Type.getTypeName()..")", query)
    end
    MySQL.scalar(query, variables, function(result)
        if callback ~= nil then
            callback(result > 0)
        end
    end)
end