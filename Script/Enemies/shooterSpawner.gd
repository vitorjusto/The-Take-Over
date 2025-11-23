class_name ShooterSpawner
extends Node2D

@onready var shooterScene: PackedScene = load("res://Scenes/Enemies/Shooter.tscn")
@onready var levelManager : LevelManager = get_tree().root.get_node("/root/Main/LevelManager")

func onSpawn():
	var instance : Shooter = shooterScene.instantiate()
	instance.connect("onDefeat", onSpawn)
	instance.position = self.position
	
	levelManager.currentLevel.add_child(instance)
