extends Resource
class_name SkillMechanic

# Các loại cơ chế kỹ năng
# enum Type {
#     DAMAGE, # Kỹ năng gây sát thương
#     HEALING, # Kỹ năng hồi phục
#     BUFF, # Kỹ năng tăng cường
#     DEBUFF, # Kỹ năng làm giảm chỉ số
#     STATUS_EFFECT, # Kỹ năng gây hiệu ứng trạng thái
#     UTILITY, # Kỹ năng cung cấp lợi ích khác
#     SUMMON, # Kỹ năng triệu hồi
#     AREA_OF_EFFECT, # Kỹ năng ảnh hưởng đến nhiều mục tiêu
#     SPECIAL # Kỹ năng đặc biệt
# }

# Phương thức áp dụng cơ chế kỹ năng
func Apply(_source: Character, _target: Character):
  pass # Phương thức này sẽ được ghi đè trong các lớp kế thừa
