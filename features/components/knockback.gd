class_name KnockbackEmemy
extends Node


@export var default_force: float = 250
@export var default_duration: float = 0.2
@export var friction: float = 800.0

@export var knockback_resistance: float = 1.0

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

@onready var character: CharacterBody2D = get_parent() as CharacterBody2D

func _ready() -> void:
	print("Knockback ready. parent =", character, " has health=", character != null and character.has_node("HealthComponent") )
	if character and character.has_node("HealthComponent"):
		var health := character.get_node("HealthComponent")
		health.took_damage.connect(_on_took_damage)	

func is_active() -> bool:
	return knockback_timer > 0.0
		
func apply_knockback(source_position: Vector2, force: float = -1.0, duration: float = -1.0) -> void:
	print("3. apply_knockback on ", character.name if character else "NULL", " from ", source_position)
	print("apply_knockback from ", source_position)
	if not character:
		return
	if force < 0.0:
		force = default_force
	if duration < 0.0:
		duration = default_duration

	var direction := source_position.direction_to(character.global_position)
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	print("source: ", source_position, " | character: ", character.global_position, " | dir: ", direction)	
	knockback_velocity = direction * (force / maxf(knockback_resistance, 0.01))
	knockback_timer = duration

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, friction * delta)
		knockback_timer -= delta 	
	else:
		knockback_velocity = Vector2.ZERO
		

func _on_took_damage(entity: Node, damage: float, source_position: Vector2) -> void:
	print("Entity: ", entity)
	apply_knockback(source_position, default_force, default_duration)
