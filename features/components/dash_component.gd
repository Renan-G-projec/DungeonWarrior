# Ad Maiorem Dei Gloriam!
class_name DashComponent
extends Node

# This node is used for making dashes and forces in a direction.
@export var dash_force: float = 200.0
@export var dash_decay: float = 0.5

var is_dashing: bool = false
var _current_dash_force = 0
var _dash_tween: Tween
var _direction: Vector2

func get_dash_force() -> Vector2:
	if !is_dashing: return Vector2.ZERO
	
	return _current_dash_force * _direction

func dash(direction: Vector2, force: float = dash_force, decay: float = dash_decay) -> void:
	if is_dashing: return
	if _dash_tween:
		_dash_tween.kill()
	_dash_tween = create_tween()
	
	_current_dash_force = force
	_direction = direction
	is_dashing = true
	
	_dash_tween.tween_property(self, "_current_dash_force", 0.0, decay).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_dash_tween.tween_callback(func() -> void: is_dashing = false)

func end_dash() -> void:
	if _dash_tween:
		_dash_tween.kill()
	is_dashing = false
	_current_dash_force = 0
