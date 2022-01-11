extends Area2D

onready var player = find_parent("Player")

func _on_MineArea_mouse_entered():
	player.ableToMine = true

func _on_MineArea_mouse_exited():
	player.ableToMine = false
