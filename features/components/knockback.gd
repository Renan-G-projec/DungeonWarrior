# Ad Maiorem Dei Gloriam! 
class_name KnockbackComponent
extends Node

@export var default_force: float = 250
@export var friction: float = 3600.0
@export var knockback_resistance: float = 1.0

var knockback_velocity: Vector2 = Vector2.ZERO

@onready var character: CharacterBody2D = get_parent() as CharacterBody2D

func is_active() -> bool:
	return knockback_velocity.length_squared() > 0.01

func apply_knockback(direction: Vector2, force: float = default_force) -> void:
	if not character:
		return
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	knockback_velocity = direction.normalized() * (force / maxf(knockback_resistance, 0.01))

func _physics_process(delta: float) -> void:
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * friction)
