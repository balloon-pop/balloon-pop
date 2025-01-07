extends Node2D

@export var bomb_scene: PackedScene
@onready var bomb_timer: Timer = $BombTimer
@onready var spawn_area: Vector2 = get_viewport_rect().size

var MAX_BOMB_COUNT := 3
var bomb_timer_delay := randf_range(2, 4)

func _ready() -> void:
	bomb_timer.timeout.connect(_on_bomb_timer_timeout)
	bomb_timer.start(bomb_timer_delay)

func spawn_bomb() -> void:
	var bomb_count = get_tree().get_nodes_in_group('bomb').size()
	var can_spawn_bomb = bomb_count < MAX_BOMB_COUNT && PlayerManager.velocity.y < 0
	
	if can_spawn_bomb:
		var bomb_instance = bomb_scene.instantiate()
		bomb_instance.scale = Vector2(0.4, 0.4)

		var random_x = randf_range(-spawn_area.x / 2, spawn_area.x / 2)
		var random_y = PlayerManager.position.y - [100, 200, 300][randi() % 3]
		bomb_instance.position = Vector2(random_x, random_y)

		add_child(bomb_instance)
	
	bomb_timer.start(bomb_timer_delay)

func _on_bomb_timer_timeout() -> void:
	spawn_bomb()

func _process(delta: float) -> void:
	pass
