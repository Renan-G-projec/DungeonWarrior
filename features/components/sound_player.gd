# Ad Maiorem Dei Gloriam!
class_name SoundPlayer
extends AudioStreamPlayer

@warning_ignore("native_method_override")

func play(from_position: float = 0.05) -> void:
	pitch_scale = randf_range(0.4, 0.9)
	volume_db = -40 + (40 * Settings.master_volume * Settings.sound_effects_volume)
	super.play(from_position)
