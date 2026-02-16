extends Area2D

@onready var animation_player = $AnimationPlayer
@export var value: int = 5

func _ready() -> void:
	$Label.text = "+"+str(value);

func _on_body_entered(body):
	if body.name == "Player":
		$CollisionShape2D.queue_free()
		event_manager.emit_signal("defaultChannel",["pickups","coin",5])
		animation_player.play("pickup")
