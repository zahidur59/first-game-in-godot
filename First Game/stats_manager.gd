extends Node

var coins: int = 110
var player_health = 100;
var lives = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_manager.connect("defaultChannel",process_signal)
	

func process_signal(args) -> void:
	if(args[0] == "pickups" && args[1] == "coin"):
		coins += args[2];
		event_manager.emit_signal("defaultChannel",["update_hud","coins",coins])

func add_life(life:=1):
	lives += life;

func remove_life(life:=1):
	if(lives <= life):
		event_manager.emit_signal("worldChannel",["player","dead"])
		remove_all_life()
		return
	lives -= life;
		
func remove_all_life():
	lives = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
