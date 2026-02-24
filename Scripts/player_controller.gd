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

@export_category("wall variable")
@export var wall_slide = 50.0
@onready var raycast_left: RayCast2D = $Node2D/raycast_left
@onready var raycast_right: RayCast2D = $Node2D/raycast_right
@export var wall_x_force = 200.0
@export var wall_y_force = -220.0
var is_wall_jumping = false

var movement = Vector2()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	horizontal_movement()
	jump_logic()
	wall_logic()
	set_animations()
	flip()
	move_and_slide()

func horizontal_movement():
	if is_wall_jumping == false:
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
	if is_on_wall_only():
		$anim.play("fall")

func flip():
	if velocity.x > 0:
		sprite_2d.flip_h = false
		#scale.x = scale.y * 1
		#wall_x_force = 200
	if velocity.x < 0:
		sprite_2d.flip_h = true
		#scale.x = scale.y * -1
		#wall_x_force = -200

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
		
func wall_logic():
	if is_on_wall_only():
		velocity.y = wall_slide
		if Input.is_action_just_pressed("ui_accept"):
			if raycast_left.is_colliding():
				jump_amount = 2
				velocity = Vector2(wall_x_force, wall_y_force)
				wall_jumping()
			if raycast_right.is_colliding():
				jump_amount = 2
				velocity = Vector2(-wall_x_force, wall_y_force)
				wall_jumping()

func wall_jumping():
	is_wall_jumping = true
	await get_tree().create_timer(0.12).timeout
	is_wall_jumping = false
