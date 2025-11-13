class_name Player
extends CharacterBody2D

enum Direction {LEFT, RIGHT, UP, DOWN}

const SPEED = 500.0
const RUNNING_SPEED = 1200.0
const JUMP_VELOCITY = -800.0
var facingDirection: Direction = Direction.RIGHT
var blockedControls = []
var checkpointPosition: Vector2
var allowMove: bool = true

@export var LevelManager: Node2D

@onready var projectile: PackedScene = load("res://Scenes/Player/PlayerProjectile.tscn")
@onready var animation: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var aniAntenna: AnimatedSprite2D = get_node("BodyAnimations/AniAntenna")
@onready var aniEye: AnimatedSprite2D = get_node("BodyAnimations/AniEye")

@onready var camera: Camera2D = get_node("Camera2D")

@onready var bodyAnimations: Node2D = get_node("BodyAnimations")
var isDebugMode : bool = false

func _physics_process(delta: float) -> void:
	##TODO: RemoveDebugMode on release
	if HandleDebugMode():
		return
	
	if not allowMove:
		return
	
	HandleJump(delta)
	HandleMoviment()
	HandleShoot()
	
	move_and_slide()

func HandleDebugMode() -> bool:
	if Input.is_action_just_pressed("DebugMode"):
		isDebugMode = not isDebugMode
	
	if not isDebugMode:
		return false
	
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	position += direction * (10 if not Input.is_action_pressed("Run") else 40)
	return true
	
func HandleJump(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if VerifyActionJustPressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func HandleMoviment() -> void:
	var direction := 0
	
	if VerifyActionPressed("Right"):
		facingDirection = Direction.RIGHT
		if is_on_floor():
			animation.play("Walk")
			aniAntenna.play("Walk")
		
		animation.scale = abs(animation.scale)
		bodyAnimations.scale = abs(bodyAnimations.scale)
		direction = 1
	elif VerifyActionPressed("Left"):
		facingDirection = Direction.LEFT
		
		if is_on_floor():
			animation.play("Walk")
			aniAntenna.play("Walk")
		
		animation.scale = abs(animation.scale) * Vector2(-1, 1)
		bodyAnimations.scale = abs(bodyAnimations.scale) * Vector2(-1, 1)
		direction = -1
		
	if not (VerifyActionPressed("Left") or VerifyActionPressed("Right")) and is_on_floor():
		animation.play("Idle")
		aniAntenna.play("Idle")
	elif velocity.y > 0:
		animation.play("Falling")
	elif velocity.y < 0:
		animation.play("Jump")
		
	if VerifyActionPressed("Up"):
		aniEye.play("Up")
	elif VerifyActionPressed("Down"):
		aniEye.play("Down")
	else:
		aniEye.play("Idle")
	
	
	if animation.frame == 2 or animation.frame == 6:
		bodyAnimations.position = Vector2(0, -6)
	elif animation.frame % 2 == 1:
		bodyAnimations.position = Vector2(0, -3)
	else:
		bodyAnimations.position = Vector2(0, 0)
	
	velocity.x = move_toward(velocity.x, direction * (RUNNING_SPEED if VerifyActionPressed("Run") else SPEED), 40)

func HandleShoot() -> void:
	if not VerifyActionJustPressed("Shoot"):
		return
	
	var proj: PlayerProjectile = projectile.instantiate();
	proj.player = self
	
	if VerifyActionPressed("Run"):
		proj.xSpeed += 800
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
signal onChangeLevel(levelName : String, id : int)

func onEnemyDeteced(body: Node2D) -> void:
	emit_signal("onDefeat")
