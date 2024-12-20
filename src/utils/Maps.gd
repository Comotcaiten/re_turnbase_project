class_name Maps

var db: Dictionary = {}
var size: int:
	get:
		return db.size()

func _init(_db: Dictionary = {}):
	db = _db
	pass

func get_val(id):
	if db.has(id):
		return db.get(id)
	return null

func set_val(_id, _val) -> bool:
	if db.has(_id):
		db[_id] = _val
		return true
	return false

func set_db(new_db: Dictionary = {}):
	db = new_db
	return

func add_val(_id: Variant, _val: Variant = null) -> bool:
	# db.get_or_add(
	if db.has(_id):
		return false
	db[_id] = _val
	return true

func has(_id: Variant = null) -> bool:
	if _id == null:
		return false
	return db.has(_id)

func has_value(_val) -> bool:
	if _val in db.values():
		return true
	return false

func clear():
	db.clear()

func delete(_id: Variant = null):
	if _id == null:
		return false
	return db.erase(_id)