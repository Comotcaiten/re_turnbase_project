class_name Maps

var db: Dictionary = {}

var keys_allowed: int
var values_allowed: int

# Trả về kích thước của Dictionary
var size: int:
	get:
		return db.size()

# Hàm khởi tạo
func _init(_keys_allowed: int = 0, _values_allowed: int = 0, _db: Dictionary = {}):
	keys_allowed = _keys_allowed
	values_allowed = _values_allowed
	db = _db.duplicate() # Tránh tham chiếu ngoài ý muốn

# Lấy giá trị dựa trên key
func get_value(_id: Variant = null) -> Variant:
	if !check_key(_id):
		return null
	return db.get(_id, null)

# Cập nhật giá trị nếu key đã tồn tại
func set_value(_id: Variant = null, _val: Variant = null) -> bool:
	if !check_key(_id) or !check_value(_val):
		return false
	db[_id] = _val # Cho phép tạo mới nếu chưa tồn tại
	return true

# Thêm key-value mới (không ghi đè nếu key đã tồn tại)
func add(_id: Variant = null, _val: Variant = null) -> bool:
	if !check_key(_id) or !check_value(_val):
		return false
	if db.has(_id):
		return false
	db[_id] = _val
	return true

# Kiểm tra sự tồn tại của key
func has(_id: Variant = null) -> bool:
	return check_key(_id) and db.has(_id)

# Kiểm tra sự tồn tại của value
func has_value(_val: Variant = null) -> bool:
	return check_value(_val) and (_val in db.values())

# Xóa tất cả các phần tử
func clear():
	db.clear()

# Xóa một phần tử dựa trên key
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

# Kiểm tra tính hợp lệ của key
func check_key(key: Variant = null) -> bool:
	if key == null:
		return false
	if keys_allowed == 0: # Không giới hạn loại key
		return true
	return typeof(key) == keys_allowed

# Kiểm tra tính hợp lệ của value
func check_value(value: Variant = null) -> bool:
	if value == null:
		return false
	if values_allowed == 0: # Không giới hạn loại value
		return true
	return typeof(value) == values_allowed

# Kiểm tra Dictionary có trống không
func is_empty() -> bool:
	return db.is_empty()

# In ra loại dữ liệu được phép
func print_allowed():
	print("Keys Allowed Type: ", keys_allowed)
	print("Values Allowed Type: ", values_allowed)

# In ra toàn bộ dữ liệu trong Dictionary
func print_data():
	for key in db:
		print("Key: ", key, " - Value: ", db[key])
