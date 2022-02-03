extends GridContainer

const SlotClass = preload("res://Scripts/Player/Inventory/Slot.gd")
onready var inventory_hotbar = $Hotbar
onready var inventory_slots = $PauseInventory
var holding_item = null

var hotbarSlotCount
var currentSlot = 0
var currentSlotItem
var slots

var playerNode
var itemTexture


func _ready():
	#set global player inv its location
	PlayerInventory.inventoryNode = self
	
	#find player node
	playerNode = find_parent("Player")
	
	# get the lenght of hotbar
	hotbarSlotCount = inventory_hotbar.get_child_count() - 1
	
	slots = inventory_hotbar.get_children() + inventory_slots.get_children()
	for i in range(len(slots)):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i


func initInventorySlots():
	PlayerInventory.setCurrentItemAndCategory()
	initialize_inventory()
	moveSelector()
	holdingItemTexture(slots[0].item) # set a texture of 1st item if item exist

func initialize_inventory():
	var slots = inventory_hotbar.get_children() + inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory and PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func moveSelector():
	$Selector.position.x = currentSlot * 22
	if !holding_item:
		holdingItemTexture(slots[currentSlot].item)

func holdingItemTexture(currentItem):
	if currentItem: # if the player hold an item
		itemTexture = currentItem.get_node("Texture").texture
	else:
		itemTexture = null
	playerNode.find_node("Item").texture = itemTexture

func remove_one(selectedSlot):
	selectedSlot[1] -= 1
	if selectedSlot[1] == 0:
		PlayerInventory.remove_item(slots[currentSlot])
		holdingItemTexture(null)
		slots[currentSlot].removeItem()

	initialize_inventory()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item: #place holding item into slot
					left_click_empty_slot(slot)
				else: # slot occupied	
					#swaped items get pregen names which will result in error !
					if holding_item.item_name != slot.item.item_name: #swap holding item in slot
						left_click_different_slot(event, slot)
					else: # merge items
						left_click_same_item(slot)
			elif slot.item: # not holding an item, pickup item
				left_click_not_holding(slot)
		
		if event.button_index == BUTTON_RIGHT && event.pressed:
			right_click_take_one(slot)

func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null
	holdingItemTexture(slots[currentSlot].item) #show selected item instead

func left_click_different_slot(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	#temp_item.set_name("Item")
	#print(slot.item.name)
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(Global.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity

	if able_to_add >= holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null

	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holdingItemTexture(holding_item)
	holding_item.global_position = get_global_mouse_position()

func right_click_take_one(slot: SlotClass):
	#todo implement split
	print(slot.slot_index)
	print(PlayerInventory.inventory[slot.slot_index])
	var clickedSlot = PlayerInventory.inventory[slot.slot_index]
	#remove_one(clickedSlot, slot)

func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("wUP"):
		#bar move left
		if currentSlot <= 0:
			currentSlot = hotbarSlotCount
		else:
			currentSlot -= 1
		
		PlayerInventory.setCurrentItemAndCategory()
		moveSelector()

	elif Input.is_action_just_released("wDOWN"):
		#bar move right
		if currentSlot >= hotbarSlotCount:
			currentSlot = 0
		else:
			currentSlot += 1
		
		PlayerInventory.setCurrentItemAndCategory()
		moveSelector()
