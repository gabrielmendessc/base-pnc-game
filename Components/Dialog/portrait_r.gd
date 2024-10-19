extends Resource
class_name PortraitR
## Holds a character image associeted with an emotion.

enum EMOTION {
	Neutral,
	Happy,
	Sad,
	Angry
}

@export var texture: Texture2D ## Character image.
@export var emotion: EMOTION ## Character emotion.
