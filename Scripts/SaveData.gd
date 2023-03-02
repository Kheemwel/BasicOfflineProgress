extends Node

const SAVE_FILE = "user://savefile.save"
var gamedata = {}

func _ready() -> void:
	load_data()

func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var(gamedata)
	file.close()


func load_data():
	if not FileAccess.file_exists(SAVE_FILE):
		gamedata = {
			"units": 0,
			"unitspersec": 1,
			"level": 0,
			"price": 10,
			"lastplaydatetime": null
		}
		save_data()
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	gamedata = file.get_var()
	file.close()
	
