class_name SQLController
# extends Control

# static var database: SQLite

# const file_path: String = "res://data/data.db"

# const table_unit_instance = {
# 	"id": {
# 		"data_type": "int",
# 		"primary_key": true,
# 		"not_null": true,
# 		"auto_increment": true},
# 	"base": {
# 		"data_type": "text",
# 		"not_null": true,
# 	},
# 	"name": {
# 		"data_type": "text",
# 		"not_null": true},
# 	"level": {
# 		"data_type": "int",
# 		"not_null": true},
# 	"current_hp": {
# 		"data_type": "int",
# 		"not_null": true},
# }

# func _ready():
# 	database = SQLite.new()
# 	database.path = file_path
# 	database.open_db()
# 	create_table()
# 	pass

# func create_table():
# 	database.create_table("unit_instace", table_unit_instance)

# func add_unit(base: UnitBaseModel):
# 	var id_base: String = "404"
	
# 	for index in DatabaseController.units_base:
# 		if base == DatabaseController.units_base[index]:
# 			id_base = index
	
# 	if id_base == "404":
# 		return false
	
# 	if !find_by_base(id_base).is_empty():
# 		return false
	
# 	var unit_instance: UnitInstance = UnitInstance.new(base, 1)
	
# 	var unit_schema: Dictionary = {
# 		"name": base.name,
# 		"base": id_base,
# 		"level": 1,
# 		"current_hp": unit_instance.current_hp
# 	}
	
# 	database.insert_row("unit_instace", unit_schema)
# 	return true

# func find_by_base(name_base: String):
# 	var query: String = "SELECT * FROM unit_instace WHERE name='" + name_base + "'"
# 	database.query(query)
# 	return database.query_result

# func load_units():
# 	var query: String = "SELECT * FROM unit_instace"
# 	database.query(query)
# 	return database.query_result

# # static get_unit_data(name_base: String):
# # 	var query: String = "SELECT * FROM unit_instace WHERE name='" + name_base + "'"
# # 	database.query(query)
# # 	return database.query_result