extends Resource
class_name DialogLineR
## Holds information for one dialog speech.

@export var condition: ConditionR ## The condition for this line to be played.
@export var actions: Array[ActionR] ## Acitions to be executed before or after the dialog is played.

@export_group("Display")
@export var character: CharacterR ## The character to be displayed.
@export var emotion: PortraitR.EMOTION ## The emotion portrait to be displayed.
@export var text: String ## The text to be displayed.
@export var choices: Array[ChoiceR] ## @experimental

@export_group("Follow Up")
@export_file("*.tres") var next_dialog: String ## The resource path for another [DialogR] to be played.
