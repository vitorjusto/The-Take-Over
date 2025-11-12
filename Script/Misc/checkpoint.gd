extends Node2D

func onPlayerDeteced(body: Node2D) -> void:
	var player : Player = body
	player.checkpointPosition = position 
