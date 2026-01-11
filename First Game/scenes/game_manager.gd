extends Node

# Called when the node enters the scene tree for the first time.
@onready var timer = $Timer

func _ready() -> void:
	print("GameManager loaded")
	event_manager.connect("worldChannel",_process_WorldChannel)
	event_manager.connect("defaultChannel",_process_WorldChannel)

func _process_WorldChannel(args):

	if(args[0] == "player" && args[1] == "dead"):
		Engine.time_scale = 0.3
		timer.start()

func _on_timer_timeout():
	print("ON Timer end called")
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
