extends Control

onready var GameNode = find_parent("Game")

onready var player = GameNode.find_node("Player")
onready var tileMap = GameNode.find_node("TileMap")
onready var inventory = GameNode.find_node("Inventory")

#lables
onready var fps = $Information/FPS
onready var position = $Information/Position
onready var selectedCell = $Information/SelectedCell
onready var selectedItem = $Information/SelectedItem
onready var holdingItem = $Information/HoldingItem

var selected
var holding

func setLables():
	fps.text = ("FPS: " + str(Engine.get_frames_per_second()))
	position.text = ("Position: " + str(Vector2(round(player.position.x / 8), round(player.position.y / 8))))
	selectedCell.text = ("Selected cell: " + str(tileMap.selector.mouse_pos)) 
	#selectedItem.text = ("Selected item: " + selected) #  + str(inventory.currentSlot) 
	#holdingItem.text = ("Holding item: " + holding)

func _physics_process(delta):
	
	if false:#PlayerInventory.:
		selected = inventory.currentSlotItem.item_name
	else:
		selected = "nothing"
	
	if inventory.holding_item:
		holding = inventory.holding_item.item_name
	else:
		holding = "nothing"
	
	setLables()
