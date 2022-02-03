extends Control

onready var inventoryMenu = $Inventory/PauseInventory
onready var menu = $PauseMenu
var paused = false

onready var game = find_parent("Game")

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		paused = !paused
		inventoryMenu.visible = paused
		menu.visible = paused

func _on_MenuButton_pressed():
	game.save_world()
	Global.goto_scene(Global.menuPath)
