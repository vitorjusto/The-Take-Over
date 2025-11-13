class_name WarpZone
extends Area2D

@export var levelName : String


func OnPlayerDeteced(body: Node2D) -> void:
	var player : Player = body
	player.emit_signal("onChangeLevel", levelName)
