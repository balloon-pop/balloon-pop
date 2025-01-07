extends CanvasLayer

@onready var start_button: Button = $Button

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	GameManager.game_state_change.emit(GameManager.GameState.PLAYING)


