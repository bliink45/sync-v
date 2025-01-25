function GetLicenseId()
    -- Get all identifiers for the player
    local identifiers = GetPlayerIdentifiers(source)

    -- Loop through the identifiers to find the license
    for _, identifier in ipairs(identifiers) do
        if string.sub(identifier, 1, 8) == "license:" then
            return string.match(identifier, "license:(%w+)") -- Return the license ID
        end
    end

    -- Return nil if no license ID is found
    return nil
end