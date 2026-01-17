class_name Player
extends CharacterBody2D

enum Direction {LEFT, RIGHT, UP, DOWN}

const SPEED = 500.0
const RUNNING_SPEED = 1200.0
const JUMP_VELOCITY = -800.0
var facingDirection: Direction = Direction.RIGHT
var blockedControls = []
var bossBlockedControls = []
var checkpointPosition: Vector2
var allowMove: bool = true
var hasArmor: bool = false
var hp = 10
var insideEnemys = []
var cooldown = 0

var iframes = 0
var aniIFrames = 0
@export var levelManager: LevelManager

@onready var projectile: PackedScene = load("res://Scenes/Player/PlayerProjectile.tscn")
@onready var armoredProjectile: PackedScene = load("res://Scenes/Player/ArmoredPlayerProjectile.tscn")
@onready var animation: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var aniAntenna: AnimatedSprite2D = get_node("BodyAnimations/AniAntenna")
@onready var aniEye: AnimatedSprite2D = get_node("BodyAnimations/AniEye")
@onready var collision : CollisionShape2D = get_node("CollisionShape2D")

@onready var camera: Camera2D = get_node("Camera2D")

@onready var bodyAnimations: Node2D = get_node("BodyAnimations")
@onready var manager : ParticleManager = get_tree().root.get_node("/root/Main/ParticleManager")
@onready var audio : AudioStreamPlayer = get_node("AudioStreamPlayer")
@onready var explosionAudio : AudioStreamPlayer = get_node("AudioStreamPlayer2")

var isDebugMode : bool = false

func _physics_process(delta: float) -> void:
	##TODO: RemoveDebugMode on release
	if HandleDebugMode():
		return
	
	collision.disabled = not allowMove
	
	if not allowMove:
		return
	
	HandleJump(delta)
	HandleMoviment()
	if hasArmor:
		HandleArmoredProjectile(delta)
	else:
		HandleShoot()
	AnimateIFrames(delta)
	
	move_and_slide()

func AnimateIFrames(delta: float) -> void:
	if iframes == 0:
		if insideEnemys.is_empty():
			return
		
		takeDamage()
	
	iframes -= delta * 60
	if iframes <= 0:
		visible = true
		iframes = 0
		aniIFrames = 0
		return
	
	aniIFrames -= delta * 60
	if aniIFrames <= 0:
		visible = not visible
		aniIFrames = 5
	
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
	
	if blockedControls.any(func(x): return x.GetBlockControlString() == "Fall"):
		velocity.y = clamp(velocity.y, -999999999999, 0)
	

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

func HandleArmoredProjectile(delta: float) -> void:
	if not VerifyActionPressed("Shoot"):
		return
	
	if VerifyActionJustPressed("Shoot"):
		ShootArmorProjectile()
	else:
		cooldown -= delta * 60
		if cooldown <= 0:
			ShootArmorProjectile()

func ShootArmorProjectile():
	var proj: armoredPlayerProjectile = armoredProjectile.instantiate();
	
	if VerifyActionPressed("Up"):
		proj.speed.y = -800
	elif VerifyActionPressed("Down"):
		proj.speed.y = 800
	
	if facingDirection == Direction.LEFT:
		proj.speed.x = -800
	else:
		proj.speed.x = 800
	
	if VerifyActionPressed("Run"):
		proj.speed *= 1.4
	
	proj.position = position
	levelManager.currentLevel.add_child(proj)
	cooldown = 10

func HandleShoot() -> void:
	if not VerifyActionJustPressed("Shoot"):
		return
	
	audio.play()
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
	
	levelManager.currentLevel.add_child(proj)

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
	insideEnemys.append(body)
	takeDamage()
	
func changeVisibility(v: bool):
	animation.visible = v
	aniAntenna.visible = v
	aniEye.visible = v
	
func takeDamage():
	if not hasArmor:
		changeVisibility(false)
		manager.CreateSplashParticles(3, position, Color.from_rgba8(103, 128, 115, 255), Vector2(-5, -5), Vector2(-7, -7), Vector2(3, 3))
		manager.CreateSplashParticles(3, position, Color.from_rgba8(103, 128, 115, 255), Vector2(5, -5), Vector2(7, -7), Vector2(3, 3))
		emit_signal("onDefeat")
		explosionAudio.play()
		return
	
	if iframes > 0:
		return
	
	hp -= 1
	
	if hp == 0:
		emit_signal("onDefeat")
		explosionAudio.play()
	else:
		var label : Label = get_node("CanvasLayer/Label")
		label.text = "%d" % hp
		velocity.x += 800 if facingDirection == Direction.LEFT else -800
		velocity.y += -500
		iframes = 100
	
func onBodyExited(body: Node2D) -> void:
	insideEnemys.erase(body)
