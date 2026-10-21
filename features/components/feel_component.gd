# Ad Maiorem Dei Gloriam!
class_name FeelComponent
extends Node

## I usually try to avoid repeating code
## This node helps adding squash and hit effects


var _hit_tween: Tween
var _squash_tween: Tween

# If no sprite is provided, changes all the parent modulate
func hit_animation(sprite: Node2D = null, time: float = 0.1) -> void:
	if _hit_tween:
		_hit_tween.kill()
	if !sprite:
		sprite = get_parent()
	
	sprite.modulate = Color.WHITE * 30.0
	_hit_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_hit_tween.tween_property(sprite, "modulate", Color.WHITE, time)

# If no sprite is provided, changes all the parent scale. USE CAREFULLY W
func _squash_animation(sprite: Node2D = null, squash_scale: Vector2 = Vector2(1.2, 0.8), time: float = 0.1) -> void:
	if _squash_tween:
		_squash_tween.kill()
	if !sprite:
		sprite = get_parent()

	sprite.scale = squash_scale
	_squash_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_squash_tween.tween_property(sprite, "scale", Vector2.ONE * 0.08, time)
