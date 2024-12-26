class_name Maps

var db: Dictionary = {}

var keys_allowed: int
var values_allowed: int

var size: int:
	get:
		return db.size()

func _init(_keys_allowed: int = 0, _values_allowed: int = 0):
	keys_allowed = _keys_allowed
	values_allowed = _values_allowed
	pass

func get_value(_id: Variant = null) -> Variant:
	if !check_key(_id):
		return null
	if db.has(_id):
		return db[_id]
	return null

func set_value(_id: Variant = null, _val: Variant = null) -> bool:
	if !check_key(_id) or !check_value(_val):
		return false
	if db.has(_id):
		db[_id] = _val
		return true
	return false

func add(_id: Variant = null, _val: Variant = null) -> bool:
	if !check_key(_id) or !check_value(_val):
		return false
	if db.has(_id):
		return false
	db[_id] = _val
	return true

func has(_id: Variant = null) -> bool:
	if !check_key(_id):
		return false
	return db.has(_id)

func has_value(_val: Variant = null) -> bool:
	if !check_value(_val):
		return false
	return _val in db.values()

func clear():
	db.clear()

func delete(_id: Variant = null) -> bool:
	if !check_key(_id):
		return false
	if db.has(_id):
		db.erase(_id)
		return true
	return false

# Lấy tất cả keys trong Dictionary
func get_all_keys() -> Array:
	return db.keys()

# Lấy tất cả values trong Dictionary
func get_all_values() -> Array:
	return db.values()

func check_key(key: Variant = null):
	if key == null:
		return false
	if keys_allowed == 0:
		return true
	if typeof(key) != keys_allowed:
		return false
	return true

func check_value(value: Variant = null):
	if value == null:
		return false
	if values_allowed == 0:
		return true
	if typeof(value) != values_allowed:
		return false
	return true

func is_empty() -> bool:
	return db.is_empty()

func print_allowed():
	print(keys_allowed)
	print(values_allowed)

func print_data():
	for key in db:
		print(key, " - ", db[key])