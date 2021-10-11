extends Reference
class_name Person

var character : Character
export var cell : Vector2 setget set_cell
var window

const MAX_MOVES := 2
export var moves_left := MAX_MOVES

signal cell_change(delta)
signal requesting_follow_path(path)
signal lock_window()

func _init(new_character : Character):
	character = new_character

func set_cell(new_cell : Vector2):
	var old_cell = cell
	cell = new_cell
	emit_signal("cell_change",new_cell - old_cell)
	
func move_cell(path : PoolVector2Array):
	var offset = path[path.size() - 1]
	cell += offset
	
	if moves_left > 0:
		moves_left = moves_left - 1
	else:
		lock_movemement_window()
	
	emit_signal("cell_change", offset)
	emit_signal("requesting_follow_path",path)
	print("moves left ")
	print(moves_left)
	move_window(offset)

func initialize_window(map) -> MovementWindow:
	window = MovementWindow.get_window(cell,map,3)
	window.get_node("Control").connect("path_accepted", self, "move_cell")
	self.connect("lock_window", window, "lock_window")
	return window
	
func move_window(offset : Vector2):
	window.map.center_cell += offset
	window.map.repopulate_fields()
	window.map.repopulate_displays()
	window.regenerate_astar()

func to_unit(map, icon) -> Unit:
	var unit : Unit = preload("res://Scripts/Primary/Map/Displays/Unit.tscn").instance()
	map.tile_map.add_child(unit)
	unit.subscribe(self,map)
	unit.is_icon = icon
	return unit

func lock_movemement_window():
	emit_signal("lock_window")
