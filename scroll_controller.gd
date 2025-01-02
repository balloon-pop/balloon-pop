extends CharacterBody2D

@export var GRAVITY := 50
# 좌우 스피드
@export var SPEED := 70
@export var JUMP_SPEED := -250

const GRAVITY_ACCELERATION := 5
const SPEED_ACCELERATION := 5
const MAX_JUMP_SPEED := -450


func _physics_process(_delta):
	var x_direction = Input.get_axis("ui_left", "ui_right")
	velocity.y = move_toward(velocity.y, GRAVITY, GRAVITY_ACCELERATION)
	
	if x_direction:
		velocity.x = move_toward(velocity.x, x_direction * SPEED, SPEED_ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_ACCELERATION)
	

	if Input.is_action_just_pressed("ui_accept"):
		velocity.y += JUMP_SPEED

	if velocity.y < MAX_JUMP_SPEED:
		velocity.y = MAX_JUMP_SPEED
	
	move_and_slide()
