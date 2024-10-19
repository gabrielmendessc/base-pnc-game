extends Area2D
class_name TriggerC
## An interactable region that triggers [ActionR]'s.
##
## This nodes holds a list of [ActionR]'s with a variety of events and can, optionally,
## move the room's [Player] to a designated position when interacting with.
## When having a [member TriggerC.trigger_pos] it triggers the [ActionR] list after reaching the position,
## otherwise it triggers right after interacting with.

#region Variables
@export var trigger_pos: Marker2D ## The position to move the room's [Player] to.
@export_enum("North", "Northwest", "West", "Southwest", "South", "Southeast", "East", "Northeast") var facing_dir: String ## The direction the room's [Player] should look on interacting.
@export var actions: Array[ActionR] ## The [ActionR]'s to be triggered on interacting.

@onready var collision: CollisionPolygon2D = _get_collision() ## The mouse click collision.

var room: RoomC ## The [RoomC] this node belongs to.
var is_mouse_in: bool ## If the mouse is inside the trigger collision polygon.

signal trigger_click(trigger: TriggerC) ## Signal emitted when interacting with.
#endregion

func _ready() -> void:
	_init_vars()
	_connect_signals()
	add_to_group("input_receiver")
	
func _unhandled_input(event: InputEvent) -> void:
	if !event.is_action_pressed("click") || Engine.is_editor_hint():
		return
		
	#Verify if the click position is inside the collision polygon.
	if Geometry2D.is_point_in_polygon(get_local_mouse_position(), collision.polygon):
		trigger_click.emit(self)
	
## Adds an [ActionR] to the [ActionR] list.
func add_action(action: ActionR) -> void:
	print("Adding ActionR '%s' to TriggerC '%s'." % [action.resource_name, name])
	actions.append(action)

## Removes an [ActionR] from the [ActionR] list.
func erase_action(action: ActionR) -> void:
	print("Removing ActionR '%s' from TriggerC '%s'." % [action.resource_name, name])
	actions.erase(action)
	
## Triggers all the [ActionR] in the list.
##
## Disabled [ActionR] will be skipped and using items will be returned to room's [InventoryC]
## if not handled inside an action. The actions will be triggered sequentially.
func trigger_actions() -> void:
	for action in actions:
		if action.enabled:
			print("Triggering ActionR '%s' from TriggerC '%s'." % [action.resource_name, name])
			action.call_deferred("trigger_action", self) ## Calls the action in the next frame to run async and capture the action_finished signal
			await action.action_finished
		
	if room.inventory && room.inventory.using_item:
		push_warning("Using item '%s' not handled in TriggerC '%s'. Returning to room inventory." % [room.inventory.using_item.name, name])
		room.inventory.return_using_item()

func _init_vars() -> void:
	if !owner is RoomC: push_error("TriggerC '%s' initialized without a RoomC owner." % name)
	room = owner
	
func _connect_signals() -> void:
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exited)
	
func _get_collision() -> CollisionPolygon2D:
	for child in get_children():
		if child is CollisionPolygon2D:
			return child
			
	return null
	
func _on_mouse_enter() -> void:
	is_mouse_in = true
	
func _on_mouse_exited() -> void:
	is_mouse_in = false
