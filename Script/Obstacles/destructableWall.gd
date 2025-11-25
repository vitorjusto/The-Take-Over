extends StaticBody2D

@onready var ani : AnimationPlayer = get_node("AnimationPlayer")
@onready var manager : ParticleManager = get_tree().root.get_node("/root/Main/ParticleManager")

var hp = 10

func OnBodyDetected(body: Node2D) -> void:
	body.call_deferred("queue_free")
	ani.play("animation")
	hp-= 1
	manager.CreateSplashParticles(3, position, Color.from_rgba8(153, 92, 92, 255), Vector2(-5, -5), Vector2(-7, -7), Vector2(3, 3))
	manager.CreateSplashParticles(3, position, Color.from_rgba8(153, 92, 92, 255), Vector2(5, -5), Vector2(7, -7), Vector2(3, 3))
	if hp == 0:
		manager.CreateSplashParticles(3, position, Color.from_rgba8(153, 92, 92, 255), Vector2(-5, -5), Vector2(-7, -7), Vector2(3, 3))
		manager.CreateSplashParticles(3, position, Color.from_rgba8(153, 92, 92, 255), Vector2(5, -5), Vector2(7, -7), Vector2(3, 3))
		call_deferred("queue_free")
