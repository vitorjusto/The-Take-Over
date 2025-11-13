class_name WarpZone
extends Area2D

@export var levelName : String
@export var id : int


func OnPlayerDeteced(body: Node2D) -> void:
	var player : Player = body
	player.emit_signal("onChangeLevel", levelName, id)
