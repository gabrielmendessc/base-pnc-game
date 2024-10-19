extends Control
class_name DialogUI
## UI for displaying lines of [DialogR]'s.
##
## This nodes holds all the logic for timing letters, displaying portraits and lines texts.
## It emits a handfull of signals to sinalize finished lines or dialogs. 

#region Variables
@onready var text_label: Label = $TextBox/TextContainer/TextLabel ## Label that displays the lines text.
@onready var timer: Timer = $LetterDisplayTimer ## Timer for displaying letters.
@onready var player_portrait: Sprite2D = $PlayerPortrait ## Portrait on the left.
@onready var npc_portrait: Sprite2D = $NpcPortrait ## Portrait on the right.
@onready var voice_player: AudioStreamPlayer = $VoiceAudioPlayer ## AudioStream for playing the character "voice".

var trigger: TriggerC ## Trigger that played the dialog.

var lines: Array[DialogLineR] ## Lines to be displayed.
var line_index: int ### Current line being displayed.

var character: CharacterR ## Current character being displayed.

var text: String ## Text to be displayed.
var text_index: int ## Current letter being displayed. 

var letter_time: float = 0.03 ## Time for displaying a letter.
var space_time: float = 0.06 ## Time for displaying a space.
var punctuation_time: float = 0.2 ## Time for displaying a punctuation.

var can_skip: bool ## If the player can skip to the next line.

signal finished_dialog() ## Emitted when all lines in the dialog were displayed.
signal finished_text() ## Emitted when all letter in the line text were displayed.
#endregion

#region Natives
func _ready() -> void:
	finished_dialog.connect(_on_finished_dialog)
	finished_text.connect(_on_finished_text)

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("click"):
		return
		
	if can_skip:
		if line_index - 1 > 0 && lines[line_index - 1].next_dialog: #If there's another dialog linked to the current, load and display it.
			display_dialog(load(lines[line_index - 1].next_dialog), trigger)
		else:
			_display_line()
			
		return
		
	if !can_skip && text_index < text.length():
		finished_text.emit()
		return
#endregion

## Displays the given dialog.
func display_dialog(dialog: DialogR, _trigger: TriggerC) -> void:
	
	_init_line(_trigger, dialog.lines)
	_display_line()
	
#region Line
## Inits all variables to start displaying a new line.
func _init_line(_trigger: TriggerC, _lines: Array[DialogLineR]) -> void:
	show()
	
	trigger = _trigger
	lines = _lines
	line_index = 0

## Displays the next line.
func _display_line() -> void:
	if line_index >= lines.size():
		await get_tree().create_timer(0.2).timeout
		finished_dialog.emit()
		return
		
	var line: DialogLineR = lines[line_index]
	if line.condition && !line.condition.has_met_condition(trigger):
		line_index += 1
		_display_line()
		return
	
	can_skip = false
	
	_init_character(line)
	_display_character()
	
	_init_text(line)
	_display_text()
	
	line_index += 1
#endregion
	
#region Portrait
## Inits all variables to start displaying character data.
func _init_character(line: DialogLineR) -> void:
	character = line.character
		
## Displays the current line character data.
func _display_character() -> void:
	if !character:
		player_portrait.hide()
		npc_portrait.hide()
		player_portrait.texture = null
		npc_portrait.texture = null
		voice_player.stream = null
		
		return
		
	#Finds the portrait linked to the provided emotion.
	var portrait: PortraitR = character.portraits.filter(func (_portrait: PortraitR) -> bool: return _portrait.emotion == lines[line_index].emotion)[0]	
	if character.npc:
		player_portrait.hide()
		npc_portrait.texture = portrait.texture
		npc_portrait.show()
		
	else:
		npc_portrait.hide()
		player_portrait.texture = portrait.texture
		player_portrait.show()
		
	voice_player.stream = character.audio
#endregion
	
#region Text
## Inits all variables to start displaying the current line text.
func _init_text(line: DialogLineR) -> void:
	text_label.text = ""
	text = line.text
	text_index = 0
		
## Displays the next letter from the current line text.
func _display_text() -> void:
	if text_index >= text.length():
		finished_text.emit()
		
		return
		
	text_label.text += text[text_index]
	
	match text[text_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			
	text_index += 1	
#endregion

#region Signals Callback
func _on_letter_display_timer_timeout() -> void:
	if character && character.audio && timer.wait_time == letter_time:
		voice_player.play()
		voice_player.pitch_scale = randf_range(0.9, 1.0)
		
	_display_text()
	
func _on_finished_text() -> void:
	timer.stop()
	
	text_label.text = text
	text_index = text.length() - 1
	can_skip = true
	
func _on_finished_dialog() -> void:
	hide()
	
	can_skip = false
#endregion
