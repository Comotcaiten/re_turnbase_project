class_name Character

var base: CharacterBase
var level: int:
	get:
		return max(level, 0)
var nameCharacter: String:
	get:
		return base.name

var mainhandSlot: ItemzBase
var headSlot: ItemzBase
var chestSlot: ItemzBase
var legsSlot: ItemzBase

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


func EquipItem(_item: ItemzBase, slotType: ItemzSlot.Type):
	# enum Type {AnySlot, Mainhand, Head, Chest, Legs, Inventory}
	match slotType:
		ItemzSlot.Type.AnySlot:
			print("AnySlot")
		ItemzSlot.Type.Mainhand:
			self.mainhandSlot = _item
		ItemzSlot.Type.Head:
			self.headSlot = _item
		ItemzSlot.Type.Chest:
			self.chestSlot = _item
		ItemzSlot.Type.Legs:
			self.legsSlot = _item
		ItemzSlot.Type.Inventory:
			print("Inventory")
		_:
			print("<!> Không thể trang bị/bỏ trong kho - Item is null/can result")


func GetAttribute(attribute: CharacterBase.Attribute) -> int:
	var amountBase = attribute_base[attribute]
	var amountModified = attribute_modified[attribute]
	
	# Item
	# <Mainhand>
	if mainhandSlot != null:
		# <Extra>
		if attribute == CharacterBase.Attribute.Attack:
			amountBase += mainhandSlot.damage
			print("Attack Bonus ", mainhandSlot.damage)
		# </Extra>
		# <Attribute>
		amountBase += mainhandSlot.GetValueAttribute(attribute)
		print(CharacterBase.Attribute.keys()[attribute], " Bonus ", mainhandSlot.GetValueAttribute(attribute))
		#	</Attribute>
	# </MainHand>
	# <Head>
	if headSlot != null:
		if (headSlot is ItemzArmorBase) and (attribute == CharacterBase.Attribute.Defense):
			amountBase += headSlot.defense
			print("Defense Bonus ", headSlot.defense)
		# <Attribute>
		amountBase += headSlot.GetValueAttribute(attribute)
		print(CharacterBase.Attribute.keys()[attribute], " Bonus ", headSlot.GetValueAttribute(attribute))
		#	</Attribute>
	# </Head>
	# /Item
	
	var amountCal = amountBase + ((amountModified * amountBase) / 100.0)
	return max(int(amountCal), 0)

func _init(_base: CharacterBase, _level: int):
	self.base = _base
	self.level = _level
	SetUpAttribute()
	SetUpSkill()

func TakeDamage(_skill: Skill, _attacker: Character) -> bool:
	var critical = 1.0
	var typeEff = 1.0
	var modifiers = randf_range(0.85, 1.0) * typeEff * critical
	var a = ((2.0 * _attacker.level + 10.0) / 250.0)
	var damage = int(a * modifiers)

	self.hp -= damage
	
	print(nameCharacter, " took ", damage, " DMG")
	print(nameCharacter, " has ", hp, " HP")
	
	return hp == 0

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
    
	# Sử dụng hàm item_info để tạo chuỗi thông tin trang bị
	print("Mainhand: ", item_info(mainhandSlot))
	print("Head: ", item_info(headSlot))
	print("Chest: ", item_info(chestSlot))
	print("Legs: ", item_info(legsSlot))
    
	print("-----</Trang bi>-----")


func RandomSkill() -> Skill:
	return skills[randi() % skills.size()]
