# Ad Maiorem Dei Gloriam!
class_name Wand 
extends BulletWeapon


@export var current_state: WandBullet.BulletType = WandBullet.BulletType.FIRE:
	set(new_state):
		current_state = new_state
		match current_state:
			WandBullet.BulletType.FIRE:
				$WeaponSprite.self_modulate = Color(1.825, 1.406, 0.525, 1.0)
			WandBullet.BulletType.PSYQUIC:
				$WeaponSprite.self_modulate = Color(3.168, 0.664, 2.881)
			WandBullet.BulletType.ICE:
				$WeaponSprite.self_modulate = Color(0.304, 1.087, 2.138, 1.0)

func attack() -> void:
	if _is_recharging || _is_on_cooldown: return
	
	var instantiated_bullet = bullet.instantiate()
	get_tree().current_scene.add_child(instantiated_bullet)
	
	instantiated_bullet.velocity = _to_mouse().normalized() * bullet_velocity
	instantiated_bullet.global_position = %BulletSpawn.global_position
	instantiated_bullet.global_rotation = global_rotation
	
	instantiated_bullet.scale = Vector2(1.4, 0.6)
	instantiated_bullet.create_tween().tween_property(instantiated_bullet, "scale", Vector2.ONE, min(0.4, 0.01 * bullet_velocity)).set_trans(Tween.TRANS_QUAD)
	
	instantiated_bullet.type = current_state
	
	_is_on_cooldown = true
	ammo -= 1
	%ShootCooldown.start()
	%FeelComponent.squash_animation($WeaponSprite, Vector2(0.3, 1.9), 0.32)
	
	attacked.emit()

func next_state() -> WandBullet.BulletType:
	match current_state:
		WandBullet.BulletType.FIRE: current_state = WandBullet.BulletType.PSYQUIC
		WandBullet.BulletType.PSYQUIC: current_state = WandBullet.BulletType.ICE
		WandBullet.BulletType.ICE: current_state = WandBullet.BulletType.FIRE
	return current_state

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		next_state()
