fx_version 'adamant'
game 'gta5'

name 'SyncV'
description 'Custom modular framework.'
author 'bliink & Alex Grants'
version '1.0'

-- Server specific scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*'
}

-- Client specific scripts
client_scripts {
    'client/**/*'
}

-- Shared scripts
shared_scripts {
    'config.lua',
    'shared/**/*'
}

dependencies {
    'oxmysql'
}