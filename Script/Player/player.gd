extends CharacterBody2D

enum Direction {LEFT, RIGHT, UP, DOWN}

const SPEED = 300.0
const RUNNING_SPEED = 900.0
const JUMP_VELOCITY = -800.0
var facingDirection: Direction = Direction.RIGHT

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

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func HandleMoviment() -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	if direction.x > 0:
		facingDirection = Direction.RIGHT
	elif direction.x < 0:
		facingDirection = Direction.LEFT
		
	velocity.x = move_toward(velocity.x, direction.x * (RUNNING_SPEED if Input.is_action_pressed("Run") else SPEED), 40)

func HandleShoot() -> void:
	if not Input.is_action_just_pressed("Shoot"):
		return
	
	var proj: PlayerProjectile = projectile.instantiate();
	
	if facingDirection == Direction.LEFT:
		proj.xSpeed *= -1
	if Input.is_action_pressed("Up"):
		proj.JumpVelocity = proj.MAX_JUMP_VELOCITY
		proj.velocity = Vector2(0, proj.JumpVelocity)
	
	elif Input.is_action_pressed("Down"):
		proj.JumpVelocity = proj.MIN_JUMP_VELOCITY
	
	proj.position = position
	
	LevelManager.add_child(proj)
	
func OnEnemyDetected(body: Node2D) -> void:
	print("doeo")
