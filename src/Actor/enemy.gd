extends "res://src/Actor/Actor.gd"

func _ready() -> void:
	vel.x = -speed.x
	preload("res://src/global.gd")

func _on_Area2D_body_entered(body: PhysicsBody2D):
	# Hitbox
	# hit from top
	if body.global_position.y > get_node("Area2D").global_position.y:
		return
	StompSound.play()
	
	Globals.eScore += 15
	get_node("CollisionShape2D").disabled = true
	queue_free()

func _physics_process(delta: float) -> void:
	vel.y += gra * delta
	if is_on_wall():
		vel.x *= -1.0
	vel.y = move_and_slide(vel, Vector2.UP).y



