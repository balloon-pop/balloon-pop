# PlayerManager
extends Node

enum State {IDLE, JUMP, HURT, DEAD}

signal player_altitude_change(altitude: int)
signal air_count_change(count: int)
signal player_position_change(position: Vector2)
signal player_velocity_change(velocity: Vector2)
signal player_state_change(state: State)

const MAX_AIR_COUNT := 5
const AIR_JUMP_COOL_TIME := 10

var air_jump_timer: Timer
var air_count := MAX_AIR_COUNT
var position: Vector2
var velocity: Vector2
var altitude: int
var highest_altitude: int
var player_state = State.IDLE

func init():
	air_count = MAX_AIR_COUNT
	altitude = 0
	highest_altitude = 0
	player_state = State.IDLE
	init_air_jump_timer()


func init_air_jump_timer():
	air_jump_timer = Timer.new()
	air_jump_timer.one_shot = true
	air_jump_timer.wait_time = AIR_JUMP_COOL_TIME
	air_jump_timer.timeout.connect(restore_air_count.bind(1))
	add_child(air_jump_timer)


func restore_air_count(value: int):
	if air_count + value >= MAX_AIR_COUNT:
		air_count_change.emit(MAX_AIR_COUNT)
		air_jump_timer.stop()
		return
	
	air_count_change.emit(air_count + value)


func can_air_jump() -> bool:
	return air_count > 0 and not player_state == State.DEAD

func _ready() -> void:
	init()
	air_count_change.connect(_on_air_count_change)
	player_position_change.connect(_on_player_position_change)
	player_velocity_change.connect(_on_player_velocity_change)
	player_state_change.connect(_on_player_state_change)

func _on_air_count_change(count: int) -> void:
	air_count = count
	if air_jump_timer.is_stopped() && count < MAX_AIR_COUNT:
		air_jump_timer.start()
	if count == 0:
		air_jump_timer.stop()
		air_jump_timer.start()

		# FIXME: DEAD 상태 변경 테스트 하기 위해 임시로 넣은 것임
		player_state_change.emit(State.DEAD)

func _on_player_position_change(_position: Vector2) -> void:
	if velocity.y > 0: return

	position = _position
	altitude = max(altitude, round(position.y) / 5 * -1)
	highest_altitude = max(ScoreManager.highest_altitude, altitude)

	if altitude > ScoreManager.highest_altitude:
		ScoreManager.highest_altitude = altitude
		ScoreManager.save_high_score()

	player_altitude_change.emit(altitude)

func _on_player_velocity_change(_velocity: Vector2) -> void:
	velocity = _velocity

func _on_player_state_change(state: State) -> void:
	player_state = state