extends Node2D

signal state_changed(new_state)

enum State { IDLE, TELEGRAPH, DASHING, COOLDOWN}

@export var movement_component: Node
@export var idle_delay := 1.5
@export var detection_range := 400
@export var target_group := "player"

@export var damage := 15
@export var telegraph_time := 0.8
@export var lock_time := 0.5
@export var dash_speed := 900.0
@export var dash_time := 0.4
@export var cooldown_time := 2.0
@export var stop_on_wall := true
@export var telegraph_width := 12.0

var state: State = State.IDLE
var target: Node2D
var body: CharacterBody2D

var _timer := 0.0
var _dash_elapsed := 0.0
var _direction := Vector2.RIGHT
var _already_hit: Array = []

@onready var hit_area: Area2D = $HitArea

func _ready() -> void:
	body = get_parent() as CharacterBody2D
	if body == null:
		print("Dash Attack nush be a child of CharacterBody2D")
		set_physics_process(false)
		return
	hit_area.monitoring = false
	_timer = idle_delay

func _physics_process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		target = get_tree().get_first_node_in_group(target_group) as Node2D
		if target == null:
			return
			
	match state:
		State.IDLE:
			_timer = _timer - delta
			if _timer <= 0.0 and body.global_position.distance_to(target.global_position) <= detection_range:
				_set_state(State.TELEGRAPH)
		
		State.TELEGRAPH:
			_timer = _timer - delta
			if _timer > lock_time:
				_direction = (target.global_position - body.global_position).normalized()
			global_rotation = _direction.angle()
			queue_redraw()
			if _timer <= 0.0:
				_set_state(State.DASHING)
		
		State.DASHING:
			_dash_elapsed = _dash_elapsed + delta
			var time := clampf(_dash_elapsed / dash_time, 0.0, 1.0)
			var speed := dash_speed * ((1.0 - time) ** 2)
			body.velocity = _direction * speed
			body.move_and_slide()
			_hit_slide_collisions()
			_hit_overlapping()
			if time >= 1.0 or (stop_on_wall and _hit_wall()):
				body.velocity = Vector2.ZERO
				_set_state(State.COOLDOWN)
		
		State.COOLDOWN:
			_timer = _timer - delta
			if _timer <= 0.0:
				_set_state(State.IDLE)

func _set_state(new_state: State) -> void:
	state = new_state
	match state:
		
		State.IDLE:
			_timer = idle_delay
			_set_movement(true)
		
		State.TELEGRAPH:
			_timer = telegraph_time
			_set_movement(false)
		
		State.DASHING:
			_dash_elapsed = 0.0
			_already_hit.clear()
			hit_area.set_deferred("monitoring", true)
			
		State.COOLDOWN:
			_timer = cooldown_time
			hit_area.set_deferred("monitoring", false)
			
	state_changed.emit(state)
	queue_redraw()

func _hit_slide_collisions() -> void:
	for i in body.get_slide_collision_count():
		var collider = body.get_slide_collision(i).get_collider()
		if collider is Node:
			_try_damage(collider)

func _hit_overlapping() -> void:
	for other in hit_area.get_overlapping_bodies():
		_try_damage(other)
	for other in hit_area.get_overlapping_areas():
		_try_damage(other)

func _hit_wall() -> bool:
	for i in body.get_slide_collision_count():
		var collider = body.get_slide_collision(i).get_collider()
		if collider is Node and not collider.is_in_group(target_group):
			return true
	return false
	
func _try_damage(node: Node) -> void: 
	var owner_node := node
	var health = node.get_node_or_null("HealthComponent")
	if health == null and node.get_parent():
		owner_node = node.get_parent()
		health = owner_node.get_node_or_null("HealthComponent")
	if health == null or owner_node == body or owner_node in _already_hit:
		return
	_already_hit.append(owner_node)
	health.take_damage(damage, body)
	
func _set_movement(enabled: bool) -> void:
	if movement_component:
		movement_component.set_physics_process(enabled)

func _draw() -> void: 
	if state != State.TELEGRAPH:
		return
	var length := dash_speed * dash_time / 3.0
	var time := 1.0 - (_timer / telegraph_time)
	var half := telegraph_width * 0.5
	draw_rect(Rect2(0, -half, length, telegraph_width), Color(1, 0, 0, 0.8), false, 2.0)
	draw_rect(Rect2(0, -half, length * time, telegraph_width), Color(1, 0, 0, 0.25))


	
	
	
	
