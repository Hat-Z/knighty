extends CharacterBody2D

@export var health : int = 2

func _process(delta: float) -> void:
	if health <= 0:
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword"):
		health -= 1
