# Ad Maiorem Dei Gloriam!
class_name EnemyBase
extends CharacterBody2D


func _on_health_component_died() -> void:
	queue_free()

func _on_health_component_took_damage(damage: float) -> void:
	$FeelComponent.hit_animation(%Sprite)
