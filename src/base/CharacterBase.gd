extends Resource
class_name CharacterBase

enum StatType {MaxHealth, AttackPhysical, AttackMagic, DefensePhysical, DefenseMagic, Speed}
enum Element {Physical, Fire, Water}

@export var name: String

@export var element: Element

@export var max_health: int

@export_group("Attack")
@export var attack_physical: int
@export var attack_magic: int

@export_group("Defense")
@export var defense_physical: int
@export var defense_magic: int

@export_group("Speed")
@export var speed: int

@export_group("Skill")
var max_skills: int = 4
@export var skills: Array[SkillBase]

func get_stats():
    return {
        StatType.MaxHealth: max(0, max_health),

        StatType.AttackPhysical: max(0, attack_physical),
        StatType.AttackMagic: max(0, attack_magic),

        StatType.DefensePhysical: max(0, defense_physical),
        StatType.DefenseMagic: max(0, defense_magic),

        StatType.Speed: max(0, speed),
    }

static func get_stats_default():
    return {
        StatType.MaxHealth: 0,

        StatType.AttackPhysical: 0,
        StatType.AttackMagic: 0,

        StatType.DefensePhysical: 0,
        StatType.DefenseMagic: 0,
        
        StatType.Speed: 0,
    }