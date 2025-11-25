class_name ParticleManager
extends Node2D

@onready var particule : PackedScene = load("res://Scenes/Particles/FallingParticles.tscn")

func CreateSplashParticles(quantity: int, pos: Vector2, color: Color, minVel: Vector2, maxVel: Vector2, s: Vector2):
	for i in range(quantity):
		var instance : FallingParticles = particule.instantiate()
		instance.position = pos
		instance.modulate = color
		instance.vel = Vector2(randf_range(minVel.x, maxVel.x), randf_range(minVel.y, maxVel.y))
		instance.scale = s
		
		add_child(instance)
