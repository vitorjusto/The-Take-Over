class_name Main
extends Node2D

enum ScreenTransitionState {NONE, STARTED, LOADING, ENDING}
var state = ScreenTransitionState.NONE
var level = 1

@export var levelPath = ""
@export var levelId = 0
@export var levelManager: LevelManager
@export var player: Player

@onready var screenTransitionPanel: Panel = get_node("CanvasLayer/Panel")

func _ready() -> void:
	level = Globals.level
	state = ScreenTransitionState.LOADING
	screenTransitionPanel.position.x =  -264

func _process(delta: float) -> void:
	
	if state == ScreenTransitionState.NONE:
		return
	elif state == ScreenTransitionState.STARTED:
		StartTransition(delta)
	elif state == ScreenTransitionState.LOADING:
		LoadLevel()
		
	elif state == ScreenTransitionState.ENDING:
		EndTransition(delta)

func StartTransition(delta: float) -> void:
	player.allowMove = false
	screenTransitionPanel.position.x += delta * 3000
	
	if screenTransitionPanel.position.x > -264:
		state = ScreenTransitionState.LOADING

func EndTransition(delta: float) -> void:
	player.allowMove = true
	
	screenTransitionPanel.position.x += delta * 3000
	
	if screenTransitionPanel.position.x > 2336.0:
		state = ScreenTransitionState.NONE
	

func LoadLevel() -> void:
	player.velocity = Vector2.ZERO
	player.changeVisibility(true)
	
	if player.hasArmor:
		player.hp = 10
		player.get_node("CanvasLayer/ArmorHp1").visible = true
		player.get_node("CanvasLayer/ArmorHp2").visible = true
		player.get_node("CanvasLayer/ArmorHp3").visible = true
		player.get_node("CanvasLayer/ArmorHp4").visible = true
		player.get_node("CanvasLayer/ArmorHp5").visible = true
		player.get_node("CanvasLayer/ArmorHp6").visible = true
		player.get_node("CanvasLayer/ArmorHp7").visible = true
		player.get_node("CanvasLayer/ArmorHp8").visible = true
		player.get_node("CanvasLayer/ArmorHp9").visible = true
		player.get_node("CanvasLayer/ArmorHp10").visible = true
	
	if levelManager.currentLevel != null:
		levelManager.currentLevel.queue_free()
		levelManager.currentLevel = null
	
	if levelPath == "":
		levelPath = "res://Scenes/Levels/Level%d.tscn" % level
	
	var scene : PackedScene = load(levelPath)
	var instance = scene.instantiate()
	
	levelManager.currentLevel = instance
	if player.checkpointPosition == Vector2.ZERO:
		for spawner : Spawner in levelManager.currentLevel.get_children().filter(func(x): return x is Spawner):
			if spawner.id == levelId:
				player.position = spawner.position
				break
		
	else:
		player.position = player.checkpointPosition
	
	levelManager.add_child(levelManager.currentLevel)
	
	for blocker : cameraBlocker in levelManager.currentLevel.get_children().filter(func(x): return x is cameraBlocker):
		if blocker.direction == blocker.EDIRECTION.TOP:
			player.camera.limit_top = blocker.position.y
		elif blocker.direction == blocker.EDIRECTION.BOTTOM:
			player.camera.limit_bottom = blocker.position.y
		elif blocker.direction == blocker.EDIRECTION.LEFT:
			player.camera.limit_left = blocker.position.x
		elif blocker.direction == blocker.EDIRECTION.RIGHT:
			player.camera.limit_right = blocker.position.x
	
	state = ScreenTransitionState.ENDING

func onPlayerDefeat() -> void:
	if state != ScreenTransitionState.NONE:
		return
	
	state = ScreenTransitionState.STARTED
	screenTransitionPanel.position.x += -5000.0

func OnPlayerChangedLevel(levelName: String, id : int) -> void:
	levelPath = "res://Scenes/Levels/" + levelName + ".tscn"
	state = ScreenTransitionState.STARTED
	screenTransitionPanel.position.x += -5000.0
	player.checkpointPosition = Vector2.ZERO
	levelId = id

func onLevelFinished() -> void:
	var animation : AnimationPlayer = get_node("AnimationPlayer")
	animation.play("finalTransition")

func onTransitionFinished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelClearedScreen.tscn");
