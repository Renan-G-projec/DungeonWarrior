class_name Pull
extends Node

signal arrived 

@export var pull_resistance: float = 1.0
@export var arrive_margin: float = 20.0

var pull_velocity: Vector2 = Vector2.ZERO
var timer: float = 0.0
var target: Node2D = null
var force: float = 0.0
var stop_distance: float = 24.0
var active: bool = false

@onready var character: CharacterBody2D = get_parent() as CharacterBody2D

func is_active() -> bool:
	return active

func apply_pull(pull_to: Node2D, pull_force: float = 200.0, duration: float = 0.6, stop_dist: float = 24.0) -> void:
	if not character or pull_to == null:
		return
	target = pull_to
	force = pull_force / maxf(pull_resistance, 0.01)
	stop_distance = stop_dist
	timer = duration
	active = true

func cancel() -> void:
	timer = 0.0
	target = null
	pull_velocity = Vector2.ZERO
	active = false

func _finish(reached:bool) -> void:
	cancel()
	if reached:
		arrived.emit()


func _physics_process(delta: float) -> void:
	if not active:
		return
	
	if target == null or not is_instance_valid(target):
		_finish(false)
		return
	
	var distance := character.global_position.distance_to(target.global_position)
	
	if distance <= stop_distance:
		_finish(true)
		return	

	if timer <= 0.0:
		_finish(distance <= stop_distance + arrive_margin)
		return
		
	pull_velocity = (target.global_position - character.global_position).normalized() * force
	timer -= delta
