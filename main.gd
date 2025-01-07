extends Node2D

@onready var main_hud: CanvasLayer = $MainHud
@onready var start_hud: CanvasLayer = $StartHud


func _ready() -> void:
	GameManager.game_state_change.connect(_on_game_state_change)


func _on_game_state_change(new_state: GameManager.GameState) -> void:
	match new_state:
		GameManager.GameState.PLAYING:
			start_hud.visible = false
			main_hud.visible = true
		GameManager.GameState.READY:
			start_hud.visible = true