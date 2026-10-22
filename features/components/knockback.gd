class_name Knockback
extends Node

@onready var character: CharacterBody2D = get_parent() as CharacterBody2D

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
@export var knockback_resistance: float = 5.0 

func apply_knockback(source_positon: Vector2, force: float, knockback_duration: float) -> void:
	if not character:
		return
	var direction = source_positon.direction_to(character.global_position)
	knockback_velocity = direction * force
	knockback_timer = knockback_duration 

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		character.velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * delta)
		knockback_timer = knockback_timer - delta
	else:
		knockback_velocity = Vector2.ZERO
		
func _ready() -> void:
	if character.has_node("HealthComponent"):
		var health = character.get_node("HealthComponent")
		health.took_damage.connect(_on_took_damage)	
