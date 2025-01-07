extends Node

@export var item: Array[PackedScene]
@export var spawn_time: float = 1.5

var MAX_SPAWNED_ITEM_COUNT := 10
var spawn_timer: Timer = Timer.new()


func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	spawn_timer.timeout.connect(spawn_item)
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.start()


func spawn_item() -> void:
	var spawned_item_count = get_tree().get_nodes_in_group('item').size()
	var can_spawn_item = spawned_item_count < MAX_SPAWNED_ITEM_COUNT && PlayerManager.velocity.y < 0
	if !can_spawn_item: return

	var random_item = item[randi() % item.size()]
	var item_instance = random_item.instantiate()
	# 아이템 생성 위치는 임시로 이렇게 작성
	var random_x = PlayerManager.position.x + randf_range(-10, 10)
	var random_y = PlayerManager.position.y - randf_range(100, 200)
	item_instance.position = Vector2(random_x, random_y)
	add_child(item_instance)
