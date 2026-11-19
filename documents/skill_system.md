# Hệ thống Skill (version 0.6)

Tài liệu mô tả hệ thống kỹ năng (skill) trong trận đấu theo lượt: các class, function, mối quan hệ giữa chúng, luồng hoạt động và cách tạo skill mới.

---

## 1. Tổng quan

Hệ thống skill được thiết kế theo hướng **dữ liệu + thành phần (component-based)**:

- Một skill là một **Resource** (`SkillBase`, file `.tres`) chỉnh trong Inspector của Godot, không cần viết code.
- Mỗi skill gồm nhiều **Component**. Mỗi component có danh sách **Condition** (điều kiện) và **Mechanic** (hiệu ứng thực thi).
- Khi vào trận, mỗi `SkillBase` được bọc trong một **`SkillModel`** (dữ liệu runtime gắn với unit).
- **`SkillController`** điều khiển việc chọn skill, chọn mục tiêu (người chơi hoặc AI) và thực thi skill.
- Sát thương đi qua **`DamageModel`** và **`BattleEvents`** để passive, hiệu ứng, HUD có thể can thiệp hoặc lắng nghe.

```
SkillBase (.tres)                       ← dữ liệu thiết kế
 ├─ name, id, element, description
 ├─ target_type, target_mode
 └─ components: Array[SkillComponent]
	  ├─ conditions: Array[SkillCondition]   ← tất cả phải true
	  └─ mechanics:  Array[SkillMechanic]    ← chạy lần lượt
		   ├─ SkillMechanicDamage       → DamageModel → UnitModel.take_damage()
		   ├─ SkillMechanicHeal         → UnitModel.heal()
		   └─ SkillMechanicApplyStatus  → UnitModel.apply_status(StatusEffect)
```

### Vị trí file

| File | Vai trò |
|---|---|
| [src/base/SkillBase.gd](../src/base/SkillBase.gd) | Resource định nghĩa skill |
| [src/models/SkillModel.gd](../src/models/SkillModel.gd) | Skill runtime gắn với unit, hàm thực thi |
| [src/components/skill/SkillComponent.gd](../src/components/skill/SkillComponent.gd) | Nhóm điều kiện + mechanic |
| [src/components/skill/SkillCondition.gd](../src/components/skill/SkillCondition.gd) | Lớp cơ sở cho điều kiện |
| [src/components/skill/SkillMechanic.gd](../src/components/skill/SkillMechanic.gd) | Lớp cơ sở cho mechanic |
| [src/components/skill/mechanics/](../src/components/skill/mechanics/) | Các mechanic cụ thể (Damage, Heal, ApplyStatus) |
| [src/controllers/SkillController.gd](../src/controllers/SkillController.gd) | State machine chọn/thực thi skill |
| [src/models/DamageModel.gd](../src/models/DamageModel.gd) | Gói thông tin một đòn sát thương |
| [asset/skill/](../asset/skill/) | Các skill `.tres` đã tạo |

---

## 2. Các class và function

### 2.1. `SkillBase` (extends `Resource`)

Định nghĩa tĩnh của một skill, tạo trong editor.

| Thuộc tính | Kiểu | Ý nghĩa |
|---|---|---|
| `name` | `String` | Tên hiển thị trên nút skill |
| `id` | `String` | Mã định danh, quy ước `skill_<tên>` |
| `element` | `Element.Type` | Hệ của skill (`PHYSICAL`, `FIRE`, `WATER`), dùng để tính khắc hệ và break |
| `description` | `String` | Mô tả, hiện ở tooltip nút skill |
| `target_type` | `TargetType` | Phe được nhắm: `SELF`, `ENEMY`, `ALLY`, `ANY` |
| `target_mode` | `TargetMode` | Số mục tiêu: `ALL`, `SINGLE`, `THREE` |
| `components` | `Array[SkillComponent]` | Danh sách thành phần thực thi |

**Enum:**

- `TargetType { SELF = 0, ENEMY = 1, ALLY = 2, ANY = 3 }`
- `TargetMode { ALL = 0, SINGLE = 1, THREE = 2 }`

> Getter của `target_mode`: nếu `target_type == SELF` thì luôn trả về `SINGLE`, bất kể giá trị đã đặt.

---

### 2.2. `SkillModel`

Bản sao runtime của skill, được `UnitModel` tạo khi khởi tạo unit:

```gdscript
# UnitModel._init()
for skill in _base.skills:
	if skill is SkillBase:
		skills.append(SkillModel.new(skill))
```

