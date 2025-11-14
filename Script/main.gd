class_name Main
extends Node2D

enum ScreenTransitionState {NONE, STARTED, LOADING, ENDING}
var state = ScreenTransitionState.NONE
@export var levelPath = "res://Scenes/Levels/Level1.tscn"
@export var levelId = 0
@export var levelManager: LevelManager
@export var player: Player

@onready var screenTransitionPanel: Panel = get_node("CanvasLayer/Panel")

func _ready() -> void:
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
	if levelManager.currentLevel != null:
		levelManager.currentLevel.queue_free()
		levelManager.currentLevel = null
		
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
