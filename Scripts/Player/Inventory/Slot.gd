extends Panel
#https://www.youtube.com/watch?v=FHYb63ppHmk

var ItemClass = preload("res://Scenes/Player/Item.tscn")
var item = null
var slot_index

func initialize_item(itemName, itemQuantity):
	if item == null:
		item = ItemClass.instance()
		item.position = Vector2(2, 2) # offset
		add_child(item)
		item.set_item(itemName, itemQuantity)
	else:
		item.set_item(itemName, itemQuantity)

func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	item.set_name("Item")
	inventoryNode.add_child(item)
	item = null

#scrapped
func pickOneFromSLot():
	var inventoryNode = find_parent("Inventory")
	item.set_name("Item")
	inventoryNode.add_child(item)

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(2, 2) # offset
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