| Thuộc tính | Ý nghĩa |
|---|---|
| `base: SkillBase` | Resource gốc (dùng để đọc `components`, `description`) |
| `name`, `element`, `target_type`, `target_mode` | Sao chép từ `base` lúc khởi tạo |

| Function | Mô tả |
|---|---|
| `_init(_base: SkillBase)` | Sao chép dữ liệu từ `SkillBase` |
| `excute(unit, targets)` | Thực thi skill: nếu `targets` rỗng → `false`. Chạy lần lượt từng `component.run(...)`; nếu một component trả về `false` (điều kiện không thỏa) thì **dừng luôn**, các component phía sau không chạy |

> Tên hàm đang là `excute` (thiếu chữ "e"), giữ nguyên khi gọi.

---

### 2.3. `SkillComponent` (extends `Resource`)

Một "khối" logic của skill: kiểm tra điều kiện rồi chạy các mechanic.

| Thuộc tính | Ý nghĩa |
|---|---|
| `conditions: Array[SkillCondition]` | Rỗng = luôn thỏa. Tất cả phải trả về `true` |
| `mechanics: Array[SkillMechanic]` | Chạy theo thứ tự trong mảng |

| Function | Mô tả |
|---|---|
| `check(unit, targets) -> bool` | `true` nếu mọi condition thỏa |
| `run(unit, targets, skill) -> bool` | Nếu `check` thất bại → `false`. Ngược lại gọi `apply_mechanic` của từng mechanic và trả về `true` |

Nhờ chia component, một skill có thể có nhiều nhánh, ví dụ: component 1 luôn gây sát thương, component 2 chỉ gây thêm hiệu ứng khi thỏa điều kiện (lưu ý: component lỗi điều kiện sẽ chặn các component sau nó, nên đặt component có điều kiện ở **cuối**).

---

### 2.4. `SkillCondition` (extends `Resource`)

Lớp cơ sở cho điều kiện. Mặc định luôn `true`.

```gdscript
func check(_unit: UnitModel, _targets: Array[UnitModel]):
	return true
```

Hiện **chưa có condition cụ thể nào**; để thêm, kế thừa và ghi đè `check()` (xem mục 5.3).

---

### 2.5. `SkillMechanic` (extends `Resource`)

Lớp cơ sở cho mọi hiệu ứng của skill.

```gdscript
func apply_mechanic(_unit: UnitModel, _targets: Array[UnitModel], _skill: SkillModel):
	pass
```

- `unit`: người dùng skill
- `targets`: danh sách mục tiêu đã chọn
- `skill`: `SkillModel` đang thực thi (lấy `element`, truyền vào `DamageModel`)

#### 2.5.1. `SkillMechanicDamage`

| Thuộc tính | Mặc định | Ý nghĩa |
|---|---|---|
| `power` | `0` | Sức mạnh skill (cộng thêm hoặc hệ số, tùy `type_damage`) |
| `type_damage` | `DAMAGE` | Cách tính sát thương gốc |
| `true_damage` | `false` | `true` = bỏ qua phòng thủ (defense) |
| `break_power` | `50` | Lượng break gauge bị trừ nếu đòn khắc hệ mục tiêu |

**Công thức sát thương gốc** (`ATK` = `unit.get_stats(Stats.Type.ATTACK)`):

| `type_damage` | Công thức |
|---|---|
| `DAMAGE` (0) | `2 × ATK + 10 + power` |
| `MULTIPLIER` (1) | `(2 × ATK + 10) × power` |
| `PERCENTLEFT`, `PERCENTMISSING` | Chưa cài đặt → sát thương = 1 |

Với mỗi mục tiêu, mechanic tạo **một `DamageModel` riêng** (để kết quả không ghi đè nhau), gán `damage` và `break_power`, rồi gọi `target.take_damage(damage_model)`.

#### 2.5.2. `SkillMechanicHeal`

| Thuộc tính | Mặc định | Ý nghĩa |
|---|---|---|
| `percent` | `30` | Hồi `percent`% **máu tối đa của mục tiêu** |

Gọi `target.heal(int(target.max_health * percent / 100.0))`. Unit đã gục không được hồi; lượng hồi không vượt quá máu tối đa.

#### 2.5.3. `SkillMechanicApplyStatus`

| Thuộc tính | Mặc định | Ý nghĩa |
|---|---|---|
| `status` | — | Một `StatusEffect` (Poison, Bleed, Stun, Clarity…) |
| `chance` | `100` | Tỉ lệ % gây hiệu ứng, tính riêng cho từng mục tiêu |
| `apply_to_self` | `false` | `true` = áp lên người dùng skill thay vì mục tiêu |

