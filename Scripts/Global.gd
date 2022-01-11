extends Node

#save path
var savePath = "res://saves/"
var menuPath = "res://Scenes/GameEngine/Menu.tscn"

var current_scene = null
var world = null

var blocks = {
	"mud": 0,
	"grass": 1,
	"stone": 2 
}

var item_data: Dictionary

#singleton / global scripts - https://docs.godotengine.org/en/3.1/getting_started/step_by_step/singletons_autoload.html
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	item_data = LoadData("res://Data/ItemData.json")

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.queue_free()

	# Load the new scene.
	var scene = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = scene.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

func setWorld(path: String):
	print("WORLD: ", path)
	world = path
	var pathLen = path.find_last("/") + 1
	var extensionLenght = 5
	
	#remove the path and the extension to get the name
	#path.erase(0, pathLen)
	#path.erase(path.length() - extensionLenght, extensionLenght)
	#print(": ", path)

func LoadData(filePath):
	var json_data
	var file_data = File.new()
	
	file_data.open(filePath, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
