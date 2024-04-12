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
	default.node_sound_defaults(table)
	return table
end

boulder_shape = minetest.settings:get("boulder_shape") or "default"

	--wherein_boulders = {"default:stone","group:crumbly"}
	wherein_boulders = {"default:stone","default:dirt","default:dry_dirt"}

if minetest.get_modpath("boulder_dig") then
	boulder_cluster_scarcity = 7 * 7 * 7
else
	boulder_cluster_scarcity =  9 * 9 * 9
end
	
if boulder_cluster_scarcity < 7 * 7 * 7 then
	if (boulder_shape == "round") then
		minetest.register_node("boulders:boulder", {
			description = "Boulder",
			drawtype = "mesh",

			mesh = "boulder.obj",
			groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
			sounds = default.node_sound_boulder_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"boulders:boulder"}}
				}
			},
			tiles = {"default_stone.png"},
			on_construct = function(pos, node)
				check_for_tumbling(pos,"boulders:boulder",{"boulder_dig:gemstone","boulders:boulder"},"falling_boulder")
			end,
		})
	else
		minetest.register_node("boulders:boulder", {
			description = "Boulder",
			tiles = {"boulder.png"},
			on_construct = function(pos, node)
				check_for_tumbling(pos,"boulders:boulder",{"boulder_dig:gemstone","boulders:boulder"},"falling_boulder")
			end,
			groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
			sounds = default.node_sound_boulder_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"boulders:boulder"}}
				}
			}
		})
	end

	minetest.register_ore({
		ore_type = "scatter",
		ore = "boulders:boulder",
		wherein = wherein_boulders,
		---clust_scarcity = 4 * 4 * 4,
		clust_scarcity = boulder_cluster_scarcity,
		clust_num_ores = 8,
		clust_size = 4,
		height_min = -31000,
		height_max = 10000,
	})
