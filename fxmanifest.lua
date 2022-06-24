name 'Prospecting Example'
author 'glitchdetector'
contact 'glitchdetector@gmail.com'

fx_version 'adamant'
game 'gta5'

description 'Shows how the interface works for Prospecting'

dependencies {'prospecting'}
ui_page 'html/index.html'

files {
    'html/app.js',
    'html/index.html',
    'html/style.css',
    'html/*.png',
}

shared_script 'config.lua'
server_script '@prospecting/interface.lua'

client_scripts  {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    'client/cl_*.lua'
}

server_script 'server/sv_*.lua'