Gọi `receiver.apply_status(status, unit)`. Nếu mục tiêu đã có cùng loại hiệu ứng (cùng script) thì làm mới số lượt/cộng stack thay vì thêm bản mới.

---

### 2.6. `DamageModel`

Gói dữ liệu cho một đòn đánh, truyền qua `UnitModel.take_damage()` và các signal của `BattleEvents`.

**Đầu vào (do mechanic gán):** `power`, `type_damage`, `true_damage`, `element`, `source`, `skill`, `damage`, `break_power`.

**Kết quả (được điền khi xử lý):** `is_miss`, `is_crit`, `crit_multiplier`, `defense_applied`, `element_multiplier`, `break_multiplier`, `damage_dealt`, `hp_before`, `hp_after`, `is_lethal`, `break_dealt`, `caused_break`.

| Function | Mô tả |
|---|---|
| `resolve_against(target)` | Tính chính xác/chí mạng, trừ defense, nhân hệ số khắc hệ, break, crit |
| `set_damage(value)` / `get_damage()` | Đặt/lấy sát thương, tối thiểu là 1 |

**Công thức sát thương cuối** (trong `resolve_against`):

```
nếu random(1..100) > accuracy của source  → MISS (dừng)
crit nếu random(1..100) <= crit_chance    → crit_multiplier = crit_damage / 100
amount = damage - (true_damage ? 0 : target.defense)
final  = max(1, amount × element_multiplier × break_multiplier × crit_multiplier)
```

- `element_multiplier` lấy từ `Element.CHART` (ví dụ `WATER → FIRE = 2.0`, `FIRE → WATER = 0.5`).
- `break_multiplier = 1.5` nếu mục tiêu đang bị break.
- Đòn có `from_passive = true` (sát thương từ passive/hiệu ứng) không trượt, không crit.

---

### 2.7. `SkillController` (extends `Node`)

State machine điều khiển một lượt dùng skill. Được `BattleSystem` gọi `play(unit)` mỗi frame khi đang ở state `SELECTSKILL` (người chơi) hoặc `AIACTION` (AI).

**Signal:** `selection_changed` — phát khi state, skill đang chọn hoặc mục tiêu thay đổi (HUD nghe để vẽ lại nút).

**State:** `START → SELECT | AISELECT → EXECUTE → END`

| Biến | Ý nghĩa |
|---|---|
| `ai_delay` | Số giây AI "suy nghĩ" trước khi hành động |
| `current_index`, `current_skill` | Skill đang chọn |
| `current_target` | Chỉ số mục tiêu trung tâm trong `group_targets_available` |
| `group_targets_available` | Các mục tiêu hợp lệ (theo `target_type`, đã lọc unit gục) |
| `group_targets_select` | Các mục tiêu sẽ trúng (theo `target_mode`) |

**Function chính:**

| Function | Mô tả |
|---|---|
| `initialized(battle_system)` | Lưu tham chiếu `BattleSystem` |
| `play(unit)` | Gọi handler theo state hiện tại |
| `change_state(state)` | Đổi state và phát `selection_changed` |
| `handle_start(unit)` | Chọn skill 0, mục tiêu 0; sang `SELECT` (người chơi) hoặc `AISELECT` (AI). Không có skill → `END` |
| `handle_select(unit)` | Đọc input bàn phím qua `perform_handle_select` |
| `handle_ai_select(unit)` | Chờ `ai_delay`, chọn skill ngẫu nhiên và mục tiêu ngẫu nhiên, sang `EXECUTE` |
| `handle_excute(unit)` | Gọi `current_skill.excute(unit, group_targets_select)`, sang `END` |
| `handle_end()` | `refesh()` rồi `battle_system.get_next_turn()` |
| `select_skill(index, unit)` | Đổi skill, tính lại toàn bộ mục tiêu (dùng bởi phím 1–4 và nút HUD) |
| `select_target(index)` | Đổi mục tiêu (dùng bởi phím trái/phải và nút HUD) |
| `confirm()` | Xác nhận từ HUD, chỉ khi đang `SELECT` và có mục tiêu |
| `set_group_targets_available(unit)` | Lọc mục tiêu theo `target_type` (xem bảng dưới) |
| `set_group_targets_select()` | Lấy mục tiêu trúng theo `target_mode` (xem bảng dưới) |
| `set_current_target(value)` | Đặt chỉ số mục tiêu, có quay vòng (wrap-around) |
| `refesh()` | Reset về `START`, xóa skill và mục tiêu đã chọn |

