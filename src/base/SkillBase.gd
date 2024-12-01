extends Resource
class_name SkillBase

@export var name: String
@export var element: CharacterBase.Element

@export_group("Targeting")
enum TargetType {SELF, ENEMY, ALLY, ANY}
@export var target_type: TargetType = TargetType.ANY

enum TargetMode {ALL, SINGLE, THREE}
@export var target_mode: TargetMode = TargetMode.ALL

@export_group("Components")
@export var components: Array[SkillComponent]

func select_targets(_s):
  """
    Chọn mục tiêu dựa trên kiểu và chế độ mục tiêu.
    - caster: Đơn vị sử dụng kỹ năng.
    - candidates: Danh sách các đơn vị có thể chọn.
    - target_index: Vị trí trung tâm (chỉ dùng khi target_mode = SINGLE hoặc THREE).
  """
  # Lọc các mục tiêu dựa trên target_type
  var filtered_targets = []

  match target_type:
    TargetType.SELF:
      # filtered_targets.append()
      pass
    TargetType.ENEMY:
      pass
    TargetType.ALLY:
      pass
    TargetType.ANY:
      pass

  # Xử lý chế độ mục tiêu
  match target_mode:
    TargetMode.ALL:
      pass
    TargetMode.SINGLE:
      pass
    TargetMode.THREE:
      pass


    # # Lọc các mục tiêu dựa trên target_type
    # var filtered_targets = []
    # match target_type:
    #     TargetType.SELF:
    #         filtered_targets.append(caster)
    #     TargetType.ENEMY:
    #         filtered_targets = candidates.filter((unit) -> unit.is_enemy(caster))
    #     TargetType.ALLY:
    #         filtered_targets = candidates.filter((unit) -> unit.is_ally(caster))
    #     TargetType.ANY:
    #         filtered_targets = candidates

    # # Xử lý chế độ mục tiêu
    # match target_mode:
    #     TargetMode.ALL:
    #         return filtered_targets
    #     TargetMode.SINGLE:
    #         if target_index >= 0 and target_index < len(filtered_targets):
    #             return [filtered_targets[target_index]]
    #     TargetMode.THREE:
    #         if target_index >= 0 and target_index < len(filtered_targets):
    #             var result = []
    #             # Thêm mục tiêu trung tâm
    #             result.append(filtered_targets[target_index])
    #             # Thêm mục tiêu bên trái (nếu có)
    #             if target_index > 0:
    #                 result.append(filtered_targets[target_index - 1])
    #             # Thêm mục tiêu bên phải (nếu có)
    #             if target_index < len(filtered_targets) - 1:
    #                 result.append(filtered_targets[target_index + 1])
    #             return result