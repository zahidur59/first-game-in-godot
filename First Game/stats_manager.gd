extends Node

var coins: int = 110

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_manager.connect("defaultChannel",process_signal)
	

func process_signal(args) -> void:
	if(args[0] == "pickups" && args[1] == "coin"):
		coins += args[2];
		event_manager.emit_signal("defaultChannel",["update","coins",coins])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
