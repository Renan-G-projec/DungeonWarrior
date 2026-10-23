# Ad Maiorem Dei Gloriam!
class_name Room
extends Node2D

var _door_id_mapping: Dictionary[int, Door] = {}

signal player_interacted_with_door(door_target_room: String, door_target_id: int)

func _ready() -> void:
	_sync_doors_id()

func _sync_doors_id() -> void:
	_door_id_mapping.clear()
	var doors = get_children()
	for door in doors:
		if !(door is Door):
			continue
		_door_id_mapping[door.id] = door
		door.player_interacted.connect(player_interacted_with_door.emit.bind(door.target_scene, door.target_door_id))

# Returns the door current tile in global position
func get_door_position(door_id: int) -> Vector2:
	assert(_door_id_mapping.has(door_id), "Error: Could not find in map %s the door with id %d." % [name, door_id])
	
	return Vector2($Floor.local_to_map($Floor.to_local(_door_id_mapping[door_id].global_position))) * Vector2(8.0, 8.0)
