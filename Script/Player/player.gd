extends CharacterBody2D


const SPEED = 300.0
const RUNNING_SPEED = 900.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 800

func _physics_process(delta: float) -> void:
	
	HandleJump(delta)
	HandleMoviment(delta)
	
	move_and_slide()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.



func HandleJump(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func HandleMoviment(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	
	velocity.x = move_toward(velocity.x, direction.x * (RUNNING_SPEED if Input.is_action_pressed("Run") else SPEED), 40)


func OnEnemyDetected(body: Node2D) -> void:
	print("doeo")
