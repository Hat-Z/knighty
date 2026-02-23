extends CharacterBody2D

@export var move_speed = 120.0
@export var decelaration = 0.1
@export var gravity = 500.0
@onready var sprite_2d : Sprite2D = $Sprite2D

var movement = Vector2()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	horizontal_movement()
	set_animations()
	flip()
	move_and_slide()

func horizontal_movement():
	movement = Input.get_axis("ui_left","ui_right")
	
	if movement:
		velocity.x = movement * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * decelaration)
		
func set_animations():
	if velocity.x != 0:
		$anim.play("move")
	if velocity.x == 0:
		$anim.play("idle")

func flip():
	if velocity.x > 0:
		sprite_2d.flip_h = false
		#scale.x = scale.y * 1
	if velocity.x < 0:
		sprite_2d.flip_h = true
		#scale.x = scale.y * -1
