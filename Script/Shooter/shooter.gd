extends CharacterBody2D

var timer = 0
const MAX_TIMER = 120
@onready var player : Player = get_tree().root.get_node("/root/Main/Player")
@onready var levelManager : LevelManager = get_tree().root.get_node("/root/Main/LevelManager")
@onready var projectile : PackedScene = load("res://Scenes/Enemies/EnemiesProjectiles/ShooterProjectile.tscn")

func _physics_process(delta: float) -> void:
	timer += delta * 60
	
	if timer <= MAX_TIMER:
		return
		
	var p : ShooterProjectile = projectile.instantiate()
	
	if player.position.x < position.x:
		p.SPEED *= -1
	
	p.position = position
	levelManager.currentLevel.add_child(p)
	
	timer -= MAX_TIMER


func OnProjectileDeteced(body: Node2D) -> void:
	body.call_deferred("queue_free")
	call_deferred("queue_free")
