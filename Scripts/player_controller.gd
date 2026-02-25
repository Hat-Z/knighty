extends CharacterBody2D

@export_category("movement variable")
@export var move_speed = 120.0
@export var decelaration = 0.1
@export var gravity = 500.0
@onready var sprite_2d : Sprite2D = $Sprite2D
var movement = Vector2()

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

@export_category("dash variable")
@export var dash_speed = 400.0
@export var facing_right = true
@export var dash_gravity = 0
@export var dash_number = 1
var dash_key_pressed = 0
var is_dashing = false
var dash_timer = Timer

@export_category("sword variable")
@export var is_attacking : bool = false

func _ready() -> void: #sword
	$sword/sword_collider.disabled = true

func _physics_process(delta: float) -> void:
	if !is_dashing:
		velocity.y += gravity * delta
	elif is_dashing:
		velocity.y = dash_gravity
	
	horizontal_movement()
	jump_logic()
	wall_logic()
	set_animations()
	flip()
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("sword"):
		is_attacking = true

func horizontal_movement():
	if is_wall_jumping == false and is_dashing == false:
		movement = Input.get_axis("ui_left","ui_right")
		
		if movement:
			velocity.x = movement * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed * decelaration)
	if Input.is_action_just_pressed("dash") and dash_key_pressed == 0 and dash_number >= 1:
		dash_number -= 1
		dash_key_pressed = 1
		dash()
		
func set_animations():
	if not is_attacking:
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
	if is_attacking:
		$anim.play("sword")

func flip():
	if velocity.x > 0:
		facing_right = true
		#sprite_2d.flip_h = false
		scale.x = scale.y * 1
		wall_x_force = 200
	if velocity.x < 0:
		facing_right = false
		#sprite_2d.flip_h = true
		scale.x = scale.y * -1
		wall_x_force = -200

func jump_logic():
	
	if is_on_floor():
		dash_number = 1
		jump_amount = 2
		if Input.is_action_just_pressed("ui_accept"):
			jump_amount -= 1
			velocity.y -= lerp(jump_speed, accelaration, 0.1)
			
	if not is_on_floor():
		if jump_amount > 0:
			
			if Input.is_action_just_pressed("ui_accept"):
				jump_amount = 0
				velocity.y -= lerp(jump_speed, accelaration, 1)
				
			if Input.is_action_just_released("ui_accept"):
				velocity.y = lerp(velocity.y, gravity, 0.2)
				velocity.y *= 0.3
	else:
		return
		
func wall_logic():
	if is_on_wall_only():
		dash_number = 1 #i added
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

func dash():
	if dash_key_pressed == 1:
		is_dashing = true
	else:
		is_dashing = false
		
	if facing_right:
		velocity.x = dash_speed
		dash_started()
	if !facing_right:
		velocity.x = -dash_speed
		dash_started()
		
func dash_started():
	if is_dashing:
		dash_key_pressed = 1
		await get_tree().create_timer(0.1).timeout
		is_dashing = false
		dash_key_pressed = 0
	else:
		return

func reset_states():
	is_attacking = false
	
