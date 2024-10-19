extends Resource
class_name ChoiceR
## @experimental

@export var text: String
@export var condition: ConditionR
@export var actions: Array[ActionR]

@export_group("Follow Up")
@export_file("*.tres") var next_dialog: String
