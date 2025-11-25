class_name FallingParticles
extends Node2D

var vel = Vector2(0, 0)

func _process(delta: float) -> void:
	position += vel  * (delta * 60)
	vel = Vector2(vel.x, vel.y + 1)

func onScreenExited() -> void:
	call_deferred("queue_free")
