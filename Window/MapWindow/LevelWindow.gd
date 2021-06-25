extends WindowDialog
class_name LevelWindow

onready var cursor : Cursor = $Cursor
onready var tilemap : TileMap = $TileMap

var map : Map

func initalize(tilemap : TileMap, cursor : Cursor):
	map = Map.new(tilemap)
	cursor.map = map

func _init(tilemap : TileMap = $TileMap as TileMap , cursor : Cursor = $Cursor as Cursor):
	initalize(tilemap,cursor)

func _ready():
	initalize(tilemap,cursor)
	call_deferred("resize_window")
	var _connection = get_tree().connect("screen_resized", self, "resize_window")
	_connection = cursor.connect("accept_pressed",self,"get_window")

func resize_window():
	popup(get_viewport_rect())

func get_window(cell : Vector2) -> MovementWindow:
	return MovementWindow.new() if map.is_occupied(cell) else null
