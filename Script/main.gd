extends Node2D

enum ScreenTransitionState {NONE, STARTED, LOADING, ENDING}
var state = ScreenTransitionState.NONE
@export var levelPath = "res://Scenes/Levels/Level1.tscn"
@export var levelManager: LevelManager
@export var player: Node2D

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
	screenTransitionPanel.position.x += delta * 3000
	
	if screenTransitionPanel.position.x > -264:
		state = ScreenTransitionState.LOADING

func EndTransition(delta: float) -> void:
	screenTransitionPanel.position.x += delta * 3000
	
	if screenTransitionPanel.position.x > 2336.0:
		state = ScreenTransitionState.NONE
	

func LoadLevel() -> void:
	if levelManager.currentLevel != null:
		levelManager.currentLevel.queue_free()
		levelManager.currentLevel = null
		
	var scene : PackedScene = load(levelPath)
	var instance = scene.instantiate()
	
	levelManager.currentLevel = instance
	var spawner = instance.get_node("Spawner")
	player.position = spawner.position
	
	levelManager.add_child(levelManager.currentLevel)
	
	state = ScreenTransitionState.ENDING
