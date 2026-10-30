# Ad Maiorem Dei Gloriam!
class_name Menu
extends Node

enum Buttons {
	PLAY,
	SETTINGS,
	CREDITS,
	EXIT
}

var _previous_text = "Play"

@onready var buttons: Array[Node] = %ButtonsContainer.get_children()
@export var current_button_index: int:
	set(val):
		if current_button_index && val == current_button_index: return
		
		var previous_button: RichTextLabel = buttons[current_button_index]
		previous_button.text = _previous_text
		previous_button.create_tween().set_trans(Tween.TRANS_QUAD).tween_property(previous_button, "offset_transform_position", Vector2(0, 0), 0.2).set_ease(Tween.EASE_IN)
		current_button_index = clamp(val, 0, buttons.size() - 1)
		
		var new_button: RichTextLabel = buttons[current_button_index]
		_previous_text = new_button.text
		new_button.text = _get_hovered_effect(new_button.text)
		
		new_button.offset_transform_scale = Vector2(1.4, 0.7)
		var new_buttons_animation = new_button.create_tween().set_trans(Tween.TRANS_QUAD).set_parallel()
		new_buttons_animation.tween_property(new_button, "offset_transform_position", Vector2(2, 0), 0.2).set_ease(Tween.EASE_OUT)
		new_buttons_animation.tween_property(new_button, "offset_transform_scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_OUT)

var _buttons_actions: Dictionary = {
	Buttons.PLAY: (func() -> void: TransitionManager.flash(func() -> void: get_tree().change_scene_to_file("res://scenes/main.tscn"))),
	Buttons.SETTINGS: (func() -> void: print("Error: Settings still not working")),
	Buttons.CREDITS: (func() -> void: print("To implement")),
	Buttons.EXIT: (func() -> void: get_tree().quit())
}

func _get_hovered_effect(string: String) -> String:
	return "[wave amp=1.0 freq=4.0 connected=0][color=aqua]%s[/color][/wave]" % string

func _ready() -> void:
	current_button_index = 0
	
	for button in buttons:
		button.offset_transform_enabled = true
		button.offset_transform_pivot_ratio = Vector2.ONE / 2

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"): current_button_index -= 1
	if Input.is_action_just_pressed("ui_down"): current_button_index += 1
	if Input.is_action_just_pressed("ui_accept"):
		var action: Callable = _buttons_actions[current_button_index]
		if action:
			action.call()
