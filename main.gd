extends Node2D

@onready var main_hud: CanvasLayer = $MainHud
@onready var start_hud: CanvasLayer = $StartHud
@onready var phantom_camera_2d: PhantomCamera2D = $PhantomCamera2D
@onready var player: Player = $Player

const PLAYER_DEADLINE_POSITION_Y_OFFSET = 80

func _ready() -> void:
	GameManager.game_state_change.connect(_on_game_state_change)
	PlayerManager.player_position_change.connect(_on_player_position_change)



func _on_game_state_change(new_state: GameManager.GameState) -> void:
	match new_state:
		GameManager.GameState.PLAYING:
			start_hud.visible = false
			main_hud.visible = true
			phantom_camera_2d.limit_bottom = int(player.position.y) + PLAYER_DEADLINE_POSITION_Y_OFFSET
		GameManager.GameState.READY:
			start_hud.visible = true
		GameManager.GameState.END:
			start_hud.visible = false
			main_hud.visible = false

func _on_player_position_change(_position: Vector2) -> void:
	var player_bottom_limit = int(player.position.y) + PLAYER_DEADLINE_POSITION_Y_OFFSET
	if player.velocity.y <= 0 && player_bottom_limit < phantom_camera_2d.limit_bottom:
		phantom_camera_2d.limit_bottom = player_bottom_limit