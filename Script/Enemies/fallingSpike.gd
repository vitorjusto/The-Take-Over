extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var isFalling = false
var animationStarted = false

func _physics_process(delta: float) -> void:
	
	if not isFalling:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	if is_on_floor():
		queue_free()


func onPlayerDeteced(body: Node2D) -> void:
	if animationStarted:
		return
	
	animationStarted = true
	var animation : AnimationPlayer = get_node("AnimationPlayer")
	animation.play("new_animation")


func onAnimationFinished(anim_name: StringName) -> void:
	isFalling = true
