extends CharacterBody2D
class_name Player
## The player.

@export var speed: float = 200.0

@onready var player_animation: AnimatedSprite2D = $PlayerAnimation
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _process(_delta: float) -> void:
	if velocity.x == 0 && velocity.y == 0:
		player_animation.play("idle")
		return
		
	player_animation.play("walk")
	player_animation.flip_h = true if velocity.x > 0 else false
	
func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	var direction: Vector2 = (navigation_agent.get_next_path_position()  - global_position).normalized()
	velocity = direction * speed
	
	move_and_slide()

func move_to(move_pos: Vector2) -> void:
	navigation_agent.target_position = move_pos
