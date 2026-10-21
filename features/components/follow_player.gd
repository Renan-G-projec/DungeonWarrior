class_name FollowPlayer
extends Node

@export var speed: float = 20.0
@export var stop_distance: float = 1.0
var player: Player

@onready var body: CharacterBody2D = get_parent()

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player

func _physics_process(delta: float) -> void:
	if !player:
		body.velocity = Vector2.ZERO
		return
	
	var distance: float = body.global_position.distance_to(player.global_position)
	
	if distance > stop_distance:
		var direction: Vector2 =  body.global_position.direction_to(player.global_position)
		body.velocity = direction * speed 
	else: 
		body.velocity = Vector2.ZERO
		
	body.move_and_slide()
