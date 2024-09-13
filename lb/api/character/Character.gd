class_name Character

var base: CharacterBase
var level: int:
	get:
		return max(level, 0)
var nameCharacter: String:
	get:
		return base.name

var mainHand: ItemzBase
var equipments: Array[ItemzBase] = []

var attribute_base: Dictionary = {
	CharacterBase.Attribute.Hp: 0,
	CharacterBase.Attribute.Mp: 0,
	CharacterBase.Attribute.Attack: 0,
	CharacterBase.Attribute.Defense: 0,
	CharacterBase.Attribute.Speed: 0,
}

var attribute_modified: Dictionary = {
	CharacterBase.Attribute.Hp: 0,
	CharacterBase.Attribute.Mp: 0,
	CharacterBase.Attribute.Attack: 0,
	CharacterBase.Attribute.Defense: 0,
	CharacterBase.Attribute.Speed: 0,
}

var max_hp: int:
	get:
		return GetAttribute(CharacterBase.Attribute.Hp)
var hp: int

var max_mp: int:
	get:
		return GetAttribute(CharacterBase.Attribute.Mp)
var mp: int

var attack: int:
	get:
		return GetAttribute(CharacterBase.Attribute.Attack)
var defense: int:
	get:
		return GetAttribute(CharacterBase.Attribute.Defense)
var speed: int:
	get:
		return GetAttribute(CharacterBase.Attribute.Speed)
var crit: int:
	get:
		return GetAttribute(CharacterBase.Attribute.Crit)

var skills: Array[Skill]

func SetUpAttribute():
	SetUpAttributeBase()
	hp = max_hp
	mp = max_mp

func SetUpAttributeBase():
	attribute_base[CharacterBase.Attribute.Hp] = base.hp * level
	attribute_base[CharacterBase.Attribute.Mp] = base.mp * level
	attribute_base[CharacterBase.Attribute.Attack] = base.attack * level
	attribute_base[CharacterBase.Attribute.Defense] = base.defense * level

func SetAttributeModified(attribute: CharacterBase.Attribute, amount: int):
	attribute_modified[attribute] = amount

func SetUpSkill():
	if base.skillLearables.size() <= 0:
		pass
	for skill in base.skillLearables:
		if skill.level <= level:
			skills.append(Skill.new(skill.base))

func EquipItem(_item: ItemzBase) -> bool:
	if _item == null:
		print("<!> Không thể trang bị/bỏ trong kho - Item is null/can result")
		return false
	if equipments.size() >= 6:
		print("<!> Kho đã đầy")
		return false
	equipments.append(_item)
	return true

func ResetEquipment():
	equipments.clear()

func GetAttribute(attribute: CharacterBase.Attribute) -> int:
	var amountBase = attribute_base[attribute]
	var amountModified = attribute_modified[attribute]

	# <Equipments>
	if equipments.size() > 0:
		for item in equipments:
			amountBase += item.GetValueAttribute(attribute)
			print(CharacterBase.Attribute.keys()[attribute], " Bonus ", item.GetValueAttribute(attribute))
	# </Equipments>

	var amountCal = amountBase + ((amountModified * amountBase) / 100.0)
	return max(int(amountCal), 0)

func _init(_base: CharacterBase, _level: int):
	base = _base
	level = _level
	SetUpAttribute()
	SetUpSkill()

func TakeDamage(_skill: Skill, _attacker: Character) -> bool:
	hp -= CalculateDamageTaken(_skill, _attacker)
	return hp == 0

func CalculateDamageTaken(_skill: Skill, _attacker: Character) -> int:
	if _attacker == null:
		return 0
	
	var critical = 1.0
	var typeEff = 1.0

	if _skill != null:
		typeEff = ElementEffectiveness.GetEffectiveness(_attacker.base.element, base.element)
	
	var damage = int(((2.0 * _attacker.level + 10.0) / 250.0) * randf_range(0.85, 1.0) * typeEff * critical)

	if _attacker.mainHand != null:
		damage += int((damage * _attacker.mainHand * 1.0) / 100.0)

	print(nameCharacter, " took ", damage, " DMG")
	print(nameCharacter, " has ", hp, "/", max_hp, " HP")

	return damage

func ResetAllAttributeModified():
	for attr in attribute_modified.keys():
		attribute_modified[attr] = 0

func PrintSkill():
	print("-----<Print_Skill>-----")
	if skills.size() <= 0:
		print("<!> Chưa có danh sách kỹ năng - SkillLearables are null.")
	for i in range(0, skills.size()):
		print("<", i, ">", skills[i].base.name)
	print("-----</Print_Skill>-----")

func PrintAttribute():
	print("-----<Print_Attribute>-----")
	print("Name: ", nameCharacter)
	print("Level: ", level)
	print("Hp: ", max_hp)
	print("Mp: ", max_mp)
	print("Attack: ", attack)
	print("Defense: ", defense)
	print("-----</Print_Attribute>-----")

func item_info(item: ItemzBase) -> String:
	if item:
		return "{a} => {b}".format({"a": item, "b": item.name})
	return "None"

func PrintItemEquiped():
	print("-----<Trang bi>-----")
	print("[Equipments]: ", equipments)
	for i in range(0, equipments.size()):
		print("<", i + 1, "> ", item_info(equipments[i]))
	print("-----</Trang bi>-----")

func AddItem(_item: ItemzBase):
	EquipItem(_item)

func RandomSkill() -> Skill:
	return skills[randi() % skills.size()]
