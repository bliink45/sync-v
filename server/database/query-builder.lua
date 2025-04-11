QueryBuilder = {}

function QueryBuilder.buildUpdateOneQuery(object)
    local objectId = object.id

    local set = 'SET '
    local variables = build(object:toRawObject(), function(index, maxIndex, key, _)
        local separator = index < maxIndex and ', ' or ''
        set = set .. key .. '=?' .. separator
    end)

    return 'UPDATE ' .. Utility.toSnakeCase(object:getTypeName()) .. ' ' .. set .. ' WHERE id='..objectId, variables
end

function QueryBuilder.buildInsertOneQuery(object)
    local fields = '('
    local variables = build(object:toRawObject(), function(index, maxIndex, key, _)
        local separator = index < maxIndex and ', ' or ')'
        fields = fields .. key .. separator
    end)

    local values = fields:gsub("([%w_]+)", "?")
    return "INSERT INTO " .. Utility.toSnakeCase(object:getTypeName()) .. ' ' .. fields .. ' VALUES ' .. values, variables
end

function QueryBuilder.buildFetchQuery(Type, conditions)
    local where = 'WHERE '

    local variables = build(conditions, function(index, maxIndex, key, _)
        local separator = index < maxIndex and ' AND ' or ''
        where = where .. key .. '=?' .. separator
    end)

    return "SELECT * FROM " .. Utility.toSnakeCase(Type.getTypeName()) .. ' ' .. where, variables
end

function QueryBuilder.buildExistsQuery(Type, attributes)
    local where = 'WHERE '

    local variables = build(attributes, function(index, maxIndex, key, _)
        local separator = index < maxIndex and ' AND ' or ''
        where = where .. key .. '=?' .. separator
    end)

    return "SELECT COUNT(*) FROM " .. Utility.toSnakeCase(Type:getTypeName()) .. ' ' .. where, variables
end

function build(map, builder)
    local maxIndex = Utility.countObjectFields(map)
    local variables = {}
    local index = 1
    
    for key, value in pairs(map) do
        builder(index, maxIndex, key, value)
        table.insert(variables, value)
        index = index + 1
    end

    return variables
end