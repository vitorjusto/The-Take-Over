class_name BossTriAttack
extends CharacterBody2D

var speed = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	velocity = speed * delta
	
	if move_and_slide():
		queue_free()
