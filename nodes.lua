--manual changes: 

local function add_fall_damage(node, damage)

	if minetest.registered_nodes[node] then

		local group = minetest.registered_nodes[node].groups

		group.falling_node_damage = damage

		minetest.override_item(node, {groups = group})
	else
		print (node .. " not found to add falling_node_damage to")
	end
end


function default.node_sound_boulder_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_hard_footstep", gain = 0.25}
	table.dig = table.dig or
			{name = "default_dig_cracky", gain = 0.35}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	table.place = table.place or
			{name = "falling_boulder", gain = 1.0}
			--{name = "default_dug_node", gain = 1.0}
			--{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

boulder_shape = minetest.settings:get("boulder_shape") or "default"



if minetest.get_modpath("boulder_dig") then
	if (boulder_shape == "default" or boulder_shape == "block") then
		minetest.register_node("boulders:boulder", {
			description = "Boulder",
			tiles = {"default_gravel.png^[colorize:black:77"},
			--tiles = {"boulder.png"},
			groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
			sounds = default.node_sound_boulder_defaults(),
			--sounds = default.node_sound_gravel_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"boulders:boulder"}}
				}
			}
		})
	else
		minetest.register_node("boulders:boulder", {
		description = "Boulder",
		drawtype = "mesh",

		mesh = "boulder.obj",
		--[[on_place = function(itemstack, placer, pointed_thing)
			local pointed_pos = minetest.get_pointed_thing_position(pointed_thing, true)
			local return_value = minetest.item_place(itemstack, placer, pointed_thing, math.random(0,3))
			local pointed_node = minetest.get_node(pointed_pos)

			if pointed_node and pointed_node.name then
				local node_def = minetest.registered_nodes[pointed_node.name]
				if node_def and node_def.buildable_to == true then
				else
				minetest.set_node(pointed_pos, {name = "boulder_dig:boulder",
												 param2 = math.random(0,3)})

				end
			end
			return return_value
		end,]]
		groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
		sounds = default.node_sound_boulder_defaults(),
		drop = {
			max_items = 1,
			items = {
				{items = {"boulder_dig:boulder"}}
			}
		},
		tiles = {"default_stone.png"},
	})
	end
	minetest.register_ore({
		ore_type = "scatter",
		ore = "boulders:boulder",
		wherein = "default:dirt",
		clust_scarcity = 4 * 4 * 4,
		clust_num_ores = 8,
		clust_size = 4,
		height_min = -31000,
		height_max = 10000,
	})
else --boulder_dig mod not loaded
minetest.log("x", "boulder_shape:"..boulder_shape)
	if(boulder_shape == "default" or boulder_shape == "round") then
		minetest.register_node("boulders:boulder", {
			description = "Boulder",
			drawtype = "mesh",

			mesh = "boulder.obj",
			--[[on_place = function(itemstack, placer, pointed_thing)
				local pointed_pos = minetest.get_pointed_thing_position(pointed_thing, true)
				local return_value = minetest.item_place(itemstack, placer, pointed_thing, math.random(0,3))
				local pointed_node = minetest.get_node(pointed_pos)

				if pointed_node and pointed_node.name then
					local node_def = minetest.registered_nodes[pointed_node.name]
					if node_def and node_def.buildable_to == true then
					else
					minetest.set_node(pointed_pos, {name = "boulder_dig:boulder",
													 param2 = math.random(0,3)})

					end
				end
				return return_value
			end,]]
			groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
			sounds = default.node_sound_boulder_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"boulder_dig:boulder"}}
				}
			},
			tiles = {"default_stone.png"},
		})
	else
		minetest.register_node("boulders:boulder", {
		description = "Boulder",
		tiles = {"default_gravel.png^[colorize:black:77"},
		--tiles = {"boulder.png"},
		groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
		sounds = default.node_sound_boulder_defaults(),
		--sounds = default.node_sound_gravel_defaults(),
		drop = {
			max_items = 1,
			items = {
				{items = {"boulders:boulder"}}
			}
		}
	})
	end
	
	stone_and_dirt = {"default:stone","default:dirt"}
	minetest.register_ore({
		ore_type = "scatter",
		ore = "boulders:boulder",
		--wherein = "default:stone",
		wherein = stone_and_dirt,
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 7,
		clust_size = 4,
		height_min = -31000,
		height_max = 10000,
	})
end

add_fall_damage("boulders:boulder", 4)

minetest.register_craft({
	output = "default:stone 4",
	recipe = {
		{"boulders:boulder", "boulders:boulder"},
		{"boulders:boulder", "boulders:boulder"},
	}
})

	
	
minetest.register_craft({
	output = "boulders:boulder 5",
	recipe = {
		{"", "default:stone", ""},
		{"default:stone", "default:stone", "default:stone"},
		{"", "default:stone", ""},
	}
})
