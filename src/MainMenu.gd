extends MarginContainer
signal timer_end

func _ready():
	# Starting game and switch scene
	yield(get_tree().create_timer(1.5), "timeout")
	get_node("StartEffects").play()
	get_tree().change_scene("res://src/Levels.tscn")
