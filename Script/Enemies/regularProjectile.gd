class_name RegularProjectile
extends CharacterBody2D

var SPEED = 30000.0

func _physics_process(delta: float) -> void:
	
	velocity.x = SPEED * delta
	
	move_and_slide()
	
	if is_on_wall():
		queue_free()

func onScreenExited() -> void:
	call_deferred("queue_free")
