# BATTLE SYSTEM – UI, CAMERA & GAMEPLAY ARCHITECTURE

**Document Type:** Game Design & Technical Design Document  
**System:** 3D Turn-based RPG Battle System  
**Reference:** Anime 3D RPG Battle UI / Honkai: Star Rail-inspired presentation  
**Status:** Proposed Architecture  
**Version:** 1.0

---

# 1. OVERVIEW

## 1.1. Mục tiêu

Xây dựng hệ thống chiến đấu 3D Turn-based RPG với hai đội hình đối đầu nhau:

- Player Team: Đội hình nhân vật của người chơi.
- Enemy Team: Đội hình kẻ địch.
- Battle UI: Giao diện hiển thị thông tin và điều khiển trận đấu.
- Camera System: Điều khiển góc nhìn chiến trường và nhân vật đang hành động.
- Turn System: Quản lý thứ tự lượt hành động.
- Combat System: Xử lý Attack, Skill, Ultimate, Damage và Status Effect.

Hệ thống cần đáp ứng các mục tiêu:

1. Hiển thị rõ ràng hai đội hình Player và Enemy.
2. Nhân vật được bố trí theo các Formation Slot cố định.
3. Camera tự động chuyển đến nhân vật Player đang có lượt hành động.
4. Camera hướng từ nhân vật đang hành động về phía mục tiêu.
5. UI hiển thị trạng thái và thông tin chiến đấu theo thời gian thực.
6. Hỗ trợ animation, cinematic camera và target selection.
7. Có khả năng mở rộng số lượng nhân vật và kẻ địch.

## 1.2. Design Direction

Định hướng thiết kế:

- 3D Anime RPG.
- Turn-based Combat.
- Character-focused Camera.
- Slot-based Formation.
- Screen-space Battle UI.
- Cinematic Action Presentation.

## 1.3. Core Design Principles

| Principle | Description |
|---|---|
| Separation of Concerns | Tách biệt UI, Camera, Formation và Combat Logic |
| Data-driven | Dữ liệu nhân vật và đội hình không phụ thuộc UI |
| Event-driven | Các hệ thống giao tiếp thông qua sự kiện |
| Camera-independent Formation | Đội hình không thay đổi khi camera chuyển góc |
| Reusable Camera Rig | Camera sử dụng chung logic cho nhiều nhân vật |
| Scalable | Hỗ trợ nhiều số lượng nhân vật và kẻ địch |

---

# 2. BATTLE SCENE ARCHITECTURE

## 2.1. Scene Overview

Battle Scene bao gồm ba lớp chính:

### A. World Space

Chứa toàn bộ đối tượng trong thế giới 3D.

- Environment
- Terrain
- Lighting
- Player Characters
- Enemy Characters
- Combat VFX
- Battle Animations

### B. Screen Space UI

Chứa các thành phần giao diện được hiển thị trên màn hình.

- Enemy Information
- Battle Controls
- Turn Order
- Player Team HUD
- Combat Actions
- Target Selection
- Battle Notifications

### C. Gameplay Logic

Chứa các hệ thống điều khiển gameplay.

- Battle Manager
- Formation Manager
- Turn Manager
- Character Manager
- Enemy Manager
- Target Manager
- Action Manager
- Camera Manager
- UI Manager

## 2.2. High-level Architecture

```text
BattleScene
│
├── WorldSpace
│   ├── Environment
│   ├── Lighting
│   ├── BattleGround
│   ├── PlayerTeam
│   ├── EnemyTeam
│   └── CombatVFX
│
├── CameraSystem
│   ├── MainCamera
│   ├── CameraManager
│   ├── BattleOverviewCamera
│   ├── ActiveActorCamera
│   ├── ActionCamera
│   └── UltimateCamera
│
├── BattleSystems
│   ├── BattleManager
│   ├── FormationManager
│   ├── TurnManager
│   ├── CharacterManager
│   ├── EnemyManager
│   ├── TargetManager
│   ├── ActionManager
│   └── CombatResolver
│
└── BattleUI
    ├── TopHUD
    ├── TurnOrderHUD
    ├── PlayerTeamHUD
    ├── CombatActionHUD
    ├── TargetSelectionHUD
    └── BattleOverlay
```

---

# 3. FORMATION SYSTEM

## 3.1. Formation Design

### Mục tiêu

Player Team và Enemy Team được bố trí thành hai hàng nhân vật đối diện nhau.

