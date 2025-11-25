extends Node2D

func onPlayerDeteced(body: Node2D) -> void:
	var player : Player = body
	player.allowMove = false
	player.hasArmor = true
	var ani: AnimationPlayer = get_node("AnimationPlayer")
	ani.play("new_animation")


func onAnimationFinished(anim_name: StringName) -> void:
	var main : Main = get_tree().root.get_node("/root/Main")
	
	main.levelPath = "res://Scenes/Levels/Level5_2.tscn"
	main.state = main.ScreenTransitionState.LOADING
