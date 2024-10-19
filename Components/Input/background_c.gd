@tool
extends Sprite2D
class_name BackgroundC
## The [RoomC]'s background image.
##
## This sprite emit signals for clicks to be handled by the InputManager, holds the background image,
## and resizes and recolour the room's [Player]'s sprite based on his position relative to the size/light
## map images.

@export var size_map: Texture2D ## The image map for scaling the room's [Player] sprite.
@export var light_map: Texture2D ## The image map for iluminating/obscuring the room's [Player] sprite.

var room: RoomC ## The [RoomC] it belongs to.
var last_mouse_click_pos: Vector2 ## The last position in this image clicked by the player.

signal background_click(background: BackgroundC) ## Emited when the player clicked on this.

func _ready() -> void:
	_init_vars()
	add_to_group("input_receiver")

func _unhandled_input(event: InputEvent) -> void:
	if !event.is_action_pressed("click") || Engine.is_editor_hint():
		return
	
	last_mouse_click_pos = get_global_mouse_position()
	background_click.emit(self)

func _init_vars() -> void:
	if !owner is RoomC: push_error("BackgroundC initialized without a RoomC owner.")
		
	room = owner

#region Tooling
func _get_configuration_warnings() -> PackedStringArray:
	var warnings_arr: PackedStringArray = PackedStringArray()
	
	if !owner is RoomC: warnings_arr.append("Owner node isn't a RoomC.")
	
	return warnings_arr
#endregion
