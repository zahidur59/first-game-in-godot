extends Node2D

@onready var canvas = $CanvasModulate
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var Mob = preload("res://scenes/levels/level_001.tscn")
	var mob_instance = Mob.instantiate()
	add_child(mob_instance)
	fade_in()

func fade_out(time := 1.0):
	var tween = create_tween()
	tween.tween_property(canvas, "color", Color.BLACK, time)
	tween.finished.connect(_on_fadeout_tween_finished)

func fade_in(time := 1.0 ):
	var tween = create_tween()
	tween.tween_property(canvas, "color", Color.WHITE, time)
	
func _on_fadeout_tween_finished():
	event_manager.emit_signal("worldChannel",["world","transition_end"])
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
