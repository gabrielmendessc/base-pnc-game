extends ActionR
class_name PickUpActionR
## Adds a definied item to the room inventory when triggered.

@export var pick_up_item: ItemR

func _init() -> void:
	set_name("PickUpActionR")

func run_action(trigger: TriggerC) -> void:
	if !pick_up_item:
		push_warning("Tried to pick-up item without a pick_up_item definied.")
	
	elif !trigger.room.inventory:
		push_error("Tried to pick-up item in a inventoryless room.")
	
	elif trigger.room.inventory.add_item(pick_up_item):
		print("Successfully added item '%s' to room inventory." % pick_up_item.name)
		pick_up_item = null
	
	else: 
		push_error("Failed to add item '%s' to room inventory" % pick_up_item.name)
	
	action_finished.emit()
