# Ad Maiorem Dei Gloriam!
class_name Main
extends Node2D

@onready var player: Player = %Player

@export var current_room: Room:
	set(room):
		if current_room:
			current_room.queue_free()
		current_room = room
		current_room.player_interacted_with_door.connect(change_current_room)
		current_room.enemy_died.connect(_on_room_enemy_died)

		move_child(current_room, 0)

# Shoudl hold Room: [ enemy/bat enemy/slime... ] etc
var _persistance_keys: Dictionary[String, Array] = {}

func change_current_room(room: String, door_id: int) -> void:
	assert(FileAccess.file_exists(room), "Error: Tried to go to a unexistant room: %s" % room)

	var room_scene: PackedScene = load(room)
	var room_instance: Room = room_scene.instantiate()
	add_child(room_instance)
	
	if _persistance_keys.has(room_instance.scene_file_path):
		room_instance.remove_enemies(_persistance_keys[room_instance.scene_file_path])
	else:
		_persistance_keys[room_instance.scene_file_path] = []
	
	if current_room:
		current_room.queue_free()
	current_room = room_instance
	
	player.global_position = room_instance.get_door_position(door_id)


func _on_player_gameover() -> void:
	TransitionManager.flash(func() -> void: get_tree().reload_current_scene.call_deferred())

func _on_room_enemy_died(enemy_key: NodePath) -> void:
	_persistance_keys[current_room.scene_file_path].push_back(enemy_key)
