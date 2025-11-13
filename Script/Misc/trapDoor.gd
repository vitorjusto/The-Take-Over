extends Node2D
var buttonActivated = 0
@export var amount = 1

func OnActivate():
	buttonActivated += 1
	
	if buttonActivated < amount:
		return;
	
	var animation : AnimationPlayer = get_node("AnimationPlayer")
	animation.play("Open")
