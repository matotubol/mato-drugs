fx_version 'cerulean'
game 'gta5'

server_scripts {
    'server/weed-init.lua',
    'server/weed-process.lua',
    '@ox_core/imports/server.lua',
}
client_scripts {
    'client/weed-init.lua',
    'client/weed-process.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

files {
	'stream/mw_props.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/mw_props.ytyp'

lua54 'yes'