class_name HitBox
extends Area2D

@export var damage := 1


func _init():
	collision_layer = 2  # the hitbox collision layer is 2
	collision_mask = 0  # detect all collisions

func _ready():
	pass

