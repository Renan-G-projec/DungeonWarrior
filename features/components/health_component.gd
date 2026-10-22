# Ad Maiorem Dei Gloriam!
class_name HealthComponent
extends Node

@onready var character = get_parent()

@export var max_life: float = 100.0:
	set(new_max_life):
		assert(new_max_life > 0.0, "Error: Max life cannot be under zero.")
		
		# Caps exceding life
		if life > new_max_life:
			life = new_max_life
		
		max_life = new_max_life
		max_life_changed.emit(new_max_life)
		
@export var life: float = 100.0:
	set(new_life):
		if new_life < 0.0:
			died.emit()
		
		life = clamp(new_life, 0.0, max_life)
		life_changed.emit(life)

@export var has_iframes: bool = false
@export var iframe_duration: float = 0.5

var is_invincible: bool = false
var iframe_timer: Timer 

signal max_life_changed(new_max_life: float)
signal life_changed(new_life: float)
signal took_damage(character: Node, damage: float, source_position: Vector2)
signal died()
signal iframe_started()
signal iframe_ended()

func _ready() -> void:
	if has_iframes == true:
		iframe_timer = Timer.new()
		iframe_timer.one_shot = true
		iframe_timer.wait_time = iframe_duration
		iframe_timer.timeout.connect(_on_iframe_timeout)
		add_child(iframe_timer)
		
func _on_iframe_timeout() -> void:
	print("invincible period has ended")
	is_invincible = false
	iframe_ended.emit()


func take_damage(damage: float, attacker: Node2D) -> void:
	if has_iframes and is_invincible:
		return

	life -= damage
	var source_postiton: Vector2 = attacker.global_position
	took_damage.emit(character, damage, source_postiton)
	
	if has_iframes and life > 0.0 and iframe_duration > 0.0:
		print("invincible period has started")
		is_invincible = true
		iframe_timer.start()
		iframe_started.emit()

func die() -> void:
	life = -1.0
