# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D

@onready var speed: float = 32.0

var _input_direction: Vector2

func _physics_process(delta: float) -> void:
	_update_inputs()
	_update_velocity()
	_update_sprite()
	_update_position()

func _update_inputs() -> void:
	_input_direction.x = Input.get_axis("walk_left", "walk_right")
	_input_direction.y = Input.get_axis("walk_up", "walk_down")

func _update_velocity() -> void:
	var direction_to_go: Vector2 = _input_direction.normalized()
	velocity = direction_to_go * speed

func _update_position() -> void:
	move_and_slide()

func _update_sprite() -> void:
	if _input_direction.x < 0.0:
		$Sprite2D.flip_h = true
	elif _input_direction.x > 0.0:
		$Sprite2D.flip_h = false
