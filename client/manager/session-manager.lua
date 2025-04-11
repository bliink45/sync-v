SessionManager = {}

local operation = false
local result

function sessionManagerUpdateOperation(value)
    result = value
    operation = false
end

function sessionManagerExecuteOperation()
    operation = true
    while operation == true do
        Citizen.Wait(1)
    end
    return result
end