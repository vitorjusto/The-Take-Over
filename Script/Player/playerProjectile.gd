class_name PlayerProjectile
extends CharacterBody2D

var xSpeed = 300.0
var JumpVelocity = -500.0
const MAX_JUMP_VELOCITY = -900
const MIN_JUMP_VELOCITY = -100

func _physics_process(delta: float) -> void:
	var jumpVelocityModifier = 0;
	
	if(Input.is_action_pressed("Up")):
		jumpVelocityModifier -= 5
	elif(Input.is_action_pressed("Down")):
		jumpVelocityModifier += 5
	
	JumpVelocity = clamp(JumpVelocity + jumpVelocityModifier, MAX_JUMP_VELOCITY, MIN_JUMP_VELOCITY)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y += JumpVelocity
	
	velocity = Vector2(xSpeed, clamp(velocity.y, -1500, 7000))
	
	if is_on_wall():
		xSpeed *= -1
	
	move_and_slide()
