extends Sprite
class_name PlayerTexture

var normal_attack: bool = false
var shield_off: bool = false
var crouching_off: bool = false

var attack_sufix: String = "Right"

onready var animation: AnimationPlayer = get_node("../Animation")
onready var player: KinematicBody2D = get_parent()

func animate(direction :Vector2) -> void:
	verify_position(direction)
	
	if player.attacking or player.defending or player.crouching:
		action_behavior()
	elif direction.y != 0:
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
		attack_sufix = "Right"
	elif direction.x < 0:
		flip_h = true
		attack_sufix = "Left"

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

func action_behavior() -> void: 
	if player.attacking and normal_attack:
		animation.play("Attack" + attack_sufix)
	elif player.defending and shield_off:
		animation.play("Shield")
		shield_off = false
	elif player.crouching and crouching_off:
		animation.play("Crouch")
		crouching_off = false

# Sinal emitido após toda animação
func _on_animation_finished(anim_name: String):
	match anim_name:
		"Landing": 
			player.landing = false
			player.set_physics_process(true)
			
		"AttackRight":
			player.attacking = false
			normal_attack = false
			
			
		"AttackLeft":
			normal_attack = false
			player.attacking = false
