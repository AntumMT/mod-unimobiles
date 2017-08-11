title = 'Unimobiles mod for Minetest'
project = 'Unimobiles'
format = 'discount'
--format = 'markdown'
not_luadoc = true
--wrap = true
boilerplate = true
one = true

file = {
	'init.lua',
	'api.lua',
	exclude = {'engine/mobf/api.lua'},
}

local function italic(value)
	return '<i>' .. value .. '</i>'
end

new_type('setting', 'Settings')
new_type('chatcmd', 'Chat Commands', false, 'chatparam')
custom_tags = {
	{'dfield',
		title = 'Definition Fields',
	},
	{'chatparam',
		title = 'Parameters',
	},
	{'settype',
		title = 'Type',
		format = italic,
	},
	{'default',
		title = 'Default',
		format = italic,
	},
	{'note',
		title = 'Notes',
		format = italic,
	},
}

local function chatcmd_handler(item)
	local output = item.name
	for i, p in ipairs(item.tags.chatparam) do
		output = output .. ' ' .. p
	end
	
	return output
end

function custom_display_name_handler(item, default_handler)
	if item.type == 'chatcmd' then
		return chatcmd_handler(item)
	end
	
	return default_handler(item)
end
