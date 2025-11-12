class_name BlockSign
extends Node2D

enum EPlayerControl
{
	LEFT,
	RIGHT, 
	UP,
	DOWN,
	RUN,
	JUMP,
	SHOOT
}
var controls_dict ={
	EPlayerControl.LEFT: "Left",
	EPlayerControl.RIGHT: "Right", 
	EPlayerControl.UP: "Up",
	EPlayerControl.DOWN: "Down",
	EPlayerControl.RUN: "Run",
	EPlayerControl.JUMP: "Jump",
	EPlayerControl.SHOOT: "Shoot",
}

@export var BlockControl: EPlayerControl

func _ready() -> void:
	var animation: AnimatedSprite2D = get_node("AnimatedSprite2D")
	animation.play(GetBlockControlString())

func onPlayerEntered(body: Node2D) -> void:
	var player: Player = body
	player.blockedControls.push_back(self)


func OnPlayerExited(body: Node2D) -> void:
	var player: Player = body
	player.blockedControls.erase(self)

func GetBlockControlString() -> String:
	return controls_dict[BlockControl]
