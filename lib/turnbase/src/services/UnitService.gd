class_name UnitService

func print_data(_source: UnitModel):
  print("[>] Name: ", _source.base.name)
  print("[>] Max HP: ", _source.max_hp)
  print("[>] Max MP: ", _source.max_mp)
  print("[>] Attack: ", _source.attack)
  print("[>] Defense: ", _source.defense)
  print("[>] Speed: ", _source.speed)
  print("[>] Critical: ", _source.critical)
