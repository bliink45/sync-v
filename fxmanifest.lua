fx_version 'adamant'
game 'gta5'

name 'SyncV'
description 'Custom modular framework.'
author 'bliink & Alex Grants'
version '1.0'

-- Server-specific scripts
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/**/*.lua'
}

-- Shared scripts
shared_scripts {
    'config.lua',
    'shared/**/*.lua'
}