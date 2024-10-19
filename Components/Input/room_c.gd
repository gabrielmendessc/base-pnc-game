extends Node
class_name RoomC
## The root node of every scene.
##
## This node holds references to the main nodes of scenes(players, inventories and dialogui)
## and connected signals from this nodes to the InputManager.

@export var player: Player ## The scene player.
@export var inventory: InventoryC ## The scene inventory UI.
@export var dialog: DialogUI ## The scene dialog UI.

func _ready() -> void:
	_connect_signals()
	
func _unhandled_input(event: InputEvent) -> void:
	if !OS.is_debug_build():
		return
		
	if event.is_action_pressed("console_toggle"):
		if Console.visible:
			Console.hide()
		else:
			Console.show()
	
## Connect the signals from the main nodes to the InputManager.
func _connect_signals() -> void:
	#All nodes within "input_receiver" group needs to be connected to an InputHandler method.
	for node in get_tree().get_nodes_in_group("input_receiver"):
		if node is BackgroundC:
			node.background_click.connect(InputManager.on_background_click)
			print("Connected BackgroundC '%s' to InputManager" % node.name)
			continue
			
		if node is TriggerC:
			node.trigger_click.connect(InputManager.on_trigger_click)
			print("Connected TriggerC '%s' to InputManager" % node.name)
			continue
		
	#Connects the player's navigation agent signal to the InputManager so it can call callback
	#methods after the player reached its destination.
	if player:
		player.navigation_agent.target_reached.connect(InputManager.on_navigation_finished)
