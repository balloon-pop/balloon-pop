extends Area2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D) -> void:
	print("item entered")

func _on_screen_exited() -> void:
	if position.y > PlayerManager.position.y:
		queue_free()
