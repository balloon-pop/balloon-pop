extends PathFollow2D

var speed: float = 50

func _ready() -> void:
    speed = randf_range(50, 90)

func _process(delta):
    progress += speed * delta