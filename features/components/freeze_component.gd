# Ad Maiorem Dei Gloriam!
class_name FreezeComponent
extends Node

## TODO: Make so it remembers the previous speed multiplier of the target

@export var health_component: HealthComponent:
	set(new_health_component):
		if new_health_component == health_component: return
		
		if health_component:
			health_component.died.disconnect(_on_freeze_timer_timeout)
		if new_health_component:
			new_health_component.died.connect(_on_freeze_timer_timeout)
			
		health_component = new_health_component
@export var sprite: Node2D
@export var target_to_freeze: Node2D = owner as Node2D
 
@export_range(0.0, 1.0, 0.05) var speed_multiplier: float = 0.5
@export var freeze_time: float = 1.5

@export var active: bool = false

var _freeze_timer: Timer

func start_freeze_effect() -> void:
	assert(target_to_freeze && "speed_multiplier" in target_to_freeze, "Error: No defined target to freeze or target doesn't have the property speed_multiplier.")
	if !_freeze_timer:
		_freeze_timer = Timer.new()
		add_child(_freeze_timer)
		_freeze_timer.wait_time = freeze_time
		_freeze_timer.autostart = false
		_freeze_timer.one_shot = true
		_freeze_timer.timeout.connect(_on_freeze_timer_timeout)
		
	_freeze_timer.start()
	target_to_freeze.speed_multiplier = speed_multiplier
	
	sprite.self_modulate = Color(0.572, 2.605, 4.502, 1.0)
	

	active = true

func _on_freeze_timer_timeout() -> void:
	active = false
	target_to_freeze.speed_multiplier = 1.0
	if (sprite): sprite.self_modulate = Color.WHITE
