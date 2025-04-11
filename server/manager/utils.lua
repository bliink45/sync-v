function GetLicenseId(player)
    if player == nil then
        player = source
    end

    -- Get all identifiers for the player
    local identifiers = GetPlayerIdentifiers(player)

    -- Loop through the identifiers to find the license
    for _, identifier in ipairs(identifiers) do
        if string.sub(identifier, 1, 8) == "license:" then
            return string.match(identifier, "license:(%w+)") -- Return the license ID
        end
    end

    if Config.Dev.debug then
        print("license Id not found for "..GetPlayerName(player))
    end

    -- Return nil if no license ID is found
    return nil
end