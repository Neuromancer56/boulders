-- Register the boulders:dropper node
minetest.register_node("boulders:dropper", {
    description = "Boulder Dropper",
    tiles = {"default_stone.png^crack_anylength.png^[sheet:1x5:0,4"},
    groups = {cracky = 3, stone = 1},
    sounds = default.node_sound_stone_defaults(),
    -- Node box and selection box are the same as stone
    drawtype = "normal",
    paramtype = "light",
    is_ground_content = false,
    on_timer = function(pos)
        local players = minetest.get_connected_players()
        local player_nearby = false

        for _, player in ipairs(players) do
            local player_pos = player:get_pos()
            if vector.distance(pos, player_pos) <= 20 then
                player_nearby = true
                break
            end
        end

        if player_nearby then
            local below_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
            local below_node = minetest.get_node(below_pos)
            
            if below_node.name == "air" then
                minetest.set_node(below_pos, {name = "boulders:boulder"})
                minetest.check_for_falling(below_pos)
            end
        end

        -- Reschedule the timer
        return true
    end,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        minetest.get_node_timer(pos):start(2.0)
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        minetest.get_node_timer(pos):stop()
    end,
})


-- Function to start timers for existing nodes
local function start_dropper_timers()
    local positions = minetest.find_nodes_in_area(
        {x = -31000, y = -31000, z = -31000}, 
        {x = 31000, y = 31000, z = 31000}, 
        {"boulders:dropper"}
    )

    if positions and #positions > 0 then
        for _, pos in ipairs(positions) do
            minetest.get_node_timer(pos):start(2.0)
        end
    end
end

-- Call the function on mod load
minetest.register_on_mods_loaded(start_dropper_timers)
