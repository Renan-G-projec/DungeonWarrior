class_name LaserAttack
extends Node2D

signal state_changed(new_state)

enum State {IDLE, CHARGING, FIRING, COOLDOWN}

@export var damage := 5
@export var damage_interval := 0.8
@export var first_hit_delay := 0.15
@export var max_length := 1200.0
@export var charge_time := 1.0
@export var lock_time := 0.4
@export var fire_time := 1.5
@export var cooldown_time := 1.5
@export var beam_width := 14.0
@export var warn_width := 3.0
@export var track_speed := 3.0
@export var sweep_speed := 0.8 

@export var idle_delay := 1.9
@export var detection_range := 600.0
@export var leash_multiplier := 1.5
@export var require_line_of_sight := true
@export var target_group := "player"
@export var movement_component: Node

@export var warn_color := Color(1.0, 0.3, 0.3, 0.5)
@export var fire_color := Color(1.0, 1.0, 1.0, 1.0)

var state = State.IDLE
var target: Node2D
var attacker: Node

var _timer := 0.0
var _tick := 0.0
var _sweep_dir := 1.0

@onready var ray: RayCast2D = $RayCast2D
@onready var beam: Line2D = $Line2D
var _hitbox: ShapeCast2D

func _ready() -> void:
	attacker = get_parent()
	ray.target_position = Vector2(max_length, 0)
	beam.visible = false	
	_timer = idle_delay
	
	_hitbox = ShapeCast2D.new()
	var shape := CircleShape2D.new()
	shape.radius = beam_width * 0.5
	_hitbox.shape = shape
	_hitbox.collision_mask = ray.collision_mask
	_hitbox.collide_with_areas = ray.collide_with_areas
	_hitbox.collide_with_bodies = ray.collide_with_bodies
	_hitbox.enabled = false
	if attacker is CollisionObject2D:
		_hitbox.add_exception(attacker)
	add_child(_hitbox)
	_sync_hitbox_size()

func _sync_hitbox_size() -> void:
	(_hitbox.shape as CircleShape2D).radius = beam_width * 0.5

func start(new_target: Node2D = null) -> void:
	if state != State.IDLE:
		return
	if new_target:
		target = new_target
	_set_state(State.CHARGING)

func _set_state(new_state: State) -> void: 
	state = new_state
	print()
	match state:
		State.IDLE:
			_timer = idle_delay
			beam.visible = false
			_hitbox.enabled = false
			_set_movement(true)
		State.CHARGING:
			_timer = charge_time
			beam.visible = true
			beam.modulate = warn_color
			_hitbox.enabled = false
			_set_movement(false)
		State.FIRING:
			_timer = fire_time
			_tick = first_hit_delay
			_sweep_dir = [-1.0, 1.0].pick_random()
			beam.modulate = fire_color
			_hitbox.enabled = true
		State.COOLDOWN:
			_timer = cooldown_time
			beam.visible = false
			_hitbox.enabled = false
	state_changed.emit(state)

func _cancel_attack() -> void:
	_set_movement(true)
	_set_state(State.COOLDOWN)

func _physics_process(delta: float) -> void:

	if target == null or not is_instance_valid(target):
		target = get_tree().get_first_node_in_group(target_group) as Node2D
		if target == null:
			match state:
				State.CHARGING, State.FIRING:
					_cancel_attack()
				State.IDLE:
					_timer -= delta
				State.COOLDOWN:
					_timer -= delta
					if _timer <= 0.0:
						_set_state(State.IDLE)
			return

	match state:
		State.IDLE:
			_timer -= delta
			if _timer <= 0.0 and global_position.distance_to(target.global_position) <= detection_range and (not require_line_of_sight or _has_line_of_sight()):
				_set_state(State.CHARGING)

		State.CHARGING:
			_timer -= delta

			if global_position.distance_to(target.global_position) > detection_range * leash_multiplier:
				_cancel_attack()
				return

			if _timer > lock_time:
				_follow_target(delta)

			var progress := 1.0 - clampf(_timer / charge_time, 0.0, 1.0)
			update_beam(lerpf(warn_width, warn_width * 2.5, progress))

			if _timer <= 0.0:
				_set_state(State.FIRING)

		State.FIRING:
			_timer -= delta
			global_rotation += _sweep_dir * sweep_speed * delta
			update_beam(beam_width)
			_apply_damage(delta)
			if _timer <= 0.0:
				_set_state(State.COOLDOWN)

		State.COOLDOWN:
			_timer -= delta
			if _timer <= 0.0:
				_set_state(State.IDLE)
				
func _set_movement(enabled: bool) -> void:
	if movement_component:
		movement_component.set_physics_process(enabled)

func _follow_target(delta: float) -> void:
	if target == null:
		return
	var wanted := (target.global_position - global_position).angle()
	var angle_difference := angle_difference(global_rotation, wanted)
	var step := track_speed * delta
	global_rotation += clampf(angle_difference, -step, step)

func _has_line_of_sight() -> bool:
	var query := PhysicsRayQueryParameters2D.create(
		global_position, target.global_position, ray.collision_mask)
	if attacker is CollisionObject2D:
		query.exclude = [attacker.get_rid()]
	var result := get_world_2d().direct_space_state.intersect_ray(query)
	return result.is_empty() or result.collider == target
	
func update_beam(width: float) -> void:
	ray.force_raycast_update()
	var end := ray.target_position
	if ray.is_colliding():
		end = to_local(ray.get_collision_point())
	beam.width = width
	beam.points = PackedVector2Array([Vector2.ZERO, end])

func _apply_damage(delta: float) -> void: 
	_tick = _tick - delta
	if _tick > 0.0: 
		return
	
	_hitbox.target_position = beam.points[1]
	_hitbox.force_shapecast_update()
	
	for i in _hitbox.get_collision_count():
		var hit := _hitbox.get_collider(i) as Node
		if hit == null:
			continue
		var health = hit.get_node_or_null("HealthComponent")
		if health: 
			health.take_damage(damage, attacker)
			_tick = damage_interval
			return
	
	_tick = first_hit_delay
	
