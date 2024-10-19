extends PanelContainer
class_name SlotC
## UI with data of an item slot.

@export var is_slot_visible: bool = true

@onready var item_tex: TextureRect = $SlotContainer/ItemTexture
@onready var slot_tex: TextureRect = $SlotContainer/SlotTexture

var item: ItemR

signal slot_clicked(index: int)

func _ready() -> void:
	slot_tex.visible = is_slot_visible

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		slot_clicked.emit(get_index())

## Sets the slot's item data and texture.
func set_item(_item: ItemR) -> void:
	item = _item
	if item:
		item_tex.texture = item.texture
	else:
		item_tex.texture = null

## Removes and return to the caller the slot's item data and remove the slot's item texture..
func pop_item() -> ItemR:
	if !item:
		return null
		
	var return_item: ItemR = item.duplicate()
	item_tex.texture = null
	item = null
	
	return return_item
	
## Swap the slot's item with the provided item.
func swap_item(grabbed_item: ItemR) -> ItemR:
	var return_item: ItemR = pop_item()
	
	set_item(grabbed_item)
	
	return return_item
