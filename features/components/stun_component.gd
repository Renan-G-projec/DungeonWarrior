class_name StunComponent
extends Node

signal stunned
signal recovered

var time_left: float = 0.0

func is_stunned() -> bool:
	return time_left > 0.0

func stun(duration: float) -> void:
	print("Stun: stuned for: ", duration)
	var was_stunned := is_stunned()
	time_left = maxf(time_left, duration)
	if not was_stunned:
		stunned.emit()

	
func _physics_process(delta: float) -> void: 
	if time_left <= 0.0: 
		return 
	time_left = time_left - delta
	if time_left <= 0.0:
		time_left = 0.0
		recovered.emit()
