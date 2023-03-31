extends Sprite
class_name PlayerTexture

onready var animation: AnimationPlayer = get_node("../Animation")

func animate(direction :Vector2) -> void:
	verify_position(direction)
	
	horizontal_behavior(direction)


func verify_position(direction :Vector2) -> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

func horizontal_behavior(direction :Vector2) -> void:
	print(animation)
	if direction.x != 0:
		animation.play("Run")
	else: 
		animation.play("Idle")
	
