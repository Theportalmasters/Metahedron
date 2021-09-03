extends "res://addons/gut/test.gd"

var map_window : MovementWindow

func before_each():
	map_window = MovementWindow.get_window(Vector2.ZERO,Map.new(autofree(TileMap.new())),3)
	add_child_autofree(map_window)

func test_initalization():
	pre_map_initalzation_tests()
	add_map(Map.new(TileMap.new()))
	post_map_initalization_tests()

func pre_map_initalzation_tests():
	assert_not_null(map_window.tilemap_container)

func add_map(map : Map):
	autofree(map.tile_map)
	map_window.map = map

func post_map_initalization_tests():
	assert_not_null(map_window.map)
	assert_not_null(map_window.cursor)
	assert_eq(map_window.map.tile_map.get_parent(),map_window.tilemap_container)
	assert_eq(map_window.cursor.get_index(),0, "Cursor is behind decorations and units")
	assert_eq(map_window.cursor.get_parent(), map_window.map.tile_map, "Cursor parent is tilemap")
	assert_eq(map_window.cursor.map, map_window.map)
