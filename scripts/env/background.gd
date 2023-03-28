extends ParallaxBackground
class_name Background

# ParallaxBackground é um nó para background em layers, podendo move-las
# individualmente em velocidades distintas para noção de profundidade

# Cada layer do ParallaxBackground é um nó de tipo ParallaxLayer onde é
# necessário conter uma textura para ser renderizada na layer

export(bool) var can_process
export(Array, int) var layer_speed

# Quando can_process for igual a false, deve-se desabilitar a função nativa
# _physics_process

func _ready():
	if can_process == false:
		set_physics_process(false)

# Se _physics_process não estiver desabilitada ela irá mover as layers na
# na velocidade definida no array layer_speed

func _physics_process(delta):
	for index in get_child_count():
		if get_child(index) is ParallaxLayer:
			get_child(index).motion_offset.x -= delta * layer_speed[index]
