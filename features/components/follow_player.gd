class_name FollowPlayer
extends Node

@export var speed: float = 20.0
@export var stop_distance: float = 1.0

var player: Player

@onready var body: CharacterBody2D = get_parent()
@onready var knockback: Knockback = body.get_node_or_null("Knockback") as Knockback

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player

func _physics_process(delta: float) -> void:
	print("knockback node: ", knockback, " active: ", knockback != null and knockback.is_active())
	if knockback and knockback.is_active():
		body.velocity = knockback.knockback_velocity
	elif player:
		var distance: float = body.global_position.distance_to(player.global_position)
	
		if distance > stop_distance:
			var direction: Vector2 =  body.global_position.direction_to(player.global_position)
			body.velocity = direction * speed 
		else: 
			body.velocity = Vector2.ZERO
		

	body.move_and_slide()
	_check_player_collison()
	
func _check_player_collison() -> void:
	for i in body.get_slide_collision_count():
		var collision: KinematicCollision2D = body.get_slide_collision(i)
		if collision.get_collider() == player:
			var player_health := player.get_node_or_null("HealthComponent") as HealthComponent
			if player_health:
				player_health.take_damage(10, body)
		
			

			
			
