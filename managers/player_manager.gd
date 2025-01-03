# PlayerManager
extends Node

signal on_air_count_change(count: int)
signal player_altitude_change(altitude: int)

const MAX_AIR_COUNT := 3
const AIR_JUMP_COOL_TIME := 5

var dash_timer: Timer
var air_count := 3


func init_dash_timer():
	dash_timer = Timer.new()
	dash_timer.one_shot = true
	dash_timer.wait_time = AIR_JUMP_COOL_TIME
	dash_timer.timeout.connect(restore_air_count.bind(1))
	add_child(dash_timer)


func restore_air_count(value):
	on_air_count_change.emit(min(air_count + value, MAX_AIR_COUNT))


func can_air_jump() -> bool:
	return air_count > 0


func _ready() -> void:
	init_dash_timer()
	on_air_count_change.connect(_on_air_count_change)


func _on_air_count_change(count: int) -> void:
	air_count = count
	if dash_timer.is_stopped() && count < MAX_AIR_COUNT:
		dash_timer.start()
