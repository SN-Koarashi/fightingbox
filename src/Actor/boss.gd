extends "res://src/Actor/Actor.gd"
# Oh , this is a boss code

# boss was hit times
var hit_counter = 0

func _ready() -> void:
	# Starting move when game ready
	vel.x = -speed.x

func _on_Area2D_body_entered(body: PhysicsBody2D):
	# Hitbox
	if body.global_position.y+2.0 > get_node("Area2D").global_position.y:
		return
	hit_counter += 1
	get_node("HitSucceed").play()
	
	# hit from top
	if(abs(vel.x) < 945):
		vel.x = -speed.x * hit_counter * 1.05
	if(hit_counter > 10):
		get_node("CollisionShape2D").disabled = true
		queue_free()

func _physics_process(delta: float) -> void:
	vel.y += gra * delta
	if is_on_wall():
		vel.x *= -1.0
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if(collision.collider.name == "Player"):
				vel.x *= -1.0
	vel.y = move_and_slide(vel, Vector2.UP).y
