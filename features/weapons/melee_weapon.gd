# Ad Maiorem Dei Gloriam!
class_name MeleeWeapon
extends WeaponBase

@export var damage: float = 7.0
@export var animation_range: float = 40.0
@export var animation_velocity: float = 0.2

var _is_on_cooldown: bool = false

func attack() -> void:
	if _is_on_cooldown: return
	_is_on_cooldown = true
	
	rotation_degrees -= animation_range
	var _sprite_tween = create_tween()
	_sprite_tween.tween_property(self, "rotation_degrees", rotation_degrees + 2 * animation_range, animation_velocity).set_trans(Tween.TRANS_CUBIC)

	await _sprite_tween.finished
	_is_on_cooldown = false

func _process(delta: float) -> void:
	if _is_on_cooldown: return
	rotation = _to_mouse().angle()
	
func _to_mouse() -> Vector2:
	return (get_global_mouse_position() - global_position)
