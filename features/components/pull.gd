class_name Pull
extends Node

@export var pull_resistance: float = 1.0

var pull_velocity: Vector2 = Vector2.ZERO
var timer: float = 0.0
var target: Node2D = null
var force: float = 0.0
var stop_distance: float = 24.0

@onready var character: CharacterBody2D = get_parent() as CharacterBody2D

func is_active() -> bool:
	return timer > 0.0

func apply_pull(pull_to: Node2D, pull_force: float = 200.0, duration: float = 0.6, stop_dist: float = 24.0) -> void:
	if not character or pull_to == null:
		return
	target = pull_to
	force = pull_force / maxf(pull_resistance, 0.01)
	stop_distance = stop_dist
	timer = duration

func cancel() -> void:
	timer = 0.0
	target = null
	pull_velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if timer <= 0.0 or target == null or not is_instance_valid(target):
		cancel()
		return

	var to_target := target.global_position - character.global_position
	if to_target.length() <= stop_distance:
		cancel()
		return

	pull_velocity = to_target.normalized() * force
	timer -= delta
