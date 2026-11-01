# Ad Maiorem Dei Gloriam!
## Autoload: Settings
extends Node

@export_range(0.0, 1.0) var master_volume: float = 1.0:
	set(val):
		master_volume = clampf(val, 0.0, 1.0)
		master_volume_changed.emit()

@export_range(0.0, 1.0) var sound_effects_volume: float = 1.0:
	set(val):
		sound_effects_volume = clampf(val, 0.0, 1.0)
		sound_effects_volume_changed.emit()

@export_range(0.0, 1.0) var music_effects_volume: float = 1.0:
	set(val):
		music_effects_volume = clampf(val, 0.0, 1.0)
		music_effects_volume_changed.emit()


signal master_volume_changed()
signal sound_effects_volume_changed()
signal music_effects_volume_changed()
