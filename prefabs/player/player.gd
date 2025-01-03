extends CharacterBody2D

@export var GRAVITY := 40
# 좌우 스피드
@export var SPEED := 70
@export var JUMP_SPEED := -200


const GRAVITY_ACCELERATION := 1.5
const SPEED_ACCELERATION := 5
const MAX_JUMP_SPEED := -350


func air_jump():
	if not PlayerManager.can_air_jump(): return

	var current_air_count = max(PlayerManager.air_count - 1, 0)
	PlayerManager.on_air_count_change.emit(current_air_count)

	velocity.y = JUMP_SPEED
	if velocity.y < MAX_JUMP_SPEED:
		velocity.y = MAX_JUMP_SPEED


func _physics_process(_delta):
	var x_direction = Input.get_axis("ui_left", "ui_right")
	velocity.y = move_toward(velocity.y, GRAVITY, GRAVITY_ACCELERATION)
	
	if x_direction:
		velocity.x = move_toward(velocity.x, x_direction * SPEED, SPEED_ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_ACCELERATION)

	if Input.is_action_just_pressed("ui_accept"):
		air_jump()
	
	move_and_slide()
