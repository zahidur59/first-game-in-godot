extends Node

# Called when the node enters the scene tree for the first time.

@onready var player_dead_timer = $player_dead
@onready var the_world = $World


func _ready() -> void:
	print("GameManager loaded")
	event_manager.connect("worldChannel",_process_WorldChannel)

func _process_WorldChannel(args):
	if(args[0] == "player"):
		if(args[1] == "player_hit_kill_zone"):
			stats_manager.remove_life(1)
			kill_player()
		if(args[1] == "got_hit"):
			stats_manager.remove_life(args[2])
			event_manager.emit_signal("worldChannel",["world","shake",5])
			if(!stats_manager.lives):
				kill_player()
		if(args[1] == "dead_animation_finished" ):
			the_world.fade_out()
		event_manager.emit_signal("defaultChannel",["update_hud","player_lives"])	
		
	if(args[0] == "world" && args[1] == "transition_end" ):
		get_tree().reload_current_scene()

func kill_player():
	the_world.get_tree().paused = true
	stats_manager.remove_life()
	event_manager.emit_signal("worldChannel",["player","dead"])
	player_dead_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_game"):
		event_manager.emit_signal("defaultChannel",["update_hud","player_lives"])
		kill_player()


func _on_player_dead_timeout() -> void:
	player_dead_timer.stop()
	the_world.get_tree().paused = false
	#the_world.fade_out();
	
	
