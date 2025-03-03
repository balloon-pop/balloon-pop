extends Node

@export var bird_scene: PackedScene
var bird_timer: Timer = Timer.new()

var MAX_BIRD_COUNT := 3
var bird_timer_delay := randf_range(2, 4)

func _ready() -> void:
	bird_timer.one_shot = false
	bird_timer.wait_time = bird_timer_delay
	bird_timer.timeout.connect(_on_bird_timer_timeout)
	add_child(bird_timer)
	bird_timer.start(bird_timer_delay)

func spawn_bird() -> void:
	var bird_count = get_tree().get_nodes_in_group('bird').size()
	var can_spawn_bird = bird_count < MAX_BIRD_COUNT && PlayerManager.velocity.y < 0
	
	if can_spawn_bird:
		var bird_instance = bird_scene.instantiate()
		bird_instance.scale = Vector2(0.3, 0.3)

		var random_x = PlayerManager.position.x + randf_range(-10, 10)
		var random_y = PlayerManager.position.y - [50, 100, 200][randi() % 3]
		bird_instance.position = Vector2(random_x, random_y)

		add_child(bird_instance)
	

func _on_bird_timer_timeout() -> void:
	spawn_bird()
