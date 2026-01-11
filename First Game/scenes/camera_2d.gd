extends Camera2D

var shake_strength := 0.0
var shake_fade := 10.0

func _ready() -> void:
	print("Camera Initiated")
	event_manager.connect("worldChannel",shake)

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO

func shake(args):
	if(args[0]=="world" && args[1]=="shake"):
		print("The world is shaking")
		shake_strength = args[2]
