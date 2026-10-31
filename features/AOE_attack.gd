class_name AOEAttack 
extends Area2D

signal state_changed(new_state)

enum State {IDLE, TELEGRAPH, ACTIVE, COOLDOWN}

@export var damage := 10
@export var telegraph_time := 0.8
@export var active_time := 0.3
@export var cooldown_time := 2.0
@export var tick_damage :=false

var state: State = State.IDLE
var attacker: Node
var _already_hit = []

@onready var shape: CollisionShape2D= $CollisionShape2D
@onready var telegraph_timer: Timer = $TelegraphTimer
@onready var active_timer: Timer = $ActiveTimer
@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	attacker = get_parent()
	shape.disabled = true
	telegraph_timer.timeout.connect(func(): _set_state(State.ACTIVE))	
	active_timer.timeout.connect(func(): _set_state(State.IDLE))
	cooldown_timer.timeout.connect(func(): _set_state(State.IDLE))

func _set_state(new_state: State) -> void:
	state = new_state
	match state:
		State.IDLE:
			shape.set_deferred("disabled", true)
			queue_redraw()
		State.TELEGRAPH:
			shape.set_deferred("disabled", true)
			telegraph_timer.start(telegraph_time)
			queue_redraw()
		State.COOLDOWN:
			shape.set_deferred("disabled", false)
			active_timer.start(active_time)
			queue_redraw()
	state_changed.emit(state)
	
func _physics_process(delta: float) -> void: 
	if state == State.ACTIVE and tick_damage:
		_hit_overlapping()
		
func _hit_overlapping() -> void:
	if state != State.ACTIVE:
		return
	for body in get_overlapping_bodies():
		if not tick_damage and body in _already_hit:
			continue
		_already_hit.append(body)
		var health = body.get_node_or_null("HealthComponent")
		if health:
			health.take_damage(damage, attacker)

func _draw() -> void:
	var r: float = shape.shape.radius
	match state:
		State.TELEGRAPH:
			draw_arc(Vector2.ZERO, r, 0, TAU, 48, Color(1,0,0,0.8))
			var t := 1.0 - (telegraph_timer.time_left / telegraph_time)
			draw_circle(Vector2.ZERO, r*t, Color(1, 0, 0 , 0.25))
		State.ACTIVE:
			draw_circle(Vector2.ZERO, r, Color(1, 0.3, 0, 0.6))

func _process(delta: float) -> void:
	if state == State.TELEGRAPH:
		queue_redraw()
