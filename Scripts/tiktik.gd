extends CharacterBody2D

@export var health : int = 2
@export var damage = 1.0

func _process(delta: float) -> void:
	if health <= 0:
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword"):
		health -= 1


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.health -= damage
