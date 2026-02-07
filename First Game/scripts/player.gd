extends CharacterBody2D

var original_layer : int

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var control_on = true
var alive= true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

#knockbacks
@export var knockback_strength := 120.0
@export var knockback_up := 60.0
@export var knockback_time := 0.15
var knockback_dir := 0
var knockback_timer := 0.0
var in_knockback := false
@export var invisibility_frame_time := 1
var invincible := false

var lives = 10

func _ready() -> void:
	original_layer = collision_layer
	event_manager.connect("worldChannel",_process_WorldChannel)
	event_manager.emit_signal("defaultChannel",["update_hud","player_lives",lives])
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

func add_life(life:=1):
	lives += life;
	event_manager.emit_signal("defaultChannel",["update_hud","player_lives",lives])

func remove_life(life:=1):
	if(lives <= life):
		remove_all_life()
		return
	lives -= life;
	event_manager.emit_signal("defaultChannel",["update_hud","player_lives",lives])
		
func remove_all_life():
	lives = 0
	alive = false;
	event_manager.emit_signal("worldChannel",["player","dead"])
	event_manager.emit_signal("defaultChannel",["update_hud","player_lives",lives])


func apply_knockback(from_position: Vector2):
	in_knockback = true
	knockback_timer = knockback_time
	knockback_dir = sign(global_position.x - from_position.x)
	velocity.x = knockback_dir * knockback_strength
	velocity.y = -knockback_up

	
func _on_animation_finished():
	var anim_name = $AnimatedSprite2D.animation 
	if(anim_name == "dead_1" || anim_name == "dead_2"):
		event_manager.emit_signal("worldChannel",["player","dead_animation_finished"])	
	
func _process_WorldChannel(args):
	if(args[0] == "player"):
		if(args[1] == "dead"):
			control_on = false;
			alive = false;
			velocity.y = 0;
			velocity.x = 0;
			
			if is_on_floor():
				animated_sprite.play("dead_1")
			else:
				animated_sprite.play("dead_2")
			return
		if(args[1] == "got_hit" && alive):
			if invincible: return
			if(lives > args[2]):
				var tween = create_tween()
				var canvas = animated_sprite
				canvas.modulate = Color.RED
				#tween.tween_property(canvas, "modulate", Color.RED, 0.1)
				tween.tween_property(canvas, "modulate", Color.WHITE, 0.1)
				#animated_sprite.modulate = Color(1, 0, 0) # RGBA
				remove_life(args[2])		
				apply_knockback(args[3])
				start_invincibility()
			else:	
				remove_all_life()
			
		if(args[1] == "player_hit_kill_zone"):
				print("player hit kill zone")
				remove_all_life()
								
		if(args[1] == "reset_game_pressed"):
			remove_all_life()
	
func start_invincibility():
	invincible = true
	collision_layer = 20
	await get_tree().create_timer(invisibility_frame_time).timeout
	collision_layer = original_layer
	invincible = false


func _process(delta):
	if invincible:
		$AnimatedSprite2D.visible = int(Time.get_ticks_msec() / 80) % 2 == 0
	else:
		$AnimatedSprite2D.visible = 1
	
func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if in_knockback:
		knockback_timer -= delta
		if knockback_timer <= 0:
			in_knockback = false
	else:
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
