-- Define the OutfitService class
OutfitService = setmetatable({}, GenericService)
OutfitService.__index = OutfitService

function OutfitService:new()
    local outfitService = GenericService.new(self, Outfit, "personageId", false)
    return outfitService
end

outfitService = OutfitService:new()