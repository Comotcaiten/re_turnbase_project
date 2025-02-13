class_name Element

enum Type {PHYSICAL, FIRE, WATER}

static var type_effect = [
    # [AT V /DEF >]  Physic Fire Water
    #   Physic
    #   Fire
    #   Water
    [1.0, 1.0, 1.0],
    [1.0, 1.0, 1.0],
    [1.0, 2.0, 1.0]
]

static var color_element = [ # Color
    Color.html("BFBBA9"), # Physical
    Color.html("E52020"), # Fire
    Color.html("0D92F4") # Water
]

static func reactor_element_effect(attacker: Type, defender: Type) -> int:
    if attacker == null or defender == null:
        return 1

    return type_effect[attacker][defender]

static func get_color_element(element: Type) -> Color:
    if element == null:
        return color_element[0]
    return color_element[element]