# Ad Maiorem Dei Gloriam!
class_name Main
extends Node2D

@onready var player: Player = %Player

@export var current_room: Room:
	set(room):
		if current_room:
			current_room.player_interacted_with_door.disconnect(change_current_room)
		current_room = room
		current_room.player_interacted_with_door.connect(change_current_room)
		move_child(current_room, 0)
	
func change_current_room(room: String, door_id: int) -> void:
	assert(FileAccess.file_exists(room), "Error: Tried to go to a unexistant room: %s" % room)

	var room_scene: PackedScene = load(room)
	var room_instance: Room = room_scene.instantiate()
	add_child(room_instance)
	if current_room:
		current_room.queue_free()
	current_room = room_instance
	
	player.global_position = room_instance.get_door_position(door_id)
