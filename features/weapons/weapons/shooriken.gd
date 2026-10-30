# Ad Maiorem Dei Gloriam!
class_name ShoorikenWeapon
extends BulletWeapon

@export var spread_angle: float = 10.0

func attack() -> void:
	if _is_recharging || _is_on_cooldown: return
	
	for i in range (-1, 2):
		var instantiated_bullet = bullet.instantiate()
		get_tree().root.add_child(instantiated_bullet)
		
		instantiated_bullet.velocity = _to_mouse().normalized().rotated(deg_to_rad(spread_angle) * i) * bullet_velocity
		var spawn_pos: Vector2 = %BulletSpawn.position.rotated(deg_to_rad(spread_angle) * i)
		instantiated_bullet.global_position = to_global(spawn_pos)
		instantiated_bullet.global_rotation = global_rotation
		instantiated_bullet.scale = Vector2(1.4, 0.6)
		instantiated_bullet.create_tween().tween_property(instantiated_bullet, "scale", Vector2.ONE, min(0.4, 0.01 * bullet_velocity)).set_trans(Tween.TRANS_QUAD)
		
	_is_on_cooldown = true
	ammo -= 1
	%ShootCooldown.start()
	%FeelComponent.squash_animation($WeaponSprite, Vector2(0.3, 1.9), 0.32)
