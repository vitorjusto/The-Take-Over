extends CharacterBody2D

var hp = 5
@onready var spr : Node2D = get_node("Scrap2")
var a = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	a -= 10
	a = clamp(a, 0, 255)
	spr.modulate = Color.from_rgba8(255, 255, 255, a)
	move_and_slide()
	
	if position.y > 1055:
		queue_free()


func onPlayerProjectileDeteced(body: Node2D) -> void:
	body.call_deferred("queue_free")
	hp -= 1
	a = 200
	if hp == 0:
		call_deferred("queue_free")
