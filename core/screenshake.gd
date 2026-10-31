# Ad Maiorem Dei Gloriam!
## Autoload: Screenshake
extends Node

var current_intensity: float = 0.0
var decay_speed: float = 10
var active: bool = false

func shake(val: float = 10.0):
	active = true
	current_intensity = val

func _process(delta: float) -> void:
	if active:
		current_intensity = move_toward(current_intensity, 0.0, delta * decay_speed)
		if current_intensity <= 0.1:
			current_intensity = false
