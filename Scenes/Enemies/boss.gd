extends Node2D

enum EBOSSSTATE {ENTRERING, MOVING, SETFORBIDENCONTROLL, ATTACKING}
var state = EBOSSSTATE.ENTRERING
var hp = 20

## moving vars
var goingTo = 0
const MIN_POSITON = 320.0
const MAX_POSITION = 1600.0
const SPEED = 200.0

## Attack vars
@onready var leftAnchor : Node2D = get_node("LeftAnchor")
@onready var middleAnchor : Node2D = get_node("MiddleAnchor")
@onready var rightAnchor : Node2D = get_node("RightAnchor")
@onready var levelManager : LevelManager = get_tree().root.get_node("/root/Main/LevelManager")
@onready var main : Main = get_tree().root.get_node("/root/Main")
@onready var animation : AnimationPlayer = get_node("AnimationPlayer2")
@onready var aniBlockControl : AnimatedSprite2D = get_node("AniBlockControl")
@onready var hpBar : Panel = get_node("HpBar")

enum EBOSSATTACK {TRIATTACK, LAZER, SUPERSHOOT, SCRAPS}
var currentAttack = EBOSSATTACK.LAZER

## Controls Vars
@onready var player : Player = get_tree().root.get_node("/root/Main/Player")
@export var blockSign : BlockSign
@export var blockSign2 : BlockSign
var conveyorbeltIsGoingLeft = true 

enum EBlockingControl{UP, DOWN, RUN,JUMP,SHOOT, UPDOWN, SIDEWAYS, FALL}

var controls_dict_str ={
	EBlockingControl.UP: "Up",
	EBlockingControl.DOWN: "Down",
	EBlockingControl.RUN: "Run",
	EBlockingControl.JUMP: "Jump",
	EBlockingControl.SHOOT: "Shoot",
	EBlockingControl.FALL: "Fall",
}
var controls_dict ={
	EBlockingControl.UP: BlockSign.EPlayerControl.UP,
	EBlockingControl.DOWN: BlockSign.EPlayerControl.DOWN,
	EBlockingControl.RUN: BlockSign.EPlayerControl.RUN,
	EBlockingControl.JUMP: BlockSign.EPlayerControl.JUMP,
	EBlockingControl.SHOOT: BlockSign.EPlayerControl.SHOOT,
	EBlockingControl.FALL: BlockSign.EPlayerControl.FALL
	
}

var currentForbidenControl = EBlockingControl.UP
var availableControls = [EBlockingControl.UP,
EBlockingControl.DOWN,
EBlockingControl.RUN,
EBlockingControl.JUMP]

### Attack tri-projectile
@onready var triAttackScene : PackedScene = load("res://Scenes/Enemies/EnemiesProjectiles/BossTriAttack.tscn")
var triAttackTimer = 0
const TRI_ATTACK_MAX_TIMER = 70
var triAttackCount = 0

### Attack Lazers
@onready var bossLazer: BossLazer = get_node("BossLazer")
@onready var bossLazer2: BossLazer = get_node("BossLazer2")
var lazerTimer = 0

func _process(delta: float) -> void:
	if state == EBOSSSTATE.ENTRERING:
		EnteringStage(delta)
	elif state == EBOSSSTATE.MOVING:
		Move(delta)
	elif state == EBOSSSTATE.SETFORBIDENCONTROLL:
		SetForbidenControl()
	elif state == EBOSSSTATE.ATTACKING:
		Attack(delta)
	

func EnteringStage(delta: float) -> void:
	position.y += 500 * delta
	
	if position.y >= 288.0:
		position.y = 288.0
		SetMovingState()

func Move(delta: float) -> void:
	var diference = goingTo - position.x
	
	if(abs(diference) <= 100):
		state = EBOSSSTATE.SETFORBIDENCONTROLL
		return
	
	if diference > 0:
		position.x += SPEED * delta
	else:
		position.x -= SPEED * delta
	
func Attack(delta: float) -> void:
	if currentAttack == EBOSSATTACK.TRIATTACK:
		TriAttack(delta)
	elif currentAttack == EBOSSATTACK.SUPERSHOOT:
		SuperShooter(delta)
	elif currentAttack == EBOSSATTACK.LAZER:
		Lazer(delta)
	elif currentAttack == EBOSSATTACK.SCRAPS:
		Scraps(delta)

func SetMovingState() -> void:
	state = EBOSSSTATE.MOVING
	var newDestiny = randi_range(1, 5) * 320
	
	if goingTo == newDestiny:
		newDestiny += 320 if newDestiny < 1600 else -1280
	
	goingTo = newDestiny

func Scraps(delta: float) -> void:
	triAttackTimer += delta * 60
	if triAttackTimer <= 70:
		return
	
	emit_signal("onSpawnScrap")
	triAttackTimer = 0
	SetMovingState()

