class_name BossConveyorBelt
extends Node2D

enum ESTATE {STOPED, LEFT, RIGHT}
var currentState = ESTATE.STOPED
@onready var panel : Panel = get_node("Panel")
@onready var body : StaticBody2D = get_node("StaticBody2D")

func ChangeState():
	if currentState == ESTATE.LEFT:
		currentState = ESTATE.RIGHT
		panel.modulate = Color.RED
		body.constant_linear_velocity.x = 300
	else:
		currentState = ESTATE.LEFT
		panel.modulate = Color.BLUE
		body.constant_linear_velocity.x = -300
