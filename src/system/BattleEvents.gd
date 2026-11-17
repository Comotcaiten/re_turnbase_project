### Autoload: kênh sự kiện chung của trận đấu
extends Node

# Trước khi trừ máu: listener có thể đổi sát thương bằng damage_model.set_damage()
signal damage_before(damage_model: DamageModel)
# Sau khi trừ máu: damage_dealt, hp_before, hp_after, is_lethal đã có giá trị
signal damage_after(damage_model: DamageModel)
# Unit vừa hồi đầy break. Lúc bị break: kiểm tra damage_model.caused_break ở damage_after
signal break_recovered(unit: UnitModel)
# Unit bắt đầu một lượt được hành động (lượt bị mất vì break không tính)
signal turn_started(unit: UnitModel)
signal turn_skipped(unit: UnitModel)
signal battle_ended(player_won: bool)
signal status_applied(unit: UnitModel, status: StatusModel)
signal status_removed(unit: UnitModel, status: StatusModel)
