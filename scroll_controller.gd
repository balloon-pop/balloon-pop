extends CharacterBody2D

var speed := 20
var direction: float
var direction2: float

func _physics_process(_delta):
	direction = Input.get_axis("ui_up", "ui_down")

	# 좌우 테스트
	# direction2 = Input.get_axis("ui_left", "ui_right")
	# if direction2:
	# 	velocity.x = direction2 * speed
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, speed)
	
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()
