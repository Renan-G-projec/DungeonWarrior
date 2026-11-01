# Ad Maiorem Dei Gloriam!
extends CanvasLayer

func _ready() -> void:
	await create_tween().tween_property($Control/Typewriter, "visible_ratio", 1.0, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).finished
	set_process(true)

func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		set_process(false)
		TransitionManager.flash(func() -> void: get_tree().change_scene_to_file("res://scenes/menu.tscn"))
