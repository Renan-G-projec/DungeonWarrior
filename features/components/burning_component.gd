# Ad Maiorem Dei Gloriam!
class_name BurningComponent
extends Node

## This componenent just makes a entity burnable
## This means, cause some damage and mnakes the sprite a little more modulated

@export var damage_target: HealthComponent:
	set(health_component):
		if health_component == damage_target: return
		
		if damage_target:
			damage_target.died.disconnect(_on_burning_timer_timeout)
		if health_component:
			health_component.died.connect(_on_burning_timer_timeout)
			
		damage_target = health_component
@export var sprite: Node2D
 
@export var damage: float = 3.0
@export var burning_rate: float = 1.5 # The time between the burning damage, eg: Takes damage every 1.2s
@export var burning_time: float = 5.0

@export var active: bool = false

var _burning_timer: Timer
var _damage_timer: Timer

func start_burning_effect() -> void:
	if !_burning_timer:
		_burning_timer = Timer.new()
		add_child(_burning_timer)
		_burning_timer.wait_time = burning_time
		_burning_timer.autostart = false
		_burning_timer.one_shot = true
		_burning_timer.timeout.connect(_on_burning_timer_timeout)
		
	if !_damage_timer:
		_damage_timer = Timer.new()
		add_child(_damage_timer)
		_damage_timer.wait_time = burning_rate
		_damage_timer.autostart = false
		_damage_timer.one_shot = false
		_damage_timer.timeout.connect(_on_damage_timer_timeout)
	_burning_timer.start()
	_damage_timer.start()
	
	sprite.self_modulate = Color(4.502, 4.502, 1.775)

	active = true

func _on_burning_timer_timeout() -> void:
	active = false
	if (sprite): sprite.self_modulate = Color.WHITE
	if (_damage_timer): _damage_timer.stop()

func _on_damage_timer_timeout() -> void:
	if damage_target:
		damage_target.take_damage(damage, sprite)
