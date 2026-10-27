# Ad Maiorem Dei Gloriam!
class_name Room
extends Node2D

var _door_id_mapping: Dictionary[int, Door] = {}

signal player_interacted_with_door(door_target_room: String, door_target_id: int)
signal enemy_died(enemy_key: NodePath)

# Main will call this function. As soon as main realize the player already passed this level it will free all the defeated enemies
# TODO: Add a life storage. For now, main just holds the dead enemies, but the others restore life.
func remove_enemies(persistance_keys: Array) -> void:
	for enemy_key in persistance_keys:
		get_node(enemy_key).queue_free()

# Returns the door current tile in global position
func get_door_position(door_id: int) -> Vector2:
	assert(_door_id_mapping.has(door_id), "Error: Could not find in map %s the door with id %d." % [name, door_id])
	
	return Vector2($Floor.local_to_map($Floor.to_local(_door_id_mapping[door_id].global_position))) * Vector2(8.0, 8.0)

func _ready() -> void:
	_connect_enemies()
	_sync_doors_id()

func _connect_enemies(root: NodePath = self.get_path()) -> void:
	for child in get_node(root).get_children():
		if child is EnemyBase:
			child.died.connect(enemy_died.emit.bind(get_path_to(child)))
		_connect_enemies(get_path_to(child))

func _sync_doors_id() -> void:
	_door_id_mapping.clear()
	var doors = get_children()
	for door in doors:
		if !(door is Door):
			continue
		_door_id_mapping[door.id] = door
		door.player_interacted.connect(player_interacted_with_door.emit.bind(door.target_scene, door.target_door_id))
