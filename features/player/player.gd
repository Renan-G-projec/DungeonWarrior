# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D

@onready var speed: float = 32.0
@onready var knockback: KnockbackComponent = $KnockbackComponent
@onready var dash_component: DashComponent = %DashComponent
@onready var feel_component: FeelComponent = $FeelComponent
@onready var pull: Pull = $Pull
@onready var stun_component: StunComponent = $StunComponent

@export var weapon: WeaponBase:
	set(new_weapon):
		if weapon == new_weapon: return
		if weapon:
			weapon.attacked.disconnect(_on_weapon_attacked)
		if new_weapon:
			new_weapon.attacked.connect(_on_weapon_attacked)
		
		weapon = new_weapon

signal gameover()
var _input_direction: Vector2

func _physics_process(_delta: float) -> void:
	if %HealthComponent.is_dead(): return
	_update_inputs()
	_update_velocity()
	_update_sprite()
	_update_position()


func _update_inputs() -> void:
	_input_direction.x = Input.get_axis("walk_left", "walk_right")
	_input_direction.y = Input.get_axis("walk_up", "walk_down")

	if stun_component.is_stunned():
		_input_direction = Vector2.ZERO
		return
	
	if Input.is_action_just_pressed("attack") and weapon:
		weapon.attack()
		
	if Input.is_action_just_pressed("dash"):
		dash_component.dash(_get_mouse_direction())
		feel_component.squash_animation($Sprite2D, Vector2(1.5, 0.5), 0.3)


func _update_velocity() -> void:
	if stun_component.is_stunned():
		velocity = Vector2.ZERO
	elif pull.is_active():
		velocity = pull.pull_velocity
	elif knockback.is_active():
		print("4. player knocked back, velocity=", velocity)
		velocity = knockback.knockback_velocity
	elif dash_component.is_dashing:
		velocity = (
			dash_component.get_dash_force()
			+ _input_direction.normalized() * speed
		)

		if get_slide_collision_count() > 0:
			dash_component.end_dash()
	else:
		velocity = _input_direction.normalized() * speed


func _update_position() -> void:
	move_and_slide()


func _update_sprite() -> void:
	if _input_direction:
		$Sprite2D.play("run")
	else:
		$Sprite2D.play("default")

	if _input_direction.x < 0.0:
		$Sprite2D.flip_h = true
	elif _input_direction.x > 0.0:
		$Sprite2D.flip_h = false
		


func _on_bow_ammo_changed(new_ammo: int) -> void:
	print(new_ammo)


func _get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()


func _on_health_component_took_damage(
	character: Node,
	damage: float,
	source_position: Vector2
) -> void:
	%FeelComponent.squash_animation($Sprite2D, Vector2(1.4, 0.6), 0.3)
	%FeelComponent.hit_animation($Sprite2D, 0.2)


func _on_health_component_died() -> void:
	feel_component.squash_animation($Sprite2D, Vector2(0.2, 1.8), 0.4)
	
	$Sprite2D.play('death')
	await $Sprite2D.animation_finished
	gameover.emit()
	
	queue_free()

func _on_weapon_attacked() -> void:
	if weapon.is_heavy: dash_component.dash((global_position - get_global_mouse_position()).normalized() * 0.5)
