name 					= "Ironmaking"
description 			= "Introducing a new type of ore and its relevant items"
author					= "Mentalistpro"
version 				= "1.0"
api_version 			= 10

dst_compatible 			= true
all_clients_require_mod = true
client_only_mod 		= false

server_filter_tags 		= {"hamlet"}

icon_atlas 				= "modicon.xml"
icon 					= "modicon.tex"

configuration_options 	= {
	{
	name = "minimap_icon", 
	label = "Minimap Icon",
	options = {
			  {description = "OFF", data = 0},
			  {description = "ON", data = 1},
	          },
	default = 0
	},
}