fx_version 'adamant'
game 'gta5'

name 'SyncV'
description 'Custom modular framework.'
author 'bliink & Alex Grants'
version '1.0'

-- Server specific scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*.lua'
}

-- Client specific scripts
client_scripts {
    'client/**/*.lua'
}

-- Shared scripts
shared_scripts {
    'config.lua',
    'shared/**/*.lua'
}

dependencies {
    'oxmysql'
}