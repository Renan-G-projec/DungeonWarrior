# Ad Maiorem Dei Gloriam!
class_name Lifebar
extends Control

@export var bind_health_component: HealthComponent:
	set(health_component):
		if bind_health_component:
			bind_health_component.life_changed.disconnect(_on_life_changed)
			bind_health_component.max_life_changed.disconnect(_on_max_life_changed)
		
		bind_health_component = health_component
		bind_health_component.life_changed.connect(_on_life_changed)
		bind_health_component.max_life_changed.connect(_on_max_life_changed)
		
		_sync_with_life_component()

func _ready() -> void:
	_sync_with_life_component()

func _on_life_changed(new_life: float) -> void:
	$ProgressBar.value = new_life

func _on_max_life_changed(new_max_life: float) -> void:
	$ProgressBar.max_value = new_max_life

func _sync_with_life_component() -> void:
	if bind_health_component:
		$ProgressBar.max_value = bind_health_component.max_life
		$ProgressBar.value = bind_health_component.life
