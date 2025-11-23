class_name Shooter
extends CharacterBody2D

var timer = 0
const MAX_TIMER = 120
@onready var player : Player = get_tree().root.get_node("/root/Main/Player")
@onready var levelManager : LevelManager = get_tree().root.get_node("/root/Main/LevelManager")
@onready var projectile : PackedScene = load("res://Scenes/Enemies/EnemiesProjectiles/ShooterProjectile.tscn")
signal onDefeat

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
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
	emit_signal("onDefeat")
	body.call_deferred("queue_free")
	call_deferred("queue_free")
