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

var _can_attack: bool = true

func attack() -> void:
	if !_can_attack: return
	
	var instantiated_bullet = bullet.instantiate()
	get_tree().root.add_child(instantiated_bullet)
	
	instantiated_bullet.velocity = Vector2.ONE * bullet_velocity
	instantiated_bullet.global_position = %BulletSpawn.global_position
	
	_can_attack = false
	ammo -= 1

func start_recharging() -> void:
	_can_attack = false
	started_recharging.emit()
	%RechargeCooldown.start()

func _process(delta: float) -> void:
	rotation = _to_mouse()
	
func _to_mouse() -> float:
	return (get_global_mouse_position() - global_position).angle()


func _on_shoot_cooldown_timeout() -> void:
	_can_attack = true


func _on_recharge_cooldown_timeout() -> void:
	_can_attack = true
	ammo = max_ammo
	ended_recharging.emit()
