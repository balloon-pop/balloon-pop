extends Node

enum GameState {
	READY,
	PLAYING,
	END
}

signal game_state_change(new_state: GameState)

var game_state: GameState = GameState.READY


func init_game_state():
	PlayerManager.init()
	ScoreManager.init()


func restart_game() -> void:
	game_state_change.emit(GameState.READY)
	get_tree().reload_current_scene()
	init_game_state()


func _ready():
	game_state_change.connect(on_game_state_change)


func on_game_state_change(new_state: GameState):
	game_state = new_state
	match new_state:
		GameState.END:
			get_tree().paused = true
		GameState.READY:
			get_tree().paused = false
