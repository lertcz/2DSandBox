extends Area2D

onready var player = find_parent("Player")
onready var selector = find_parent("Game").find_node("selector")

func _on_MineArea_mouse_entered():
	player.ableToMine = true

func _on_MineArea_mouse_exited():
	player.ableToMine = false
