extends TileMap
class_name LevelData

func to_map() -> Map:
	var map := Map.new(self)
	for child in get_children():
		if child is Unit:
			map.units[map.world_to_map(child.global_position)] = child as Unit
	return map

func add_unit(position : Vector2):
	var new_unit = Unit.new()
	new_unit.position = position
	add_child(new_unit)
