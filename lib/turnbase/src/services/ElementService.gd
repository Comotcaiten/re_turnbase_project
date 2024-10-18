class_name ElementService

static var type_eff = [
    # [AT V /DEF >]  Physic Fire Water
    #   Physic
    #   Fire
    #   Water
    [1.0, 1.0, 1.0],
    [1.0, 1.0, 1.0],
    [1.0, 1.0, 1.0]
]

static func get_effectiveness(_attacker: ElementBase.Type, _defender: ElementBase.Type):
  if _attacker == null or _defender == null:
    return 1
  if _attacker == ElementBase.Type.None or _defender == ElementBase.Type.None:
    return 1
  return type_eff[_attacker - 1][_defender - 1]