func Lazer(delta: float) -> void:
	lazerTimer += delta * 60
	
	if lazerTimer >= 10 and not bossLazer.active:
		bossLazer.setActive(true)
		bossLazer2.setActive(true)
	elif lazerTimer >= 100:
		bossLazer.setActive(false)
		bossLazer2.setActive(false)
		lazerTimer = 0
		SetMovingState()

func SuperShooter(delta: float) -> void:
	triAttackTimer += delta * 60
	if triAttackTimer <= 150:
		return
	
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 2), sin(PI/ 2)), middleAnchor.position)
	
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 12), sin(PI/ 12)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos((PI * 2)/ 12), sin((PI * 2)/ 12)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos((PI * 3)/ 12), sin((PI * 3)/ 12)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos((PI * 4)/ 12), sin((PI * 4)/ 12)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos((PI * 5)/ 12), sin((PI * 5)/ 12)), middleAnchor.position)
	
	InstantiateTriAttackProjectile(Vector2(-cos(PI/ 12), sin(PI/ 12)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(-cos((PI * 2)/ 12), sin((PI * 2)/ 12)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(-cos((PI * 3)/ 12), sin((PI * 3)/ 12)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(-cos((PI * 4)/ 12), sin((PI * 4)/ 12)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(-cos((PI * 5)/ 12), sin((PI * 5)/ 12)), middleAnchor.position)
	
	triAttackTimer = 0
	SetMovingState()
	
func TriAttack(delta: float) -> void:
	triAttackTimer += delta * 60
	if triAttackTimer <= TRI_ATTACK_MAX_TIMER:
		return
	
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 2), sin(PI/ 2)), leftAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 2), sin(PI/ 2)), rightAnchor.position)
	
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 3), sin(PI/ 3)), leftAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 3), sin(PI/ 3)), rightAnchor.position)
	
	InstantiateTriAttackProjectile(Vector2(-cos(PI/ 3), sin(PI/ 3)), leftAnchor.position)
	InstantiateTriAttackProjectile(Vector2(-cos(PI/ 3), sin(PI/ 3)), rightAnchor.position)
	
	triAttackTimer -= TRI_ATTACK_MAX_TIMER
	triAttackCount += 1
	if triAttackCount == 3:
		triAttackCount = 0
		SetMovingState()

func SetForbidenControl() -> void:
	
	if hp <= 170:
		emit_signal("changeConveyorBelt")
		conveyorbeltIsGoingLeft = not conveyorbeltIsGoingLeft
	
	var i = randi() % availableControls.size()
	var control: EBlockingControl = availableControls[i]
	
	if currentForbidenControl == control:
		i += 1
		control = availableControls[i if i < availableControls.size() else 0]
	
	if control == EBlockingControl.UPDOWN:
		blockSign.BlockControl =  BlockSign.EPlayerControl.UP
		blockSign2.BlockControl = BlockSign.EPlayerControl.DOWN
		aniBlockControl.play("UpDown")
	elif control == EBlockingControl.SIDEWAYS:
		blockSign.BlockControl =  BlockSign.EPlayerControl.RIGHT if conveyorbeltIsGoingLeft else BlockSign.EPlayerControl.LEFT
		blockSign2.BlockControl = BlockSign.EPlayerControl.NONE
		if blockSign.BlockControl == BlockSign.EPlayerControl.RIGHT:
			aniBlockControl.play("Right")
		else:
			aniBlockControl.play("Left")
	else:
		blockSign.BlockControl = controls_dict[control]
		blockSign2.BlockControl = BlockSign.EPlayerControl.NONE
		aniBlockControl.play(controls_dict_str[control])
	
	currentForbidenControl = control
	
	state = EBOSSSTATE.ATTACKING
	var numberCurrentAttack = randi_range(0, 100)
	
	if numberCurrentAttack <= 20:
		currentAttack = EBOSSATTACK.TRIATTACK
	elif numberCurrentAttack <= 40:
		currentAttack = EBOSSATTACK.LAZER
	elif numberCurrentAttack <= 60 and hp <= 170:
		currentAttack = EBOSSATTACK.SCRAPS
	else:
		currentAttack = EBOSSATTACK.SUPERSHOOT

func InstantiateTriAttackProjectile(angule: Vector2, pos: Vector2):
	var p : BossTriAttack = triAttackScene.instantiate()
	p.speed = angule * 20000
	p.position = pos + self.position
	levelManager.currentLevel.add_child(p)

func onDamage(body: Node2D) -> void:
	body.call_deferred("queue_free")
	hp -= 1
	get_node("BossHitEffect").visible = true
	animation.play("new_animation")
	hpBar.size = Vector2((318 * hp)/ 200, 15)
	if hp == 130:
		emit_signal("onHalfHp")
	if hp == 90:
		availableControls.append(EBlockingControl.FALL)
	if hp == 40:
		availableControls.append(EBlockingControl.SIDEWAYS)
	if hp == 0:
		main.onLevelFinished()

signal changeConveyorBelt
signal onHalfHp
signal onSpawnScrap
