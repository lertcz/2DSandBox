extends Area2D

onready var player = find_parent("Player")

func _on_BuildArea_mouse_entered():
	player.ableToPlace = true

func _on_BuildArea_mouse_exited():
	player.ableToPlace = false