**Chọn mục tiêu theo `target_type`:**

| `target_type` | `group_targets_available` |
|---|---|
| `SELF` | `[unit]` |
| `ENEMY` | Nhóm phe đối diện (`get_group_is_player(not unit.is_player)`) |
| `ALLY` | Nhóm cùng phe |
| `ANY` | Tất cả unit |

Sau đó lọc bỏ unit `is_fainted`.

**Số mục tiêu theo `target_mode`:**

| `target_mode` | `group_targets_select` |
|---|---|
| `SINGLE` | `[available[current_target]]` |
| `THREE` | Mục tiêu đang chọn và hai bên cạnh: `available[current_target-1 .. current_target+1]` |
| `ALL` | Toàn bộ `available` |

**Input người chơi** (`perform_handle_select`):

| Action | Tác dụng |
|---|---|
| `ui_action_1` … `ui_action_4` | Chọn skill 1–4 |
| `ui_left` / `ui_right` | Đổi mục tiêu (+1 / −1) |
| `ui_accept` | Thực thi skill |

---

### 2.8. Các class liên quan

| Class | Liên quan đến skill |
|---|---|
| `UnitBase` | `skills: Array[SkillBase]` — danh sách skill của nhân vật; có `add_skill`, `remove_skill`, `has_skill` |
| `UnitModel` | `skills: Array[SkillModel]`, `get_skill(index)`, `take_damage(dm)`, `heal(amount)`, `apply_status(effect, source)` |
| `StatusEffect` | Hiệu ứng được `SkillMechanicApplyStatus` gây ra |
| `BattleEvents` (autoload) | `damage_before`, `damage_after`, `status_applied`, … phát trong lúc skill thực thi |
| `BattleSystem` | Gọi `skill_controller.play()`; `SkillController` gọi ngược `get_next_turn()` |
| `BattleHUD` | Vẽ nút skill/mục tiêu, gọi `select_skill`, `select_target`, `confirm`; nghe `selection_changed` |

---

## 3. Mối quan hệ giữa các class

```
				┌──────────────┐  skill_controller.play(unit)  ┌────────────────┐
				│ BattleSystem │ ────────────────────────────▶ │ SkillController│
				│              │ ◀──────────────────────────── │                │
				└──────────────┘        get_next_turn()        └───────┬────────┘
																	   │ selection_changed
													select_skill /     ▼
													select_target / ┌──────────┐
													confirm  ◀───── │ BattleHUD│
																	└──────────┘
   SkillController.current_skill.excute(unit, targets)
						│
						▼
  UnitBase.skills ──▶ UnitModel.skills: SkillModel ──base──▶ SkillBase
															   │ components
															   ▼
														SkillComponent
													 ┌─────────┴─────────┐
												conditions             mechanics
											  SkillCondition         SkillMechanic
																 ┌───────┼──────────┐
															Damage      Heal     ApplyStatus
															   │          │           │
														  DamageModel     │       StatusEffect
															   ▼          ▼           ▼
													 UnitModel.take_damage / heal / apply_status
															   │
															   ▼
												  BattleEvents (damage_before/after, status_applied)
															   │
													 Passive, BattleHUD, BattleSystem (log)
```

- **Kế thừa:** `SkillMechanicDamage`, `SkillMechanicHeal`, `SkillMechanicApplyStatus` kế thừa `SkillMechanic`. Condition mới kế thừa `SkillCondition`.
- **Sở hữu (composition):** `SkillBase` → nhiều `SkillComponent` → nhiều `SkillCondition` / `SkillMechanic`. Tất cả là Resource nên lưu cùng trong một file `.tres` (dạng sub-resource).
- **Bọc (wrap):** `SkillModel` giữ tham chiếu `base: SkillBase`. `SkillBase` dùng chung giữa các unit; `SkillModel` là của riêng từng unit.

---

## 4. Luồng hoạt động một lượt

