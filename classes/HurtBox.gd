class_name HurtBox
extends Area2D


func _init():
	collision_layer = 0
	collision_mask = 2  # detect hitbox collisions

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hit: HitBox):
	if hit == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hit.damage)
	
	if hit.has_method("hit_confirmed"):
		hit.hit_confirmed()
