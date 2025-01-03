extends CanvasLayer


@onready var air_label: Label = $Control/AirLabel
@onready var wind_texture: TextureProgressBar = $Control/TextureRect2

func _ready() -> void:
	PlayerManager.on_air_count_change.connect(_on_air_count_change)

func _process(_delta):
	var dash_cool_percent = 1 - PlayerManager.dash_timer.time_left / PlayerManager.dash_timer.wait_time
	wind_texture.value = wind_texture.max_value * dash_cool_percent


func _on_air_count_change(count: int) -> void:
	air_label.text = "%02d" % count
	if count <= 0:
		air_label.label_settings.font_color = Color.RED
	else:
		air_label.label_settings.font_color = Color.BLACK
