# Ad Maiorem Dei Gloriam!
class_name BossBase
extends CharacterBody2D

func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

func _on_health_component_died() -> void:
	queue_free()

func _on_health_component_took_damage(damage: float) -> void:
	$FeelComponent.hit_animation()
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	$CollisionShape2D.set_deferred("disabled", false) 
	self.visible = true