Formation System quản lý vị trí của các nhân vật trong World Space.

Nguyên tắc:

- Player và Enemy có Formation Slot riêng.
- Các nhân vật trong cùng một đội hình nằm trên cùng một hàng.
- Player quay về hướng Enemy.
- Enemy quay về hướng Player.
- Camera không quyết định vị trí Formation.
- Nhân vật có thể di chuyển tạm thời trong lúc thực hiện animation nhưng cần có vị trí Formation gốc.

## 3.2. Formation Layout

Định hướng bố trí:

```text
                  ENEMY TEAM

          [E1]    [E2]    [E3]    [E4]


                  COMBAT ZONE


          [P1]    [P2]    [P3]    [P4]

                  PLAYER TEAM
```

Hai hàng nhân vật nằm đối diện nhau và có khoảng cách phù hợp để thực hiện combat animation.

Đây là bố cục logic trong World Space, không bắt buộc phải tương ứng trực tiếp với bố cục trái/phải trên màn hình.

## 3.3. Formation Coordinate System

Đề xuất sử dụng hệ tọa độ:

- X: Chiều ngang đội hình.
- Y: Chiều cao.
- Z: Khoảng cách giữa hai đội hình.

Ví dụ với đội hình 4v4:

```text
Player Team:

P1 = (-3, 0, 0)
P2 = (-1, 0, 0)
P3 = ( 1, 0, 0)
P4 = ( 3, 0, 0)


Enemy Team:

E1 = (-3, 0, 8)
E2 = (-1, 0, 8)
E3 = ( 1, 0, 8)
E4 = ( 3, 0, 8)
```

Các tọa độ trên chỉ là giá trị khởi tạo minh họa.

Khoảng cách thực tế cần được điều chỉnh dựa trên:

- Character Model Bounds.
- Character Animation.
- Attack Range.
- Skill Area.
- Camera Framing.
- Environment Size.

## 3.4. Formation Slot Structure

Mỗi Formation Slot cần quản lý:

| Property | Description |
|---|---|
| Slot ID | Định danh vị trí |
| Team | Player hoặc Enemy |
| Position | Vị trí trong World Space |
| Rotation | Hướng quay |
| Occupant | Character đang chiếm slot |
| IsOccupied | Trạng thái slot |
| IsAlive | Trạng thái nhân vật |

## 3.5. Formation Behavior

Khi nhân vật chết:

- Character chuyển sang Death State.
- Formation Slot có thể giữ nguyên vị trí.
- Không tự động dồn các nhân vật còn lại vào giữa.
- Việc thay đổi đội hình chỉ diễn ra khi gameplay yêu cầu.

**Đề xuất:** Sử dụng Static Formation Slot kết hợp Temporary Combat Movement.

Điều này giúp duy trì bố cục chiến trường ổn định trong khi vẫn cho phép nhân vật lao tới, né tránh hoặc di chuyển khi tấn công.

---

# 4. CAMERA SYSTEM

## 4.1. Camera Design Objective

Camera System là một thành phần quan trọng của Battle Presentation.

Mục tiêu:

1. Quan sát được toàn bộ chiến trường.
2. Tập trung vào nhân vật đang hành động.
3. Hiển thị được mối quan hệ giữa Active Character và Enemy Target.
4. Hỗ trợ cinematic khi sử dụng Skill và Ultimate.
5. Chuyển đổi camera mượt mà giữa các lượt.
6. Không làm thay đổi Formation.

Camera cần hoạt động dựa trên dữ liệu của Turn Manager.

## 4.2. Camera Modes

### A. Battle Overview Camera

Camera mặc định khi bắt đầu trận đấu.

Chức năng:

- Quan sát toàn bộ Player Team.
- Quan sát Enemy Team.
- Hiển thị không gian chiến đấu.
- Sử dụng khi cần quan sát tổng thể.

Đặc điểm:

- Fixed hoặc Semi-fixed Camera.
- Look At Battle Center.
- Có thể điều chỉnh framing theo kích thước đội hình.

### B. Active Player Camera

Camera chính theo yêu cầu của gameplay.

**Điều kiện kích hoạt:**

Khi Turn Manager xác định nhân vật Player hiện tại là Actor có lượt hành động.

Ví dụ:

```text
Current Turn = Player A
        |
        v
Get Player A
        |
        v
Get Player A Camera Anchor
        |
        v
Blend Camera to Player A
        |
        v
Active Player Camera
```

