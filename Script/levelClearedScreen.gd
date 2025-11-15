extends Node2D
var transitionStarted = false

func _process(delta: float) -> void:
	if transitionStarted :
		return
	
	if Input.is_anything_pressed():
		var ani : AnimationPlayer = get_node("AnimationPlayer")
		ani.play("transition")
		transitionStarted = true


func onAnimationFinished(anim_name: StringName) -> void:
	Globals.level += 1
	get_tree().change_scene_to_file("res://Scenes/Main.tscn");
