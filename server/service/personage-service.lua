-- Define the PersonageService class
PersonageService = setmetatable({}, GenericService)
PersonageService.__index = PersonageService

function PersonageService:new()
    local personageService = GenericService.new(self, Personage, "playerId")
    return personageService
end

personageService = PersonageService:new()