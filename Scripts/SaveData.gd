extends Node

const SAVE_FILE = "user://savefile.save"
var gamedata = {}

func _ready() -> void:
	load_data()

func save_data():
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_var(gamedata)
	file.close()


func load_data():
	var file = File.new()
	if not file.file_exists(SAVE_FILE):
		gamedata = {
			"units": 0,
			"unitspersec": 1,
			"level": 0,
			"price": 10,
			"lastplaydatetime": null
		}
		save_data()
	file.open(SAVE_FILE, File.READ)
	gamedata = file.get_var()
	file.close()
	
