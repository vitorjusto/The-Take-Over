class_name BossLazer
extends CharacterBody2D

var active: bool = false
@onready var sprite: Panel = get_node("Panel")
@onready var collision: CollisionShape2D = get_node("CollisionShape2D")

func setActive(value: bool):
	active = value
	sprite.visible = active
	collision.disabled = not active
