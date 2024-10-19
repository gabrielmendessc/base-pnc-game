extends ActionR
class_name ChangeVarActionR
## Changes global variables values when triggered.

## When conditions are meet(if there are any) this action will change one or more global variables
## to the definied value. 
## If the variable not exists, an error will be pushed.

@export var variables: Dictionary = {}

func _init() -> void:
	set_name("ChangeVarActionR")

func run_action(_trigger: TriggerC) -> void:
	change_var()
	
func change_var() -> void:
	for key: String in variables.keys():
		if Globals.vars.has(key):
			print("Chaging var '%s' to '%s'." % [key, variables[key]])
			Globals.vars[key] = variables[key]
			
			continue
			
		push_error("Tried to change the value of the non-existent var '%s'" % key)
		
	action_finished.emit()
