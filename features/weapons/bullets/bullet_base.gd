# Ad Maiorem Dei Gloriam!
class_name BulletBase
extends Area2D

@export var damage: float = 5.0

var velocity: Vector2

func _on_lifetime_timeout() -> void:
	_destroy()

func _physics_process(delta: float) -> void:
	position += delta * velocity

func _destroy() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	var health := body.get_node_or_null("HealthComponent") as HealthComponent
	if health:
		health.take_damage(damage, self)
	_destroy()
