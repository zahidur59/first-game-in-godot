extends Area2D

func _on_body_entered(body):
	event_manager.emit_signal("worldChannel",["player","dead"])
	
	
