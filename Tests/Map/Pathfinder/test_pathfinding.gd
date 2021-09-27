extends "res://addons/gut/test.gd"

func test_index_generation():
	var has_duplicate := false
	var checked := []
	for x in MapTestUtilites.SIZE.x:
		for y in MapTestUtilites.SIZE.y:
			var index := MapSpaceConverter.refrence_map_to_index(Vector2(x,y))
			has_duplicate = has_duplicate or checked.find(index) != -1
			checked.append(index)
	assert_false(has_duplicate, "Does not create duplicates")

func test_is_occupied():
	var map = MapTestUtilites.initalize_full_map()
	
	assert_false(Pathfinder.is_occupied(Vector2.ZERO,map), "false when not occupied")
	add_unit(map, MapTestUtilites.SIZE - Vector2.ONE)
	assert_true(Pathfinder.is_occupied(MapTestUtilites.SIZE - Vector2.ONE,map), "true when occupied")
	
	map.tile_map.free()

func test_is_walkable():
	var map := MapTestUtilites.initalize_full_map(Vector2(3,1))
	map.tile_map.set_cellv(Vector2.UP,-1)
	map.tile_map.tile_set = TileSet.new()
	map.tile_map.tile_set.create_tile(0)
	map.tile_map.tile_set.create_tile(1)
	map.tile_map.tile_set.tile_set_tile_mode(1,TileSet.ATLAS_TILE)
	map.tile_map.tile_set.autotile_set_size(1,Vector2.ONE)
	map.tile_map.tile_set.tile_add_shape(1,RectangleShape2D.new(),Transform2D.IDENTITY,false,Vector2.RIGHT)
	map.tile_map.set_cell(3,0,1,false,false,false,Vector2.RIGHT)
	map.tile_map.set_cell(3,1,1,false,false,false,Vector2.ZERO)
	add_unit(map, Vector2(2,0))
	assert_true(Pathfinder.is_walkable(Vector2.RIGHT, map), "true when full")
	assert_false(Pathfinder.is_walkable(Vector2.UP, map), "false when empty")
	assert_true(Pathfinder.is_walkable(Vector2(2,0), map), "true when occupied")
	assert_false(Pathfinder.is_walkable(Vector2(3,0), map), "false when has collision")
	assert_true(Pathfinder.is_walkable(Vector2(3,1), map), "true when does not have collison")
	
	map.tile_map.free()

func add_unit(map : Map, map_point : Vector2):
	var person = Person.new(Character.new())
	person.cell = map_point
	map.add_person(person)

func setup_walkable_map() -> Map:
	var map := MapTestUtilites.initalize_full_map(Vector2(5,2))
	map.tile_map.set_cellv(Vector2.ZERO,-1)
	var tile_set = TileSet.new()
	tile_set.create_tile(1)
	tile_set.tile_set_shape(1,0,RectangleShape2D.new())
	map.tile_map.tile_set = tile_set
	for i in 5:
		map.tile_map.set_cell(i,1,1)
	return map

func test_get_walkable_tiles():
	var map = setup_walkable_map()
	var tiles = Pathfinder.get_walkable_tiles_in_range(Vector2.RIGHT,3,map)
	assert_eq(tiles.find(Vector2.ZERO),-1,"Unwalkable tiles not included " + str(Vector2.ZERO))
	assert_ne(tiles.find(Vector2.RIGHT),-1, "Starting tile included " + str(Vector2.RIGHT))
	assert_eq(tiles.find((Vector2(5,0))),-1, "Out of range tile not included " + str(Vector2(4,0)))
	assert_eq(tiles.find(Vector2.DOWN),-1, "Tiles with collision not included " + str(Vector2(Vector2.DOWN)))
	map.tile_map.free()