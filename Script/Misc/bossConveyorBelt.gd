class_name BossConveyorBelt
extends Node2D

enum ESTATE {STOPED, LEFT, RIGHT}
var currentState = ESTATE.STOPED
@onready var body : StaticBody2D = get_node("StaticBody2D")
@onready var tileRight : TileMap = get_node("TileMap")
@onready var tileLeft : TileMap = get_node("TileMap2")

func ChangeState():
	if currentState == ESTATE.LEFT:
		currentState = ESTATE.RIGHT
		tileRight.visible = true
		tileLeft.visible = false
		body.constant_linear_velocity.x = 300
	else:
		currentState = ESTATE.LEFT
		tileRight.visible = false
		tileLeft.visible = true
		body.constant_linear_velocity.x = -300
