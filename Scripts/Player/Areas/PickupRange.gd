extends Area2D

var itemsInRange = {}

func _on_PickupRange_body_entered(body):
	itemsInRange[body] = body

func _on_PickupRange_body_exited(body):
	if itemsInRange.has(body):
		itemsInRange.erase(body)
