# PlayerManager
extends Node

signal on_air_count_change(count: int)

const MAX_AIR_COUNT := 3

var air_count := 3


func restore_air_count(value):
	on_air_count_change.emit(min(air_count + value, MAX_AIR_COUNT))


func can_air_jump() -> bool:
	return air_count > 0


func _ready() -> void:
	on_air_count_change.connect(_on_air_count_change)


func _on_air_count_change(count: int) -> void:
	air_count = count