else --boulder_dig mod not loaded
minetest.log("x", "boulder_shape:"..boulder_shape)
	if(boulder_shape == "block") then
		minetest.register_node("boulders:boulder", {
			description = "Boulder",
			tiles = {"boulder.png"},
			on_construct = function(pos, node)
				check_for_tumbling(pos,"boulders:boulder",{"boulder_dig:gemstone","boulders:boulder"},"falling_boulder")
			end,
			groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
			sounds = default.node_sound_boulder_defaults(),
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
			groups = {cracky = 2, falling_node = 1, falling_node_hurt =1},
			sounds = default.node_sound_boulder_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"boulders:boulder"}}
				}
			},
			tiles = {"default_stone.png"},
			on_construct = function(pos, node)
				check_for_tumbling(pos,"boulders:boulder",{"boulder_dig:gemstone","boulders:boulder"},"falling_boulder")
			end,
		})
	end
	minetest.register_ore({
		ore_type = "scatter",
		ore = "boulders:boulder",
		wherein = wherein_boulders,
		clust_scarcity = boulder_cluster_scarcity,
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

--[[
function check_for_tumbling(pos,"boulders:boulder","falling_boulder")
	local x_start = -1
	local x_end = 1
	local y_start = -1
	local y_end = 1
	local z_start = -1
	local z_end = 1
	for dx = x_start, x_end do
		--minetest.log("x","dx:"..dx)	
		for dy = 0, 0 do
			for dz = z_start, z_end do
				--minetest.log("x","dz:"..dz)	
				local node_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				local node = minetest.get_node(node_pos)
				local under_node_pos = {x = node_pos.x, y = node_pos.y -1, z = node_pos.z}
				local node_under_boulder = minetest.get_node(under_node_pos)
				--minetest.log("x","node.name:"..node.name)	
				if (node.name == "boulders:boulder")then 					
					local boulder_tumbled = false
					--minetest.log("x","node_under_boulder.name:"..node_under_boulder.name)	
					if (node_under_boulder.name == "boulders:boulder") then
						
						--check all 4 directions 1 node below
						x_neg_pos = {x = node_pos.x -1, y = node_pos.y -1, z = node_pos.z}
						x_neg_node = minetest.get_node(x_neg_pos)
						x_pos_pos = {x = node_pos.x +1, y = node_pos.y -1, z = node_pos.z}
						x_pos_node = minetest.get_node(x_pos_pos)
						z_neg_pos = {x = node_pos.x, y = node_pos.y -1, z = node_pos.z -1}
						z_neg_node = minetest.get_node(z_neg_pos)
						z_pos_pos = {x = node_pos.x, y = node_pos.y -1, z = node_pos.z +1}
						z_pos_node = minetest.get_node(z_pos_pos)
						above_x_neg_pos = {x = node_pos.x -1, y = node_pos.y, z = node_pos.z}
						above_x_neg_node = minetest.get_node(above_x_neg_pos)
						above_x_pos_pos = {x = node_pos.x +1, y = node_pos.y, z = node_pos.z}
						above_x_pos_node = minetest.get_node(above_x_pos_pos)
						above_z_neg_pos = {x = node_pos.x, y = node_pos.y, z = node_pos.z -1}
						above_z_neg_node = minetest.get_node(above_z_neg_pos)
						above_z_pos_pos = {x = node_pos.x, y = node_pos.y, z = node_pos.z +1}
						above_z_pos_node = minetest.get_node(above_z_pos_pos)
						local start_tumble_pos = nil
						local boulder_tumbled = false
						--minetest.log("x","x_neg_node.name:"..x_neg_node.name)	
						if(x_neg_node.name == "air" and above_x_neg_node.name == "air")then 
							minetest.set_node(node_pos, {name = "air", param2 = node.param2})
							start_tumble_pos = {x = node_pos.x -1, y = node_pos.y , z = node_pos.z}
							minetest.set_node(start_tumble_pos, {name = "boulders:boulder", param2 = node.param2})
							boulder_tumbled = true
						elseif (x_pos_node.name == "air" and above_x_pos_node.name == "air")then 
							minetest.set_node(node_pos, {name = "air", param2 = node.param2})
							start_tumble_pos = {x = node_pos.x + 1, y = node_pos.y , z = node_pos.z}
							minetest.set_node(start_tumble_pos, {name = "boulders:boulder", param2 = node.param2})
							boulder_tumbled = true
						elseif(z_neg_node.name == "air" and above_z_neg_node.name == "air")then 
							minetest.set_node(node_pos, {name = "air", param2 = node.param2})
							start_tumble_pos = {x = node_pos.x, y = node_pos.y , z = node_pos.z-1}
							minetest.set_node(start_tumble_pos, {name = "boulders:boulder", param2 = node.param2})
							boulder_tumbled = true
						elseif (z_pos_node.name == "air" and above_z_pos_node.name == "air")then 
							minetest.set_node(node_pos, {name = "air", param2 = node.param2})
							start_tumble_pos = {x = node_pos.x, y = node_pos.y , z = node_pos.z+1}
							minetest.set_node(start_tumble_pos, {name = "boulders:boulder", param2 = node.param2})
							boulder_tumbled = true
						end
						if boulder_tumbled == true then
							minetest.sound_play("falling_boulder", {pos = pos, gain = 0.5, max_hear_distance = 10}) 
							minetest.check_for_falling(start_tumble_pos)	
						end							
					end
				end
			end
		end
	end
end
]]

function node_buildable_to(node)
	node_def = minetest.registered_nodes[node.name]
	if node_def and node_def.buildable_to == true then
		return true
	else
		return false
	end
		
end

function check_for_tumbling(pos, node_name, tumble_off_of, sound_name)
    local x_start = -1
    local x_end = 1
    local y_start = -1
    local y_end = 1
    local z_start = -1
    local z_end = 1

    for dx = x_start, x_end do
        for dy = 0, 0 do
            for dz = z_start, z_end do
                local node_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
                local node = minetest.get_node(node_pos)
                local under_node_pos = {x = node_pos.x, y = node_pos.y - 1, z = node_pos.z}
                local node_under_boulder = minetest.get_node(under_node_pos)

                if (node.name == node_name) then
                    local boulder_tumbled = false

					local match_found = false
					for _, value in ipairs(tumble_off_of) do
						if node_under_boulder.name == value then
							match_found = true
							break
						end
					end
                    if (match_found) then
                        -- Check all 4 directions 1 node below
                        x_neg_pos = {x = node_pos.x - 1, y = node_pos.y - 1, z = node_pos.z}
                        x_neg_node = minetest.get_node(x_neg_pos)
                        x_pos_pos = {x = node_pos.x + 1, y = node_pos.y - 1, z = node_pos.z}
                        x_pos_node = minetest.get_node(x_pos_pos)
                        z_neg_pos = {x = node_pos.x, y = node_pos.y - 1, z = node_pos.z - 1}
                        z_neg_node = minetest.get_node(z_neg_pos)
                        z_pos_pos = {x = node_pos.x, y = node_pos.y - 1, z = node_pos.z + 1}
                        z_pos_node = minetest.get_node(z_pos_pos)
                        above_x_neg_pos = {x = node_pos.x - 1, y = node_pos.y, z = node_pos.z}
                        above_x_neg_node = minetest.get_node(above_x_neg_pos)
                        above_x_pos_pos = {x = node_pos.x + 1, y = node_pos.y, z = node_pos.z}
                        above_x_pos_node = minetest.get_node(above_x_pos_pos)
                        above_z_neg_pos = {x = node_pos.x, y = node_pos.y, z = node_pos.z - 1}
                        above_z_neg_node = minetest.get_node(above_z_neg_pos)
                        above_z_pos_pos = {x = node_pos.x, y = node_pos.y, z = node_pos.z + 1}
                        above_z_pos_node = minetest.get_node(above_z_pos_pos)
						x_neg_buildable = node_buildable_to(x_neg_node)
						x_pos_buildable = node_buildable_to(x_pos_node)
						z_neg_buildable = node_buildable_to(z_neg_node)
						z_pos_buildable = node_buildable_to(z_pos_node)
                        local start_tumble_pos = nil
                        local boulder_tumbled = false

                        local conditions = {
                            [math.random()] = {(x_neg_node.name == "air" or x_neg_buildable)and above_x_neg_node.name == "air", function()
                                minetest.set_node(node_pos, {name = "air", param2 = node.param2})
                                start_tumble_pos = {x = node_pos.x - 1, y = node_pos.y, z = node_pos.z}
                                minetest.set_node(start_tumble_pos, {name = node_name, param2 = node.param2})
                                boulder_tumbled = true
                            end},
                            [math.random()] = {(x_pos_node.name == "air" or x_pos_buildable) and above_x_pos_node.name == "air", function()
                                minetest.set_node(node_pos, {name = "air", param2 = node.param2})
                                start_tumble_pos = {x = node_pos.x + 1, y = node_pos.y, z = node_pos.z}
                                minetest.set_node(start_tumble_pos, {name = node_name, param2 = node.param2})
                                boulder_tumbled = true
                            end},
                            [math.random()] = {(z_neg_node.name == "air" or z_neg_buildable) and above_z_neg_node.name == "air", function()
                                minetest.set_node(node_pos, {name = "air", param2 = node.param2})
                                start_tumble_pos = {x = node_pos.x, y = node_pos.y, z = node_pos.z - 1}
                                minetest.set_node(start_tumble_pos, {name = node_name, param2 = node.param2})
                                boulder_tumbled = true
                            end},
                            [math.random()] = {(z_pos_node.name == "air" or z_pos_buildable) and above_z_pos_node.name == "air", function()
                                minetest.set_node(node_pos, {name = "air", param2 = node.param2})
                                start_tumble_pos = {x = node_pos.x, y = node_pos.y, z = node_pos.z + 1}
                                minetest.set_node(start_tumble_pos, {name = node_name, param2 = node.param2})
                                boulder_tumbled = true
                            end}
                        }

                        -- Execute the conditions in random order
                        for _, condition in pairs(conditions) do
                            if condition[1] then
                                condition[2]()
                                break
                            end
                        end

                        if boulder_tumbled == true then
                            minetest.sound_play(sound_name, {pos = pos, gain = 0.5, max_hear_distance = 10})
                            minetest.check_for_falling(start_tumble_pos)
                        end
                    end
                end
            end
        end
    end
end

local function boulderTouchAction(player)
	local pos = player:get_pos()
	local x_offset, z_offset= get_direction_offsets(player)
	
	--minetest.log("x","x_start:"..x_start..", x_end:"..x_end)	
	--minetest.log("x","z_start:"..z_start..", z_end:"..z_end)	
	local boulder_rolled = false
	local boulder_new_pos = nil

	for dx = x_offset, x_offset do
		--minetest.log("x","dx:"..dx)	
		for dy = 0, 0 do
			for dz = z_offset, z_offset do
				--minetest.log("x","dz:"..dz)	
				local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				boulder_new_pos = {x = pos.x + dx + dx, y = pos.y + dy, z = pos.z + dz +dz}
				local node = minetest.get_node(neighbor_pos)
				local boulder_new_pos_node = minetest.get_node(boulder_new_pos)
				
				if (node.name == "boulders:boulder" and boulder_new_pos_node.name == "air"  )then
					minetest.set_node(neighbor_pos, {name = "air", param2 = node.param2})
					minetest.set_node(boulder_new_pos, {name = "boulders:boulder", param2 = node.param2})
					boulder_rolled = true					
							
				end
			end
		end
	end
    if boulder_rolled then 
		minetest.sound_play("falling_boulder", {pos = pos, gain = 0.5, max_hear_distance = 10}) 		
		for dx = x_offset, x_offset do
			--minetest.log("x","dx:"..dx)	
			for dy = -1, 2 do
				for dz = z_offset, z_offset do
					--minetest.log("x","dz:"..dz)	
					local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
					local node = minetest.get_node(neighbor_pos)
					minetest.check_for_falling(neighbor_pos)
				end
			end
		end
	end
		--minetest.log("x","x:"..neighbor_pos.x ..",z:"..neighbor_pos.z)
	
end

registerNodeTouchAction("boulders:boulder", boulderTouchAction)