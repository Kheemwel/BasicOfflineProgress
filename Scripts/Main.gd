extends Control


onready var unitslbl = $Units
onready var levellbl = $Level
onready var currentunitslbl = $CurrentUnitsperSecs
onready var pricelbl = $Price
onready var btn_upgrade = $Upgrade
const base_price = 10
const price_multiplier = 1.75
const units_multiplier = 2.36


onready var gamedata = SaveData.gamedata

func _ready() -> void:
	OS.set_window_position(OS.get_screen_position(OS.get_current_screen()) + OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)
	offlineprogress()
	updateGUI()


#func _process(delta: float) -> void:
#	if btn_upgrade.pressed:
#		upgrade()


func _on_Upgrade_pressed() -> void:
	upgrade()


func upgrade():
	if gamedata.units >= gamedata.price:
		$UnitTimer.stop()
		gamedata.level += 1
		gamedata.unitspersec = units_multiplier * gamedata.level
		gamedata.units -= gamedata.price
		gamedata.price = pow((base_price * gamedata.level), price_multiplier)  
		updateGUI()
		SaveData.save_data()
		$UnitTimer.start()


func _on_ResetButton_pressed() -> void:
	$UnitTimer.stop()
	Directory.new().remove("user://savefile.save")
	SaveData.load_data()
	gamedata = SaveData.gamedata
	updateGUI()
	$UnitTimer.start()


func _on_UnitTimer_timeout() -> void:
	gamedata.units += gamedata.unitspersec
	unitslbl.text = "Units: %s" % format_number(gamedata.units)
	gamedata.lastplaydatetime = OS.get_datetime()
	SaveData.save_data()


func offlineprogress():
	var lastdatetime = gamedata.lastplaydatetime
	if not lastdatetime == null:
		var currentdatetime = OS.get_datetime()
		var secondsbetween = OS.get_unix_time_from_datetime(currentdatetime) - OS.get_unix_time_from_datetime(lastdatetime)
		gamedata.units += (gamedata.unitspersec * secondsbetween)
		SaveData.save_data()


func format_number(num):
	var illions = [[1,"%.2f"], [1000.0,"%.3fK"], [1e6, "%.3fM"], [1e9,"%.3fB"], [1e12,"%.3fT"]]
	for i in illions.size():
		if (i + 1) < illions.size():
			if not num >= illions[i + 1][0]:
				return illions[i][1] % (num / illions[i][0])
				break
		else:
			return illions[i][1] % (num / illions[i][0])

func updateGUI():
	unitslbl.text = "Units: %s" % format_number(gamedata.units)
	levellbl.text = "Level: %s" % [gamedata.level]
	currentunitslbl.text = "Current Units/s: %s" % format_number(gamedata.unitspersec)
	pricelbl.text = "Price: %s" % format_number(gamedata.price)



func _on_UpgradeTimer_timeout() -> void:
	if btn_upgrade.pressed:
		upgrade()
