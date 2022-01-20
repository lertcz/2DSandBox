extends "res://addons/gut/test.gd"

var inventory

func before_each():
	inventory = preload("res://Scripts/Player/Inventory/Inventory.gd").new()

func test_slot_gui_input():
	inventory.slot_gui_input()
	
	assert_eq(2, 1, "should hold an item")
