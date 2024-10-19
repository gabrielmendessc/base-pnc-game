extends Resource
class_name CharacterR
## Holds character data for dialogs.

@export var character: String = "" ## Chacter name.
@export var npc: bool ## If true, the portrait will appear at the right.
@export var portraits: Array[PortraitR] ## The portraits images and it's emotions.
@export var audio: AudioStream ## The character "voice".
