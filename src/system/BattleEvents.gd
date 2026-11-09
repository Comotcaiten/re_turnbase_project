### Autoload: kênh sự kiện chung của trận đấu
extends Node

# Trước khi trừ máu: listener có thể đổi sát thương bằng damage_model.set_damage()
signal damage_before(damage_model: DamageModel)
# Sau khi trừ máu: damage_dealt, hp_before, hp_after, is_lethal đã có giá trị
signal damage_after(damage_model: DamageModel)
