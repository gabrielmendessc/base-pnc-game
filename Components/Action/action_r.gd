extends Resource
class_name ActionR
## A superclass for triggerable actions that modifies the [RoomC]'s elements.
##
## This superclass contains the logic that valid conditions for triggering it's child classes.
## It also disable itself when oneshot actions are finished.

@export var condition: ConditionR ## The condition for triggering this action.
@export var enabled: bool = true ## If disabled, this action will not be triggered in the [TriggerC] it belongs to.
@export var oneshot: bool ## If enabled, this action will be disabled after triggering for the first time.

var name: String = "ActionR" ## The action name for debugging.

signal action_finished() ## Signal emited by the child class when finished.

## Called by the [TriggerC] it belongs to when triggered.
##
## Valids the conditions for triggering the action, calls the child class implementation of [method ActionR.run_action]
## and disables itself if it is a oneshot action.
func trigger_action(trigger: TriggerC) -> void:	
	if condition && !condition.has_met_condition(trigger):
		print("Has not met condition %s for ActionR '%s' in TriggerC '%s'." % [condition.not_met_condition, resource_name, trigger.name])
		action_finished.emit()
		return
	
	run_action(trigger)
	
	if oneshot:
		enabled = false
	
## Method to be implemented by the child class with the action functionality.
func run_action(_trigger: TriggerC) -> void:
	push_error("UNIMPLEMENTED METHOD: ActionC.run_action()")
