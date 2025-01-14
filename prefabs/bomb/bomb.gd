extends Area2D

enum State { IDLE, EXPLODE }

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitBox: Area2D = $HitBox
@onready var visibleNotifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func change_state(state: State) -> void:
	match state:
		State.IDLE:
			animation_player.play("idle")
		State.EXPLODE:
			animation_player.play("explode")

func _on_hitBox_body_entered(_body: Node2D) -> void:
	var current_air_count = max(PlayerManager.air_count - 1, 0)
	PlayerManager.air_count_change.emit(current_air_count)

func _on_bomb_screen_exited() -> void:
	var is_bomb_below_player = position.y > PlayerManager.position.y

	# bomb가 화면을 빠져나갈 때 플레이어보다 아래에 있었을 때만 제거
	if is_bomb_below_player:
		queue_free()

func _ready() -> void:
	change_state(State.IDLE)
	hitBox.body_entered.connect(_on_hitBox_body_entered)
	visibleNotifier.screen_exited.connect(_on_bomb_screen_exited)

func _process(delta: float) -> void:
	pass
