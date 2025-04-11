-- Define the BasicTest class
BasicTest = {}
BasicTest.__index = BasicTest

function BasicTest:new(name, test, beforeTest, afterTest)
    -- Create a new object (table) and set its metatable to Player
    local basicTest = setmetatable({}, self)

    -- Set BasicTest fields
    basicTest.name = name
    basicTest.test = test
    basicTest.beforeTest = beforeTest
    basicTest.afterTest = afterTest

    return basicTest
end

function BasicTest:runTest()
    if self.beforeTest then
        self.beforeTest()
    end

    local result = self.test()

    if self.afterTest then
        self.afterTest()
    end

    return result
end