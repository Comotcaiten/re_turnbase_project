extends Resource
class_name ItemzSlot

enum Type {AnySlot, Inventory, Equipment}

var item: ItemzBase
var amount: int

var type: Type

func SetType(_type: Type):
  type = _type

func AddItem(_item: ItemzBase, _amount: int) -> int:
  if _item == null:
    return 0
  item = _item
  amount = min(_item.maxAmount, _amount)
  return abs(_item.maxAmount - _amount)