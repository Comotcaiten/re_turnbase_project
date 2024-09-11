extends Resource
class_name ItemzBase

@export_group("Icon")
@export var icon: Texture2D

@export_group("Text")
@export var id: String
@export var name: String

@export_group("Extras")
@export var damage: int
@export var unbreakable: bool

@export_group("Attributes")
@export var attributes: Array[ItemzAttribute]

func GetValueAttribute(_attribute: CharacterBase.Attribute) -> int:
  for attr in attributes:
      if attr.type == _attribute:
          return attr.values
  return 0 # Default value if no matching attribute is found

# enum MaterialType {Leather, Chainmail, Golden, Iron, Diamond}

# # Từ điển ánh xạ loại vật liệu với màu sắc tương ứng
# var materialColorDB: Dictionary = {
#     MaterialType.Leather: Color(0.7, 0.5, 0.3), # Màu nâu cho da
#     MaterialType.Chainmail: Color(0.6, 0.6, 0.6), # Màu xám cho chainmail
#     MaterialType.Golden: Color(1.0, 0.84, 0.0), # Màu vàng cho golden
#     MaterialType.Iron: Color(0.5, 0.5, 0.5), # Màu xám cho sắt
#     MaterialType.Diamond: Color(0.0, 0.8, 1.0) # Màu xanh nhạt cho diamond
# }

# func GetMaterialColor(material_type: MaterialType) -> Color:
#     return materialColorDB.get(material_type, Color(1, 1, 1)) # Mặc định là trắng nếu không tìm thấy