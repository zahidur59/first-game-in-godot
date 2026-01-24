extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_manager.connect("defaultChannel",process_signal)
	update_coins(stats_manager.coins);
	update_life_level()
func process_signal(args) -> void:
	if(args[0] == "update_hud"):
		if(args[1] == "coins"):
			update_coins(args[2])
		if(args[1] == "player_lives"):
			update_life_level();

func update_coins(value) -> void:
	var tween = create_tween() # Create a new Tween
	tween.tween_method(set_label_coins, int($CoinCount.text), value,0.3)
	$AnimationPlayer.play("pop")
func update_life_level():
	$LifeCount.text = str(stats_manager.lives)

func set_label_coins(value: float):
	$CoinCount.text = str(int(value)) # Convert the float to an integer string for display	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
