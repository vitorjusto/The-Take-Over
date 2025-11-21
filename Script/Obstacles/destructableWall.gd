extends StaticBody2D

var hp = 10

func OnBodyDetected(body: Node2D) -> void:
	body.call_deferred("queue_free")
	
	hp-= 1
	if hp == 0:
		call_deferred("queue_free")
