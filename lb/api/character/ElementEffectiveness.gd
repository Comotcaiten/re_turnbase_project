class_name ElementEffectiveness
static var typeEff = [
    # [AT V /DEF >]  Physic Fire Water
    #   Physic
    #   Fire
    #   Water
    [1.0, 1.0, 1.0],
    [1.0, 1.0, 1.0],
    [1.0, 1.0, 1.0]
]

static func GetEffectiveness(_attacker: CharacterBase.Element, _defender: CharacterBase.Element):
  if _attacker == null or _defender == null:
    return 1
  if _attacker == CharacterBase.Element.None or _defender == CharacterBase.Element.None:
    return 1
  return typeEff[_attacker - 1][_defender - 1]