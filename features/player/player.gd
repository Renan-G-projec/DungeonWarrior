# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D

@onready var speed: float = 32.0
@onready var knockback: Knockback = $Knockback
@onready var dash_component: DashComponent = %DashComponent
@export var weapon: WeaponBase
@onready var feel_component: FeelComponent = $FeelComponent

var _input_direction: Vector2

func _physics_process(delta: float) -> void:
	_update_inputs()
	_update_velocity()
	_update_sprite()
	_update_position()
	

func _update_inputs() -> void:
	_input_direction.x = Input.get_axis("walk_left", "walk_right")
	_input_direction.y = Input.get_axis("walk_up", "walk_down")
	
	if Input.is_action_just_pressed("attack"):
		weapon.attack()
	if Input.is_action_just_pressed("dash"):
		dash_component.dash(_get_mouse_direction())
		feel_component._squash_animation($Sprite2D, $Sprite2D.scale * 0.9)

func _update_velocity() -> void:
	if knockback.is_active():
		print("4. player knocked back, velocity=", velocity)
		velocity = knockback.knockback_velocity
		return
	elif dash_component.is_dashing:
		velocity = dash_component.get_dash_force() + _input_direction.normalized() * speed
		if get_slide_collision_count() > 0:
			dash_component.end_dash()
	else:
		velocity = _input_direction.normalized() * speed

func _update_position() -> void:
	move_and_slide()

func _update_sprite() -> void:
	if _input_direction.x < 0.0:
		$Sprite2D.flip_h = true
	elif _input_direction.x > 0.0:
		$Sprite2D.flip_h = false


func _on_bow_ammo_changed(new_ammo: int) -> void:
	print(new_ammo)

func _get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()
