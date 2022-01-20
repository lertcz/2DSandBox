extends Node

const SlotClass = preload("res://Scripts/Player/Inventory/Slot.gd")
const ItemClass = preload("res://Scripts/Player/Inventory/Item.gd")

const HOTBAR_SIZE = 5
const INVENTORY_SLOTS = 15

var inventory
#var inventory = {
#	0: ["CopperPickaxe", 1], # --> itemIndex: [ItemName, item quantity]
#}

func add_item(itemName, itemQuantity):
	for item in inventory:
		if inventory[item][0] == itemName:
			var stack_size = int(Global.item_data[itemName]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= itemQuantity:
				inventory[item][1] += itemQuantity
				return
			else:
				inventory[item][1] += able_to_add
				itemQuantity -= able_to_add

	#item dont exist yet
	#add to inventory first
	for i in range(HOTBAR_SIZE, INVENTORY_SLOTS + HOTBAR_SIZE):
		if !inventory.has(i):
			inventory[i] = [itemName, itemQuantity]
			return
	
	#then add into hotbar
	for i in range(HOTBAR_SIZE):
		if !inventory.has(i):
			inventory[i] = [itemName, itemQuantity]
			return

func remove_item(slot: SlotClass):
	inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	inventory[slot.slot_index][1] += quantity_to_add
