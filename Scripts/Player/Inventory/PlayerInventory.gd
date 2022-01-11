extends Node

const SlotClass = preload("res://Scripts/Player/Inventory/Slot.gd")
const ItemClass = preload("res://Scripts/Player/Inventory/Item.gd")

const HOTBAR_SIZE = 5
const INVENTORY_SLOTS = 15

var inventory = {
	0: ["CopperPickaxe", 1], # --> itemIndex: [ItemName, item quantity]
	1: ["CopperAxe", 1],
	2: ["grass", 12],
	3: ["mud", 12],
	4: ["stone", 15]
}

func add_item(itemName, itemQuantity):
	for item in inventory:
		if inventory[item][0] == itemName:
			#TODO check if slot is full
			inventory[item][1] += itemQuantity
			return
	
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
