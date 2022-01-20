extends Node2D

var item_name
var item_quantity
var item_category

func asas_ready():
	var randint = randi() % 6
	if randint == 0:
		item_name = "CopperSword"
	elif randint == 1:
		item_name = "CopperPickaxe"
	elif randint == 2:
		item_name = "CopperAxe"

	elif randint == 3:
		item_name = "stone"
	elif randint == 4:
		item_name = "grass"
	else:
		item_name = "mud"
	
	#print("res://Art/Items/" + Global.item_data[item_name]["ItemCategory"] + "/" + item_name + ".png")
	$Texture.texture = load("res://Art/Items/" + Global.item_data[item_name]["ItemClass"] + "/" + item_name + ".png")
	var stack_size = int(Global.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		$Count.visible = false
	else:
		$Count.text = String(item_quantity)

func set_item(itemName, itemQuantity):
	item_name = itemName
	item_quantity = itemQuantity
	
	$Texture.texture = load("res://Art/Items/" + PlayerInventory.getItemCategory(item_name) + "/" + item_name + ".png")

	var stack_size = int(Global.item_data[PlayerInventory.getItemCategory(item_name)][item_name]["StackSize"])
	if stack_size == 1:
		$Count.visible = false
	else:
		$Count.visible = true
		$Count.text = String(item_quantity)

func add_item_quantity(amount):
	item_quantity += amount
	$Count.text = String(item_quantity)

func decrease_item_quantity(amount):
	item_quantity -= amount
	$Count.text = String(item_quantity)
