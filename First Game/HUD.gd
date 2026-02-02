extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_manager.connect("defaultChannel",process_signal)
	update_coins(stats_manager.coins);

func process_signal(args) -> void:
	if(args[0] == "update_hud"):
		if(args[1] == "coins"):
			update_coins(args[2])
		if(args[1] == "player_lives"):
			update_level_player_life(args[2]);

func update_coins(value) -> void:
	var tween = create_tween() # Create a new Tween
	tween.tween_method(set_label_coins, int($CoinCount.text), value,0.3)
	$AnimationPlayer.play("pop")
func update_level_player_life(lives):
	$LifeCount.text = str(lives)

func set_label_coins(value: float):
	$CoinCount.text = str(int(value)) # Convert the float to an integer string for display	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
