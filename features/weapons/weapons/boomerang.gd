# Ad Maiorem Dei Gloriam!
class_name Boomerang
extends WeaponBase

## Note: This doesnt inherit of melee or bullet weapons as its a diferent kind of weapon
## Melee ones have a fixed cooldown
## Bullet ones have a fixed timestang to recharge

@export var speed: float = 500

var _bullet_scene: PackedScene = preload("res://features/weapons/bullets/boomerang/boomerang_bullet.tscn")
var _has_boomerang: bool = true

func attack():
	if !_has_boomerang: return
	
	var boomerang_bullet: BoomerangBullet = _bullet_scene.instantiate()
	boomerang_bullet.velocity = _to_mouse().normalized() * speed
	
	visible = false
	_has_boomerang = false
	
	boomerang_bullet.speed = speed
	boomerang_bullet.global_position = global_position
	boomerang_bullet.player_collected.connect(_on_player_collected_boomerang)
	boomerang_bullet._player_ref = get_tree().get_first_node_in_group("player")
	
	attacked.emit()
	get_tree().current_scene.add_child(boomerang_bullet)

func _to_mouse() -> Vector2:
	return (get_global_mouse_position() - global_position)

func _process(delta: float) -> void:
	rotation = _to_mouse().angle()

func _on_player_collected_boomerang() -> void:
	visible = true
	_has_boomerang = true
