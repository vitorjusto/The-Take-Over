class_name ShooterProjectile
extends CharacterBody2D

var SPEED = 400.0
const JUMP_VELOCITY = -600.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.x = SPEED

	move_and_slide()
	
	if is_on_wall():
		queue_free()

func onScreenExited() -> void:
	call_deferred("queue_free")
