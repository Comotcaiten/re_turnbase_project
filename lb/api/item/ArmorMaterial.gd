extends ItemzArmorBase
class_name ArmorMaterial

enum MaterialType {Leather, Chainmail, Golden, Iron, Diamond}

@export var defense: int

# Từ điển ánh xạ loại vật liệu với màu sắc tương ứng
var materialColorDB: Dictionary = {
    MaterialType.Leather: Color(0.7, 0.5, 0.3), # Màu nâu cho da
    MaterialType.Chainmail: Color(0.6, 0.6, 0.6), # Màu xám cho chainmail
    MaterialType.Golden: Color(1.0, 0.84, 0.0), # Màu vàng cho golden
    MaterialType.Iron: Color(0.5, 0.5, 0.5), # Màu xám cho sắt
    MaterialType.Diamond: Color(0.0, 0.8, 1.0) # Màu xanh nhạt cho diamond
}

func GetMaterialColor(material_type: MaterialType) -> Color:
    return materialColorDB.get(material_type, Color(1, 1, 1)) # Mặc định là trắng nếu không tìm thấy
