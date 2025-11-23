extends Node2D

@onready var scene: PackedScene = load("res://Scenes/Enemies/Scrap.tscn")
@onready var levelManager : LevelManager = get_tree().root.get_node("/root/Main/LevelManager")

func onSpawn():
	var instace : Node2D = scene.instantiate()
	instace.position = position
	levelManager.currentLevel.add_child(instace)
