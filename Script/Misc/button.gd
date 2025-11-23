extends Area2D

var buttonPressed = false
signal onButtonPressed

func OnButtonPressed(body: Node2D) -> void:
	if buttonPressed:
		return
	
	emit_signal("onButtonPressed")
	buttonPressed = true
	
	var ani : AnimatedSprite2D = get_node("AnimatedSprite2D")
	ani.play("Active")
