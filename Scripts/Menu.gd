extends Control

onready var game_save_class = preload("res://Scripts/Save/game_save.gd")

var extensionLenght = 5

onready var worldContainer = $Worlds/ScrollContainer/WorldContainer

onready var saves = list_files_in_directory("res://saves")

var delete = false

#godot menu - https://www.youtube.com/watch?v=Mx3iyz8AUAE
#godot scroll container - https://www.youtube.com/watch?v=mMJ2Sh7VCqI
#add button with code - https://godotengine.org/qa/45367/how-to-create-a-node-and-add-it-as-a-child

func _ready():
	$MainMenu/Start.grab_focus()
	reloadSaves()

func reloadSaves():
	saves = list_files_in_directory("res://saves")
	if saves:
		#remove saves from loaded container
		for save in worldContainer.get_children():
			save.queue_free()

	for save in list_files_in_directory("res://saves"):
			var button = Button.new()
			button.text = save
			button.connect("pressed", self, "_on_world_pressed", [button.text])

			#set the font
			var dynamic_font = DynamicFont.new()
			dynamic_font.font_data = load("res://Art/Fonts/m5x7.ttf")
			dynamic_font.size = 32
			button.set("custom_fonts/font", dynamic_font)

			worldContainer.add_child(button)

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):

			file.erase(file.length() - extensionLenght, extensionLenght)
			files.append(file)

	dir.list_dir_end()

	return files

func _on_Start_pressed():
	$MainMenu.visible = false
	$Worlds.visible = true
	_ready()

func _on_Options_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()

func _on_NewWorld_pressed():
	$Worlds.visible = false
	$NewWorld.visible = true

func _on_world_pressed(name: String):
	var path = "res://saves/"
	var completePath = path + name + ".tres"
	if !delete:
		Global.setWorld(completePath)
		Global.goto_scene("res://Scenes/GameEngine/Game.tscn")
	else:
		#create the confirmation dialog	
		var popup = ConfirmationDialog.new()
		popup.window_title = "Are you sure to delete the save?"
		popup.dialog_text = "Save: " + name
		popup.connect("confirmed", self, "_on_delete_confirmed", [completePath, popup])
		popup.rect_position = Vector2(436, 241)

		$Worlds.add_child(popup)
		popup.show()

func _on_delete_confirmed(path, popup):
	#remove the popup
	popup.queue_free()

	#remove actual save
	var dir = Directory.new()
	dir.remove(path)
	
	#reload the container
	_ready()

func _on_Back_pressed():
	$MainMenu.visible = true
	$Worlds.visible = false

func _on_Generate_pressed():
	var NAMEval = "NewWorld"
	var NAME = $NewWorld/Items/Name/nameInput
	var HEIGHT = $NewWorld/Items/Height/heightInput
	var LENGTH = $NewWorld/Items/Length/lenthInput
	
	if !NAME.text.empty():
		NAMEval = NAME.text

	if NAMEval in saves: #check if the file name don't exist
		NAME.text = ""
		NAME.placeholder_text = "Already exists!"
		return
	
	if !(int(HEIGHT.text) >= 50):
		HEIGHT.text = ""
		HEIGHT.placeholder_text = "min: 50"
		return

	if !(int(LENGTH.text) >= 100):
		LENGTH.text = ""
		LENGTH.placeholder_text = "min: 100"
		return

	print(NAMEval, " ", int(LENGTH.text), " ", int(HEIGHT.text))
	generate_world(NAMEval, int(LENGTH.text), int(HEIGHT.text))
	
	reloadSaves()
	
	#Same as backNW button
	$Worlds.visible = true
	$NewWorld.visible = false

var noise: OpenSimplexNoise = OpenSimplexNoise.new()
func randomPreset() -> void:
	randomize()
	
	noise.seed = randi()
	noise.octaves = 0
	noise.period = 5
	noise.persistence = 0.588 
	noise.lacunarity = 2.43

func create_map(w, h):
	var map = []
	for x in range(w):
		var col = []
		col.resize(h)
		map.append(col)

	return map

func generate_world(name: String, max_x: int, max_y: int):
	randomPreset()
	var offset = 10
	
	#generates verticaly
	var Map = create_map(max_x, max_y)
	
	for x in max_x:
		var noise_height = int(noise.get_noise_1d(x) * 4.5) + offset # -10 to get the map lower
		Map[x][noise_height] = Global.blocks.grass
		#set_cell(x, noise_height, Blocks.blocks.grass) # position, height, mud

		var rand_limit = int(rand_range(noise_height+4, noise_height+6)) # dirt will be 4 - 6 block high
		for depth in range(noise_height+1, rand_limit):
			Map[x][depth] = Global.blocks.mud

		for depth in range(rand_limit, max_y):
			var tile_id = generate_id(noise.get_noise_2d(x, depth))
			
			if(depth > rand_limit+3):
				if(tile_id != -1):
					Map[x][depth] = Global.blocks.stone
			else:
				Map[x][depth] = Global.blocks.stone
				#set_cell(x, depth, blocks.stone)
	
	var new_save = game_save_class.new()
	new_save.name = name
	new_save.height = max_y
	new_save.length = max_x
	#spawn in middle
	new_save.player_pos = Vector2((max_x*8)/2, 0) #mult by tile size
	print(new_save.player_pos)
	new_save.tilemap_cells = Map

	print(Global.savePath + name + ".tres")
	ResourceSaver.save(Global.savePath + name + ".tres", new_save)

func generate_id(noise_level: float):
	if(noise_level <= -0.3): # value when the block wont show else it will show the block
		return -1
	else:
		return 0

func _on_BackNW_pressed():
	$Worlds.visible = true
	$NewWorld.visible = false

func _on_Delete_toggled(button_pressed):
	delete = button_pressed
