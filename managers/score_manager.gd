extends Node

const SAVE_PATH = "user://altitude.save"
var highest_altitude = 0

func _ready() -> void:
    GameManager.game_state_change.connect(_on_change_game_state)
    load_high_score()
  
func _on_change_game_state(state: GameManager.GameState) -> void:
    if state == GameManager.GameState.END:
        highest_altitude = max(highest_altitude, PlayerManager.highest_altitude)
        save_high_score()

func load_high_score():
    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file:
        highest_altitude = file.get_var()
        file.close()
    
func save_high_score():
    var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    save_file.store_var(highest_altitude)
    save_file.close()