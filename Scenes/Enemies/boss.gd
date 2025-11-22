extends Node2D

enum EBOSSSTATE {ENTRERING, MOVING, SETFORBIDENCONTROLL, ATTACKING}
var state = EBOSSSTATE.ENTRERING
var hp = 100

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

enum EBOSSATTACK {TRIATTACK, LAZER}
var currentAttack = EBOSSATTACK.LAZER

## Controls Vars
@onready var player : Player = get_tree().root.get_node("/root/Main/Player")
@export var blockSign : BlockSign
@export var blockSign2 : BlockSign

enum EBlockingControl{UP, DOWN, RUN,JUMP,SHOOT, UPDOWN, SIDEWAYS}

var controls_dict ={
	EBlockingControl.UP: BlockSign.EPlayerControl.UP,
	EBlockingControl.DOWN: BlockSign.EPlayerControl.DOWN,
	EBlockingControl.RUN: BlockSign.EPlayerControl.RUN,
	EBlockingControl.JUMP: BlockSign.EPlayerControl.JUMP,
	EBlockingControl.SHOOT: BlockSign.EPlayerControl.SHOOT
}

#var availableControls = [EBlockingControl.UP,
#EBlockingControl.DOWN,
#EBlockingControl.RUN,
#EBlockingControl.JUMP]
var availableControls = [EBlockingControl.UPDOWN]

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
	elif currentAttack == EBOSSATTACK.LAZER:
		Lazer(delta)

func SetMovingState() -> void:
	state = EBOSSSTATE.MOVING
	var newDestiny = randi_range(1, 5) * 320
	
	if goingTo == newDestiny:
		newDestiny += 320 if newDestiny < 1600 else -1280
	
	goingTo = newDestiny
	if hp <= 50:
		emit_signal("changeConveyorBelt")

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

func TriAttack(delta: float) -> void:
	triAttackTimer += delta * 60
	if triAttackTimer <= TRI_ATTACK_MAX_TIMER:
		return
	
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 2), sin(PI/ 2)), leftAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 2), sin(PI/ 2)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 2), sin(PI/ 2)), rightAnchor.position)
	
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 3), sin(PI/ 3)), leftAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 3), sin(PI/ 3)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(cos(PI/ 3), sin(PI/ 3)), rightAnchor.position)
	
	InstantiateTriAttackProjectile(Vector2(-cos(PI/ 3), sin(PI/ 3)), leftAnchor.position)
	InstantiateTriAttackProjectile(Vector2(-cos(PI/ 3), sin(PI/ 3)), middleAnchor.position)
	InstantiateTriAttackProjectile(Vector2(-cos(PI/ 3), sin(PI/ 3)), rightAnchor.position)
	
	triAttackTimer -= TRI_ATTACK_MAX_TIMER
	triAttackCount += 1
	if triAttackCount == 5:
		triAttackCount = 0
		SetMovingState()

func SetForbidenControl() -> void:
	var control: EBlockingControl = availableControls[randi() % availableControls.size()]
	
	if control == EBlockingControl.UPDOWN:
		blockSign.BlockControl =  BlockSign.EPlayerControl.UP
		blockSign2.BlockControl = BlockSign.EPlayerControl.DOWN
	else:
		blockSign.BlockControl = controls_dict[control]
		blockSign2.BlockControl = BlockSign.EPlayerControl.NONE
	
	state = EBOSSSTATE.ATTACKING
	var numberCurrentAttack = randi_range(0, 100)
	if numberCurrentAttack <= 60:
		currentAttack = EBOSSATTACK.TRIATTACK
	else:
		currentAttack = EBOSSATTACK.LAZER

func InstantiateTriAttackProjectile(angule: Vector2, pos: Vector2):
	var p : BossTriAttack = triAttackScene.instantiate()
	p.speed = angule * 10000
	p.position = pos + self.position
	levelManager.currentLevel.add_child(p)


func onDamage(body: Node2D) -> void:
	body.call_deferred("queue_free")
	hp -= 1
	if hp == 80:
		availableControls.push(EBlockingControl.UPDOWN)

signal changeConveyorBelt
