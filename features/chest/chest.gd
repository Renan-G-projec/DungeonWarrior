# Ad Maiorem Dei Gloriam!
class_name Chest
extends StaticBody2D

var _containing_item: WeaponBase = null
var _player_ref: Player = null

func _ready() -> void:
	for child in get_children():
		if child is WeaponBase:
			_containing_item = child

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_ref = body

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && _player_ref && _containing_item:
		if _player_ref.weapon:
			_player_ref.weapon.queue_free()
		remove_child(_containing_item)
		_player_ref.add_child(_containing_item)
		_player_ref.weapon = _containing_item
		_player_ref.weapon.position = Vector2.ZERO

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_ref = null
