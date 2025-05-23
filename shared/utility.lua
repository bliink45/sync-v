Utility = {}

-- Function to display table values
function Utility.printTable(tbl)
    for key, value in pairs(tbl) do
        if type(value) == "boolean" then
            value = tostring(value)
        elseif type(value) == "table" then
            print(key .. " ---")
            Utility.printTable(value)
        else
            print(key .. ': ' .. value)
        end
    end
end

function Utility.countObjectFields(object)
    local count = 0
    for _ in pairs(object) do
        count = count + 1
    end
    return count
end

function Utility.toSnakeCase(str)
    return str:gsub("(%l)(%u)", "%1_%2"):lower()
end

function Utility.toCamelCase(str)
    return str:gsub("_(%l)", function(letter)
        return letter:upper()
    end)
end

function Utility.encodeJson(data)
    return json.encode(data)
end

function Utility.decodeJson(data)
    return json.decode(data)
end