Chức năng:

- Chuyển camera đến góc nhìn của nhân vật đang hành động.
- Nhân vật Active Character trở thành chủ thể chính.
- Camera hướng về phía Enemy hoặc Target.
- Giữ được nhân vật trong khung hình.
- Cho phép quan sát Enemy trong cùng một góc camera.

Đề xuất sử dụng Over-the-Shoulder / Third-person Oblique Camera.

Camera không nhất thiết phải nằm chính xác tại vị trí mắt nhân vật. Có thể đặt camera phía sau và lệch vai để nhân vật vẫn xuất hiện trong khung hình.

### C. Enemy Camera

Khi Enemy đến lượt:

- Camera có thể chuyển về Battle Overview.
- Hoặc chuyển đến Enemy đang hành động nếu cần cinematic.
- Enemy được xác định thông qua Turn Manager.
- Camera hướng về phía Player Target.

Đề xuất:

Sử dụng Overview Camera cho các Enemy Action thông thường. Chỉ chuyển sang Enemy Action Camera khi cần nhấn mạnh animation hoặc đòn tấn công đặc biệt.

### D. Action Camera

Khi Player thực hiện Attack hoặc Skill:

- Camera có thể tiến gần nhân vật.
- Điều chỉnh góc nhìn theo animation.
- Giữ Enemy Target trong khung hình.
- Có thể thay đổi vị trí camera để tăng tính điện ảnh.

### E. Ultimate Camera

Khi sử dụng Ultimate:

- Camera chuyển sang Cinematic Camera.
- Có thể sử dụng các góc nhìn được thiết kế riêng cho từng nhân vật.
- Animation và camera được đồng bộ.
- Sau khi kết thúc Ultimate, camera trở về Active Player Camera hoặc camera của lượt tiếp theo.

## 4.3. Camera Transition Logic

Ví dụ chuyển lượt từ Player A sang Player B:

```text
Player A Turn
      |
      v
Camera A Active
      |
      v
Player A Action
      |
      v
Action Completed
      |
      v
Turn Manager Updates
      |
      v
Player B Turn
      |
      v
Get Camera Anchor B
      |
      v
Camera Blend A -> B
      |
      v
Camera B Active
```

Không bắt buộc phải quay về Overview Camera giữa hai Player Turn.

Có thể blend trực tiếp giữa hai Camera Anchor để giảm chuyển động thừa.

## 4.4. Camera Anchor Structure

Mỗi Character nên có Camera Anchor riêng.

```text
Character
│
├── Model
├── Animator
├── CharacterController
│
└── CameraRig
    ├── CameraAnchor
    ├── FollowTarget
    └── LookAtTarget
```

### CameraAnchor

Vị trí tham chiếu để camera chuyển đến.

### FollowTarget

Điểm camera theo dõi trong quá trình hành động.

### LookAtTarget

Điểm camera hướng đến, thường là Enemy Target hoặc Combat Focus Point.

Không nên sử dụng trực tiếp Transform của toàn bộ Character Model làm LookAtTarget vì có thể khiến góc nhìn thay đổi không ổn định theo animation.

## 4.5. Camera Manager Responsibilities

Camera Manager chịu trách nhiệm:

- Nhận thông tin Active Actor.
- Xác định Camera Mode.
- Lấy Camera Anchor tương ứng.
- Điều khiển Follow Target.
- Điều khiển Look At Target.
- Thực hiện Camera Blend.
- Xử lý Camera Priority.
- Quản lý Camera State.
- Trả camera về trạng thái phù hợp sau animation.

## 4.6. Camera Configuration

Các thông số khởi tạo đề xuất:

| Property | Initial Proposal |
|---|---|
| Projection | Perspective |
| FOV | 40–55° |
| Pitch | 10–20° |
| Transition Duration | 0.5–1.0 seconds |
| Camera Mode | State-based |
| Follow Mode | Smooth Follow |
| Look At | Active Target |
| Collision | Enabled |
| Default Camera | Battle Overview |

Các giá trị trên cần được hiệu chỉnh bằng Playtest, không phải thông số chính xác được trích xuất từ hình tham khảo.

---

# 5. TURN SYSTEM

## 5.1. Turn Manager

Turn Manager chịu trách nhiệm xác định nhân vật nào đang có lượt hành động.

Thông tin quản lý:

