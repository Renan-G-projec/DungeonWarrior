class_name ShootComponent
extends Node

@export var projectile: PackedScene
@export var muzzle: Marker2D
@export var fire_rate: float = 1.5 
@export var range: float = 400.0

var time_since_shot: float = 0.0 
var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	time_since_shot = time_since_shot + delta
	
	if player == null or muzzle == null or projectile == null:
		return
	if muzzle.global_position.distance_to(player.global_position) > range:
		return
		
	if time_since_shot > fire_rate:
		_shoot()
		time_since_shot = 0.0

func _shoot() -> void:
	var bullet := projectile.instantiate()
	var angle := muzzle.global_position.direction_to(player.global_position).angle()
	print(bullet.name, " | ", bullet.get_script(), " | ", projectile.resource_path)
	bullet.global_position = muzzle.global_position
	bullet.global_rotation = angle
	bullet.direction = angle
	get_tree().current_scene.add_child(bullet)
