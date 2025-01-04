# PlayerManager
extends Node

signal air_count_change(count: int)

const MAX_AIR_COUNT := 3
const AIR_JUMP_COOL_TIME := 5

var air_jump_timer: Timer
var air_count := 3


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


func _on_air_count_change(count: int) -> void:
	air_count = count
	if air_jump_timer.is_stopped() && count < MAX_AIR_COUNT:
		air_jump_timer.start()
