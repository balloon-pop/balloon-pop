extends CanvasLayer


@onready var air_label: Label = $Control/AirLabel


func _ready() -> void:
	PlayerManager.on_air_count_change.connect(_on_air_count_change)


func _on_air_count_change(count: int) -> void:
	air_label.text = "%02d" % count
	if count <= 0:
		air_label.label_settings.font_color = Color.RED
	else:
		air_label.label_settings.font_color = Color.BLACK
