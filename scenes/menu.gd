# Ad Maiorem Dei Gloriam!
class_name Menu
extends Node

@export_enum("Menu", "Settings") var current_state: String = "Menu":
	set(new_state):
		current_state = new_state
		_restore_button_animation(_current_button)
		_previous_text = _buttons[current_state][0].text
		current_button_index = 0
		

@onready var _buttons: Dictionary[String, Array] = {
	"Menu": %ButtonsContainer.get_children(),
	"Settings":  %SettingsContainer.get_children()
}

var _transition_tween: Tween
var _previous_text = "Play"

var _buttons_actions: Dictionary = {
	"Menu": [
		(func() -> void: TransitionManager.flash(func() -> void: get_tree().change_scene_to_file("res://scenes/main.tscn"))),
		(func() -> void: _go_to_settings()),
		(func() -> void: print("To implement")),
		(func() -> void: get_tree().quit())
	],
	"Settings": [
		(func() -> void: pass),
		(func() -> void: pass),
		(func() -> void: pass),
		(func() -> void: _go_to_menu())
	]
}

var _previous_button: RichTextLabel
var _current_button: RichTextLabel
@export var current_button_index: int:
	set(val):
		if current_button_index && val == current_button_index: return
		
		
		_previous_button = _buttons[current_state][current_button_index]
		_restore_button_animation(_buttons[current_state][current_button_index])
		current_button_index = clamp(val, 0, _buttons[current_state].size() - 1)
		_make_button_hover_animation(_buttons[current_state][current_button_index])
		_current_button = _buttons[current_state][current_button_index]
		

func _get_hovered_effect(string: String) -> String:
	return "[wave amp=1.0 freq=4.0 connected=0][color=aqua]%s[/color][/wave]" % string

func _ready() -> void:
	current_button_index = 0
	
	for button in _buttons["Menu"]:
		button.offset_transform_enabled = true
		button.offset_transform_pivot_ratio = Vector2.ONE / 2
	for button in _buttons["Settings"]:
		button.offset_transform_enabled = true
		button.offset_transform_pivot_ratio = Vector2.ONE / 2

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"): current_button_index -= 1
	if Input.is_action_just_pressed("ui_down"): current_button_index += 1
	if Input.is_action_just_pressed("ui_accept"):
		var action: Callable = _buttons_actions[current_state][current_button_index]
		if action:
			action.call()

func _restore_button_animation(button: RichTextLabel) -> void:
	button.text = _previous_text
	button.create_tween().set_trans(Tween.TRANS_QUAD).tween_property(button, "offset_transform_position", Vector2(0, 0), 0.2).set_ease(Tween.EASE_IN)

func _make_button_hover_animation(button: RichTextLabel) -> void:

	_previous_text = button.text
	button.text = _get_hovered_effect(button.text)
	
	button.offset_transform_scale = Vector2(1.4, 0.7)
	var buttons_animation = button.create_tween().set_trans(Tween.TRANS_QUAD).set_parallel()
	buttons_animation.tween_property(button, "offset_transform_position", Vector2(2, 0), 0.2).set_ease(Tween.EASE_OUT)
	buttons_animation.tween_property(button, "offset_transform_scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_OUT)

func _go_to_settings() -> void:
	_restart_animations()
	
	current_state = "Settings"
	_transition_tween.tween_property($Title, "position", Vector2($Title.position.x - 40, $Title.position.y), 0.5)
	_transition_tween.tween_property(%MainPanel, "offset_transform_position", -%SettingsPanel.offset_transform_position, 0.6).set_ease(Tween.EASE_IN_OUT)
	_transition_tween.tween_property(%SettingsPanel, "offset_transform_position", Vector2.ZERO, 0.8)


func _go_to_menu() -> void:
	_restart_animations()
	
	current_state = "Menu"
	_transition_tween.tween_property($Title, "position", Vector2($Title.position.x + 40, $Title.position.y), 0.5)
	_transition_tween.tween_property(%SettingsPanel, "offset_transform_position", -%MainPanel.offset_transform_position, 0.6).set_ease(Tween.EASE_IN_OUT)
	_transition_tween.tween_property(%MainPanel, "offset_transform_position", Vector2.ZERO, 0.8)
	
func _restart_animations() -> void:
	if _transition_tween:
		_transition_tween.kill()
	_transition_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel().set_ease(Tween.EASE_OUT)
