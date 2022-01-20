#https://www.youtube.com/watch?v=mHeh-8xZvBo
extends KinematicBody2D

onready var tileMapNode = find_parent("Game").find_node("TileMap")
onready var inventory = get_node("Gui/PauseGui/Inventory")

const JUMP_FORCE = 300
const MOVE_SPEED = 150
const GRAVITY = 15
var pullRate = 0
const MAX_SPEED = 500

const FRICTION_GND = 0.1
const FRICTION_AIR = 0.8

var velocity = Vector2.ZERO
var dir = "right"

var paused = false

var ableToMine = false
var ableToPlace = false

onready var selector = tileMapNode.find_node("selector")

func _physics_process(delta: float) -> void:
	# walking
	var walk = (Input.get_action_strength("right") - Input.get_action_strength("left")) * MOVE_SPEED

	#change the player's direction
	if walk > 0:
		dir = "right"
	if walk < 0:
		dir = "left"

	if dir == "right":
		$Graphic.scale.x = 1
	else:
		$Graphic.scale.x = -1

	# falling
	velocity.y = pullRate
	
	velocity.x += walk
	move_and_slide(velocity, Vector2.UP)
	velocity.x -= walk
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	if is_on_floor():
		velocity.x *= FRICTION_GND
		pullRate = -1
		#if velocity.y >= 50:
		#	velocity.y = 50
	elif is_on_ceiling():
		#make player instantly fall if he bump his head into ceiling
		pullRate = 0
	else:
		#make gradualy falling faster
		if pullRate < 400:
			velocity.x *= FRICTION_AIR
	pullRate += GRAVITY

func reload_inventory():
	inventory.initialize_inventory()

func _input(event):
	#jumping
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			pullRate = -JUMP_FORCE

	if Input.is_action_just_pressed("ui_cancel"):
		paused = !paused
		$Gui/PauseGui/Inventory/PauseInventory.visible = paused

	if Input.is_action_just_pressed("ui_accept"):
		if paused:
			Global.goto_scene(Global.menuPath)
	
	if Input.is_action_pressed("pickUp"):
		if $Areas/PickupRange.itemsInRange.size() > 0:
			var pickupItem = $Areas/PickupRange.itemsInRange.values()[0]
			pickupItem.pick_up_item(self)
			$Areas/PickupRange.itemsInRange.erase(pickupItem)
	
	if Input.is_action_just_pressed("test"):
		print(PlayerInventory.inventory)

	if(Input.is_action_pressed("LMB")): # check for lmb
		#using items
		if PlayerInventory.inventory.has(inventory.currentSlot): #check if u hold an item
			var selectedSlot = PlayerInventory.inventory[inventory.currentSlot]
			var itemName = selectedSlot[0]
			#check if item is pickaxe
			if PlayerInventory.currentItemCategory == "Tools":
				if Global.item_data["Tools"][itemName]["ItemCategory"] == "Pickaxe":
					if ableToMine: # check if in range
						tileMapNode.removeBlock()

			#check if item is a block
			if Global.item_data["Blocks"].has(itemName):
				if ableToPlace and tileMapNode.return_cell_pos_and_id()[0] == -1: # check if in range
					#decrease the amount after ! -------------------------
					var id = Global.item_data["Blocks"][itemName]["ID"]
					selectedSlot[1] -= 1
					tileMapNode.placeBlock(id)
					#remove the block from inventory
					if selectedSlot[1] == 0:
						PlayerInventory.remove_item(inventory.slots[inventory.currentSlot])
						inventory.slots[inventory.currentSlot].removeItem()

					reload_inventory()
