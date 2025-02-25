class_name Maps

# Dữ kiệu kiểu Dictionary được quản lý, Mục đích là dùng cho tham chiếu
var db: Dictionary = {}

# Kiểu giá trị key/id cho phép
var keys_allowed: int

# Kiểu giá trị dữ liệu cho phép
var values_allowed: int

# Trả về kích thước của Dictionary
var size: int:
	get:
		return db.size()

var max_size: int = -1 # -1: Không giới hạn

# Hàm khởi tạo
func _init(_keys_allowed: int = 0, _values_allowed: int = 0, _db: Dictionary = {}, _max_size: int = -1):
	# if _keys_allowed < 0 or _keys_allowed > 27: # Giới hạn theo typeof()
	# 	push_error("Invalid keys_allowed type")
	# 	return
	# if _values_allowed < 0 or _values_allowed > 27:
	# 	push_error("Invalid values_allowed type")
	# 	return
	keys_allowed = _keys_allowed
	values_allowed = _values_allowed
	max_size = max(-1, _max_size)
	db = _db.duplicate()


# Lấy giá trị dựa trên key
func get_value(_key: Variant = null, _null: Variant = null) -> Variant:
	if !check_key(_key) or !db.has(_key):
		return _null
	return db.get(_key, _null)

# Cập nhật giá trị nếu key đã tồn tại
func set_value(_key: Variant = null, _val: Variant = null) -> bool:
	if !check_key(_key) or !check_value(_val) or !db.has(_key):
		return false
	db[_key] = _val # Cho phép tạo mới nếu chưa tồn tại
	return true

# Thêm key-value mới (không ghi đè nếu key đã tồn tại)
func add(_key: Variant = null, _val: Variant = null) -> bool:
	if max_size > 0 and db.size() >= max_size:
		print("Maps lỗi  size của db lớn hơn max size")
		return false
	if !check_key(_key) or !check_value(_val):
		print("Maps lỗi add vì key hoặc value đều không đúng type")
		return false
	if db.has(_key):
		print("Map da co key nay roi")
		return false
	db[_key] = _val
	return true

# Kiểm tra sự tồn tại của key
func has(_key: Variant = null) -> bool:
	return check_key(_key) and db.has(_key)

# Kiểm tra sự tồn tại của value
func has_value(_val: Variant = null) -> bool:
	return check_value(_val) and (_val in db.values())

# Xóa tất cả các phần tử
func clear():
	db.clear()

# Xóa một phần tử dựa trên key
func delete(_key: Variant = null) -> bool:
	if !check_key(_key) or !db.has(_key):
		return false
	db.erase(_key)
	return true

# Lấy tất cả keys trong Dictionary
func keys() -> Array:
	return db.keys()

# Lấy tất cả values trong Dictionary
func values() -> Array:
	return db.values()

# Kiểm tra tính hợp lệ của key
func check_key(key: Variant = null) -> bool:
	return key != null and (keys_allowed == 0 or typeof(key) == keys_allowed)

# Kiểm tra tính hợp lệ của value
func check_value(value: Variant = null) -> bool:
	return value != null and (values_allowed == 0 or typeof(value) == values_allowed)

# Kiểm tra Dictionary có trống không
func is_empty() -> bool:
	return db.is_empty()

# In ra loại dữ liệu được phép
func print_allowed():
	print("Keys Allowed Type: ", keys_allowed)
	print("Values Allowed Type: ", values_allowed)

# In ra toàn bộ dữ liệu trong Dictionary
func print_data():
	print("Dictionary Data: ", db)