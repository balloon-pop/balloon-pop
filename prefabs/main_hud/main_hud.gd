extends CanvasLayer


@onready var air_label: Label = $Control/AirLabel


func _ready() -> void:
	PlayerManager.on_air_jump.connect(_on_air_jump)


func _on_air_jump() -> void:
	air_label.text = "%02d" % PlayerManager.air_count
	if PlayerManager.air_count <= 0:
		air_label.label_settings.font_color = Color.RED
