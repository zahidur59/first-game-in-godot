extends Node2D

@onready var canvas = $CanvasModulate
@onready var player_dead_timer = $player_dead
@onready var player = $Player
var the_level:Object
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_manager.connect("worldChannel",_process_WorldChennel)
	var Mob = preload("res://scenes/levels/level_001.tscn")
	the_level = Mob.instantiate()
	add_child(the_level)
	fade_in()

func fade_out(time := 1.0):
	var tween = create_tween()
	tween.tween_property(canvas, "color", Color.BLACK, time)
	tween.finished.connect(_on_fadeout_tween_finished)

func fade_in(time := 1.0 ):
	var tween = create_tween()
	tween.tween_property(canvas, "color", Color.WHITE, time)
	
func _on_fadeout_tween_finished():
	get_tree().reload_current_scene()
	
func _process_WorldChennel(args):
	if(args[0] == "player"):
		if(args[1] == "got_hit"):
			event_manager.emit_signal("worldChannel",["world","shake",5])
		if(args[1] == "dead"):
			event_manager.emit_signal("worldChannel",["world","shake",20])
			the_level.get_tree().paused = true
			player_dead_timer.start()
		if(args[1] == "dead_animation_finished" ):
			fade_out()

func _on_player_dead_timeout() -> void:
	player_dead_timer.stop()
	the_level.get_tree().paused = false
