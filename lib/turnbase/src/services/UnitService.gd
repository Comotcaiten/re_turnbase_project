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