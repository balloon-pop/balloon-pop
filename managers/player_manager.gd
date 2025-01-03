# PlayerManager
extends Node

signal on_air_jump()

var air_count := 3


func can_air_jump() -> bool:
	return air_count > 0


func _ready() -> void:
	on_air_jump.connect(_on_air_jump)


func _on_air_jump() -> void:
	air_count = max(air_count - 1, 0)
