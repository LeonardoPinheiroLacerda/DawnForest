extends KinematicBody2D
class_name Player

const MAX_JUMP_COUNT = 2

onready var player_sprite: Sprite = get_node("Texture")

var velocity: Vector2

var jump_count: int = 0

var landing: bool = false

export(int) var speed = 75
export(int) var jump_speed = -175
export(int) var player_gravity = 350

func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	gravity(delta)
	
	# Primeiro argumento é o vetor de movimentação do personagem
	# o segundo argumento é a direção de cima para qual o método vai ser referenciar
	# (importante para o método is_on_floor funcitonar)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Dentro do script atrelado ao nó Texture do player existe esse método para
	# calcular qual animação o personagem deve executar
	player_sprite.animate(velocity)


# Verifica inputs do jogador e atribui os devidos valores ao atributo velocity na horizontal
func horizontal_movement_env() -> void:
	
	# Captura os inputs
	var right_strength: float = Input.get_action_strength("right")
	var left_strength: float = Input.get_action_strength("left")
	
	# Realiza uma operação para definir a qual direção o personagem deve andar
	var input_direction: float = right_strength - left_strength
	
	# Atribui o valor calculado ao atributo X do vetor de movimentação multiplicando
	# pela velocidade configurada
	velocity.x = input_direction * speed

# Verifica inputs do jogador e atribui os devidos valores ao atributo velocity na vertical
func vertical_movement_env() -> void:
	# Se o personagem estiver no chão, a quantidade de pulos disponivel reseta
	if is_on_floor():
		jump_count = 0
	
	# Ao apertar espaço e se ainda houver pulos disponiveis...
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMP_COUNT:
		# Incrementa a quantidade de pulos efetuados desde a ultima vez que o personagem
		# colidiu com o chão
		jump_count += 1
		# Incrementa a velocidade de pulo
		velocity.y = jump_speed


# Impõe gravidade ao personagem
func gravity(delta: float) -> void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
