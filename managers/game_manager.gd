extends Node

enum GameState {
	READY,
	PLAYING,
	END
}

signal game_state_change(new_state: GameState)

var game_state: GameState = GameState.READY


func _ready():
	game_state_change.connect(on_game_state_change)


func on_game_state_change(new_state: GameState):
	game_state = new_state
