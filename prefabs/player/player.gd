extends CharacterBody2D
class_name Player

@export var gravity := 10
# 좌우 스피드
@export var SPEED := 70
@export var JUMP_SPEED: float = -120
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var gravity_acceleration := 1.2
const SPEED_ACCELERATION := 5
const MAX_JUMP_SPEED := -250

func _ready():
	GameManager.game_state_change.connect(_on_game_state_change)
	PlayerManager.player_state_change.connect(_on_change_state)
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	animation_player.connect("animation_finished", _on_animation_end)

func _on_change_state(state: PlayerManager.State) -> void:
	match state:
		PlayerManager.State.IDLE:
			animation_player.play("idle")
		PlayerManager.State.JUMP:
			animation_player.play("jump")
		PlayerManager.State.HURT:
			animation_player.play("hurt")
		PlayerManager.State.DEAD:
			animation_player.play("dead")
			gravity = 100
			gravity_acceleration = 3.0

func _on_game_state_change(new_state: GameManager.GameState):
	match new_state:
		GameManager.GameState.PLAYING:
			velocity.y = JUMP_SPEED
			if velocity.y < MAX_JUMP_SPEED:
				velocity.y = MAX_JUMP_SPEED
			gravity = 40
		GameManager.GameState.READY:
			gravity = 10
		GameManager.GameState.END:
			velocity.y = 0
			gravity = 0

func air_jump():
	if not PlayerManager.can_air_jump(): return
	PlayerManager.player_state_change.emit(PlayerManager.State.JUMP)

	var current_air_count = max(PlayerManager.air_count - 1, 0)
	PlayerManager.air_count_change.emit(current_air_count)

	velocity.y = velocity.y + JUMP_SPEED if velocity.y < 0 else JUMP_SPEED
	if velocity.y < MAX_JUMP_SPEED:
		velocity.y = MAX_JUMP_SPEED


func _physics_process(_delta):
	var x_direction = Input.get_axis("ui_left", "ui_right")
	velocity.y = move_toward(velocity.y, gravity, gravity_acceleration)
	
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


func _on_screen_exited() -> void:
	GameManager.game_state_change.emit(GameManager.GameState.END)

func _on_animation_end(anim_name) -> void:
	if anim_name == "jump":
		PlayerManager.player_state_change.emit(PlayerManager.State.IDLE)
	if anim_name == "hurt":
		if PlayerManager.air_count == 0:
			PlayerManager.player_state_change.emit(PlayerManager.State.DEAD)
		else:
			PlayerManager.player_state_change.emit(PlayerManager.State.IDLE)