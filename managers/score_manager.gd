extends Node

const SAVE_PATH = "user://altitude.save"
var highest_altitude = 0

func _ready() -> void:
    PlayerManager.player_dead.connect(_on_player_dead) # 이게 아니더라도 게임이 끝났다는 상태를 읽으면 된다.
    load_high_score()
    print('Highest Altitude in _ready():', highest_altitude)

func _on_player_dead(altitude: int) -> void:
    highest_altitude = max(highest_altitude, altitude)
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