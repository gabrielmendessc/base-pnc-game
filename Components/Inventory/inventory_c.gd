extends PanelContainer
class_name InventoryC
## Inventory UI that holds slot with items.
##
## This node is usually attached to a room with the player's items. It holds methods
## for manipulating all the items in the slots.

@export var inventory_res: InventoryR ## Inventory data to be read at startup.

@onready var slot_scene: PackedScene = preload("res://Components/Inventory/slot.tscn") ## Scene to istantiate new items.
@onready var slot_grid: GridContainer = $Control/InventoryContainer/SlotGrid ## The grid with the items slots.
@onready var grabbed_slot: SlotC = $GrabbedSlot ## Item slot being dragged by the player.

var grabbed_item: ItemR ## Item being dragged by the player.
var using_item: ItemR ## Item being used by the player.

func _ready() -> void:
	slot_grid.columns = inventory_res.items.size()
	
	for item in inventory_res.items:
		var slot: SlotC = slot_scene.instantiate()
		
		slot_grid.add_child(slot)
		
		slot.set_item(item)
		slot.slot_clicked.connect(_on_slot_clicked)
		
func _process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.set_global_position(get_global_mouse_position() + Vector2(5, 5))
		
## Verifies if the provided item exist on the inventory.
func has_item(item: ItemR) -> bool:
	for slot: SlotC in slot_grid.get_children():
		if slot.item == item:
			return true
			
	return false
		
## Adds the provided item to the invetory if it has slots avaliable.
func add_item(item: ItemR) -> bool:
	for slot: SlotC in slot_grid.get_children():
		if !slot.item:
			slot.set_item(item)
			return true
			
	return false
		
## Returns the grabbed item to a inventory slot.
func return_grabbed_item() -> void:
	add_item(grabbed_item)
	grabbed_item = null
	
	_update_grabbed_item()
	
## Moves the grabbed item to be a using item.
func use_grabbed_item() -> void:
	using_item = grabbed_item
	grabbed_item = null
	
	_update_grabbed_item()
	
## Returns the using item to a inventory slot.
func return_using_item() -> void:
	add_item(using_item)
	using_item = null
		
## Callback for clicking a item slot. Swaps the clicked slot with the grabbed item.
func _on_slot_clicked(index: int) -> void:
	if grabbed_item == null:
		grabbed_item = _pop_item(index)
	else:
		grabbed_item = _swap_item(index, grabbed_item)

	_update_grabbed_item()
	
## Removes and return to the caller the item in the slot at the index provided.
func _pop_item(index: int) -> ItemR:
	if slot_grid.get_child_count() < (index + 1):
		push_error("Tried to acess an invalid index on inventory")
		return null
		
	return (slot_grid.get_child(index) as SlotC).pop_item()
	
## Swaps the item in the slot at the provided item with the provided item.
func _swap_item(index: int, _grabbed_item: ItemR) -> ItemR:
	if slot_grid.get_child_count() < (index + 1):
		push_error("Tried to acess an invalid index on inventory")
		return _grabbed_item
		
	return (slot_grid.get_child(index) as SlotC).swap_item(grabbed_item)
	
## Hides the grabbed_slot if there's no item being dragged and show it otherwise.
func _update_grabbed_item() -> void:
	if grabbed_item:
		grabbed_slot.set_item(grabbed_item)
		grabbed_slot.set_global_position(get_global_mouse_position() + Vector2(5, 5))
		grabbed_slot.show()
		return
		
	grabbed_slot.hide()
	
