extends Actor
onready var tween = get_node("Tween")
# hit from left
var left_hit = false
# hit from right
var right_hit = false
# player health
var health = 3
# resting time (count per 1/60 seconds, maybe? that mean FPS but my screen is too suck)
var AFK_counter = 0

func _physics_process(delta: float) -> void:
	var dir: = get_dir()
	vel = calcu_move_vel(vel,dir,speed)
	vel = move_and_slide(vel, Vector2.UP)

func _process(delta):
	# when player resting
	if vel == Vector2.ZERO:
		AFK_counter += 1
	else:
		AFK_counter = 0
	# Unstock, Restart game
	if Input.get_action_strength("Reflash") and AFK_counter > 150:
		AFK_counter = 0
		get_node("CollisionShape2D").disabled = true
		queue_free()
		get_tree().reload_current_scene()
		
	# Tween will be hackerman so I need to fix it.
	if(position.x > 1850.0):
		tween.interpolate_property(self, "position",
				position, Vector2(position.x-40,position.y), 0.05,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	if(position.x < 73.0):
		tween.interpolate_property(self, "position",
				position, Vector2(position.x+40,position.y), 0.05,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	if(position.y > 1985.0):
		tween.interpolate_property(self, "position",
				position, Vector2(position.x,position.y-40), 0.05,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	
	# Player Knockback
	if(left_hit):
		tween.interpolate_property(self, "position",
				position, Vector2(position.x+100,position.y-25), 0.25,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		get_node("Knockback").play()
		left_hit = false
	if(right_hit):
		tween.interpolate_property(self, "position",
				position, Vector2(position.x-100,position.y-25), 0.25,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		get_node("Knockback").play()
		right_hit = false
	
	# when counter more than 6000, it need to reset to 0 because ...?
	if(AFK_counter > 6000):
		AFK_counter = 0
func _on_Area2D_body_entered(body: PhysicsBody2D):
	# HITBOX, my love!
	if body.global_position.y-2 > get_node("Area2D").global_position.y:
		if abs((body.global_position.y-2) - get_node("Area2D").global_position.y) > 40:
			# if hit entity is boss
			var left_n_right = 0
			if randf()*100000 >= 50000.0:
				left_n_right -=250
			else:
				left_n_right +=250
			tween.interpolate_property(self, "position",
					position, Vector2(position.x+left_n_right,position.y-350), 0.45,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			get_node("HitBoss").play()
		else:
			# if this is a normal entity
			vel = calcu_stomp_vel(vel,500.0)
			get_node("Stomp").play()
	else:
		# hit from left or right?
		if(body.global_position.x < get_node("Area2D").global_position.x):
			left_hit = true
		else:
			right_hit = true
			
		# oh sad, the health minus one
		health -= 1
		
		# when health less than 0, restarting game
		# hide health images?
		if(health <= 0):
			get_node("Camera2D/VBoxContainer/hp1").hide()
			get_node("Knockback").play()
			get_node("CollisionShape2D").disabled = true
			queue_free()
			get_tree().reload_current_scene()
		elif health == 2:
			get_node("Camera2D/VBoxContainer/hp3").hide()
		elif health == 1:
			get_node("Camera2D/VBoxContainer/hp2").hide()
		
# idk
func get_dir() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.get_action_strength("move_top") and is_on_floor() else 1.0
	)
func calcu_move_vel(liner_vel: Vector2,dir: Vector2,speed: Vector2) -> Vector2:
	var new_vel: = liner_vel
	new_vel.x = speed.x * dir.x
	new_vel.y += gra * get_physics_process_delta_time()
	if dir.y == -1.0:
		new_vel.y = speed.y * dir.y
	return new_vel

func calcu_stomp_vel(liner_vel: Vector2, imm: float) -> Vector2:
	var out: = liner_vel
	out.y = -imm
	return out

func calcu_throw_vel(liner_vel: Vector2, imm: float) -> Vector2:
	var out: = liner_vel
	out.y = -imm
	out.angle_to(liner_vel)
	return out
func knockback(nodes: Node2D):
	tween.interpolate_property(nodes, "position",
			Vector2(0, 0), Vector2(100, 50), 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
