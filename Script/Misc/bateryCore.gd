extends StaticBody2D
var hp = 10
@onready var ani : AnimationPlayer = get_node("AnimationPlayer2")

func onPlayerProjectileDeteced(body: Node2D) -> void:
	body.call_deferred("queue_free")
	
	ani.play("new_animation")
	hp-= 1
	if hp > 0:
		return
	
	var main : Main = get_tree().root.get_node("/root/Main")
	main.onLevelFinished()
