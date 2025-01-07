# PlayerManager
extends Node

signal player_altitude_change(altitude: int)
signal air_count_change(count: int)
signal player_position_change(position: Vector2)
signal player_velocity_change(velocity: Vector2)

const MAX_AIR_COUNT := 3
const AIR_JUMP_COOL_TIME := 5

var air_jump_timer: Timer
var air_count := 3
var position: Vector2
var velocity: Vector2

func init_air_jump_timer():
	air_jump_timer = Timer.new()
	air_jump_timer.one_shot = true
	air_jump_timer.wait_time = AIR_JUMP_COOL_TIME
	air_jump_timer.timeout.connect(restore_air_count.bind(1))
	add_child(air_jump_timer)


func restore_air_count(value):
	air_count_change.emit(min(air_count + value, MAX_AIR_COUNT))


func can_air_jump() -> bool:
	return air_count > 0


func _ready() -> void:
	init_air_jump_timer()
	air_count_change.connect(_on_air_count_change)
	player_position_change.connect(_on_player_position_change)
	player_velocity_change.connect(_on_player_velocity_change)

func _on_air_count_change(count: int) -> void:
	air_count = count
	if air_jump_timer.is_stopped() && count < MAX_AIR_COUNT:
		air_jump_timer.start()

func _on_player_position_change(_position: Vector2) -> void:
	position = _position
	var altitude = round(position.y) / 5 * -1;
	player_altitude_change.emit(altitude)

func _on_player_velocity_change(_velocity: Vector2) -> void:
	velocity = _velocity