extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED =  225
var velocity = Vector2.ZERO
var item_name = "stone"

var player = null
var being_picked_up = false

func _ready():
	#new inventory system!
	$Sprite.texture = load("res://Art/Items/" + PlayerInventory.getItemCategory(item_name) + "/" + item_name + ".png")

#func set_name_and_texture(name):
	#$Sprite.texture = load("res://Art/Items/" + Global.item_data[name]["ItemClass"] + "/" + name + ".png")

func _physics_process(delta):
	if !being_picked_up:
		velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
	else:
		if player:
			var dir = global_position.direction_to(player.global_position)
			velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
			
			var distance = global_position.distance_to(player.global_position)

			if distance < 5:
				#TODO fix picking up items if inv is full
				PlayerInventory.add_item(item_name, 1)
				queue_free()
				player.reload_inventory()
		
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true
	$Collision.disabled = true
