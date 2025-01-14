extends CanvasLayer


@onready var air_label: Label = $Control/AirLabel
@onready var wind_texture: TextureProgressBar = $Control/TextureRect2
@onready var altitude_label: Label = $Control/AltitudeLabel
@onready var highest_altitude_label: Label = $Control/HighestAltitudeLabel

func _ready() -> void:
	PlayerManager.player_altitude_change.connect(_on_player_altitude_change)
	PlayerManager.air_count_change.connect(_on_air_count_change)
	print('MainHud Ready : ', ScoreManager.highest_altitude)


func _process(_delta):
	var air_jump_cool_percent = 1 - PlayerManager.air_jump_timer.time_left / PlayerManager.air_jump_timer.wait_time
	wind_texture.value = wind_texture.max_value * air_jump_cool_percent

func _on_player_altitude_change(altitude: int) -> void:
	altitude_label.text = "%dm" % altitude
	highest_altitude_label.text = "%dm" % ScoreManager.highest_altitude

func _on_air_count_change(count: int) -> void:
	air_label.text = "%02d" % count
	if count <= 0:
		air_label.label_settings.font_color = Color.RED
	else:
		air_label.label_settings.font_color = Color.BLACK
