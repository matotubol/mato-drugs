fx_version 'cerulean'
game 'gta5'

server_scripts {
    'server/server.lua'
}
client_scripts {
    'client/client.lua'
}

shared_scripts {
    '@ox_lib/init.lua'
}

files {
	'stream/mw_props.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/mw_props.ytyp'

lua54 'yes'