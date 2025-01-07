extends CharacterBody2D

@export var gravity := 10
# 좌우 스피드
@export var SPEED := 70
@export var JUMP_SPEED := -200

const GRAVITY_ACCELERATION := 1.5
const SPEED_ACCELERATION := 5
const MAX_JUMP_SPEED := -350


func _ready():
	GameManager.game_state_change.connect(_on_game_state_change)

func _on_game_state_change(new_state: GameManager.GameState):
	match new_state:
		GameManager.GameState.PLAYING:
			velocity.y = JUMP_SPEED
			if velocity.y < MAX_JUMP_SPEED:
				velocity.y = MAX_JUMP_SPEED	
			gravity = 40
		GameManager.GameState.READY:
			gravity = 10

func air_jump():
	if not PlayerManager.can_air_jump(): return

	var current_air_count = max(PlayerManager.air_count - 1, 0)
	PlayerManager.air_count_change.emit(current_air_count)

	velocity.y = JUMP_SPEED
	if velocity.y < MAX_JUMP_SPEED:
		velocity.y = MAX_JUMP_SPEED


func _physics_process(_delta):
	var x_direction = Input.get_axis("ui_left", "ui_right")
	velocity.y = move_toward(velocity.y, gravity, GRAVITY_ACCELERATION)
	
	if GameManager.game_state == GameManager.GameState.PLAYING:
		if x_direction:
			velocity.x = move_toward(velocity.x, x_direction * SPEED, SPEED_ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED_ACCELERATION)

		if Input.is_action_just_pressed("ui_accept"):
			air_jump()

		PlayerManager.player_position_change.emit(position)
		PlayerManager.player_velocity_change.emit(velocity)
	
	move_and_slide()