- Current Turn Index.
- Current Actor.
- Actor Team.
- Turn Order.
- Action State.
- Turn State.

## 5.2. Turn Order

Ví dụ:

```text
Turn Order:

1. Player A
2. Enemy A
3. Player B
4. Player C
5. Enemy B
6. Player D
```

Turn Order HUD cần phản ánh thứ tự này trên UI.

## 5.3. Player Turn Event

Khi một Player đến lượt:

```text
OnTurnStarted(PlayerCharacter)
```

Các hệ thống liên quan nhận sự kiện:

- Camera Manager: Chuyển sang Active Player Camera.
- UI Manager: Highlight nhân vật đang hành động.
- Action Manager: Cho phép chọn hành động.
- Target Manager: Chuẩn bị lựa chọn mục tiêu.

## 5.4. Enemy Turn Event

Khi Enemy đến lượt:

```text
OnTurnStarted(EnemyCharacter)
```

Các hệ thống liên quan:

- Camera Manager: Chọn Overview hoặc Enemy Camera.
- Enemy AI: Quyết định hành động.
- Target Manager: Xác định Player Target.
- Action Manager: Thực hiện Enemy Action.

---

# 6. BATTLE UI ARCHITECTURE

## 6.1. UI Design Direction

UI được chia thành các khu vực cố định trên màn hình.

Nguyên tắc:

- World Space và Screen Space tách biệt.
- UI không phụ thuộc vào Camera Anchor.
- UI phản ánh dữ liệu gameplay.
- Các thành phần UI được cập nhật thông qua sự kiện.

## 6.2. UI Layout

```text
BattleCanvas
│
├── TopHUD
│   ├── EnemyInformation
│   ├── EnemyName
│   ├── EnemyHP
│   ├── PauseButton
│   ├── SpeedButton
│   └── AutoBattleButton
│
├── LeftHUD
│   └── TurnOrderPanel
│       ├── TurnItem_01
│       ├── TurnItem_02
│       └── TurnItem_N
│
├── BottomHUD
│   └── PlayerTeamPanel
│       ├── CharacterSlot_01
│       ├── CharacterSlot_02
│       ├── CharacterSlot_03
│       └── CharacterSlot_04
│
├── RightHUD
│   └── CombatActionPanel
│       ├── NormalAttack
│       ├── Skill
│       ├── Ultimate
│       └── ActionPoint
│
└── Overlay
    ├── TargetIndicator
    ├── DamageNumber
    ├── BuffNotification
    ├── DebuffNotification
    └── BattleResult
```

## 6.3. Top HUD – Enemy Information

Hiển thị:

- Enemy Name.
- Enemy HP.
- Enemy Status.
- Enemy Buff/Debuff.
- Enemy Information.

Battle Controls:

- Pause.
- Double Speed.
- Auto Battle.

Enemy Information được cập nhật theo Target Selection.

## 6.4. Left HUD – Turn Order

Hiển thị danh sách các Actor theo thứ tự hành động.

Mỗi Turn Item gồm:

- Character Portrait.
- Character Identifier.
- Turn Position.
- Current Turn Indicator.
- Status Indicator.

Khi nhân vật hiện tại được kích hoạt:

- Highlight Portrait.
- Hiển thị Active Indicator.
- Có thể thay đổi kích thước hoặc độ sáng.

Turn Order UI chỉ phản ánh dữ liệu từ Turn Manager, không tự tính toán thứ tự lượt.

## 6.5. Bottom HUD – Player Team

Hiển thị thông tin từng nhân vật Player.

Mỗi Character HUD gồm:

| Component | Function |
|---|---|
| Portrait | Hiển thị nhân vật |
| HP Bar | Hiển thị HP |
| Energy | Hiển thị năng lượng |
| Buff | Hiển thị hiệu ứng có lợi |
| Debuff | Hiển thị hiệu ứng bất lợi |
| Status | Hiển thị trạng thái |
| Active Indicator | Đánh dấu nhân vật đang hành động |

Khi nhân vật có lượt:

- Highlight Character HUD.
- Đồng bộ Active State với Turn Manager.
- Hiển thị Action UI tương ứng.

## 6.6. Right HUD – Combat Actions

Hiển thị các hành động có thể thực hiện.

### Normal Attack

- Thực hiện đòn đánh thông thường.
- Có thể không tiêu tốn tài nguyên đặc biệt.

### Skill

