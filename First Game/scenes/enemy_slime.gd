extends Area2D


func _on_body_entered(body):
	var knockback_direction = (body.global_position - global_position).normalized()
	event_manager.emit_signal("worldChannel",["player","got_hit",1])
