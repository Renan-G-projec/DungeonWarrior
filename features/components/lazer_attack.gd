class_name LaserAttack
extends Node2D

signal state_changed(new_state)

enum State {IDLE, CHARGING, FIRING, COOLDOWN}

@export var damage := 5
@export var damage_interval := 0.8
@export var max_length := 1200.0
@export var charge_time := 1.0
@export var fire_time := 1.5
@export var cooldown_time := 1.5
@export var beam_width := 14.0
@export var track_speed := 3.0
@export var sweep_speed := 0.8 

@export var idle_delay := 1.0
@export var detection_range := 600.0
@export var target_group := "player"
@export var movement_component: Node

var state = State.IDLE
var target: Node2D
var attacker: Node

var _timer := 0.0
var _tick := 0.0

@onready var ray: RayCast2D = $RayCast2D
@onready var beam: Line2D = $Line2D

func _ready() -> void:
	attacker = get_parent()
	ray.target_position = Vector2(max_length, 0)
	beam.visible = false	
	_timer = idle_delay
	
func start(new_target: Node2D = null) -> void:
	if state != State.IDLE:
		return
	if new_target:
		target = new_target
	_set_state(State.CHARGING)
	
func _set_state(new_state: State) -> void: 
	state = new_state
	match state:
		State.IDLE:
			_timer = idle_delay
			beam.visible = false
			_set_movement(true)
		State.CHARGING:
			_timer = charge_time
			beam.visible = true
			_set_movement(false)
		State.FIRING:
			_timer = fire_time
			_tick = 0.0
		State.COOLDOWN:
			_timer = cooldown_time
			beam.visible = false
	state_changed.emit(state)

func _physics_process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		target = get_tree().get_first_node_in_group(target_group) as Node2D
		if target == null:
			return
	
	match state:
		State.IDLE:
			_timer = _timer - delta
			if _timer <= 0.0 and global_position.distance_to(target.global_position) <= detection_range: 
				_set_state(State.CHARGING)
		State.CHARGING:
			_timer = _timer - delta
			_follow_target(delta)
			update_beam(2.0 + sin(Time.get_ticks_msec() * 0.03))
			if _timer <= 0.0:
				_set_state(State.FIRING)
		State.FIRING:
			_timer = _timer - delta
			rotation = rotation + (sweep_speed * delta)
			update_beam(beam_width)
			_apply_damage(delta)
			if _timer <= 0.0:
				_set_state(State.COOLDOWN)
		State.COOLDOWN:
			_timer = _timer - delta
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
	
func update_beam(width: float) -> void:
	ray.force_raycast_update()
	var end := ray.target_position
	if ray.is_colliding():
		end = to_local(ray.get_collision_point())
	beam.width = width
	beam.points = PackedVector2Array([Vector2.ZERO, end])

func _apply_damage(delta: float) -> void: 
	_tick = _tick - delta
	if _tick > 0.0 or not ray.is_colliding():
		return
	_tick = damage_interval
	var health = ray.get_collider().get_node_or_null("HealthComponent")
	if health:
		health.take_damage(damage, attacker)	
