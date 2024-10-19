extends ActionR
class_name DialogActionR
## Plays the definied dialog when triggered.
##
## Calls the room DialogUI to display the definied dialog, finish the action when the dialog
## finish displaying.

@export var dialog: DialogR

func _init() -> void:
	set_name("DialogActionR")

func run_action(trigger: TriggerC) -> void:
	trigger.room.dialog.display_dialog(dialog, trigger)
	await trigger.room.dialog.finished_dialog
	action_finished.emit()
