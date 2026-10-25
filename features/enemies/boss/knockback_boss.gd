class_name KnockbackBoss
extends Node


@export var default_force: float = 250
@export var default_duration: float = 0.2
@export var friction: float = 800.0
@export var knockback_resistance: float = 1.0

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

var pull_target: Node2D = null
var pull_force: float = 0.0
var pull_stop_disatance: float = 24.0


@onready var boss: CharacterBody2D = get_parent() as CharacterBody2D

func _ready() -> void:
	if boss and boss.has_node("HealthComponent"):
		var health := boss.get_node("HealthComponent")
		health.took_damage.connect(_on_took_damage)	

func is_active() -> bool:
	return knockback_timer > 0.0
		
func apply_knockback(source_position: Vector2, force: float = -1.0, duration: float = -1.0) -> void:
	if not boss:
		return
	if force < 0.0:
		force = default_force
	if duration < 0.0:
		duration = default_duration

	var direction := source_position.direction_to(boss.global_position)
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	
	pull_target = null
	knockback_velocity = direction * (force / maxf(knockback_resistance, 0.01))
	knockback_timer = duration


func apply_pull(target: Node2D, force: float = 200.0, duration: float = 0.6, stop_distance: float = 24.0) -> void:
	if not boss or target == null:
		return
	pull_target = target
	pull_force = force
	pull_stop_disatance = stop_distance
	knockback_timer = duration

func _physics_process(delta: float) -> void:
	if knockback_timer <= 0.0:
		knockback_velocity = Vector2.ZERO
		pull_target = null
		return
	
	if pull_target and is_instance_valid(pull_target):
		var to_target := pull_target.global_position - boss.global_position
		
		if to_target.length() <= pull_stop_disatance:
			knockback_velocity = Vector2.ZERO
			pull_target = null
			knockback_timer = 0.0
			return
		
		knockback_velocity = to_target.normalized() * pull_force
	
	else: 
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, friction * delta)
	
	knockback_timer = knockback_timer - delta

func _on_took_damage(entity: Node, damage: float, source_position: Vector2) -> void:
	if pull_target:
		return
	apply_knockback(source_position, default_force, default_duration)
