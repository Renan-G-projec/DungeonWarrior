# Ad Maiorem Dei Gloriam!
class_name MeleeWeapon
extends WeaponBase

@export var damage: float = 7.0
@export var animation_range: float = 40.0
@export var animation_velocity: float = 0.15

var _is_attacking: bool = false

func attack() -> void:
	if _is_attacking: return
	_is_attacking = true
	
	var _sprite_tween := create_tween()
	_sprite_tween.tween_property(self, "rotation_degrees", rotation_degrees - animation_range, animation_velocity * 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	_sprite_tween.tween_property(self, "rotation_degrees", rotation_degrees + 2 * animation_range, animation_velocity).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	for body in %HitArea.get_overlapping_bodies():
		%HitArea.body_entered.emit(body)

	await _sprite_tween.finished
	_is_attacking = false

func _process(delta: float) -> void:
	if _is_attacking: return
	rotation = _to_mouse().angle()
	
func _to_mouse() -> Vector2:
	return (get_global_mouse_position() - global_position)


func _on_hit_area_body_entered(body: Node2D) -> void:
	if !_is_attacking: return
	var body_health := body.get_node_or_null("HealthComponent") as HealthComponent
	if body_health:
		body_health.take_damage(damage, self)
