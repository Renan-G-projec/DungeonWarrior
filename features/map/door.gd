# Ad Maiorem Dei Gloriam!
class_name Door
extends Area2D

@export var id: int = 0
@export_file("*.tscn") var target_scene: String
@export var target_door_id: int = 0

signal player_interacted()

func _ready() -> void:
	var tween: Tween = $Sprite2D.create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_loops()
	tween.tween_property($Sprite2D, "scale", Vector2(0.8, 1.2), 1.2)
	tween.tween_property($Sprite2D, "scale", Vector2(1.2, 0.8), 1.2)

func _process(delta: float) -> void:
	if !has_overlapping_bodies(): return
	
	if Input.is_action_just_pressed("Interact") || %TriggerArea.has_overlapping_bodies():
		var player: Player = get_overlapping_bodies()[0] as Player
	
		assert(player != null, "Error: another object is in the player layer and the player tryed to interact with the door.")
	
		player_interacted.emit()
		set_process(false)
