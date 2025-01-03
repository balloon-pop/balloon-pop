extends CharacterBody2D

@export var GRAVITY := 40
# 좌우 스피드
@export var SPEED := 70
@export var JUMP_SPEED := -200

@onready var dash_timer: Timer = $DashTimer

const GRAVITY_ACCELERATION := 1.5
const SPEED_ACCELERATION := 5
const MAX_JUMP_SPEED := -350


func _ready():
	PlayerManager.on_air_count_change.connect(_on_air_count_change)
	dash_timer.timeout.connect(_on_dash_timer_timeout)




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


func _on_air_count_change(_count: int):
	if dash_timer.is_stopped() && PlayerManager.air_count < PlayerManager.MAX_AIR_COUNT:
		dash_timer.start()


func _on_dash_timer_timeout():
	PlayerManager.restore_air_count(1)