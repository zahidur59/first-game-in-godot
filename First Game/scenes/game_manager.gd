extends Node

# Called when the node enters the scene tree for the first time.
@onready var the_world = $World


func _ready() -> void:
	print("GameManager loaded")
	event_manager.connect("worldChannel",_process_WorldChannel)

func _process_WorldChannel(args):
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_game"):
		event_manager.emit_signal("worldChannel",["player","reset_game_pressed"])

	
