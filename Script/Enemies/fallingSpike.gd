extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var isFalling = false
var animationStarted = false
@onready var manager : ParticleManager = get_tree().root.get_node("/root/Main/ParticleManager")

func _physics_process(delta: float) -> void:
	
	if not isFalling:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	if is_on_floor():
		manager.CreateSplashParticles(2, position + Vector2(-3, -3), position + Vector2(3, 3), Color.from_rgba8(80, 80, 115, 255), Vector2(-10, -10), Vector2(-5, -5), Vector2(3, 3))
		manager.CreateSplashParticles(2, position + Vector2(-3, -3), position + Vector2(3, 3), Color.from_rgba8(80, 80, 115, 255), Vector2(5, -10), Vector2(10, -5), Vector2(3, 3))
		queue_free()


func onPlayerDeteced(body: Node2D) -> void:
	if animationStarted:
		return
	
	animationStarted = true
	var animation : AnimationPlayer = get_node("AnimationPlayer")
	animation.play("new_animation")


func onAnimationFinished(anim_name: StringName) -> void:
	isFalling = true
