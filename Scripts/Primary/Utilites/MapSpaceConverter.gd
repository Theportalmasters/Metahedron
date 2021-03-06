class_name MapSpaceConverter
## Utility class to convert from map locations to others and back again

static func map_to_tilemap(map_point : Vector2, map) -> Vector2:
	if "map" in map:
		return map_point
	return map_point + map.tile_map.get_used_rect().position

static func tilemap_to_map(tilemap_point : Vector2, map) -> Vector2:
	if "map" in map:
		return tilemap_point
	return tilemap_point - map.tile_map.get_used_rect().position

static func map_to_local(map_point : Vector2, map) -> Vector2:
	var local_point = map.tile_map.map_to_world(map_to_tilemap(map_point, map))
	local_point += map.tile_map.cell_size/2 #Get center of the tile instead of the top left
	return local_point

static func local_to_map(local_point : Vector2, map) -> Vector2:
	return tilemap_to_map(map.tile_map.world_to_map(local_point), map)

static func map_to_global(map_point : Vector2, map) -> Vector2:
	return map.tile_map.to_global(map_to_local(map_point, map))

static func global_to_map(global_point : Vector2, map) -> Vector2:
	return local_to_map(map.tile_map.to_local(global_point), map) 

static func internal_map_to_map(internal_map_point : Vector2, map) -> Vector2:
	return internal_map_point - map.center_cell

static func map_to_internal_map(map_point : Vector2, map) -> Vector2:
	return map_point + map.center_cell

static func map_to_index(map_point : Vector2) -> int:
	var x = pow(7,map_point.x) if map_point.x > 0 else pow(3,abs(map_point.x))
	var y = pow(5,map_point.y) if map_point.y > 0 else pow(11,abs(map_point.y))
	return x*y
