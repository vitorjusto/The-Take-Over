extends Node2D
var buttonActivated = 0

func OnActivate():
	buttonActivated += 1
	
	if buttonActivated < 2:
		return;
	
	var animation : AnimationPlayer = get_node("AnimationPlayer")
	animation.play("Open")
