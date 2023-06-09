extends KinematicBody2D
class_name Player

const MAX_JUMP_COUNT = 2

onready var player_sprite: Sprite = get_node("Texture")

var velocity: Vector2

var jump_count: int = 0

var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var can_track_input: bool = true

export(int) var speed = 75
export(int) var jump_speed = -175
export(int) var player_gravity = 350

func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	
	actions_env()
	
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
	
	# Se estiver atacando ou com a flag can_track_input o personagem não deve andar
	if not can_track_input or attacking:
		velocity.x = 0
		return
	
	# Atribui o valor calculado ao atributo X do vetor de movimentação multiplicando
	# pela velocidade configurada
	velocity.x = input_direction * speed

# Verifica inputs do jogador e atribui os devidos valores ao atributo velocity na vertical
func vertical_movement_env() -> void:
	# Se o personagem estiver no chão, a quantidade de pulos disponivel reseta
	if is_on_floor():
		jump_count = 0
	
	# Se estiver atacando ou com a flag can_track_input o personagem não deve pular
	var jump_condition: bool = can_track_input and not attacking
	
	# Ao apertar espaço e se ainda houver pulos disponiveis...
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMP_COUNT and jump_condition:
		# Incrementa a quantidade de pulos efetuados desde a ultima vez que o personagem
		# colidiu com o chão
		jump_count += 1
		# Incrementa a velocidade de pulo
		velocity.y = jump_speed

# Verifica inputs de ação (ataque, defender e agachar)
func actions_env() -> void:
	attack()
	crouch()
	defense()

# Função para mapear ataque
func attack() -> void:
	# Só é possivel atacar se não estiver executando nenhuma outra ação
	var attack_condition: bool = not attacking and not crouching and not defending
	
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
		# Se cumprir todos os requesitos será setado algumas boleans que serão utilizadas 
		# no script da sprite
		attacking = true
		player_sprite.normal_attack = true

# Função para mapear agachar
func crouch() -> void:
	
	# Se pressionar o botão de aganhar e não estiver defendendo
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		# Setando valores que serão utilizados no script da sprite
		crouching = true
		can_track_input = false
	# Se não estiver pressionando o botão de agachar e nao estiver defendendo
	# Irá setar valores que cancelam o agachamento
	elif not defending:
		# Setando valores que serão utilizados no script da sprite
		crouching = false
		can_track_input = true
		player_sprite.crouching_off = true

# Função para mapear defesa
func defense() -> void:
	
	# Se pressionar o botão de defesa e não estiver agachado
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		# Setando valores que serão utilizados no script da sprite
		defending = true
		can_track_input = false
	# Se não estiver pressionando o botão de defesa e nao estiver agachado
	# Irá setar valores que cancelam a defesa
	elif not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true
		

# Impõe gravidade ao personagem
func gravity(delta: float) -> void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
