extends Node2D


func onPlayerDeteced(body: Node2D) -> void:
	var player : Player = body
	player.checkpointPosition = position 
	var ani : AnimatedSprite2D = get_node("AnimatedSprite2D")
	ani.play("Active")
	
	var aniPlayer : AnimationPlayer = get_node("AnimationPlayer")
	aniPlayer.play("active")
