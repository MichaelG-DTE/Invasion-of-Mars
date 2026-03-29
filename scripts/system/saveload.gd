extends Node

const save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"playerposition" : Vector3(0,0,0),
	"pistolunlocked" : true,
	"arunlocked" : true,
	"stgununlocked" : true,
	"rpgunlocked" : true,
	"playerhealth" : 0.0,
	"playershield" : 0.0,
	"pistolammo" : 0,
	"arammo" : 0,
	"stgunammo" : 0,
	"rpgammo" : 0,
	"level" : 0,
	"enemypositions" : [],
	"enemyhealth" : [],
	"new_data_to_save" : false
}

func _ready() -> void:
	_load()

func _save():
	var file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "gibbidygobbidygoop6393")
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ, "gibbidygobbidygoop6393")
		var data = file.get_var()
		for i in data:
			if contents_to_save.has(i):
				contents_to_save[i] = data[i]
		file.close()
