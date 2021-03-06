extends Node
class_name PrimaryLoopBootstrap,"res://Assets/Editor Icons/PrimaryLoopBootstrap.png"
## Starts up the primary gameplay loop

export var packed_level_data : PackedScene

onready var turn_gui_holder = $VSplitContainer/UnitGUI
onready var music = $AudioStreamPlayer
onready var cursor = $VSplitContainer/Playspace/Body
onready var map_scaler : MapScaler = $VSplitContainer/Playspace/Body/MapScaler
onready var end_screen = $EndScreen
onready var end_screen_timer : Timer = $EndScreen/Timer

var map : Map
var enemy_ai : EnemyAI
var turn_manager := TurnManager.new()

func _ready():
	var data = validate_level_data(packed_level_data)
	initialize_level(data)
	data.queue_free()

func _input(event):
	if event is InputEventKey && event.scancode == KEY_ESCAPE:
		var _scene = get_tree().change_scene("res://Scripts/Menu/Menu.tscn")

func initialize_level(level_data : LevelData):
	initialize_music(level_data)
	initialize_map(level_data)

func initialize_music(level_data : LevelData):
	music.stream = level_data.music
	music.play()
	var settings = Settings.new()
	music.volume_db = lerp(-50,0,settings.volume)

func initialize_map(level_data : LevelData):
	map = level_data.to_map(map_scaler.tile_map)
	map.repopulate_displays()
	turn_manager.subscribe(map)
	var _connection = turn_manager.connect("game_won",end_screen,"show")
	_connection = turn_manager.connect("game_lost",end_screen,"show")
	_connection = turn_manager.connect("game_won",end_screen_timer,"start")
	_connection = turn_manager.connect("game_lost",end_screen_timer,"start")
	cursor.map = map
	initialize_enemy_ai()
	populate_turn_gui()

# warning-ignore:shadowed_variable
func validate_level_data(packed_level_data : PackedScene) -> LevelData:
	var unpacked_level_data := packed_level_data.instance() as LevelData
	assert(unpacked_level_data != null, "Level data for " + name + " was not of type level data")
	if unpacked_level_data:
		return unpacked_level_data
	else:
		return LevelData.new()

func _on_Cursor_position_accepted(cell):
	if Pathfinder.is_occupied(cell,map):
		var person : Person = map.people[cell]
		if(!person.is_evil):
			person.open_window()

func populate_turn_gui():
	var turn_gui = turn_gui_holder.get_child(0)
	turn_gui.queue_free()
	for cell in map.people:
		var person : Person = map.people[cell]
		cursor.add_child(person.initialize_window(map))
		if !person.is_evil:
			var unit_turn_gui = turn_gui.duplicate()
			unit_turn_gui.call_deferred("subscribe",person)
			turn_gui_holder.add_child(unit_turn_gui)

func initialize_enemy_ai():
	enemy_ai = EnemyAI.new(map)
	var _connection = turn_manager.connect("new_turn", enemy_ai, "check_turn")

func _on_Timer_timeout():
	var _scene = get_tree().change_scene("res://Scripts/Menu/Menu.tscn")
