class_name PlayerProjectile
extends CharacterBody2D

var xSpeed = 800.0
var JumpVelocity = -500.0
var player: Player

const MAX_JUMP_VELOCITY = -900
const MIN_JUMP_VELOCITY = -100
var timer = 0

func _physics_process(delta: float) -> void:
	var jumpVelocityModifier = 0;
	
	if(player.VerifyActionPressed("Up")):
		jumpVelocityModifier -= 5
	elif(player.VerifyActionPressed("Down")):
		jumpVelocityModifier += 5
	
	JumpVelocity = clamp(JumpVelocity + jumpVelocityModifier, MAX_JUMP_VELOCITY, MIN_JUMP_VELOCITY)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y += JumpVelocity
	
	velocity = Vector2(xSpeed, clamp(velocity.y, -1500, 7000))
	
	move_and_slide()
	
	if is_on_wall_only():
		xSpeed *= -1
	
	timer += delta * 60
	
	if timer > 600:
		queue_free()
	


func onScreenExited() -> void:
	call_deferred("queue_free")
