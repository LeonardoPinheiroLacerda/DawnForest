extends Sprite
class_name PlayerTexture

onready var animation: AnimationPlayer = get_node("../Animation")
onready var player: KinematicBody2D = get_parent()

func animate(direction :Vector2) -> void:
	verify_position(direction)
	
	if direction.y != 0:
		vertical_behavior(direction)	
	elif player.landing == true:
		animation.play("Landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)


# Verifica qual posição o personagem está olhando
func verify_position(direction :Vector2) -> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

func horizontal_behavior(direction :Vector2) -> void:
	if direction.x != 0:
		animation.play("Run")
	else: 
		animation.play("Idle")

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("Fall")
	else: 
		animation.play("Jump")

# Sinal emitido após toda animação
func _on_animation_finished(anim_name: String):
	match anim_name:
		"Landing": 
			player.landing = false
			player.set_physics_process(true)
