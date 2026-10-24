# Ad Maiorem Dei Gloriam!
class_name Door
extends Area2D

@export var id: int = 0
@export_file("*.tscn") var target_scene: String
@export var target_door_id: int = 0

signal player_interacted()

func _process(delta: float) -> void:
	if !Input.is_action_just_pressed("Interact"): return
	if !has_overlapping_bodies(): return
	var player: Player = get_overlapping_bodies()[0] as Player
	
	assert(player != null, "Error: another object is in the player layer and the player tryed to interact with the door.")
	
	player_interacted.emit()
