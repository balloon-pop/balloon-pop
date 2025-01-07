extends CanvasLayer

@onready var start_button: Button = $Button
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	score_label.text = "%dm" % ScoreManager.highest_altitude

func _on_start_button_pressed() -> void:
	GameManager.game_state_change.emit(GameManager.GameState.PLAYING)