- Sử dụng kỹ năng nhân vật.
- Kiểm tra điều kiện sử dụng.
- Kiểm tra tài nguyên.

### Ultimate

- Sử dụng kỹ năng tối thượng.
- Có thể kích hoạt Ultimate Camera.
- Đồng bộ Animation và VFX.

### Target Selection

- Chọn Enemy mục tiêu.
- Hiển thị Target Indicator.
- Cập nhật Enemy Information.
- Xác nhận mục tiêu trước khi thực hiện hành động.

---

# 7. TARGET SELECTION SYSTEM

## 7.1. Target Manager

Target Manager quản lý mục tiêu của hành động.

Trách nhiệm:

- Lấy danh sách Enemy hợp lệ.
- Xác định Target hiện tại.
- Kiểm tra Target còn sống.
- Kiểm tra Target có hợp lệ với Skill hay không.
- Cập nhật Target Indicator.
- Gửi Target Data đến Action Manager và Camera Manager.

## 7.2. Target Selection Flow

```text
Player Selects Action
        |
        v
Get Valid Targets
        |
        v
Display Target Indicator
        |
        v
Player Selects Enemy
        |
        v
Validate Target
        |
        v
Confirm Target
        |
        v
Execute Action
```

## 7.3. Target Types

Đề xuất hỗ trợ:

- Single Target.
- Blast / Adjacent Targets.
- AoE.
- All Enemies.
- Random Target.
- Self Target.
- Ally Target.

Camera cần hỗ trợ các loại Target khác nhau.

Đối với AoE, LookAtTarget có thể sử dụng Combat Focus Point thay vì một Enemy duy nhất.

---

# 8. COMBAT SYSTEM

## 8.1. Action Manager

Action Manager chịu trách nhiệm xử lý hành động chiến đấu.

Các loại Action:

- Normal Attack.
- Skill.
- Ultimate.
- Passive Trigger.
- Counter Attack.
- Follow-up Attack.

## 8.2. Action Execution

```text
Start Action
    |
    v
Validate Action
    |
    v
Validate Resource
    |
    v
Validate Target
    |
    v
Request Camera Mode
    |
    v
Play Animation
    |
    v
Apply Combat Effect
    |
    v
Calculate Damage
    |
    v
Update Character State
    |
    v
End Action
```

## 8.3. Combat Resolver

Combat Resolver xử lý:

- Damage Calculation.
- Defense Calculation.
- Critical Hit.
- Elemental Effect.
- Buff/Debuff.
- Status Effect.
- HP Update.
- Death State.

Combat Resolver không trực tiếp điều khiển Camera hoặc UI.

Nó chỉ cung cấp kết quả để các hệ thống khác cập nhật.

---

# 9. ANIMATION & CAMERA SYNCHRONIZATION

Camera và Animation cần được đồng bộ trong quá trình thực hiện hành động.

## 9.1. Animation State

Đề xuất các trạng thái:

```text
Idle
 |
 v
Prepare
 |
 v
Attack
 |
 v
Hit
 |
 v
Recover
 |
 v
Idle
```

Skill và Ultimate có thể sử dụng animation state riêng.

## 9.2. Animation Event

Có thể sử dụng Animation Event hoặc Timeline Signal để thông báo:

- Attack Start.
- Weapon Hit.
- Projectile Spawn.
- Damage Apply.
- VFX Trigger.
- Animation End.

## 9.3. Camera Synchronization

Ví dụ Skill:

```text
Player Turn
    |
    v
Select Skill
    |
    v
Camera Transition
    |
    v
Skill Animation Start
    |
    v
Animation Event
    |
    v
Apply Damage
    |
    v
Animation End
    |
    v
Return Camera
```

Camera không nên tự xác định thời điểm gây damage.

Thời điểm tác động phải được quản lý bởi Combat/Animation Logic.

---

# 10. SYSTEM COMMUNICATION

## 10.1. Event-driven Architecture

Các hệ thống nên giao tiếp thông qua event hoặc interface.

Các sự kiện chính:

| Event | Publisher | Subscriber |
|---|---|---|
| BattleStarted | BattleManager | Camera, UI, Turn |
| TurnStarted | TurnManager | Camera, UI, Action |
| TurnEnded | TurnManager | BattleManager, UI |
| TargetChanged | TargetManager | UI, Camera |
| ActionStarted | ActionManager | Camera, Animation, UI |
| DamageApplied | CombatResolver | UI, Animation, VFX |
| CharacterDied | CharacterManager | Formation, Turn, UI |
| ActionCompleted | ActionManager | TurnManager, Camera |
| BattleEnded | BattleManager | UI, Camera |

