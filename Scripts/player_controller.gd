extends CharacterBody2D

@export_category("movement variable")
@export var move_speed = 120.0
@export var decelaration = 0.1
@export var gravity = 500.0
@onready var sprite_2d : Sprite2D = $Sprite2D

@export_category("jump variable")
@export var jump_speed = 190.0
@export var accelaration = 290.0
@export var jump_amount = 2

var movement = Vector2()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	horizontal_movement()
	jump_logic()
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
	if velocity.y < 0:
		$anim.play("jump")
	if velocity.y > 10:
		$anim.play("fall")

func flip():
	if velocity.x > 0:
		sprite_2d.flip_h = false
		#scale.x = scale.y * 1
	if velocity.x < 0:
		sprite_2d.flip_h = true
		#scale.x = scale.y * -1

func jump_logic():
	
	if is_on_floor():
		jump_amount = 2
		if Input.is_action_just_pressed("ui_accept"):
			jump_amount -= 1
			velocity.y -= lerp(jump_speed, accelaration, 0.1)
			
	if not is_on_floor():
		if jump_amount > 0:
			
			if Input.is_action_just_pressed("ui_accept"):
				jump_amount -= 1
				velocity.y -= lerp(jump_speed, accelaration, 1)
				
			if Input.is_action_just_released("ui_accept"):
				velocity.y = lerp(velocity.y, gravity, 0.2)
				velocity.y *= 0.3
	else:
		return
