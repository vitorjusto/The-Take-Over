class_name ShooterSpawner
extends Node2D

@onready var shooterScene: PackedScene = load("res://Scenes/Enemies/Shooter.tscn")
@onready var levelManager : LevelManager = get_tree().root.get_node("/root/Main/LevelManager")
var timer = 0 
var respawning = false

func onSpawn():
	var instance : Shooter = shooterScene.instantiate()
	instance.connect("onDefeat", onRespawn)
	instance.position = self.position
	
	levelManager.currentLevel.add_child(instance)
	respawning = false

func _process(delta: float) -> void:
	if not respawning:
		return
	
	timer -= delta * 60
	
	if timer <= 0:
		onSpawn()

func onRespawn():
	timer = 150
	respawning = true
