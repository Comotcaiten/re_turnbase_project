class_name UnitService

func print_data(_source: UnitModel):
  if _source == null:
    print("[!] source unit model: null")
    return
  print("[>] Name: ", _source.base.name)
  print("[>] Max HP: ", _source.max_hp)
  print("[>] Max MP: ", _source.max_mp)
  print("[>] Attack: ", _source.attack)
  print("[>] Defense: ", _source.defense)
  print("[>] Speed: ", _source.speed)
  print("[>] Critical: ", _source.critical)

func print_skills(_source: UnitModel):
  if _source.skills.size() <= 0:
    print("[>] Skills: None")
    return

  print("[>] Skills: ", _source.skills.size())
  for index in range(0, _source.skills.size()):
    print("[>] * ", index, ": ", _source.skills[index].base.name)
  return

func take_damage(_target: UnitModel, _damage_detail: DamageDetailModel) -> bool:
  if _target == null or _damage_detail == null:
    return false
  print("[>] ", _target.base.name, " take ", _damage_detail.damage, " DMG")
  _target.hp -= _damage_detail.damage
  return _target.hp <= 0

func get_passive_skill():
  return

func run_skill():
  return

func get_hp(_source: UnitModel) -> String:
  return "HP: " + str(_source.hp) + "/" + str(_source.max_hp)