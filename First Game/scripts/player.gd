extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var control_on = true


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	event_manager.connect("worldChannel",_process_WorldChannel)
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished():
	var anim_name = $AnimatedSprite2D.animation 
	if(anim_name == "dead_1" || anim_name == "dead_2"):
		print("You are dead")
		event_manager.emit_signal("worldChannel",["player","dead_animation_finished"])	
	
func _process_WorldChannel(args):
	if(args[0] == "player" and args[1] == "dead"):
		control_on = false;
		velocity.y = 0;
		velocity.x = 0;
		
		if is_on_floor():
			animated_sprite.play("dead_1")
		else:
			animated_sprite.play("dead_2")
			#get_node("CollisionShape2D").queue_free()
		
	if(args[0] == "player" and args[1] == "got_hit"):
		var tween = create_tween()
		var canvas = animated_sprite
		canvas.modulate = Color.RED
		#tween.tween_property(canvas, "modulate", Color.RED, 0.1)
		tween.tween_property(canvas, "modulate", Color.WHITE, 0.1)
		#animated_sprite.modulate = Color(1, 0, 0) # RGBA
		print("Its hurts!!!!!!!!!!!!!!!!! ")


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if(control_on):
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction: -1, 0, 1
		var direction = Input.get_axis("move_left", "move_right")
		
		# Flip the Sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Play animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
		
		# Apply movement
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
