extends CharacterBody2D

var hp = 5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
	if position.y > 1055:
		queue_free()


func onPlayerProjectileDeteced(body: Node2D) -> void:
	body.call_deferred("queue_free")
	hp -= 1
	if hp == 0:
		call_deferred("queue_free")
