extends Resource
class_name ConditionR
## Conditions to be met to trigger an action.
##
## Holds variables and items conditions that will be validate by the [ActionR] superclass
## when triggering.

@export var has_vars: Array[String] ## Global variables to be checked if are true.
@export var has_items: Array[ItemR] ## Items to be checked if exists in the room's inventory.

var not_met_condition: String = "" ## Not met conditions for debugging.

## Validates if all global variables in [member ConditionR.has_vars] are true and
## all items in [member ConditionR.has_items] exists in the room's inventory.
func has_met_condition(trigger: TriggerC) -> bool:
	
	if has_vars:
		for var_name in has_vars:
			if !Globals.vars.has(var_name):
				push_error("Tried to validate a non-existente var condition.")
				not_met_condition = "has_var '%s'" % var_name
				return false
			
			if !Globals.vars[var_name]:
				not_met_condition = "has_var '%s'" % var_name
				return false
				
	if has_items:
		if !trigger.room.inventory:
			push_error("Tried to validate a item condition in a inventoryless room.")
			not_met_condition = "has_item '%s'" % has_items[0].name
			return false
		
		for item in has_items:
			if !trigger.room.inventory.has_item(item):
				not_met_condition = "has_item '%s'" % item.name
				return false
			
	return true
