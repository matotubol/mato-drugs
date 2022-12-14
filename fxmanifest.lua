fx_version 'cerulean'
game 'gta5'

server_scripts {
    'server/weed-init.lua',
    'server/weed-process.lua',
    '@ox_core/imports/server.lua',
    '@oxmysql/lib/MySQL.lua',
}
client_scripts {
    'client/weed-init.lua',
    'client/weed-process.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

lua54 'yes'

dependencies {
	'oxmysql',
	'ox_lib',
}