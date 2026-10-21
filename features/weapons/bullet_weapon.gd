# Ad Maiorem Dei Gloriam!
class_name BulletWeapon
extends WeaponBase

@export var bullet: PackedScene
@export var bullet_velocity: float = 32.0

@export var ammo: int = 10:
	set(new_ammo):
		ammo = clamp(new_ammo, 0, max_ammo)
		ammo_changed.emit(ammo)
		
		if ammo <= 0:
			start_recharging()
		
@export var max_ammo: int = 10:
	set(new_max_ammo):
		max_ammo = max(1, new_max_ammo)
		max_ammo_changed.emit(max_ammo)

signal ammo_changed(new_ammo: int)
signal max_ammo_changed(new_max_amo: int)
signal started_recharging()
signal ended_recharging()

var _is_recharging: bool = false
var _is_on_cooldown: bool = false

func attack() -> void:
	if _is_recharging || _is_on_cooldown: return
	
	var instantiated_bullet = bullet.instantiate()
	get_tree().root.add_child(instantiated_bullet)
	
	instantiated_bullet.velocity = _to_mouse().normalized() * bullet_velocity
	instantiated_bullet.global_position = %BulletSpawn.global_position
	instantiated_bullet.global_rotation = global_rotation
	
	_is_on_cooldown = true
	ammo -= 1
	%ShootCooldown.start()

func start_recharging() -> void:
	if _is_recharging || ammo > 0: return
	_is_recharging = true
	started_recharging.emit()
	%RechargeCooldown.start()

func _process(delta: float) -> void:
	rotation = _to_mouse().angle()
	
func _to_mouse() -> Vector2:
	return (get_global_mouse_position() - global_position)

func _on_shoot_cooldown_timeout() -> void:
	_is_on_cooldown = false

func _on_recharge_cooldown_timeout() -> void:
	ammo = max_ammo
	ended_recharging.emit()
	_is_recharging = false
