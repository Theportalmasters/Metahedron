extends Control

onready var main : Control = $Main
onready var settings : Control = $Settings
onready var lore : Control = $Lore
onready var credits : Control = $Credits

var gut

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_ESCAPE):
		back()

func back():
	main.show()
	if (OS.is_debug_build()):
		gut.hide()
	settings.hide()
	lore.hide()
	credits.hide()

func _on_Gut_gut_ready():
	gut = $Gut.get_gut()
	gut.set_visible(false)

func _on_Main_request_credits():
	main.hide()
	credits.show()

func _on_Main_request_game():
	var _scene = get_tree().change_scene("res://Scripts/Primary/Interface/Bootstrap/Primary Loop Bootstrap.tscn")

func _on_Main_request_gut():
	if OS.is_debug_build() && gut && !gut.is_visible():
		gut.maximize()
		gut.set_visible(true)
		gut.test_scripts()

func _on_Main_request_lore():
	main.hide()
	lore.show()

func _on_Main_request_options():
	main.hide()
	settings.show()