1. `BattleSystem.handle_unit_turn()`: unit bắt đầu lượt (`begin_turn()` xử lý break, hiệu ứng). Nếu mất lượt → sang lượt kế.
2. Phát `BattleEvents.turn_started`. Unit phe người chơi → state `SELECTSKILL`, ngược lại → `AIACTION`. Cả hai đều gọi `skill_controller.play(current_unit)` mỗi frame.
3. **`START`** — `handle_start`: chọn skill đầu tiên, tính `group_targets_available`, chọn mục tiêu 0, tính `group_targets_select`.
4. **Chọn:**
   - Người chơi (`SELECT`): bấm phím hoặc nút HUD để đổi skill/mục tiêu; mỗi lần đổi phát `selection_changed` → HUD vẽ lại và highlight mục tiêu. Bấm `ui_accept` hoặc nút "Xác nhận" → `EXECUTE`.
   - AI (`AISELECT`): chờ `ai_delay` giây, chọn skill ngẫu nhiên + mục tiêu ngẫu nhiên → `EXECUTE`.
5. **`EXECUTE`** — `SkillModel.excute(unit, group_targets_select)`:
   - Với mỗi `SkillComponent`: kiểm tra conditions → chạy mechanics theo thứ tự.
   - `SkillMechanicDamage` → tạo `DamageModel` → `target.take_damage()`:
	 1. `resolve_against()` (trượt, chí mạng, defense, khắc hệ, break)
	 2. `BattleEvents.damage_before` (passive có thể sửa sát thương)
	 3. Trừ máu, ghi kết quả, `reduce_break()` nếu khắc hệ
	 4. `BattleEvents.damage_after` (passive hút máu, phản đòn…; HUD ghi log)
   - `SkillMechanicHeal` → `target.heal()`.
   - `SkillMechanicApplyStatus` → `receiver.apply_status()` → `BattleEvents.status_applied`.
6. **`END`** — `refesh()` rồi `BattleSystem.get_next_turn()`: nếu một phe đã gục hết → kết thúc trận, ngược lại sang unit kế tiếp theo tốc độ.

---

## 5. Cách thiết lập

### 5.1. Tạo skill mới trong editor (không cần code)

1. Trong FileSystem, chuột phải `asset/skill/` → **New Resource…** → chọn `SkillBase` → lưu thành `skill_<tên>.tres`.
2. Trong Inspector điền:
   - `Name`, `Id` (`skill_<tên>`), `Element`, `Description`.
   - Nhóm **Target**: `Target Type`, `Target Mode`.
3. Nhóm **Components**: thêm phần tử vào `Components` → **New SkillComponent**.
4. Mở component:
   - `Conditions`: để trống nếu luôn kích hoạt.
   - `Mechanics`: thêm phần tử → chọn **New SkillMechanicDamage / SkillMechanicHeal / SkillMechanicApplyStatus** và chỉnh thông số.
   - Với `SkillMechanicApplyStatus`, ở ô `Status` chọn **New StatusPoison / StatusBleed / StatusStun / StatusClarity** và chỉnh `duration`, `max_stacks`, các chỉ số riêng.
5. Gán skill cho nhân vật: mở file trong `asset/character/` hoặc `asset/enemy/` → thêm vào mảng `Skills`.

> Người chơi chỉ chọn được **4 skill đầu** bằng phím tắt (`ui_action_1..4`); HUD vẫn hiển thị nút cho mọi skill.

### 5.2. Ví dụ cấu hình

**Đòn đơn sát thương hệ — "Cầu lửa"** ([skill_fireball.tres](../asset/skill/skill_fireball.tres))

```
SkillBase: element = FIRE, target_type = ENEMY, target_mode = SINGLE
└─ SkillComponent
   └─ SkillMechanicDamage: power = 14, type_damage = DAMAGE, break_power = 50
```

**Sát thương + hiệu ứng — "Độc nha"** ([skill_venom.tres](../asset/skill/skill_venom.tres))

```
SkillBase: element = PHYSICAL, target_type = ENEMY, target_mode = SINGLE
└─ SkillComponent
   ├─ SkillMechanicDamage: power = 1, break_power = 30
   └─ SkillMechanicApplyStatus: chance = 100
	  └─ StatusPoison: percent = 10, duration = 3
```

**Buff bản thân — "Tập trung"** ([skill_focus.tres](../asset/skill/skill_focus.tres))

```
SkillBase: target_type = SELF
└─ SkillComponent
   └─ SkillMechanicApplyStatus: chance = 100
	  └─ StatusClarity: crit_bonus = 30, duration = 3
```

**Hồi máu đồng minh — "Trị liệu"** ([skill_heal.tres](../asset/skill/skill_heal.tres))

```
SkillBase: element = WATER, target_type = ALLY, target_mode = SINGLE
└─ SkillComponent
   └─ SkillMechanicHeal: percent = 30
```

