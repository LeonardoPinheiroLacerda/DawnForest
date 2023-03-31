extends KinematicBody2D
class_name Player

onready var player_sprite: Sprite = get_node("Texture")

var velocity: Vector2

var jump_count: int = 0
const MAX_JUMP_COUNT = 2

var landing: bool = false

export(int) var speed = 75
export(int) var jump_speed = -175

export(int) var player_gravity = 350

func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	gravity(delta)
	
	velocity = move_and_slide(velocity)
	
	# Dentro do script atrelado ao nó Texture do player existe esse método para
	# calcular qual animação o personagem deve executar
	player_sprite.animate(velocity)


# Verifica inputs do jogador e atribui os devidos valores ao atributo velocity
func horizontal_movement_env() -> void:
	
	# Captura os inputs
	var right_strength: float = Input.get_action_strength("right")
	var left_strength: float = Input.get_action_strength("left")
	
	# Realiza uma operação para definir a qual direção o personagem deve andar
	var input_direction: float = right_strength - left_strength
	
	# Atribui o valor calculado ao atributo X do vetor de movimentação multiplicando
	# pela velocidade configurada
	velocity.x = input_direction * speed

func vertical_movement_env() -> void:
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMP_COUNT:
		jump_count += 1
		velocity.y = jump_speed


func gravity(delta: float) -> void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
