fx_version 'cerulean'
game 'gta5'

server_scripts {
    'server/weed/server.lua',
    'server/weed/process.lua'
}
client_scripts {
    'client/weed/client.lua',
    'client/weed/process.lua'
}

shared_scripts {
    '@ox_lib/init.lua'
}

files {
	'stream/mw_props.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/mw_props.ytyp'

lua54 'yes'