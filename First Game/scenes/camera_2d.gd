extends Camera2D

@export var look_ahead := 80.0
@export var follow_y := false
@export var fall_offset := 40.0
@onready var player := get_parent()

var shake_strength := 5.0
var shake_fade := 30.0

func _ready() -> void:
	print("Camera Initiated")
	event_manager.connect("worldChannel",_process_WorldChannel)

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO

func _process_WorldChannel(args):
	if(args[0]=="world" && args[1]=="shake"):
		shake(args[2])
		
func shake(value):
	print("Camera is shaking :" + str(value))
	shake_strength = value

func _physics_process(_delta):
	# Horizontal look-ahead
	var dir = sign(player.velocity.x)
	position.x = lerp(position.x, dir * look_ahead, 0.1)
	# Vertical control
	if follow_y:
		position.y = lerp(position.y, 0.0, 0.1)
	else:
		if player.velocity.y > 0: # falling
			position.y = lerp(position.y, fall_offset, 0.05)
		else:
			position.y = lerp(position.y, 0.0, 0.15)
