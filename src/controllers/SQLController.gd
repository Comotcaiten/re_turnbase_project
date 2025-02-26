class_name SQLController
extends Control

static var database: SQLite

const table_unit_instance = {
	"id": {
		"data_type": "int",
		"primary_key": true,
		"not_null": true,
		"auto_increment": true},
	"base": {
		"data_type": "text",
		"not_null": true,
	},
	"name": {
		"data_type": "text",
		"not_null": true},
	"level": {
		"data_type": "int",
		"not_null": true},
	"current_hp": {
		"data_type": "int",
		"not_null": true},
}

func _ready():
	database = SQLite.new()
	database.path = "res://data/data.db"
	database.open_db()
	pass

static func create_table():
	database.create_table("unit_instace", table_unit_instance)

#static func add_unit(base: UnitBaseModel):
	#database.query()