## 10.2. Dependency Rules

Các nguyên tắc cần tuân thủ:

1. Camera Manager không phụ thuộc trực tiếp vào UI.
2. UI không tự quản lý Turn Order.
3. Formation Manager không phụ thuộc Camera Manager.
4. Combat Resolver không điều khiển Animation.
5. Turn Manager là nguồn dữ liệu chính của Current Actor.
6. Target Manager là nguồn dữ liệu chính của Current Target.
7. Battle Manager quản lý trạng thái tổng thể của trận đấu.

---

# 11. UNITY IMPLEMENTATION PROPOSAL

## 11.1. Recommended Hierarchy

```text
BattleScene
│
├── Environment
│
├── BattleWorld
│   ├── PlayerTeam
│   ├── EnemyTeam
│   └── FormationSlots
│
├── CameraSystem
│   ├── MainCamera
│   ├── CameraManager
│   └── CameraTargets
│
├── BattleManagers
│   ├── BattleManager
│   ├── FormationManager
│   ├── TurnManager
│   ├── TargetManager
│   ├── ActionManager
│   ├── CombatResolver
│   └── CharacterManager
│
├── BattleUI
│   ├── Canvas
│   ├── TopHUD
│   ├── TurnOrderHUD
│   ├── PlayerTeamHUD
│   ├── CombatActionHUD
│   └── OverlayHUD
│
└── BattleEffects
    ├── VFX
    ├── DamageNumbers
    └── Audio
```

## 11.2. Suggested Scripts

| Script | Responsibility |
|---|---|
| BattleManager.cs | Quản lý trạng thái trận đấu |
| FormationManager.cs | Quản lý đội hình |
| FormationSlot.cs | Quản lý vị trí nhân vật |
| TurnManager.cs | Quản lý lượt |
| CameraManager.cs | Điều khiển camera |
| CharacterCameraRig.cs | Cung cấp Camera Anchor |
| TargetManager.cs | Quản lý mục tiêu |
| ActionManager.cs | Quản lý hành động |
| CombatResolver.cs | Tính toán combat |
| CharacterController.cs | Quản lý hành vi nhân vật |
| CharacterStats.cs | Quản lý chỉ số |
| EnemyAIController.cs | Quản lý AI |
| BattleUIManager.cs | Quản lý UI tổng |
| TurnOrderUI.cs | Hiển thị thứ tự lượt |
| CharacterHUD.cs | Hiển thị thông tin nhân vật |
| CombatActionUI.cs | Điều khiển giao diện hành động |
| TargetIndicatorUI.cs | Hiển thị mục tiêu |

---

# 12. CAMERA PRIORITY & STATE MANAGEMENT

Đề xuất sử dụng Camera State Machine để tránh xung đột khi nhiều hệ thống cùng yêu cầu chuyển camera.

## 12.1. Camera Priority

Thứ tự ưu tiên:

| Priority | Camera State |
|---|---|
| 1 – Highest | Ultimate Cinematic |
| 2 | Action Camera |
| 3 | Active Actor Camera |
| 4 | Enemy Camera |
| 5 – Lowest | Battle Overview |

Priority có thể được triển khai bằng hệ thống state và transition lock.

## 12.2. Camera State Machine

```text
BattleOverview
      |
      v
ActiveActor
      |
      v
TargetSelection
      |
      v
ActionCamera
      |
      v
UltimateCinematic
      |
      v
ReturnToActiveActor
      |
      v
NextTurn
```

Không phải tất cả trạng thái đều bắt buộc đi qua theo thứ tự trên.

Camera Manager cần hỗ trợ chuyển trạng thái theo sự kiện và quyền ưu tiên.

---

# 13. DEVELOPMENT PHASES

Đề xuất chia quá trình phát triển thành các giai đoạn.

## Phase 1 – Battle Foundation

- Xây dựng Battle Scene.
- Tạo Player Formation.
- Tạo Enemy Formation.
- Thiết lập Formation Slot.
- Đặt camera Overview.

**Deliverable:** Hai đội hình xuất hiện và đối diện nhau trong 3D World.

## Phase 2 – Camera System