### 5.3. Danh sách skill hiện có

| File | Tên | Hệ | Mục tiêu | Mechanic |
|---|---|---|---|---|
| `skill_slash` | Chém | Vật lý | Địch, 1 | Damage power 6 |
| `skill_bash` | Đập choáng | Vật lý | Địch, 1 | Damage power 2 + 40% Choáng (1 lượt) |
| `skill_shadow_cut` | Ám đao | Vật lý | Địch, 1 | Damage power 4 + Chảy máu (3 lượt) |
| `skill_venom` | Độc nha | Vật lý | Địch, 1 | Damage power 1 + Độc 10% (3 lượt) |
| `skill_focus` | Tập trung | Vật lý | Bản thân | Minh mẫn +30% crit (3 lượt) |
| `skill_ember` | Tàn lửa | Hỏa | Địch, 1 | Damage power 6 |
| `skill_fireball` | Cầu lửa | Hỏa | Địch, 1 | Damage power 14 |
| `skill_fire_wave` | Sóng lửa | Hỏa | Địch, tất cả | Damage power 1 |
| `skill_water_shot` | Thủy tiễn | Thủy | Địch, 1 | Damage power 10 |
| `skill_water_rain` | Mưa nước | Thủy | Địch, 3 | Damage power 2, break 34 |
| `skill_heal` | Trị liệu | Thủy | Đồng minh, 1 | Heal 30% |

### 5.4. Thêm Mechanic mới (code)

Tạo file trong `src/components/skill/mechanics/`:

```gdscript
extends SkillMechanic

class_name SkillMechanicDrainMp

@export var amount: int = 10

func apply_mechanic(unit: UnitModel, targets: Array[UnitModel], _skill: SkillModel):
	for target in targets:
		var drained: int = mini(amount, target.mp)
		target.mp -= drained
		unit.mp = mini(unit.max_mp, unit.mp + drained)
		target.changed.emit()
		unit.changed.emit()
```

Sau khi lưu, `SkillMechanicDrainMp` xuất hiện trong danh sách **New …** của mảng `Mechanics`.

Lưu ý khi viết mechanic:

- Gây sát thương thì luôn đi qua `DamageModel` + `take_damage()` (không trừ `health` trực tiếp) để passive, break, log HUD hoạt động.
- Tạo **một `DamageModel` cho mỗi mục tiêu**.
- Dùng `@export` cho mọi thông số để chỉnh được trong Inspector.

### 5.5. Thêm Condition mới (code)

Tạo file trong `src/components/skill/` (ví dụ thư mục `conditions/`):

```gdscript
extends SkillCondition

class_name SkillConditionHpBelow

@export_range(0, 100) var percent: int = 50
@export var check_self: bool = true # true: kiểm tra người dùng; false: kiểm tra mục tiêu đầu tiên

func check(unit: UnitModel, targets: Array[UnitModel]) -> bool:
	var subject: UnitModel = unit if check_self else targets[0]
	return subject.health * 100 <= subject.max_health * percent
```

Ví dụ dùng: skill có component 1 (Damage, không điều kiện) và component 2 đặt **cuối** (`SkillConditionHpBelow` + `SkillMechanicHeal apply cho bản thân`) — chỉ hồi máu khi người dùng dưới 50% HP.

---

## 6. Lưu ý và giới hạn hiện tại

- **MP chưa được tiêu tốn**: `SkillBase` chưa có trường chi phí, `excute` không trừ `mp`.
- **Không có cooldown**: skill dùng được mọi lượt.
- `DamageModel.TypeDamage.PERCENTLEFT` và `PERCENTMISSING` đã khai báo nhưng chưa có công thức → sát thương = 1.
- `SkillMechanicDamage` luôn dùng chỉ số `ATTACK`, chưa phân biệt vật lý/phép.
- Component có condition thất bại sẽ **dừng cả skill** (các component phía sau không chạy).
- AI chọn skill và mục tiêu hoàn toàn ngẫu nhiên, không xét máu, khắc hệ hay kiểu skill.
- `SkillMechanicApplyStatus` với `apply_to_self = true` áp hiệu ứng một lần cho mỗi lần gọi mechanic, không phụ thuộc số mục tiêu.
- Tên hàm/biến đang có lỗi chính tả, giữ nguyên khi gọi: `excute`, `handle_excute`, `refesh`.
- `ui_left` tăng chỉ số mục tiêu, `ui_right` giảm — hướng có thể ngược với vị trí hiển thị tùy cách sắp xếp unit trong scene.
