extends CharacterBody2D

var health = 8

var jumping = false
var ammo = 6

@export var SPEED : float = 40
@export var FALL_STRENGTH : float = 2
@export var GRAVITY : float = 375
@export var JUMP_SPEED : float = -150
@export_range(0, 1.0) var ACCELERATION : float = 0.5
@export_range(0, 1.0) var FRICTION : float = 0.5


@onready var was_on_floor = is_on_floor()

func _ready():
	set_notify_transform(true)
func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED and get_position_delta() != Vector2.ZERO:
		$PlayerCamera.position = Vector2(208,120)-position.posmodv(Vector2(208,120))
		

func _physics_process(delta):
	var direction : float = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION)
	
	var grav = GRAVITY
	if (velocity.y >= 0) or not jumping:
		grav *= FALL_STRENGTH
	
	velocity.y += grav * delta
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	
	if not was_on_floor and is_on_floor():
		pass  # play sound effect
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_SPEED
		jumping = true
		# play sound effect
		
	elif not Input.is_action_pressed("jump") or is_on_floor():
		jumping = false
	
	was_on_floor = is_on_floor()


func _on_reload():
	ammo = 6


func take_damage(amount):
	health -= amount
	# play sound effect
