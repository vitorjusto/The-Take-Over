class_name Player
extends CharacterBody2D

enum Direction {LEFT, RIGHT, UP, DOWN}

const SPEED = 500.0
const RUNNING_SPEED = 1200.0
const JUMP_VELOCITY = -800.0
var facingDirection: Direction = Direction.RIGHT
var blockedControls = []
var checkpointPosition: Vector2

@export var LevelManager: Node2D

@onready var projectile: PackedScene = load("res://Scenes/Player/PlayerProjectile.tscn")

func _physics_process(delta: float) -> void:
	
	HandleJump(delta)
	HandleMoviment()
	HandleShoot()
	
	move_and_slide()


func HandleJump(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if VerifyActionJustPressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func HandleMoviment() -> void:
	var direction := Input.get_vector(VerifyMovimentAction("Left"), VerifyMovimentAction("Right"), VerifyMovimentAction("Up"), VerifyMovimentAction("Down"))
	
	if direction.x > 0:
		facingDirection = Direction.RIGHT
	elif direction.x < 0:
		facingDirection = Direction.LEFT
		
	velocity.x = move_toward(velocity.x, direction.x * (RUNNING_SPEED if VerifyActionPressed("Run") else SPEED), 40)

func HandleShoot() -> void:
	if not VerifyActionJustPressed("Shoot"):
		return
	
	var proj: PlayerProjectile = projectile.instantiate();
	proj.player = self
	
	if VerifyActionPressed("Run"):
		proj.xSpeed += 200
	if facingDirection == Direction.LEFT:
		proj.xSpeed *= -1
	if VerifyActionPressed("Up"):
		proj.JumpVelocity = proj.MAX_JUMP_VELOCITY
		proj.velocity = Vector2(0, proj.JumpVelocity)
	
	elif VerifyActionPressed("Down"):
		proj.JumpVelocity = proj.MIN_JUMP_VELOCITY
	
		
	proj.position = position
	
	LevelManager.add_child(proj)

func VerifyActionPressed(action: String) -> bool:
	if blockedControls.any(func(x): return x.GetBlockControlString() == action):
		return false
		
	return Input.is_action_pressed(action)
	
func VerifyActionJustPressed(action: String) -> bool:
	if blockedControls.any(func(x): return x.GetBlockControlString() == action):
		return false
		
	return Input.is_action_just_pressed(action)

func VerifyMovimentAction(action: String) -> String:	
	if blockedControls.any(func(x): return x.GetBlockControlString() == action):
		return "None"
		
	return action

signal onDefeat

func onEnemyDeteced(body: Node2D) -> void:
	emit_signal("onDefeat")