- Xây dựng Camera Manager.
- Tạo Camera Anchor cho nhân vật.
- Xây dựng Active Actor Camera.
- Tích hợp Turn Manager.
- Xử lý Camera Blend.

**Deliverable:** Camera tự động chuyển sang nhân vật Player đang có lượt.

## Phase 3 – Turn & Combat System

- Xây dựng Turn Manager.
- Xây dựng Target Manager.
- Xây dựng Action Manager.
- Tích hợp Attack, Skill và Ultimate.
- Xử lý Damage.

**Deliverable:** Một trận chiến Turn-based có thể chơi được.

## Phase 4 – Battle UI

- Xây dựng Top HUD.
- Xây dựng Turn Order HUD.
- Xây dựng Player Team HUD.
- Xây dựng Combat Action HUD.
- Xây dựng Target Selection UI.

**Deliverable:** Hoàn thiện UI chiến đấu và đồng bộ dữ liệu gameplay.

## Phase 5 – Presentation & Polish

- Camera Cinematic.
- Animation Synchronization.
- VFX.
- Damage Number.
- Hit Reaction.
- Camera Collision.
- Transition Polish.

**Deliverable:** Battle Presentation hoàn chỉnh.

---

# 14. FINAL RECOMMENDATIONS

## 14.1. Formation

Sử dụng Slot-based Formation.

Player và Enemy được đặt thành hai hàng đối diện nhau. Formation không thay đổi khi camera chuyển góc.

## 14.2. Camera

Sử dụng Multi-state Camera System.

Camera tự động nhận Active Actor từ Turn Manager.

Khi Player có lượt:

- Lấy Camera Anchor của Player.
- Chuyển camera đến góc nhìn của Player.
- Hướng về Enemy Target.
- Cho phép chọn Action và Target.

Khi hành động:

- Chuyển sang Action Camera nếu cần.
- Ultimate sử dụng Cinematic Camera.
- Kết thúc animation thì chuyển về trạng thái phù hợp.

## 14.3. UI

Sử dụng Screen Space UI độc lập với World Space.

UI chỉ hiển thị và nhận thao tác từ người chơi. Gameplay System mới là nơi quản lý trạng thái thật.

## 14.4. Architecture

Ưu tiên phân tách:

- Battle Management.
- Formation Management.
- Turn Management.
- Camera Management.
- Target Management.
- Combat Management.
- UI Management.

Không nên xây dựng tất cả logic trong một BattleManager duy nhất.

---

# 15. FINAL SYSTEM FLOW

```text
                    BATTLE START
                         |
                         v
                 INITIALIZE BATTLE
                         |
             +-----------+-----------+
             |                       |
             v                       v
       PLAYER FORMATION        ENEMY FORMATION
             |                       |
             +-----------+-----------+
                         |
                         v
                  CAMERA OVERVIEW
                         |
                         v
                    TURN MANAGER
                         |
                         v
                  GET CURRENT ACTOR
                         |
               +---------+---------+
               |                   |
               v                   v
          PLAYER TURN          ENEMY TURN
               |                   |
               v                   v
       ACTIVE PLAYER CAMERA    ENEMY / OVERVIEW
               |                   |
               v                   v
        SELECT ACTION           ENEMY AI
               |                   |
               v                   |
        SELECT TARGET              |
               |                   |
               +---------+---------+
                         |
                         v
                   ACTION MANAGER
                         |
                         v
                  ANIMATION SYSTEM
                         |
                         v
                   COMBAT RESOLVER
                         |
                         v
                   UPDATE GAME STATE
                         |
                         v
                  CHECK BATTLE END
                         |
                +--------+--------+
                |                 |
                v                 v
               NO                YES
                |                 |
                v                 v
           NEXT TURN          BATTLE RESULT
```

**Kết luận:** Kiến trúc đề xuất lấy Formation System, Turn Manager và Camera Manager làm ba thành phần nền tảng. Trong đó Turn Manager quyết định nhân vật hiện tại, Camera Manager chuyển góc nhìn theo nhân vật đó, còn Formation Manager duy trì bố cục hai hàng đối diện. UI và Combat System hoạt động độc lập nhưng đồng bộ thông qua các sự kiện gameplay.

Đây là nền tảng có thể mở rộng cho các tính năng như nhiều loại đội hình, nhiều Enemy, AoE Combat, Character-specific Cinematic và Dynamic Camera mà không phải thiết kế lại toàn bộ Battle System.