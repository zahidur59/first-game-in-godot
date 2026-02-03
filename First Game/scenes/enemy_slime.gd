extends Area2D


func _on_body_entered(body):
		if body.name == "Player" && body.alive:
			event_manager.emit_signal("worldChannel",["player","got_hit",3, self.global_position])
