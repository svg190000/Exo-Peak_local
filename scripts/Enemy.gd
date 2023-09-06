extends CharacterBody2D

@export var SPEED : float = 10
@export var GRAVITY : float = 375
@export_range(0, 1.0) var ACCELERATION : float = 0.5
@export_range(0, 1.0) var FRICTION : float = 0.5

var health = 4

var death_sfx := preload("res://audio/sfx/bones.wav")

var direction := 0.0

var following_player := false
var player: Node2D = null

func _physics_process(delta):
	
	
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * SPEED, ACCELERATION)
		$Flippable/Sprite.play("walking", abs(velocity.x)/3.0)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION)
	
	var grav = GRAVITY
	velocity.y += grav * delta
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()

func _on_awareness_zone_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == null:
		return
	if body.name == "Player":
		player = body
		following_player = true

func _on_awareness_zone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body == null:
		return
	if body.name == "Player":
		following_player = false
		player = null
		direction = 0


func _process(_delta):
	if following_player:
		if player.position.x < position.x - 12:
			$Flippable.scale.x = -1
			direction = -1
		elif player.position.x > position.x + 12:
			$Flippable.scale.x = 1
			direction = 1
		else:
			direction = 0

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	add_sibling(SoundEffect.new(death_sfx))
	queue_free()
