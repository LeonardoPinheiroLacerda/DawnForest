extends KinematicBody2D
class_name Player

onready var player_sprite: Sprite = get_node("Texture")

var velocity: Vector2

export(int) var speed = 75

func _physics_process(delta: float):
	horizontal_movement_env()
	velocity = move_and_slide(velocity)


func horizontal_movement_env() -> void:
	var right_strength: float = Input.get_action_strength("right")
	var left_strength: float = Input.get_action_strength("left")
	
	var input_direction: float = right_strength - left_strength
	
	velocity.x = input_direction * speed


