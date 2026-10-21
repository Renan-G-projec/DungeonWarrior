# Ad Maiorem Dei Gloriam!
class_name HealthComponent
extends Node

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

signal max_life_changed(new_max_life: float)
signal life_changed(new_life: float)
signal took_damage(damage: float)
signal died()

func take_damage(damage: float) -> void:
	life -= damage
	took_damage.emit(damage)

func die() -> void:
	life = -1.0
