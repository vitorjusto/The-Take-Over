class_name armoredPlayerProjectile
extends CharacterBody2D


var speed = Vector2(0, 0)
const JUMP_VELOCITY = -400.0
var wallHitCount = 0


func _physics_process(delta: float) -> void:
	velocity = speed
	
	move_and_slide()
	
	if is_on_wall_only():
		speed.x *= -1
		wallHitCount += 1
		
		if wallHitCount == 3:
			queue_free()
	
	
	if is_on_floor():
		speed.y *= -1
