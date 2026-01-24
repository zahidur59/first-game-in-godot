extends Node

signal defaultChannel(args:Array);
signal worldChannel(args:Array);
# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	print("Event manager Autoloaded")
	connect("worldChannel",_process_WorldChennel)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _process_WorldChennel(args):
	if(args[0] == "player" && args[1] == "dead"):
		emit_signal("worldChannel",["world","shake",5])
		
