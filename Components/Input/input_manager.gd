extends Node
## Autoload for handling clicks callbacks.
##
## This autoload has callbacks for [BackgroundC] and trigger clicks to
## be connected by the RoomC node. It also handles the callback for
## when the player reachs it's click destination.

## This defines how the inputs will be handled.
enum {
	INPUT_ALL, ## All inputs will be handled normally.
	INPUT_DIALOG, ## All inputs will be received by the DialogUI.
	INPUT_NONE ## No inputs will be handled.
}

## The present input mode.
var input_mode: int = INPUT_ALL

## The present callback for the reached destination.
var _trigger_actions: Callable = Callable()

## Callback for handling clicks on the room's background.
##
## It moves the player to the click position, resets the present callback
## and returns any using or grabbed item to the room inventory.
func on_background_click(background: BackgroundC) -> void:
	if input_mode != INPUT_ALL:
		return
		
	get_viewport().set_input_as_handled()
	print("Clicked on BackgroundC '%s' at %s." % [background.name, background.last_mouse_click_pos])
	
	var room: RoomC = background.room
	_trigger_actions = Callable()
	
	if room.player:
		room.player.move_to(background.last_mouse_click_pos)
		
	if room.inventory:
		room.inventory.return_grabbed_item()
		room.inventory.return_using_item()
	
## Callback for handling clicks on room's triggers.
##
## It moves the player to the trigger pos, moves the grabbed item to
## using and changes the present callback for triggering the trigger
## actions.
func on_trigger_click(trigger: TriggerC) -> void:
	if input_mode != INPUT_ALL:
		return
		
	get_viewport().set_input_as_handled()
	print("Clicked on TriggerC '%s'." % trigger.name)
	
	var room: RoomC = trigger.room
	_trigger_actions = Callable(trigger, "trigger_actions")
	
	if room.player && trigger.trigger_pos:
		print("Moving to TriggerPos at %s." % trigger.trigger_pos.global_position)
		room.player.move_to(trigger.trigger_pos.global_position)
		
	if room.inventory:
		room.inventory.use_grabbed_item()
		
	if !trigger.trigger_pos:
		_call_trigger_actions()
	
## Callback for when the player reaches his destination.
func on_navigation_finished() -> void:
	_call_trigger_actions()
	
## Call the reached destination callback.
func _call_trigger_actions() -> void:
	if _trigger_actions.is_valid():
		_trigger_actions.call()
		
	_trigger_actions = Callable()
