extends CanvasLayer

@onready var high_score: Label = $HighScore
@onready var current_score: Label = $CurrentScore

func _ready() -> void:
	GameManager.game_state_change.connect(_on_game_state_change)

func _on_game_state_change(new_state: GameManager.GameState) -> void:
	match new_state:
		GameManager.GameState.READY:
			visible = false
		GameManager.GameState.END:
			current_score.text = str(PlayerManager.altitude)
			high_score.text = str(ScoreManager.highest_altitude)
			visible = true


